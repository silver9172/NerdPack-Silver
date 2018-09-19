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
		-- This is for dungeon bosses
		elseif UnitLevel("target") >= UnitLevel("player") + 2 and not IsInRaid() then
			check = 1
			return check
		elseif UnitLevel("target") < 0 then
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

NeP.DSL:Register('energy.regen', function()
    local eregen = select(2, _G.GetPowerRegen('player'))
    return eregen
end)

NeP.DSL:Register('combopoints.deficit', function ()
	local max = 5
    if NeP.DSL:Get('talent.enabled')(nil, '3,2') == 1 then
        max = 6
    end
	local curr = GetComboPoints('player','target')
	--print(max - curr)
	return (max - curr)
end)

NeP.DSL:Register('stealthed', function()
    if NeP.DSL:Get('buff')('player', 'Shadow Dance') or NeP.DSL:Get('buff')('player', 'Stealth') or NeP.DSL:Get('buff')('player', 'Subterfuge') or NeP.DSL:Get('buff')('player', 'Vanish') or NeP.DSL:Get('buff')('player', 'Shadowmeld') or NeP.DSL:Get('buff')('player', 'Prowl') then
        return true
    else
        return false
    end
end)

NeP.DSL:Register('variable.stealth_threshold', function()
	--actions.precombat+=/variable,name=stealth_threshold,value=60+talent.vigor.enabled*35+talent.master_of_shadows.enabled*10
	local x = (60 + NeP.DSL:Get('talent.enabled')(nil, '3,1') * 35 + NeP.DSL:Get('talent.enabled')(nil, '7,1') * 10)
	--print(x)
    return x
end)

NeP.DSL:Register('shd_threshold', function()
	--cooldown.shadow_dance.charges_fractional>=1.75
	if NeP.DSL:Get('spell.charges')('player', 'Shadow Dance') >= 1.75 then
		return true
	else
		return false
	end
end)

NeP.DSL:Register('poisoned_bleeds', function()
	local x = 0
	local y = 0
	for i=1,40 do
		local name = UnitDebuff('target',i)
			if name == 'Rupture' then
				x = x + 1
			end
	end
	for i=1,40 do
		local name = UnitDebuff('target',i)
			if name == 'Garrote' then
				y = y + 1
			end
	end
	return (x + y)
end)

-- energy.regen+poisoned_bleeds*7%(2*spell_haste)
NeP.DSL:Register('energy_regen_combined', function()
	local x = (NeP.DSL:Get('energy.regen')() + NeP.DSL:Get('poisoned_bleeds')() * 7 / (2 * NeP.DSL:Get('haste')('player')))
	return x
end)

NeP.DSL:Register('use_filler', function()
	--combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined|spell_targets.fan_of_knives>=2
	if NeP.DSL:Get('combopoints.deficit')('player') > 1 or NeP.DSL:Get('deficit')('player') <= 25 + NeP.DSL:Get('energy_regen_combined')('player') or NeP.DSL:Get('area.enemies')('player','10') >= 2 then
		-- NeP.DSL:Get('area.enemies')('player','10')
		return true
	else
		return false
	end
end)

--cp_max_spend
NeP.DSL:Register('cp_max_spend', function()
	local max = 4
    if NeP.DSL:Get('talent.enabled')(nil, '3,2') == 1 then
        max = 5
    end
	return max
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