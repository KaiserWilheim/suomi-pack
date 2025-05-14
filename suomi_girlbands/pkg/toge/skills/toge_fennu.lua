local fennu = fk.CreateSkill{
    name = "toge_fennu",
    tags = {Skill.Compulsory}
}

fennu:addEffect(fk.Damage, {
    anim_type = "offensive",
    can_trigger = function (self, event, target, player, data)
        return player:hasSkill(self) and target and target == player
    end,
    on_cost = function (self, event, target, player, data)
        local room = player.room
        local targets = table.filter(room:getOtherPlayers(player), function (p) return p:getMark("toge_fennu_record-round") > 0 end)
        if #targets == 0 then return end
        room:doIndicate(player, targets)
        return room:askToSkillInvoke(player, {skill_name = self.name, prompt = "#toge_fennu_ask"})
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        local targets = table.filter(room:getOtherPlayers(player), function (p)return p:getMark("toge_fennu_record-round") > 0 end)
        for _, v in ipairs(targets) do
            room:damage{
                to = v,
                damage = 1,
                damageType = fk.NormalDamage,
            }
        end
        for _, v in ipairs(targets) do
            local doslash = room:askToUseCard(v, {
                skill_name = self.name, "slash",
                prompt = "#toge_fennu-use:"..player.id,
                cancelable = true,
                extra_data = {
                    exclusive_targets = {player.id},
                    bypass_distances = true,
                    bypass_times = true
                }
            })
            if doslash then
                print("will do slash")
                room:useCard(doslash)
            else
                if not target.tos[1]:isNude() then
                    local card = room:askToChooseCard(v, {
                        target = v,
                        flag = "he",
                        skill_name = self.name
                    })
                    room:obtainCard(player, card, true, fk.ReasonGive, target.tos[1], self.name)
                end
            end
        end
    end
})

fennu:addEffect(fk.Damage, {
    can_refresh = function (self, event, target, player, data)
        return player:hasSkill(self) and target
    end,
    on_refresh = function (self, event, target, player, data)
        player.room:addPlayerMark(target,"toge_fennu_record-round",1)
    end
})

Fk:loadTranslationTable{
    ["toge_fennu"] = "愤怒",
    [":toge_fennu"] = "锁定技。当你造成伤害后，你可令本轮受到过伤害的其他角色受到1点伤害，然后这些角色须对你使用一张【杀】，否则其交给你一张牌。",
    ["#toge_fennu_ask"] = "愤怒：你可对这些角色造成1点伤害，然后他们可能对你使用【杀】或交给你牌。",
    ["#toge_fennu-use"] = "愤怒：对%dest使用一张【杀】，否则须交给其一张牌",
}

return fennu