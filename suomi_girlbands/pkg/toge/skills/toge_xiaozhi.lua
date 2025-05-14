local xiaozhi = fk.CreateSkill{
    name = "toge_xiaozhi",
    tags = {Skill.Lord},
}

xiaozhi:addEffect(fk.Damaged, {
    anim_type = "offensive",
    can_trigger = function (self, event, target, player, data)
        return player:hasSkill(self.name) and target and target.kingdom == player.kingdom and target.phase == Player.NotActive and player:usedSkillTimes(self.name) == 0
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        local to = data.from
        room:damage{
          to = to,
          damage = 1,
          from = target,
          damageType = fk.NormalDamage,
        }
    end
})

Fk:loadTranslationTable{
    ["toge_xiaozhi"] = "小指",
    [":toge_xiaozhi"] = "主公技。每回合限一次，当与你同势力的角色于其回合外受到伤害后，你可令其对伤害来源造成一点伤害。"
}

return xiaozhi