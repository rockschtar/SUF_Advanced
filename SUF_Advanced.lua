-- SUF Advanced core namespace
-- Creates a single global table SUF_Advanced to be used by submodules in Tags/
local addonName, ns = ...

-- Ensure a consistent global namespace table
SUF_Advanced = SUF_Advanced or {}
_G.SUF_Advanced = SUF_Advanced

-- SavedVariables init
SUF_AdvancedDB = SUF_AdvancedDB or {}
if SUF_AdvancedDB.partyRoleSort == nil then
    SUF_AdvancedDB.partyRoleSort = true
end

-- Optionally expose addon name
SUF_Advanced.addonName = addonName

-- Simple slash command for toggling features
SLASH_SUFADV1 = "/sufadv"
SlashCmdList["SUFADV"] = function(msg)
    msg = (msg or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
    if msg == "" or msg == "help" then
        print("SUF Advanced:")
        print("  /sufadv partyrolesort on|off|toggle|status|apply")
        return
    end

    local cmd, arg = msg:match("^(%S+)%s*(.*)$")
    if cmd == "partyrolesort" then
        arg = (arg or ""):lower()
        if arg == "on" then
            SUF_AdvancedDB.partyRoleSort = true
            print("SUF Advanced: Party role sorting is now ON.")
            if SUF_Advanced and SUF_Advanced.PartyOrder and SUF_Advanced.PartyOrder.ApplyNow then
                C_Timer.After(0.05, function() SUF_Advanced.PartyOrder:ApplyNow() end)
            end
        elseif arg == "off" then
            SUF_AdvancedDB.partyRoleSort = false
            print("SUF Advanced: Party role sorting is now OFF.")
        elseif arg == "toggle" then
            SUF_AdvancedDB.partyRoleSort = not (SUF_AdvancedDB.partyRoleSort == false)
            print("SUF Advanced: Party role sorting is now " .. (SUF_AdvancedDB.partyRoleSort and "ON" or "OFF") .. ".")
            if SUF_AdvancedDB.partyRoleSort and SUF_Advanced and SUF_Advanced.PartyOrder and SUF_Advanced.PartyOrder.ApplyNow then
                C_Timer.After(0.05, function() SUF_Advanced.PartyOrder:ApplyNow() end)
            end
        elseif arg == "status" then
            print("SUF Advanced: Party role sorting is " .. (SUF_AdvancedDB.partyRoleSort and "ON" or "OFF") .. ".")
        elseif arg == "apply" then
            if SUF_Advanced and SUF_Advanced.PartyOrder and SUF_Advanced.PartyOrder.ApplyNow then
                SUF_Advanced.PartyOrder:ApplyNow()
            else
                print("SUF Advanced: PartyOrder module not ready yet.")
            end
        else
            print("Usage: /sufadv partyrolesort on|off|toggle|status|apply")
        end
    else
        print("SUF Advanced: Unknown command. Type /sufadv help")
    end
end

SUF_Advanced.Tags.Register()