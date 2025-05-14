local wenrou = fk.CreateSkill{
    name = "toge_wenrou",
    attached_skill_name = "toge_wenrou_active&"
}

wenrou:addAcquireEffect(
    function (self, player)
        local room = player.room
        local targets = room:getOtherPlayers(player)
        for _, v in ipairs(targets) do
            room:handleAddLoseSkills(v, "toge_wenrou_active&", self.name, nil, true)
        end
    end
)

wenrou:addEffect(fk.Deathed, {
    can_refresh = function (self, event, target, player, data)
        return target == player
    end,
    on_refresh = function(self, event, target, player, data)
        local room = player.room
        local targets = room:getOtherPlayers(player)
        for _, v in ipairs(targets) do
            room:handleAddLoseSkills(v, "-toge_wenrou_active&", self.name, nil, true)
        end
    end
})

Fk:loadTranslationTable{
    ["toge_wenrou"] = "温柔",
    [":toge_wenrou"] = "其他角色出牌阶段限一次，其可选择一项1.其对你造成1点伤害。2.其摸两张牌。3.其弃置你一张牌。然后你将选项中的“其”与“你”互换并执行剩余两项。",
}

return wenrou