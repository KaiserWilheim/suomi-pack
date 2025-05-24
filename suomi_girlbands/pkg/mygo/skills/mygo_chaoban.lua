local chaoban = fk.CreateSkill{
    name = "mygo_chaoban"
}

chaoban:addEffect("active", {
    anim_type = "special",
    card_num = 1,
    target_num = 1,
    card_filter = function(self, player, to_select, selected)
        return not table.contains(player:getTableMark("mygo_chaoban_cards-turn"),Fk:getCardById(to_select).name) and #selected == 0
    end,
    target_filter = function(self, player, to_select, selected)
        return to_select ~= player and #selected == 0 and to_select:getMark("@mygo_chaoban_yijian-round") ~= "chaoban_diff"
    end,
    on_use = function(self, room, effect)
        local player = effect.from
        local target = effect.tos[1]
        player:drawCards(1, self.name)
        local card1 = Fk:getCardById(effect.cards[1])
        room:addTableMark(player, "mygo_chaoban_cards-turn", card1.name)
        room:moveCardTo(effect.cards, Player.Hand, target, fk.ReasonGive, self.name, nil, true, player)
        local choices = {"mygo_chaoban_damage","mygo_chaoban_give"}
        local choice = room:askToChoice(target, {
            choices = choices,
            skill_name = self.name
        })
        if choice == "mygo_chaoban_damage" then
            room:damage{
                to = target,
                damage = 1,
                skillName = self.name,
            }
        else
            local card2 = Fk:getCardById(room:askToCards(target, {
                max_num = 1,
                min_num = 1,
                include_equip = true,
                skill_name = self.name,
                cancelable = false,
                prompt = "#mygo_chaoban_return",
                no_indicate = false
            })[1])
            if card1.type == card2.type then
                room:setPlayerMark(target, "@mygo_chaoban_yijian-round", "chaoban_same")
            else
                room:setPlayerMark(target, "@mygo_chaoban_yijian-round", "chaoban_diff")
            end
            room:moveCardTo(card2, Player.Hand, player, fk.ReasonGive, self.name, nil, true, target)
        end
    end
})

chaoban:addEffect("prohibit", {
    is_prohibited = function (self, from, to, card)
        return from:getMark("@mygo_chaoban_yijian-round") == "chaoban_same" and to:hasSkill(self.name)
    end
})

chaoban:addEffect("targetmod", {
    bypass_distances = function (self, player, skill, card, to)
        return player:hasSkill(self.name) and to:getMark("@mygo_chaoban_yijian-round") == "chaoban_diff"
    end,
    bypass_times = function (self, player, skill, scope, card, to)
        return player:hasSkill(self.name) and to:getMark("@mygo_chaoban_yijian-round") == "chaoban_diff"
    end
})

Fk:loadTranslationTable{
    ["mygo_chaoban"] = "超绊",
    [":mygo_chaoban"] = "出牌阶段每种牌名限一次，你可以摸一张牌并交给一名其他角色一张牌，然后其选择一项1.受到一点伤害。2.交给你一张牌，若其交给你的牌与你交给其的牌类型 相同：其本轮不能对你使用牌。不同：你本轮对其使用牌无限制且本回合不能再对其发动“超绊”。(取最后一次对其发动此技能选择的效果)",
    ["@mygo_chaoban_yijian-round"] = "超绊",
    ["chaoban_diff"] = "不同",
    ["chaoban_same"] = "相同",
    ["mygo_chaoban_damage"] = "受到一点伤害",
    ["mygo_chaoban_give"] = "还给高松灯一张牌，根据还牌类型产生效果",
    ["#mygo_chaoban_return"] = "交出 不同类型的牌，其对你用牌无限制但本回合不能再对你发动技能。相同类型的牌，你不能对其用牌。",
}

return chaoban