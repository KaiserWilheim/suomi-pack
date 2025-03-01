local zibei = fk.CreateSkill{
    name = "mygo_zibei",
}

local maxcard

zibei:addEffect(fk.GameStart,{
    can_trigger =  function (self, event, target, player, data)
        if player:hasSkill(self.name) then maxcard = player:getMaxCards() end
        --print(maxcard)
    end
})

local res = {
    anim_type = "drawcard",
    can_trigger = function (self, event, target, player, data)
        if not player:hasSkill(self.name) then return false end
        if maxcard ~= player:getMaxCards() then
            maxcard = player:getMaxCards()
            --print(maxcard)
            return target == player
        end
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        if player:getHandcardNum() <= player:getMaxCards() then
            player:drawCards(player:getMaxCards() - player:getHandcardNum())
        elseif player:getHandcardNum() > player:getMaxCards() then
            local num = player:getHandcardNum() - player:getMaxCards()
            room:askForDiscard(player, num, num, false, self.name, false)
        end
        local aim = room:askToChoosePlayers(player, {
            targets = room:getOtherPlayers(player),
            min_num = 1,
            max_num = 1,
            prompt = "#mygo_zibei-ask",
            skill_name = self.name,
            cancelable = false,
        })
        local prey = aim[1]
        if prey:getHandcardNum() <= prey:getMaxCards() then
            prey:drawCards(prey:getMaxCards() - prey:getHandcardNum())
        elseif prey:getHandcardNum() > prey:getMaxCards() then
            local num = prey:getHandcardNum() - prey:getMaxCards()
            room:addPlayerMark(prey, "mygo_forced_discard")
            room:askForDiscard(prey, num, num, false, self.name, false)
        end
    end
}

zibei:addEffect(fk.HpChanged, res)
zibei:addEffect(fk.SkillEffect, res)

Fk:loadTranslationTable{
    ["mygo_zibei"] = "自卑",
    [":mygo_zibei"] = "当你的手牌上限发生变化后，你可以将手牌调整至手牌上限，然后令一名其他角色也进行此操作。",
    ["#mygo_zibei-ask"] = "选择一名其他角色，令其将手牌数调整至手牌上限",
}

return zibei