-- SUF Advanced core namespace
-- Creates a single global table SUF_Advanced to be used by submodules in Tags/
local addonName, ns = ...

-- Ensure a consistent global namespace table
SUF_Advanced = SUF_Advanced or {}
_G.SUF_Advanced = SUF_Advanced

-- SavedVariables init
SUF_AdvancedDB = SUF_AdvancedDB or {}

-- Optionally expose addon name
SUF_Advanced.addonName = addonName

SUF_Advanced.Tags.Register()