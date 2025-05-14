local jiaxiao = fk.CreateSkill{
    name = "mygo_jiaxiao",
}

local U = require "packages/utility/utility"

jiaxiao:addEffect(fk.EventPhaseStart, {
    can_trigger = function (self, event, target, player, data)
        local room = player.room
        if player:hasSkill(self) and not player:isKongcheng() then room:setPlayerMark(player, "@mygo_jiaxiao", 0) end
        return player:hasSkill(self) and target.phase == Player.Start
    end,
    on_cost = function(self, event, target, player, data)
        local room = player.room
        for _, p in ipairs(room:getOtherPlayers(player)) do
            if p:isKongcheng() then
                room:setPlayerMark(p, "@mygo_jiaxiao", 1)
            elseif not room:askToSkillInvoke(p, {
                skill_name =  self.name,
                prompt = "#mygo_jiaxiao-ask"
            }) then
                room:setPlayerMark(p, "@mygo_jiaxiao", 1)
            end
        end
        return true
    end,
    on_use = function (self, event, target, player, data)
        local room = player.room
        local targets = table.filter(room.alive_players, function(p) return p:getMark("@mygo_jiaxiao") == 0 and not p:isKongcheng() end)
        local discussion = U.Discussion(player, targets, self.name)
        if discussion.color == discussion.results[player].opinion then
            local duelplayer = room:getAlivePlayers()
            local to ={}
            if #duelplayer > 0 then
                to = room:askToChoosePlayers(player, {
                    targets = duelplayer,
                    min_num = 2,
                    max_num = 2,
                    prompt = "#mygo_jiaxiao-choose",
                    skill_name = self.name,
                    cancelable = false
                })
            end
            if not to[1]:prohibitUse(Fk:cloneCard("duel")) then
                local duel = Fk:cloneCard("duel")
                local use = {from = to[1], tos = {to[2]}, card = duel , extraUse = true}
                room:useCard(use)
            end
        else
                room:changeMaxHp(player, -1)
                room:drawCards(player, 2, self.name)
        end
    end
})

jiaxiao:addEffect("prohibit", {
    prohibit_use = function(self, player, card)
        if player:getMark("@mygo_jiaxiao") > 0 then
            local subcards = card:isVirtual() and card.subcards or {card.id}
            return #subcards > 0 and table.every(subcards, function(id) return table.contains(player:getCardIds(Player.Hand), id) end)
        end
    end,
    prohibit_response = function(self, player, card)
        if player:getMark("@mygo_jiaxiao") > 0 then
            local subcards = card:isVirtual() and card.subcards or {card.id}
            return #subcards > 0 and table.every(subcards, function(id) return table.contains(player:getCardIds(Player.Hand), id) end)
        end
    end
})

Fk:loadTranslationTable{
    ["mygo_jiaxiao"] = "假笑",
    [":mygo_jiaxiao"] = "Crychic势力技。每名角色的准备阶段开始时，你议事并令其他角色选择是否参与议事，未参与的角色本回合不能使用或打出手牌，若议事结果与你的意见相同，你可令一名角色对另一名角色视为使用了一张【决斗】，否则你减少一点体力上限并摸两张牌。",
    ["#mygo_jiaxiao-ask"] = "假笑：是否参与议事，若不参与，本回合你不能使用或打出牌",
    ["#mygo_jiaxiao-choose"] = "假笑：选择两名角色，先选择的角色视为对后选择的角色使用【决斗】",
    ["@mygo_jiaxiao"] = "假笑",
}

return jiaxiao