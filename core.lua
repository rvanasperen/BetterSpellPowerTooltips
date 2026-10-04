local function getReplacementText(text)
    local found = string.find(text, "spells and effects")

    -- Return early with an inexpesive non-regex call to prevent multiple regex matches on every single tooltip line
    if not found then
        return text
    end

    local amount, amount2, specific

    -- Spell power (damage and healing)
    amount = text:match("^Equip: Increases damage and healing done by magical spells and effects by up to (%d+)%.$")

    if amount then
        return "Equip: +" .. amount .. " Spell Power."
    end

    -- Spell damage
    amount = text:match("^Equip: Increases damage done by magical spells and effects by up to (%d+)%.$")

    if amount then
        return "Equip: +" .. amount .. " Spell Damage."
    end

    -- Spell damage vs specific races
    specific, amount = text:match("^Equip: Increases damage done to (%a+) by magical spells and effects by up to (%d+)%.$")

    if specific and amount then
        return "Equip: +" .. amount .. " Spell Damage against " .. specific .. "."
    end

    -- Spell damage for specific schools
    specific, amount = text:match("^Equip: Increases damage done by (%a+) spells and effects by up to (%d+)%.$")

    if specific and amount then
        return "Equip: +" .. amount .. " " .. specific .. " Spell Damage."
    end
    
    -- Spell healing
    amount, amount2 = text:match("^Equip: Increases healing done by up to (%d+) and damage done by up to (%d+) for all magical spells and effects%.$")

    if amount and amount2 then
        return "Equip: +" .. amount .. " Spell Healing.\nEquip: +" .. amount2 .. " Spell Damage."
    end

    return text
end

TooltipDataProcessor.AddTooltipPreCall(Enum.TooltipDataType.Item, function (self, data)
    if not data or not data.lines then return end

    for _, line in ipairs(data.lines) do
        if line.leftText and type(line.leftText) == "string" then
            line.leftText = getReplacementText(line.leftText)
        end
    end
end)
