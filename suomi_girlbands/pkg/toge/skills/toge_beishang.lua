local beishang = fk.CreateSkill{
    name = "toge_beishang",
    tags = {Skill.Compulsory}
}

beishang:addEffect(fk.Damaged, {
    anim_type = "masochism",
    can_trigger = function (self, event, target, player, data)
        return player:hasSkill(self) and target and target == player
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        local num = player:usedSkillTimes(self.name, Player.HistoryRound) - 1
        player:drawCards(num, self.name)
        room:recover{
            who = player,
            num = num,
            skillName = self.name,
            recoverBy = player,
        }
    end
})

Fk:loadTranslationTable{
    ["toge_beishang"] = "悲伤",
    [":toge_beishang"] = "锁定技。当你受到伤害后，你摸x张牌并回复x点体力（x为本轮此技能已发动过的次数且最少为0）。",
}

return beishang