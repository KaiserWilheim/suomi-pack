local jianqie = fk.CreateSkill{
    name = "mygo_jianqie"
}

jianqie:addEffect(fk.EventPhaseStart, {
    can_trigger = function (self, event, target, player, data)
        return player:hasSkill(self) and target.phase == Player.Start and target ~= player
    end,
    on_cost = function (self, event, target, player, data)
        local room = player.room
        local choices = {"Cancel"}
        if player.hp < player.maxHp then
            table.insert(choices, 1, "mygo_jianqie_recover")
        end
        if target:getHandcardNum() > 0 then
            table.insert(choices, 1, "mygo_jianqie_give")
        end
        local choice = room:askToChoice(target, {
            choices = choices,
            skill_name = self.name
        })
        if choice == "mygo_jianqie_recover" then
            room:recover{
                who = player,
                num = 1,
                recoverBy = target,
                skillName = self.name,
            }
        end
        if choice == "mygo_jianqie_give" then
            local cardId = room:askToChooseCard(target, {
                target = target,
                flag = "he",
                skill_name = self.name
            })
            room:obtainCard(player, cardId, false, fk.ReasonGive)
        end
        if choice == "Cancel" then return true end
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        local dismantlement = Fk:cloneCard("dismantlement")
        dismantlement.skillName = self.name
        if player:prohibitUse(dismantlement) then return false end
        local tos = {target.id}
        room:useCard({
            from = player.id,
            tos = table.map(tos, function(pid) return { pid } end),
            card = dismantlement,
        })
    end
})

Fk:loadTranslationTable{
    ["mygo_jianqie"] = "剪切",
    [":mygo_jianqie"] = "Mygo势力技。每名其他角色的准备阶段，其选择令你回复一点体力或交给你一张牌，否则你可视为对其使用了一张【过河拆桥】。",
    ["mygo_jianqie_recover"] = "令长崎素世回复一点体力",
    ["mygo_jianqie_give"] = "交给长崎素世一张牌",
}

return jianqie