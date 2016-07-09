-----------------------------------
-- Area: West Ronfaure
-- NPC:  Vilatroire
-- Involved in Quests: "Introduction To Teamwork", "Intermediate Teamwork",
-- "Advanced Teamwork"
-- @pos -260.361 -70.999 423.420 100
-----------------------------------

require("scripts/globals/quests");
require("scripts/zones/West_Ronfaure/TextIDs");

-----------------------------------
-- onTrade Action
-----------------------------------

function onTrade(player,npc,trade)

end;

-----------------------------------
-- onTrigger Action
-----------------------------------

function onTrigger(player,npc)
    --player:startEvent(0x0083); -- Same job
    --player:startEvent(0x0085); -- Same race
    local introTmwrk = player:getQuestStatus(SANDORIA,INTRODUCTION_TO_TEAMWORK);
    local intermTmwrk = player:getQuestStatus(SANDORIA,INTERMEDIATE_TEAMWORK);
    local advTmwrk = player:getQuestStatus(SANDORIA,ADVANCED_TEAMWORK);
    local sFame = player:getFameLevel(SANDORIA);
    local pLvl = player:getMainLvl()
    local partySize = player:getPartySize(0)

    local introStReq = (introTmwrk == QUEST_AVAILABLE and sFame > 1);
    local intermStReq = (introTmwrk == QUEST_COMPLETED and pLvl > 9 and sFame > 2);
    local advStReq = (itermTmwrk == QUEST_COMPLETED and pLvl > 9 and sFame > 3);

    if (introStReq) then
        player:startEvent(0x0087); -- Starts first quest - 6 members same alliance
    elseif (introTmwrk == QUEST_ACCEPTED) then
        player:startEvent();
    elseif (intermStReq) then
        player:startEvent(0x0085); -- Starts the second quest - 6 members same race
    elseif (intermTmwrk == QUEST_ACCEPTED) then
        player:startEvent(0x0086); -- You don't have the requirements to finish
    elseif (advStReq) then
        player:startEvent(0x0083); -- Starts the third quest - 6 members same job
    else
        player:startEvent(0x0088); -- Default - before quests
    end
end;

-----------------------------------
-- onEventUpdate
-----------------------------------

function onEventUpdate(player,csid,option)
--printf("CSID: %u",csid);
--printf("RESULT: %u",option);
end;

-----------------------------------
-- onEventFinish
-----------------------------------

function onEventFinish(player,csid,option)
--printf("CSID: %u",csid);
--printf("RESULT: %u",option);

end;
