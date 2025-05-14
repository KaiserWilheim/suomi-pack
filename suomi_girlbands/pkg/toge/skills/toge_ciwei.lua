local ciwei = fk.CreateSkill{
    name = "toge_ciwei"
}

ciwei:addEffect(fk.AfterCardsMove, {
    anim_type = "support",
    can_trigger = function(self, event, target, player, data)
        if player:hasSkill(self) and player.phase ~= Player.Draw then
            for _, move in ipairs(data) do
                if move.to == player and move.toArea == Player.Hand then
                    return true
                end
            end
        end
    end,
    on_cost = function (self, event, target, player, data)
        local cards = {}
        for _, move in ipairs(data) do
            if move.to == player and move.toArea == Player.Hand then
                for _, info in ipairs(move.moveInfo) do
                    local card = Fk:getCardById(info.cardId)
                    table.insert(cards,card)
                end
            end
        end
        if #cards > 0 then
            self.cost_data = cards
            return player.room:askToSkillInvoke(player, {skill_name = self.name})
        end
    end,
    on_use = function (self, event, target, player, data)
        player.room:moveCardTo(self.cost_data, Player.Special, player, fk.ReasonJustMove, self.name, "@toge_ciwei", true, player)
    end
})

ciwei:addEffect(fk.EventPhaseStart, {
    anim_type = "offensive",
    can_trigger = function (self, event, target, player, data)
        return player:hasSkill("toge_ciwei") and target and target ~= player and target.phase == target.Start and #player:getPile("@toge_ciwei") > 0
    end,
    on_cost = function (self, event, target, player, data)
        return player.room:askToSkillInvoke(player, {skill_name = self.name, prompt = "#toge_ciwei_damage::"..target.id})
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        local cards = player:getPile("@toge_ciwei")
        room:moveCardTo(cards, Player.Hand, target, fk.ReasonJustMove, self.name, nil, true, player)
        room:damage{
            to = target,
            damage = 2,
            damageType = fk.NormalDamage,
            from = player,
        }
    end
})

Fk:loadTranslationTable{
    ["toge_ciwei"] = "刺猬",
    ["#toge_ciwei_active"] = "刺猬",
    [":toge_ciwei"] = "当你于摸牌阶段外获得牌时，你可将这些牌置于你的武将牌上。其他角色的准备阶段，若你的武将牌上有以此法置入的牌，你可令其获得这些牌，然后对其造成两点伤害。",
    ["#toge_ciwei_damage"] = "刺猬：你可令%dest获得你武将牌上的牌，然后对其造成两点伤害。",
    ["@toge_ciwei"] = "刺猬",
}

return ciwei