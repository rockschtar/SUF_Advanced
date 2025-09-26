
local Tags  = {}

SUF_Advanced = SUF_Advanced or {}
SUF_Advanced.Tags = Tags


function SUF_Advanced.Tags:Register()

    local function Print(msg)
        DEFAULT_CHAT_FRAME:AddMessage("|cff79c0ffSUF Advanced|r: " .. tostring(msg))
    end

    -- Event handling
    local f = CreateFrame("Frame")

    f:RegisterEvent("ADDON_LOADED")
    f:RegisterEvent("PLAYER_LOGIN")
    f:RegisterEvent("PLAYER_ENTERING_WORLD")
    f:RegisterEvent("GROUP_ROSTER_UPDATE")
    f:RegisterEvent("PLAYER_ROLES_ASSIGNED")

    f:SetScript("OnEvent", function(self, event, arg1)
        if event == "ADDON_LOADED" then
            if arg1 == addonName then
                -- our addon loaded
            elseif arg1 == "ShadowedUnitFrames" then
                -- Register tag once SUF is available
                SUF_Advanced.Tags.Translit.Register()

            end
        elseif event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" then
            if ShadowUF then
                SUF_Advanced.Tags.Translit.Register()
            end
        elseif event == "GROUP_ROSTER_UPDATE" or event == "PLAYER_ROLES_ASSIGNED" then
            -- if SUF_AdvancedDB.roleSort then ApplyRoleSort() end
        end
    end)

end
