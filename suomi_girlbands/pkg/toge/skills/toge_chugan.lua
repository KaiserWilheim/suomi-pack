local chugan = fk.CreateSkill{
    name = "toge_chugan",
}

chugan:addEffect(fk.CardUsing, {
    anim_type = "special",
    can_trigger = function (self, event, target, player, data)
        return player:hasSkill(self) and target and target == player
    end,
    on_cost = Util.TrueFunc,
    on_use = function(self, event, target, player, data)
        local room = player.room
        if player:getMark("@toge_chugan_color") == "黑" then
            room:loseHp(player, 1, self.name)
            local targets = table.filter(room.alive_players, function(p) return not p:isAllNude() end)
            if #targets > 0 then
                local to = room:askToChoosePlayers(player, {
                    targets = targets,
                    min_num = 1,
                    max_num = 1,
                    prompt = "#toge_chugan_black-choose",
                    skill_name = self.name
                })
                if #to > 0 then
                    local id = room:askToChooseCard(player, {
                        target = to[1],
                        flag = "hej",
                        skill_name = self.name
                    })
                    room:throwCard({id}, self.name, to[1], player)
                end
            end
        else
            if not player:isAllNude() then
                room:askToDiscard(player,{
                    min_num = 1,
                    max_num = 1,
                    include_equip = true,
                    skill_name = self.name,
                    cancelable = false
                })
                local targets = table.filter(room.alive_players, function(p) return p:isWounded() end)
                if #targets > 0 then
                    local to = room:askToChoosePlayers(player, {
                        targets = targets,
                        min_num = 1,
                        max_num = 1,
                        prompt = "#toge_chugan_red-choose",
                        skill_name = self.name
                    })
                    if #to > 0 then
                        room:recover{
                            who = to[1],
                            num = 1,
                            recoverBy = player,
                            skillName = self.name,
                        }
                    end
                end
            end
        end
    end,
})

chugan:addEffect(fk.RoundStart, {
    can_refresh = function(self, event, target, player, data)
        return player:hasSkill(self, true)
    end,
    on_refresh = function(self, event, target, player, data)
        local room = player.room
        room:setPlayerMark(player, "@toge_chugan_color", "<font color='red'>" .. "红" .. "</font>")
    end,
})

chugan:addEffect(fk.AfterCardsMove, {
    can_refresh = function(self, event, target, player, data)
        if not player:hasSkill(self, true) then return false end
        for _, move in ipairs(data) do
            if move.toArea == Card.DiscardPile then return true end
        end
    end,
    on_refresh = function(self, event, target, player, data)
        local room = player.room
        for _, move in ipairs(data) do
            if move.toArea == Card.DiscardPile then
                for _, info in ipairs(move.moveInfo) do
                    if Fk:getCardById(info.cardId).color == Card.Red then
                        room:addPlayerMark(player, "toge_chugan_red-round",1)
                    elseif Fk:getCardById(info.cardId).color == Card.Black then
                        room:addPlayerMark(player, "toge_chugan_black-round",1)
                    end
                end
            end
        end
        local red = player:getMark("toge_chugan_red-round")
        local black = player:getMark("toge_chugan_black-round")
        local toge_chugan_info = ""
        if red > black then
            toge_chugan_info = "<font color='red'>" .. "红" .. "</font>"
        elseif red < black then
            toge_chugan_info = "黑"
        else
            toge_chugan_info = "<font color='red'>" .. "红" .. "</font>"
        end
        room:setPlayerMark(player, "@toge_chugan_color", toge_chugan_info)
    end,
})

Fk:loadTranslationTable{
    ["toge_chugan"] = "触感",
    [":toge_chugan"] = "当你使用一张牌时，若本轮进入弃牌堆的牌中黑色牌多于红色牌，你失去一点体力，然后弃置一名角色一张牌，若黑色牌不多于红色牌，你弃置一张牌，然后令一名角色回复一点体力。",
    ["@toge_chugan_color"] = "触感",
    ["#toge_chugan_black-choose"] = "选择被弃置牌的角色",
    ["#toge_chugan_red-choose"] = "选择回复体力的角色",
}

return chugan