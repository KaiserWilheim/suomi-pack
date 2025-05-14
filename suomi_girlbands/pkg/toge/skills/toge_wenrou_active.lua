local wenrou_active = fk.CreateSkill{
    name = "toge_wenrou_active&"
}

wenrou_active:addEffect("active", {
    can_use = function (self, player)
        return player:usedSkillTimes(self.name) == 0
    end,
    card_filter = Util.FalseFunc,
    target_filter = Util.FalseFunc,
    on_use = function (self, room, effect)
        local player = table.find(room.alive_players, function (p) return p:hasSkill("toge_wenrou") end)
        if not player then return end
        local target = effect.from
        local choices = {"toge_wenrou_damage","toge_wenrou_draw","toge_wenrou_discard"}
        local choice = room:askToChoice(target, {
            choices = choices,
            skill_name = self.name
        })
        if choice == "toge_wenrou_damage" then
            room:damage{
                to = player,
                damage = 1,
                damageType = fk.NormalDamage,
                from = target,
            }
            player:drawCards(2,self.name)
            local card = room:askToChooseCard(player, {
                target = target,
                flag = "he",
                skill_name = self.name
            })
            room:throwCard(card, self.name, target, player)
        elseif choice == "toge_wenrou_draw" then
            target:drawCards(2, self.name)
            room:damage{
                to = target,
                damage = 1,
                damageType = fk.NormalDamage,
                from = player,
            }
            local card = room:askToChooseCard(player, {
                target = target,
                flag = "he",
                skill_name = self.name
            })
            room:throwCard(card, self.name, target, player)
        else
            local card = room:askToChooseCard(target, {
                target = player,
                flag = "he",
                skill_name = self.name
            })
            room:throwCard(card, self.name, player, target)
            player:drawCards(2, self.name)
            room:damage{
                to = target,
                damage = 1,
                damageType = fk.NormalDamage,
                from = player,
            }
        end
    end
})

Fk:loadTranslationTable{
    ["toge_wenrou_active&"] = "温柔",
    [":toge_wenrou_active&"] = "出牌阶段限一次，你可选择一项1.对卢帕造成1点伤害。2.你摸两张牌。3.你弃置卢帕一张牌。然后卢帕执行剩余两项的效果。",
    ["toge_wenrou_damage"] = "对卢帕造成1点伤害",
    ["toge_wenrou_draw"] = "摸两张牌",
    ["toge_wenrou_discard"] = "弃置卢帕一张牌",
}

return wenrou_active