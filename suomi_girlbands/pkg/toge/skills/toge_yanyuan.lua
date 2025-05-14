local yanyuan = fk.CreateSkill{
    name = "toge_yanyuan",
}

yanyuan:addEffect(fk.AskForCardResponse, {
    anim_type = "support",
    can_trigger = function (self, event, target, player, data)
        local playercards = player:getCardIds({Player.Hand,Player.Equip})
        local canhelp = false
        for _, c in ipairs(playercards) do
            local card = Fk:getCardById(c)
            if ((data.cardName and data.cardName == card.name ) or (data.pattern and Exppattern:Parse(data.pattern):matchExp(card.name))) then
                self.cost_data = card
                canhelp = true
            end
        end
        return target and target ~= player and player:hasSkill(self.name) and canhelp
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        local cardResponded = room:askToResponse(player, {
            skill_name = self.cost_data.name,
            pattern = self.cost_data.name,
            prompt = "#toge_yanyuan_ask:::" .. self.cost_data.name,
            cancelable = true
        })
        if cardResponded then
            room:responseCard({
                from = player,
                card = cardResponded,
                skipDrop = true,
            })
            data.result = Fk:cloneCard(self.cost_data.name)
            data.result:addSubcards(room:getSubcardsByRule(cardResponded, {Card.Processing}))
            data.result.skillName = self.name
            local choices = {"toge_yanyuan_damage","toge_yanyuan_draw"}
            local choice = room:askToChoice(target,{
                choices = choices,
                skill_name =  self.name
            })
            if choice == "toge_yanyuan_damage" then
                room:damage{
                    to = player,
                    damage = 1,
                    damageType = fk.NormalDamage,
                    from = target,
                }
            else
                player:drawCards(1, self.name)
            end
            return true
        end
    end
})

yanyuan:addEffect(fk.AskForCardUse, {
    anim_type = "support",
    can_trigger = function (self, event, target, player, data)
        local playercards = player:getCardIds({Player.Hand,Player.Equip})
        local canhelp = false
        for _, c in ipairs(playercards) do
            local card = Fk:getCardById(c)
            if ((data.cardName and data.cardName == card.name ) or (data.pattern and Exppattern:Parse(data.pattern):matchExp(card.name)))  then
                self.cost_data = card
                canhelp = true
            end
        end
        return target and target ~= player and player:hasSkill(self.name) and canhelp
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        local cardResponded = room:askToResponse(player, {
            skill_name = self.cost_data.name,
            pattern = self.cost_data.name,
            prompt = "#toge_yanyuan_ask:::" .. self.cost_data.name,
            cancelable = true
        })
        if cardResponded then
            room:responseCard({
                from = player,
                card = cardResponded,
                skipDrop = true,
            })
            data.result = {
                from = player,
                card = Fk:cloneCard(self.cost_data.name),
            }
            data.result.card:addSubcards(room:getSubcardsByRule(cardResponded, { Card.Processing }))
            data.result.card.skillName = self.name
            if data.eventData then
                data.result.toCard = data.eventData.toCard
                data.result.responseToEvent = data.eventData.responseToEvent
            end
            local choices = {"toge_yanyuan_damage","toge_yanyuan_draw"}
            local choice = room:askToChoice(target,{
                choices = choices,
                skill_name =  self.name
            })
            if choice == "toge_yanyuan_damage" then
                room:damage{
                    to = player,
                    damage = 1,
                    damageType = fk.NormalDamage,
                    from = target,
                }
            else
                player:drawCards(1, self.name)  
            end
            return true
        end
    end
})

Fk:loadTranslationTable{
    ["toge_yanyuan"] = "演员",
    [":toge_yanyuan"] = "当一名其他角色需要响应牌时，你可代其响应之，然后其可对你造成一点伤害或令你摸一张牌。",
    ["#toge_yanyuan_ask"] = "你可代其使用一张【%arg】",
    ["toge_yanyuan_damage"] = "对安和昴造成一点伤害",
    ["toge_yanyuan_draw"] = "令安和昴摸一张牌",
  }

return yanyuan