local chunri = fk.CreateSkill{
    name = "mygo_chunri",
    tags = {Skill.Lord}
}

chunri:addEffect("active", {
    anim_type = "special",
    card_filter = Util.FalseFunc,
    target_filter = Util.FalseFunc,
    can_use = function (self, player)
        return player:usedSkillTimes(self.name, Player.HistoryGame) < 2
    end,
    on_use = function (self, room, effect)
        local player = effect.from
        room:useVirtualCard("amazing_grace", nil, player, room.alive_players, self.name)
        local targets = table.filter(room.alive_players, function (p) return p:getMark("mygo_chunri-turn") > 0 end)
        for _, v in ipairs(targets) do
            room:changeHp(v, 1 - v.hp, nil, self.name)
        end
    end
})

chunri:addEffect(fk.AfterCardsMove, {
    visible = false,
    can_refresh = Util.TrueFunc,
    on_refresh = function(self, event, target, player, data)
        local room = player.room
        for _, move in ipairs(data) do
            if move.toArea == Card.PlayerHand and move.to then
                local target = move.to
                if target and target:getMark("mygo_chunri-turn") == 0 then
                    room:setPlayerMark(target, "mygo_chunri-turn", 1)
                end
            end
        end
    end,
})

Fk:loadTranslationTable{
    ["mygo_chunri"] = "春日",
    [":mygo_chunri"] = "主公技。每局游戏限两次，出牌阶段，你可以视为使用了一张【五谷丰登】，此牌结算完毕后，所有本回合获得过牌的角色将体力值调整为1。",
}

return chunri