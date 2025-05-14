local xiyue = fk.CreateSkill{
    name = "toge_xiyue",
}

xiyue:addEffect(fk.Damaged, {
    anim_type = "masochism",
    on_trigger = function(self, event, target, player, data)
        self.cancel_cost = false
        for i = 1, data.damage do
            if self.cancel_cost then break end
            self:doCost(event, target, player, data)
        end
    end,
    on_cost = function(self, event, target, player, data)
        if player.room:askToSkillInvoke(player, {skill_name = self.name}) then return true end
        self.cancel_cost = true
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local cards = player:getCardIds("h")
        player:showCards(cards)
        local red,black = {},{}
        for _, id in ipairs(cards) do
            if Fk:getCardById(id).color == Card.Red then
                table.insert(red, id)
            elseif Fk:getCardById(id).color == Card.Black then
                table.insert(black, id)
            end
        end
        if #black == #red then
            player:drawCards(2, self.name)
            room:recover{
                who = player,
                num = 1,
                skillName = self.name,
                recoverBy = player,
            }
        else
            local more,less
            if #black > #red then
                more = black
                less = Card.Red
            else
                more = red
                less = Card.Black
            end
            local choices = {"toge_xiyue_discard", "toge_xiyue_draw"}
            local choice = room:askToChoice(player, {
                choices = choices,
                skill_name =  self.name
            })
            if choice == "toge_xiyue_discard" then
                room:throwCard(more, self.name, player, player)
            else
                while true do
                    if Fk:getCardById(player:drawCards(1, self.name)[1]).color == less then return end
                end
            end
        end
    end,
})

Fk:loadTranslationTable{
    ["toge_xiyue"] = "喜悦",
    [":toge_xiyue"] = "锁定技。当你受到1点伤害后，你可展示所有手牌，若两种颜色牌数量相同，你摸两张牌并回复一点体力，否则你选择一项1.弃置较多颜色的所有牌。2.摸牌直到摸到一张较少颜色的牌。",
    ["toge_xiyue_draw"] = "摸牌直到摸到一张较少颜色的牌。",
    ["toge_xiyue_discard"] = "弃置较多颜色的所有牌。",
}

return xiyue