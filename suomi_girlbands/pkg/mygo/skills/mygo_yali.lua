local yali = fk.CreateSkill{
    name = "mygo_yali",
}

yali:addEffect(fk.TargetSpecified, {
    anim_type = "offensive",
    can_trigger = function (self, event, target, player, data)
        if not player:hasSkill(self.name) then return false end
        if target ~= player then return false end
        --print(data.to:getMark("mygo_yali-turn"))
        if data.to:getMark("mygo_yali-turn") > 0 then return false end
        return data.to:getLostHp() >= player:getLostHp()
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        room:addPlayerMark(data.to, "mygo_yali-turn")
        room:damage{
            from = player,
            to = data.to,
            damage = 1
        }
    end
})

yali:addEffect(fk.AfterCardsMove, {
    anim_type = "offensive",
    can_trigger = function (self, event, target, player, data)
        if player:hasSkill(self.name) then
            local move = data[1]
            if move.moveReason ~= fk.ReasonDiscard then return false end
            print("found discard")
            if not move.from then return false end
            local to = move.from
            if move.proposer == to and (to:getMark("mygo_forced_discard") or to == player)
            then
                print("forced discard found")
                if to:getMark("mygo_yali-turn") then return false end
                return to:getLostHp() >= player:getLostHp()
            else print("normal discard found")
            end
            local room = player.room
            room:removePlayerMark(to, "mygo_forced_discard", to:getMark("mygo_forced_discard"))
        end
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        local to = data[1].from
        room:addPlayerMark(to, "mygo_yali-turn")
        room:damage{
            from = player,
            to = to,
            damage = 1
        }
    end
})

Fk:loadTranslationTable{
    ["mygo_yali"] = "压力",
    [":mygo_yali"] = "你对已损失体力值不小于你的角色使用牌或使其弃置牌时，你可以对其造成一点伤害。（每回合每名角色限一次）",
}

return yali