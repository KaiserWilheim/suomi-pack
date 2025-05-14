local renzhen = fk.CreateSkill{
    name = "toge_renzhen",
}

renzhen:addEffect(fk.CardUsing, {
    anim_type = "offensive",
    can_trigger = function (self, event, target, player, data)
        if not player:hasSkill(self.name) then return end
        if target == player then return true
        else return target and target:getMark("@toge_renzhen") > 0 and not table.contains(player:getTableMark("@toge_renzhen_record"), data.card.trueName)
        end
    end,
    on_cost = function (self, event, target, player, data)
        if target == player then return true
        else return player.room:askToSkillInvoke(player, {
            skill_name = self.name,
            prompt = "#toge_renzhen_damage::" .. target.id,
        })
        end
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        if target == player then room:addTableMarkIfNeed(player, "@toge_renzhen_record", data.card.trueName)
        else
          room:damage{
            to = target,
            damage = 1,
            damageType = fk.NormalDamage,
            from = player,
          }
        end
    end,
})

renzhen:addEffect(fk.EventPhaseStart, {
    can_refresh = function (self, event, target, player, data)
        if not player:hasSkill(self.name) or not target == player then return end
        if player.phase == Player.Play then return true
        elseif player.phase == Player.Finish then return true
        end
    end,
    on_refresh = function (self, event, target, player, data)
        local room = player.room
        if player.phase == Player.Play then room:setPlayerMark(player, "@toge_renzhen_record", 0) end
        if player.phase == Player.Finish then
            local to = table.find(room.alive_players, function (p) return p:getMark("@toge_renzhen") > 0 end)
            if to then
                room:setPlayerMark(to,"@toge_renzhen",0)
            end
            local tos = room:askToChoosePlayers(player, {
                targets = room.alive_players,
                min_num = 1,
                max_num = 1,
                prompt = "#toge_renzhen_choose",
                skill_name = self.name,
                cancelable = true,
                no_indicate = false
            })
            if #tos > 0 then room:setPlayerMark(tos[1], "@toge_renzhen", 1) end
        end
    end,
})

Fk:loadTranslationTable{
    ["toge_renzhen"] = "认真",
    [":toge_renzhen"] = "出牌阶段开始时，你清除已记录的牌名。当你使用一张牌时，记录此牌名。结束阶段，你可选择一名其他角色，直到你下个结束阶段开始前，当其使用你未记录的牌时，你可对其造成一点伤害。",
    ["@toge_renzhen"] = "认真",
    ["@toge_renzhen_record"] = "认真",
    ["#toge_renzhen_choose"] = "认真：请选择一名角色，你有机会对其造成伤害",
    ["#toge_renzhen_damage"] = "认真：你可对%dest造成一点伤害",
  }

return renzhen