
SUF_Advanced = SUF_Advanced or {}
SUF_Advanced.PartyOrder = {}


local function partyOrder()
    if not ShadowUF then
        return
    end
    local groupingOrder = "DAMAGER,HEALER,TANK,NONE"
    if ShadowUF.Units.headerFrames.party then
        ShadowUF.Units.headerFrames.party:SetAttribute("groupingOrder", groupingOrder)
        ShadowUF.Units.headerFrames.party:SetAttribute("groupBy", "ASSIGNEDROLE")
    end

    if ShadowUF.Units.headerFrames.raid then
        ShadowUF.Units.headerFrames.raid:SetAttribute("groupingOrder", groupingOrder)
        ShadowUF.Units.headerFrames.raid:SetAttribute("groupBy", "ASSIGNEDROLE")
    end
end


local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_ROLES_ASSIGNED")
frame:RegisterEvent("UNIT_CONNECTION")
frame:RegisterEvent("ADDON_LOADED")

frame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == "ShadowedUnitFrames" then
            partyOrder()
        end
        return
    end

    partyOrder()
end)
