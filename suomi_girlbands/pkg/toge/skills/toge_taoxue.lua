local taoxue = fk.CreateSkill{
    name = "toge_taoxue",
    tags = {Skill.Compulsory},
}

taoxue:addEffect(fk.DamageCaused, {
    anim_type = "control",
    can_trigger = function (self, event, target, player, data)
        return player:hasSkill(self) and target and target == player and player.phase == Player.NotActive and player:usedSkillTimes(self.name) == 0
    end,
    on_cost = function (self, event, target, player, data)
        return player.room:askToSkillInvoke(player,{
            skill_name = self.name,
            prompt = "#toge_taoxue::" .. player.id
        })
    end,
    on_use = function (self, event, target, player, data)
        player:drawCards(2, self.name)
        data.damage = 0
        return true
    end
})

taoxue:addEffect(fk.DamageInflicted, {
    anim_type = "control",
    can_trigger = function (self, event, target, player, data)
        return player:hasSkill(self) and target and target == player and player.phase == Player.NotActive and player:usedSkillTimes(self.name) == 0
    end,
    on_cost = function (self, event, target, player, data)
        return player.room:askToSkillInvoke(player,{
            skill_name = self.name,
            prompt = "#toge_taoxue::" .. data.from.id
        })
    end,
    on_use = function (self, event, target, player, data)
        data.from:drawCards(2, self.name)
        data.damage = 0
        return true
    end
})

Fk:loadTranslationTable{
    ["toge_taoxue"] = "逃学",
    [":toge_taoxue"] = "锁定技。每回合限一次，当你于回合外造成/受到伤害时，你可防止之，并令你/伤害来源摸两张牌。",
    ["#toge_taoxue"] = "逃学：你可防止此伤害，并令%dest摸两张牌",
} 

return taoxue