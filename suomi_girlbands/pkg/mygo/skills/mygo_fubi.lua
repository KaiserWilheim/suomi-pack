local fubi = fk.CreateSkill{
    name = "mygo_fubi",
    tags = {Skill.Quest},
}

local U = require "packages/utility/utility"

fubi:addEffect(fk.GameStart, {
    mute = true,
    can_trigger = function (self, event, target, player, data)
        return player:hasSkill(self)
    end,
    on_trigger = function (self, event, target, player, data)
        local room = player.room
        local choices = { "fubi_draw","fubi_discard" }
        for _, v in ipairs(room:getOtherPlayers(player)) do
            local choise = room:askToChoice(player, {
                choices = choices,
                skill_name = self.name
            })
            if choise == "fubi_draw" then
                room:drawCards(v, 1, self.name)
                v:addMark("#@mygo_fubi", 1)
            elseif choise == "fubi_discard" then
                room:askToDiscard(v, {
                    min_num = 1,
                    max_num = 1,
                    include_equip = true,
                    skill_name =  self.name,
                    cancelable = false
                })
            end
        end
    end,
})

fubi:addEffect("fk.DiscussionFinished", {
    can_trigger = function (self, event, target, player, data)
        if not player:hasSkill(self) then return false end
        if not data.results[player.id] then return false end
        return table.find(data.tos, function(p) return not p.dead and data.results[p.id] and data.results[player.id].opinion ~= data.results[p.id].opinion end)
    end,
    on_cost = function (self, event, target, player, data)
        local targets = table.filter(data.tos, function(p) return not p.dead and data.results[p.id] and data.results[player.id].opinion ~= data.results[p.id].opinion end)
        targets = table.filter(targets, function (p) return p:getMark("#@mygo_fubi") > 0 end)
        if #targets > 0 then
            local to = player.room:askToChoosePlayers(player, {
                targets = targets,
                min_num = 1,
                max_num = 1,
                prompt =  "#fubi-choose",
                skill_name =  self.name,
                cancelable = true
            })
            if #to > 0 then
                self.cost_data = {tos = to}
                return true
            end
        end
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        player.room:damage{
            from = player,
            to = self.cost_data.tos[1],
            damage = 1,
            skillName = self.name,
        }
    end
})

fubi:addEffect(fk.EnterDying, {
    can_trigger = function (self, event, target, player, data)
        if target == player or target:getMark("#@mygo_fubi") then
            return player:hasSkill(self)
        end
    end,
    on_cost = function (self, event, target, player, data)
        return true
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        room:notifySkillInvoked(player, self.name)
        room:handleAddLoseSkills(player, "mygo_jianqie")
        room:invalidateSkill(player, self.name)
        room:invalidateSkill(player, "mygo_jiaxiao")
        room:changeKingdom(player, "mygo")
        if player.hp > 1 then
            room:loseHp(player, player.hp - 1 ,self.name)
        else
            room:recover({
                who = player,
                num = 1 - player.hp,
                recoverBy = player,
                skillName = self.name,
            })
        end
        room:updateQuestSkillState(player, self.name, true) 
        for _, p in ipairs(room.alive_players) do
            room:setPlayerMark(p, "#@mygo_fubi", 0)
            room:setPlayerMark(p, "@mygo_jiaxiao", 0)
        end
    end
})

Fk:loadTranslationTable{
    ["mygo_fubi"] = "复辟",
    [":mygo_fubi"] = "使命技。游戏开始时，你可令每名其他角色摸一张牌或弃置一张牌。当你参与议事结束后，你可对一名以此法摸牌且与你意见不同的角色造成一点伤害。失败：当你或以此法摸牌的角色进入濒死。你将体力调整为1点并改为Mygo势力。",
    ["#fubi-choose"] = "复辟：都是你的错，那个时候和这次都是。",
    ["fubi_draw"] = "其摸一张牌，之后其与你意见不同时你可对其造成伤害，其濒死时你变为Mygo势力",
    ["fubi_discard"] = "其弃置一张牌",
}

return fubi