local counter = {
    inInstance = false,
    -- active = false,
    unitName = 'Defu',
    deaths = 0,
    instanceName = ''
}

local DeathCounterFrame = CreateFrame("FRAME", "DeathCounter")
local events = {}

function events:PLAYER_ENTERING_WORLD(...)
    -- todo:
    -- take death statistics to database for high scores / averages for each dungeon
    local ZoneName, InstanceType, DifficultyID, _, _, _, _, ZoneMapID = GetInstanceInfo()

    counter.inInstance = IsInInstance()
    if counter.inInstance then
        if counter.instanceName ~= ZoneName then
            counter.instanceName = ZoneName
            SendChatMessage("Welcome to " .. counter.instanceName .. " " .. counter.unitName .. "! Your death counter has been reset.", "party");
            counter.deaths = 0
        end
    end
end

-- todo: Timer before death?
-- function events:PLAYER_REGEN_DISABLED(...)
--     if not counter.inInstance then return end

--     counter.active = true
-- end

function events:PLAYER_REGEN_ENABLED(...)
    if not counter.inInstance then return end

    if UnitIsDead(counter.unitName) then
        counter.deaths = counter.deaths + 1
        SendChatMessage(counter.unitName .. " death count: " .. counter.deaths, "party")
    end

    -- counter.active = false
end

DeathCounterFrame:SetScript("OnEvent", function(self, event, ...)
    events[event](self, ...)
end)

for k, v in pairs(events) do
    DeathCounterFrame:RegisterEvent(k)
end