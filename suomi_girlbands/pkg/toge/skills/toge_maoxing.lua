local maoxing = fk.CreateSkill{
    name = "toge_maoxing",
    tags = {Skill.Compulsory}
}

maoxing:addEffect(fk.Damaged, {
    anim_type = "masochism",
    on_trigger = function(self, event, target, player, data)
        self.cancel_cost = false
        for i = 1, data.damage do
            if self.cancel_cost then break end
            self:doCost(event, target, player, data)
        end
    end,
    on_cost = function(self, event, target, player, data)
        if player.room:askToSkillInvoke(player, {skill_name = self.name}) then
            return true
        end
        self.cancel_cost = true
    end,
    on_use = function(self, event, target, player, data)
        local room = player.room
        local cards = room:askToCards(player, {
            min_num = 1,
            max_num = 1,
            include_equip = false,
            skill_name = self.name,
            cancelable = true})
        player:showCards(cards)
        local card = Fk:getCardById(cards[1])
        room:addTableMark(player, "@toge_maoxing-round", card.trueName)
    end
})

maoxing:addEffect(fk.CardUsing, {
    can_refresh = function (self, event, target, player, data)
        return player:hasSkill(self) and target and table.contains(player:getTableMark("@toge_maoxing-round"), data.card.trueName)
    end,
    on_refresh = function (self, event, target, player, data)
        local room = player.room
        target:drawCards(2, self.name)
        room:recover{
            who = player,
            num = 1,
            skillName = self.name,
            recoverBy = target,
        }
    end
})

Fk:loadTranslationTable{
    ["toge_maoxing"] = "昴星",
    [":toge_maoxing"] = "锁定技。当你受到1点伤害后，你可展示一张手牌。当一名角色使用与你本轮以此法展示过牌的同名牌时，其摸两张牌并令你回复一点体力。",
    ["@toge_maoxing-round"] = "昴星",
}

return maoxing