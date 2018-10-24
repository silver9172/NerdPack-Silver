local _, Silver = ...
local _G = _G
local NeP = NeP

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

NeP.DSL:Register('charges_fractional', function(_, spell)
    if NeP.DSL:Get('spell.exists')(_, spell) then
        return NeP.DSL:Get('spell.charges')(_, spell)
    else
        return 0
    end
end)

NeP.DSL:Register('recharge_time', function(_, spell)
    if NeP.DSL:Get('spell.exists')(_, spell) then
        return NeP.DSL:Get('spell.recharge')(_, spell)
    else
        return 0
    end
end)

NeP.DSL:Register("inRange.spell",function(target,spell)
	local spellIndex,spellBook = NeP.Core:GetSpellBookIndex(spell)
	if not spellIndex then return false end
	if spellIndex and _G.IsSpellInRange(spellIndex,spellBook,target) == 1 then
	return true end
end)

-- /dump NeP.DSL:Get('execute_time')('player','Pyroblast')
NeP.DSL:Register('execute_time', function(_, spell)
    if NeP.DSL:Get('spell.exists')(_, spell) then
        local GCD = NeP.DSL:Get('gcd')()
        local CTT = NeP.DSL:Get('spell.casttime')(_, spell)
        if CTT > GCD then
            return CTT
        else
            return GCD
        end
    end
    return false
end)

-- Spell in range. Credit to Kleei
NeP.DSL:Register("inRange.spell", function(unit, spell)
   local spellIndex, spellBook = NeP.Core:GetSpellBookIndex(spell)
   return spellIndex and _G.IsSpellInRange(spellIndex, spellBook, unit) == 1
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
        if NeP.DSL:Get('casting')('target', castingEventSpellsAOE[i]) then return true end
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
		if ( UnitClassification('target') == 'boss' ) then
			check = 1
			return check
		elseif ( UnitClassification('target') == 'worldboss' ) then
			check = 1
			return check
		elseif ( UnitClassification('target') == 'rareelite' ) then
			check = 1
			return check
		elseif ( UnitClassification('target') == 'rare' ) then
			check = 1
			return check
		-- This is for dungeon bosses
		elseif UnitLevel('target') >= UnitLevel('player') + 2 and not IsInRaid() then
			check = 1
			return check
		elseif UnitLevel('target') < 0 then
			check = 1
			return check
		else
			return check
		end
end)

-- Need Immunity Check

NeP.DSL:Register('magicDispel', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('debuff.any')(unit, 'Wildfire')
	or NeP.DSL:Get('debuff.any')(unit, 'Molten Gold')
	or NeP.DSL:Get('debuff.any')(unit, 'Terrifying Screech')
	or NeP.DSL:Get('debuff.any')(unit, 'Terrifying Visage')
	
	-- Freehold
	or NeP.DSL:Get('debuff.any')(unit, 'Oiled Blade')
	
	-- King's Rest
	or NeP.DSL:Get('debuff.any')(unit, 'Frost Shock')
	
	-- Shrine of the Storm
	or NeP.DSL:Get('debuff.any')(unit, 'Choking Brine')
	or NeP.DSL:Get('debuff.any')(unit, 'Electrifying Shock')
	-- or NeP.DSL:Get('debuff.any')(unit, 'Touch of the Drowned')
	or NeP.DSL:Get('debuff.any')(unit, 'Mental Assault')
	-- or NeP.DSL:Get('debuff.any')(unit, 'Mind Rend')
	or NeP.DSL:Get('debuff.any')(unit, 'Explosive Void')
	or NeP.DSL:Get('debuff.any')(unit, 'Whispers of Power')
	
	-- The MOTHERLODE!!!
	or NeP.DSL:Get('debuff.any')(unit, 'Brain Freeze')
	-- or NeP.DSL:Get('debuff.any')(unit, 'Caustic Compound')
	or NeP.DSL:Get('debuff.any')(unit, 'Transmute: Enemy to Goo')
	or NeP.DSL:Get('debuff.any')(unit, 'Chemical Burn')
	
	-- Siege of Boralus
	or NeP.DSL:Get('debuff.any')(unit, 'Choking Waters')
	or NeP.DSL:Get('debuff.any')(unit, 'Putrid Waters')
	
	-- Temple of Sethraliss
	or NeP.DSL:Get('debuff.any')(unit, 'Flame Shock')
	or NeP.DSL:Get('debuff.any')(unit, 'Snake Charm')
	
	-- Tol Dagor
	or NeP.DSL:Get('debuff.any')(unit, 'Debilitating Shout')
	or NeP.DSL:Get('debuff.any')(unit, 'Torch Strike')
	or NeP.DSL:Get('debuff.any')(unit, 'Suppression Fire')
	or NeP.DSL:Get('debuff.any')(unit, 'Fuselighter')
	
	-- Underrot
	or NeP.DSL:Get('debuff.any')(unit, 'Wicked Frenzy')
	or NeP.DSL:Get('debuff.any')(unit, 'Death Bolt')
	or NeP.DSL:Get('debuff.any')(unit, 'Maddening Gaze')
	or NeP.DSL:Get('debuff.any')(unit, 'Putrid Blood')
	
	-- Waycrest Manor
	or NeP.DSL:Get('debuff.any')(unit, 'Grasping Thorns')
	or NeP.DSL:Get('debuff.any')(unit, 'Toad Blight')
	or NeP.DSL:Get('debuff.any')(unit, 'Fragment Soul')
end)

NeP.DSL:Register('poisonDispel', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('debuff.duration.any')(unit, 'Venomfang Strike') <= 7 and NeP.DSL:Get('debuff.any')(unit, 'Venomfang Strike')
	
	-- Freehold
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Poisoning Strike') >= 11 and NeP.DSL:Get('debuff.any')(unit, 'Poisoning Strike')
	
	-- King's Rest
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Hidden Blade') >= 7 and NeP.DSL:Get('debuff.any')(unit, 'Hidden Blade')
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Embalming Fluid') >= 19 and NeP.DSL:Get('debuff.any')(unit, 'Embalming Fluid')
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Poison Barrage') >= 19 and NeP.DSL:Get('debuff.any')(unit, 'Poison Barrage')
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Poison Nova') >= 19 and NeP.DSL:Get('debuff.any')(unit, 'Poison Nova')
	
	-- Siege of Boralus
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Stinging Venom Coating') >= 9 and NeP.DSL:Get('debuff.any')(unit, 'Stinging Venom Coating')
	
	-- The MOTHERLODE!!!
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Toxic Blades,') >= 5 and NeP.DSL:Get('debuff.any')(unit, 'Toxic Blades')
	
	-- Temple of Sethraliss
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Neurotoxin') >= 7 and NeP.DSL:Get('debuff.any')(unit, 'Neurotoxin')
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Noxious Breath') >= 9 and NeP.DSL:Get('debuff.any')(unit, 'Noxious Breath')
	or NeP.DSL:Get('debuff.count.any')(unit, 'Cytotoxin') >= 3
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Venomous Spit') >= 8 and NeP.DSL:Get('debuff.any')(unit, 'Venomous Spit')
	
	-- Tol Dagor
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Crippling Shiv') >= 11 and NeP.DSL:Get('debuff.any')(unit, 'Crippling Shiv')
end)

NeP.DSL:Register('diseaseDispel', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('debuff.any')(unit, 'Lingering Nausea')
	
	-- Freehold
	or NeP.DSL:Get('debuff.count.any')(unit, 'Infected Wound') >= 4
	or NeP.DSL:Get('debuff.any')(unit, 'Plague Step')
	
	-- King's Rest
	or NeP.DSL:Get('debuff.any')(unit, 'Wretched Discharge')
	
	-- The MOTHERLODE!!!
	or NeP.DSL:Get('debuff.any')(unit, 'Festering Bite')
	
	-- Temple of Sethraliss
	or NeP.DSL:Get('debuff.any')(unit, 'Plague')
	
	-- Underrot
	or NeP.DSL:Get('debuff.any')(unit, 'Decaying Mind')
	or NeP.DSL:Get('debuff.count.any')(unit, 'Decaying Spores') >= 2
	
	-- Waycrest Manor
	or NeP.DSL:Get('debuff.any')(unit, 'Infected Thorn')
	or NeP.DSL:Get('debuff.any')(unit, 'Severing Serpent')
	or NeP.DSL:Get('debuff.any')(unit, 'Virulent Pathogen')
end)

NeP.DSL:Register('curseDispel', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('debuff.duration.any')(unit, 'Unstable Hex') <= 4 and NeP.DSL:Get('debuff.any')(unit, 'Unstable Hex')
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Wracking Pain') <= 5 and NeP.DSL:Get('debuff.any')(unit, 'Wracking Pain')
	
	-- King's Rest
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Hex') <= 9 and NeP.DSL:Get('debuff.any')(unit, 'Hex')
	
	-- Underrot
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Withering Curse') <= 11 and NeP.DSL:Get('debuff.any')(unit, 'Withering Curse')
	
	-- Siege of Boralus
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Cursed Slash') <= 9 and NeP.DSL:Get('debuff.any')(unit, 'Unstable Hex')
	
	-- Waycrest Manor
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Unstable Runic Mark') <= 5 and NeP.DSL:Get('debuff.any')(unit, 'Unstable Runic Mark')
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Marking Cleave') <= 5 and NeP.DSL:Get('debuff.any')(unit, 'Marking Cleave')
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Dread Mark') <= 5 and NeP.DSL:Get('debuff.any')(unit, 'Dread Mark')
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Lingering Dread') <= 4 and NeP.DSL:Get('debuff.any')(unit, 'Lingering Dread')
	or NeP.DSL:Get('debuff.duration.any')(unit, 'Runic Mark') <= 5 and NeP.DSL:Get('debuff.any')(unit, 'Runic Mark')
end)

NeP.DSL:Register('purgeEvent', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('buff.any')(unit, 'Gilded Claws')

end)

NeP.DSL:Register('tankEvent', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('buff.any')(unit, 'Gilded Claws')
	or NeP.DSL:Get('casting')(unit, 'Serrated Teeth')
	or NeP.DSL:Get('casting')(unit, 'Skewer')
	or NeP.DSL:Get('casting')(unit, 'Venomfang Strike')
	
	-- Kings Rest
	or NeP.DSL:Get('casting')(unit, 'Tail Thrash')
	
	-- Testing
	or NeP.DSL:Get('casting')(unit, 'Uber Strike')
end)

NeP.DSL:Register('immuneCheck', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar

end)

NeP.DSL:Register('bopEvent', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('debuff.any')(unit, 'Pursuit')
	or NeP.DSL:Get('debuff.any')(unit, 'Devour')

end)

NeP.DSL:Register('freedomEvent', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('debuff.any')(unit, 'Pursuit')
	or NeP.DSL:Get('debuff.any')(unit, 'Devour')

end)

NeP.DSL:Register('stunEvent', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('name')(unit,'Spirit of Gold')
	or NeP.DSL:Get('name')(unit,'Shieldbearer of Zul') and NeP.DSL:Get('channeling')(unit,'Bulwark of Juju')
	
	or NeP.DSL:Get('name')(unit,'Orb Guardian')

end)

NeP.DSL:Register('priorityTarget', function(unit)
	------------------
	-- BFA Dungeons --
	------------------a
	return NeP.DSL:Get('name')(unit,'Explosive Orb')
	-- Atal'Dazar
	or NeP.DSL:Get('name')(unit,'Spirit of Gold')
end)

---------------------------------------
---------------- Mage -----------------
---------------------------------------


---------------------------------------
--------------- Hunter ----------------
---------------------------------------
NeP.DSL:Register('focus.regen', function()
    local fregen = select(2, GetPowerRegen('player'))
    return fregen
end)

NeP.DSL:Register('focus.time_to_max', function()
    local deficit = NeP.DSL:Get('deficit')()
    local fregen = NeP.DSL:Get('focus.regen')('player')
    return deficit / fregen
end)

-- /dump NeP.DSL:Get('isshooting')()
NeP.DSL:Register('isshooting', function()
	return IsCurrentSpell('Auto Shot')
	or IsCurrentSpell(75)
	or IsCurrentSpell(145759)
	or IsCurrentSpell(219676)
	or IsCurrentSpell(246353)
	or IsCurrentSpell(262545)
	or IsCurrentSpell(266452)
	or IsCurrentSpell(280637)
	or IsCurrentAction(57)
end)

NeP.DSL:Register('test2', function()
	return IsCurrentSpell('Auto Attack')
end)

NeP.DSL:Register('test', function()
	local _, _, _, _, _, _, spellID = GetSpellInfo('Auto Shot')
	return spellID
end)

---------------------------------------
--------------- Rogue -----------------
---------------------------------------

NeP.DSL:Register('energy.regen', function()
    local eregen = select(2, _G.GetPowerRegen('player'))
    return eregen
end)

NeP.DSL:Register('energy.time_to_max', function()
    local deficit = NeP.DSL:Get('deficit')()
    local eregen = NeP.DSL:Get('energy.regen')()
    return deficit / eregen
end)NeP.DSL:Register('energy.time_to_max', function()
    local deficit = NeP.DSL:Get('deficit')()
    local eregen = NeP.DSL:Get('energy.regen')()
    return deficit / eregen
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

NeP.DSL:Register('garrote.exsanguinated', function()
	for i=1,40 do
		local name, _, _, _, duration = UnitDebuff('target',i);
		if name == 'Garrote' then
			if duration < 18 then
				return 1
			else
				return 0
			end
		else
			return 0
		end
	end
end)

NeP.DSL:Register('rupture.exsanguinated', function()
	for i=1,40 do
		local name, _, _, _, duration = UnitDebuff('target',i);
		if name == 'Rupture' then
			if duration < 20 then
				return 1
			else
				return 0
			end
		else
			return 0
		end
	end
end)

NeP.DSL:Register('rtb_buffs', function()
  local roll = 0
    if NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(193357)) > 1.5 then  roll = roll + 1 end -- Shark Infested Waters
    if NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(193359)) > 1.5 then  roll = roll + 1 end -- True Bearing
    if NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(199603)) > 1.5 then  roll = roll + 1 end -- Jolly Roger
    if NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(193358)) > 1.5 then  roll = roll + 1 end -- Grand Melee
    if NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(199600)) > 1.5 then  roll = roll + 1 end -- Buried Treasure
    if NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(193356)) > 1.5 then  roll = roll + 1 end -- Broadsides
    if NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(202665)) > 1.5 then  roll = roll + 1 end -- Curse of the Dreadblades
    return roll
end)

NeP.DSL:Register('rtb_buffs.duration', function()
	local x = NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(193357))
	local y = NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(193359))
	local z = NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(199603))
	local a = NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(199600))
	local b = NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(193356))
	local c = NeP.DSL:Get('buff.duration')('player', _G.GetSpellInfo(202665))
	if x > 0 then 
		dur = x
		return x
	end
	if y > 0 then 
		dur = y
		return y
	end
	if z > 0 then 
		dur = z
		return z
	end
	if a > 0 then 
		dur = a
		return a
	end
	if b > 0 then 
		dur = b
		return b
	end
	if c > 0 then 
		dur = c
		return c
	end
end)

	--rtb_buffs<2&(buff.loaded_dice.up|!buff.grand_melee.up&!buff.ruthless_precision.up)
NeP.DSL:Register('rtb_reroll', function()
	if NeP.DSL:Get('rtb_buffs')('player') < 2 and ( NeP.DSL:Get('buff')('player', 'Loaded Dice') or not NeP.DSL:Get('buff')('player', 'Grand Melee') or not NeP.DSL:Get('buff')('player', 'Ruthless Precision')) then	
		return 1
	else 
		return 0
	end
end)

	-- combo_points.deficit>=2+2*(talent.ghostly_strike.enabled&cooldown.ghostly_strike.remains<1)+buff.broadside.up&energy>60&!buff.skull_and_crossbones.up

	
	-- # With multiple targets, this variable is checked to decide whether some CDs should be synced with Blade Flurry
	-- actions+=/variable,name=blade_flurry_sync,value=spell_targets.blade_flurry<2&raid_event.adds.in>20|buff.blade_flurry.up

NeP.DSL:Register("health.missing", function(target)
	return NeP.DSL:Get('health.max')(target) - NeP.DSL:Get('health.actual')(target)
end)

---------------------------------------
------------ Death Knight -------------
---------------------------------------

NeP.DSL:Register('deathstrike', function ()
	return NeP.DSL:Get('incdmg')('player', 8) * 0.25
end)

NeP.DSL:Register('rune.time_to_4', function ()
	local runeAmount = 0
	for i=1,6 do
	  local start, duration, runeReady = GetRuneCooldown(2)
	  --if runeReady == false then
		return (start + duration - _G.GetTime()) or 0
	  --end
	end
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
	local shards = WarlockPowerBar_UnitPower('player')
	return shards
end)

NeP.DSL:Register('unstableaffliction', function ()
    local count = 0
    for i = 1, 40, 1 do
	
        if (UnitAura('target', i, 'PLAYER|HARMFUL') == 'Unstable Affliction') then
            count = count + 1
        end
    end
	--print('Unstable Afflictions: '..count)
	return count
end)