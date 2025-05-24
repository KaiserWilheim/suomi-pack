local zhongli = fk.CreateSkill{
    name = "mygo_zhongli"
}

zhongli:addEffect(fk.CardUsing, {
    anim_type = "special",
    can_trigger = function (self, event, target, player, data)
        return player:hasSkill(self) and player:usedSkillTimes(self.name) == 0 and data.card.type == Card.TypeTrick
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        room:doIndicate(player, {target})
        data.tos = {}
        room:sendLog{
            type = "#CardNullifiedBySkill",
            from = target.id,
            arg = self.name,
            arg2 = data.card:toLogString(),
        }
        if room:getCardArea(data.card) == Card.Processing then
            room:moveCardTo(data.card, Card.PlayerHand, target, fk.ReasonJustMove, self.name, nil, true, player)
        end
        for _, v in ipairs(room.alive_players) do
            player.room:setPlayerMark(v, "@mygo_zhongli-turn", data.card.name)
        end
        data:removeAllTargets()
    end
})

zhongli:addEffect("prohibit", {
    prohibit_use = function (self, player, card)
        return table.find(Fk:currentRoom().alive_players, function(p) return p:getMark("@mygo_zhongli-turn") ~= 0 end) and (card or {}).name == player:getMark("@mygo_zhongli-turn")
    end
})

Fk:loadTranslationTable{
    ["mygo_zhongli"] = "重力",
    [":mygo_zhongli"] = "每回合限一次，当一名角色使用锦囊牌时，你可以取消之，若此牌有实体牌，令此牌返回其手牌，然后本回合所有角色不能使用此牌的同名牌。",
    ["@mygo_zhongli-turn"] = "重力",
}

return zhongli