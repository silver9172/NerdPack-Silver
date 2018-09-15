local _, Silver = ...

---------------------------------------
--------------- General ---------------
---------------------------------------
NeP.DSL:Register('sated', function()
    if NeP.DSL:Get('debuff')('player', 'Sated') or NeP.DSL:Get('debuff')('player', 'Exhaustion') or NeP.DSL:Get('debuff')('player', 'Fatigued') or NeP.DSL:Get('debuff')('player', 'Insanity') or NeP.DSL:Get('debuff')('player', 'Fatigued') or NeP.DSL:Get('debuff')('player', 'Temporal Displacement') then
        return true
    else
        return false
    end
end)

NeP.DSL:Register('xequipped', function(item)
    if IsEquippedItem(item) then
        return 1
    else
        return 0
    end
end)

NeP.DSL:Register('talent.enabled', function(_, x,y)
    if NeP.DSL:Get('talent')(_, x,y) then
        return 1
    else
        return 0
    end
end)

NeP.DSL:Register('deficit', function()
    local max = UnitPowerMax('player')
    local curr = UnitPower('player')
	--print(max - curr)
    return (max - curr)
end)

NeP.DSL:Register('gcd.remains', function()
    return NeP.DSL:Get('spell.cooldown')('player', '61304')
end)

NeP.DSL:Register('gcd.max', function()
    return NeP.DSL:Get('gcd')()
end)

NeP.DSL:Register('pmana', function()
    local mana = UnitPower('target')
	return (mana)
end)

-- Need enemy last cast event

local castingEventSpellsAOE = { 
	-- Testing
	'Hearthstone',
---------------------------------------
--------- Tomb of Sargeras ------------
---------------------------------------
	-- Demonic Inquisition
	'Anguished Outburst',
	
	-- Harjatan
	'Unchecked Rage',
	
	-- The Desolate Host
	'Sundering Doom',
	
	-- Maiden of Vigilance
	'Hammer of Creation', 
	'Hammer of Obliteration',
	
	-- Fallen Avatar 
	'Sear',
	
	-- Kil'jaeden
	'Hopelessness',
}

NeP.DSL:Register('castingeventAOE', function()
    for i=1, #castingEventSpellsAOE do
        if NeP.DSL:Get("casting")("target", castingEventSpellsAOE[i]) then return true end
    end
end)

---------------------------------------
---------------- Raid -----------------
---------------------------------------

-- partycheck= 1 (SOLO), partycheck= 2 (PARTY), partycheck= 3 (RAID)
NeP.DSL:Register('partycheck', function()
        if IsInRaid() then
            return 3
        elseif IsInGroup() then
            return 2
        else
            return 1
        end
end)

NeP.DSL:Register('bosscheck', function()
		local check = 0
		if ( UnitClassification("target") == "boss" ) then
			check = 1
			return check
		elseif ( UnitClassification("target") == "worldboss" ) then
			check = 1
			return check
		elseif ( UnitClassification("target") == "rareelite" ) then
			check = 1
			return check
		elseif ( UnitClassification("target") == "rare" ) then
			check = 1
			return check
		elseif UnitLevel("target") >= UnitLevel("player") + 2 then
			check = 1
			return check
		else
			return check
		end
end)

-- Needs to stop rotation when target has a buff/debuff preventing dmg
NeP.DSL:Register('immunitycheck', function ()
	for i=1,40 do
		local name,_,_,_,_,expires = UnitDebuff('target',i)
		if name == 'Rend' then
			local endTime = expires - GetTime()
			return endTime
		end
	end
	return 0
end)

---------------------------------------
--------------- Rogue -----------------
---------------------------------------

NeP.DSL:Register('combopoints.deficit', function ()
	local max = 5
    if NeP.DSL:Get('talent.enabled')(nil, '3,2') == 1 then
        max = 6
    end
	local curr = GetComboPoints('player','target')
	--print(max - curr)
	return (max - curr)
end)

---------------------------------------
-------------- Warrior ----------------
---------------------------------------

NeP.DSL:Register('ignorepain', function ()
    for i=1,40 do
		local name,_,_,_,_,_,_,_,_,_,_,_,_,_,_,value = UnitBuff('player',i)
		if name == 'Ignore Pain' then
			--print(value)
			return value
		end
	end
	return 0
end)

---------------------------------------
-------------- Warlock ----------------
---------------------------------------

NeP.DSL:Register('shards', function ()
	local shards = WarlockPowerBar_UnitPower("player")
	return shards
end)

NeP.DSL:Register('unstableaffliction', function ()
    local count = 0
    for i = 1, 40, 1 do
	
        if (UnitAura("target", i, "PLAYER|HARMFUL") == "Unstable Affliction") then
            count = count + 1
        end
    end
	--print('Unstable Afflictions: '..count)
	return count
end)