-- SUF Advanced - Cyrillic transliteration tag for Shadowed Unit Frames
-- This file provides transliteration and registers custom SUF tags.


-- Ensure namespace exists (created in SUF_Advanced.lua)
SUF_Advanced.Tags = SUF_Advanced.Tags or {}
SUF_Advanced.Tags.Translit = {}

-- Simple Cyrillic -> Latin transliteration. Covers Russian and common Ukrainian letters.
local map = {
    ["А"]="A", ["а"]="a", ["Б"]="B", ["б"]="b", ["В"]="V", ["в"]="v",
    ["Г"]="G", ["г"]="g", ["Д"]="D", ["д"]="d", ["Е"]="E", ["е"]="e",
    ["Ё"]="Yo", ["ё"]="yo", ["Ж"]="Zh", ["ж"]="zh", ["З"]="Z", ["з"]="z",
    ["И"]="I", ["и"]="i", ["Й"]="Y", ["й"]="y", ["К"]="K", ["к"]="k",
    ["Л"]="L", ["л"]="l", ["М"]="M", ["м"]="m", ["Н"]="N", ["н"]="n",
    ["О"]="O", ["о"]="o", ["П"]="P", ["п"]="p", ["Р"]="R", ["р"]="r",
    ["С"]="S", ["с"]="s", ["Т"]="T", ["т"]="t", ["У"]="U", ["у"]="u",
    ["Ф"]="F", ["ф"]="f", ["Х"]="Kh", ["х"]="kh", ["Ц"]="Ts", ["ц"]="ts",
    ["Ч"]="Ch", ["ч"]="ch", ["Ш"]="Sh", ["ш"]="sh", ["Щ"]="Shch", ["щ"]="shch",
    ["Ъ"]="",  ["ъ"]="",  ["Ы"]="Y", ["ы"]="y", ["Ь"]="",  ["ь"]="",
    ["Э"]="E", ["э"]="e", ["Ю"]="Yu", ["ю"]="yu", ["Я"]="Ya", ["я"]="ya",
    -- Ukrainian extras
    ["Ґ"]="G", ["ґ"]="g", ["Є"]="Ye", ["є"]="ie", ["І"]="I", ["і"]="i", ["Ї"]="Yi", ["ї"]="i",
}

function SUF_Advanced.Tags.Translit.Transliterate(str)
    if not str or str == "" then return str end

    local hasCyrillic = false
    local out = {}
    local i = 1

    while i <= #str do
        local c = string.byte(str, i)
        local len = 1
        if c >= 240 then len = 4 elseif c >= 224 then len = 3 elseif c >= 192 then len = 2 end
        local ch = string.sub(str, i, i + len - 1)

        if map[ch] then
            hasCyrillic = true
            table.insert(out, map[ch])
        else
            table.insert(out, ch)
        end

        i = i + len
    end

    local result = table.concat(out)
    local finalResult = hasCyrillic and "!" .. result or result

    return finalResult
end

function SUF_Advanced.Tags.Translit.Register()
    if not ShadowUF or not ShadowUF.Tags then return end
    local Tags = ShadowUF.Tags

    -- Define the tag function code as a string (SUF expects a string of Lua code returning a function)
    local code = [[function(unit, unitOwner)
        local name = UnitName(unitOwner) or UNKNOWN

        if SUF_Advanced and SUF_Advanced.Tags.Translit.Transliterate then
            return SUF_Advanced.Tags.Translit.Transliterate(name)
        end
        return name
    end]]

    Tags.defaultTags["translit:name"] = code
    Tags.defaultNames["translit:name"] = "Name (Transliterated)"
    Tags.defaultHelp["translit:name"] = "Unit name transliterated from Cyrillic to Latin."
    Tags.defaultCategories["translit:name"] = "General"
    Tags.defaultEvents["translit:name"] = "UNIT_NAME_UPDATE GROUP_ROSTER_UPDATE"

    -- translit:abbrev:name
    local codeAbbrev = [[function(unit, unitOwner)
        local name = UnitName(unitOwner) or UNKNOWN

        if SUF_Advanced and SUF_Advanced.Tags.Translit.Transliterate then
            name = SUF_Advanced.Tags.Translit.Transliterate(name)
        end
        if ShadowUF and ShadowUF.Tags and ShadowUF.Tags.abbrevCache then
            -- mirror SUF's abbrev:name behavior (only abbreviate if >10 chars)
            if string.len(name) > 10 then
                return ShadowUF.Tags.abbrevCache[name]
            end
        end
        return name
    end]]

    Tags.defaultTags["translit:abbrev:name"] = codeAbbrev
    Tags.defaultNames["translit:abbrev:name"] = "Name (Transliterated + Abbreviated)"
    Tags.defaultHelp["translit:abbrev:name"] = "Transliterates Cyrillic to Latin, then abbreviates long names like SUF's [abbrev:name]."
    Tags.defaultCategories["translit:abbrev:name"] = "General"
    Tags.defaultEvents["translit:abbrev:name"] = "UNIT_NAME_UPDATE GROUP_ROSTER_UPDATE"

    -- Reload to register the new tag
    if Tags.Reload then Tags:Reload() end
end


