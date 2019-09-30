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

NeP.DSL:Register('lust', function()
    if NeP.DSL:Get('buff')('player', 'Bloodlust') or NeP.DSL:Get('buff')('player', 'Heroism') or NeP.DSL:Get('buff')('player', 'Timewarp') then
        return true
    else
        return false
    end
end)

-- /dump NeP.DSL:Get('xequipped')('Ward of Envelopment')
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

NeP.DSL:Register('self', function(unit)
	return UnitIsUnit(unit, 'player');
end)

-- Spell in range. Credit to Kleei
NeP.DSL:Register("inRange.spell", function(unit, spell)
   local spellIndex, spellBook = NeP.Core:GetSpellBookIndex(spell)
   return spellIndex and _G.IsSpellInRange(spellIndex, spellBook, unit) == 1
end)

--USAGE in CR:
--{"%target", "CONDITION", "UNIT"}
NeP.Actions:Add('target', function(eval) eval.exe = function(eva) NeP.Protected.TargetUnit(eva.target)
    print(eva.target)
    return true
  end
  return true
end)

NeP.FakeUnits:Add('allFriendly', function()
	return NeP.OM:Get('Friendly')
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

---------------------------------------
---------------- Pally ----------------
---------------------------------------

NeP.DSL:Register('graceOfJusticar', function()
	return C_AzeriteEmpoweredItem.IsPowerSelected(ItemLocation:CreateFromEquipmentSlot(1), 393)
	or C_AzeriteEmpoweredItem.IsPowerSelected(ItemLocation:CreateFromEquipmentSlot(3), 393)
	or C_AzeriteEmpoweredItem.IsPowerSelected(ItemLocation:CreateFromEquipmentSlot(5), 393)
end)

-- Not working (Need ID)
NeP.DSL:Register('glimmerOfLight', function()
	return C_AzeriteEmpoweredItem.IsPowerSelected(ItemLocation:CreateFromEquipmentSlot(1), 393)
	or C_AzeriteEmpoweredItem.IsPowerSelected(ItemLocation:CreateFromEquipmentSlot(3), 393)
	or C_AzeriteEmpoweredItem.IsPowerSelected(ItemLocation:CreateFromEquipmentSlot(5), 393)
end)

---------------------------------------
---------------- Mage -----------------
---------------------------------------

-- /dump NeP.DSL:Get('firestarter.active')('target')
NeP.DSL:Register('firestarter.active', function(unit)
    return NeP.DSL:Get('talent.enabled')(nil, '1,1') == 1 and NeP.DSL:Get('health')(unit) > 90
end)

---------------------------------------
--------------- Hunter ----------------
---------------------------------------
-- /dump NeP.DSL:Get('focus.regen')()
NeP.DSL:Register('focus.regen', function()
    local fregen = select(2, GetPowerRegen('player'))
    return fregen
end)

NeP.DSL:Register('focus.time_to_max', function()
    local deficit = NeP.DSL:Get('deficit')()
    local fregen = NeP.DSL:Get('focus.regen')('player')
    return deficit / fregen
end)

-- /dump NeP.DSL:Get('cobraReady')()
--                   (active_enemies<2|                    cooldown.kill_command.remains                         >focus.time_to_max)                   &(focus-cost+focus.regen                                   *(cooldown.kill_command.remains-1)>action.kill_command.cost        |cooldown.kill_command.remains>1+gcd)                                                &cooldown.kill_command.remains>1
NeP.DSL:Register("cobraReady", function(target)
  return (NeP.DSL:Get('area.enemies')('player','8') < 2 or NeP.DSL:Get('spell.cooldown.duration')('Kill Command') > NeP.DSL:Get('focus.time_to_max')) and (NeP.DSL:Get('focus') - 35 + NeP.DSL:Get('focus.regen') * (NeP.DSL:Get('spell.cooldown.duration')('Kill Command') - 1) > 30 or NeP.DSL:Get('spell.cooldown.duration')('Kill Command') > 1 + NeP.DSL:Get('gcd')) and NeP.DSL:Get('spell.cooldown.duration')('Kill Command') > 1
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

-- /dump NeP.DSL:Get('combopoints.deficit')('player')
NeP.DSL:Register('combopoints.deficit', function ()
	local max = 5
    if NeP.DSL:Get('talent.enabled')(nil, '3,2') == 1 and not NeP.DSL:Get('class')('player','Druid') then
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

-- actions+=/variable,name=single_target,value=spell_targets.fan_of_knives<2
-- /dump NeP.DSL:Get('single_target')('player')
NeP.DSL:Register('single_target', function()
  return NeP.DSL:Get('area.enemies')('player','8') < 2
end)

-- combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target



-- energy.regen+poisoned_bleeds*7%(2*spell_haste)
NeP.DSL:Register('energy_regen_combined', function()
	local x = (NeP.DSL:Get('energy.regen')() + NeP.DSL:Get('poisoned_bleeds')() * 7 / (2 * NeP.DSL:Get('haste')('player')))
	return x
end)

NeP.DSL:Register('use_filler', function()
	--combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined|!variable.single_target
	if NeP.DSL:Get('combopoints.deficit')('player') > 1 or NeP.DSL:Get('deficit')('player') <= 25 + NeP.DSL:Get('energy_regen_combined')('player') or not NeP.DSL:Get('single_target')('player') then
		return true
	else
		return false
	end
end)

local garrote = false

NeP.Listener:Add('rogueBleeds', 'COMBAT_LOG_EVENT_UNFILTERED', function()
  local _, type, _,_, sName, _,_, dGUID, dName, _,_, spellId = CombatLogGetCurrentEventInfo()

  if type == "SPELL_AURA_APPLIED" or type == "SPELL_CAST_SUCCESS" then
    if spellId == 703 then
      if NeP.DSL:Get('stealthed')('player') then
        --print('Garrote is on and buffed')
        garrote = true
      else
        --print('Garrote is on, not buffed')
        garrote = false
      end
    end
  elseif type == "SPELL_AURA_REMOVED" and spellId == 703 then
        --print('Garrote is off')
        garrote = false
  end
end)

-- /dump NeP.DSL:Get('subGarrote')('player')
NeP.DSL:Register('subGarrote', function()
  return garrote
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
local procReact = {
  -- Versatillity
  277179,

  -- Intellect
  277185, 268550, 273942, 273988, 278154,

  -- Crit
  289522, 273955,

  -- Mastery
  274431,
}

-- /dump NeP.DSL:Get('stackingProc')('player')
NeP.DSL:Register('procReact', function (target)
  for i = 1, #procReact do
  local buffName = _G.GetSpellInfo(procReact[i])
   if NeP.DSL:Get("buff")(target, buffName) and NeP.DSL:Get("buff.duration")(target, buffName) > NeP.DSL:Get("spell.casttime")('player', 'Chaos Bolt') then
  --  print('We have a buff!')
    return true
   end
  end
end)


NeP.DSL:Register('shards', function ()
	local shards = WarlockPowerBar_UnitPower('player')
	return shards
end)

-- /dump NeP.DSL:Get('wildimps')()
NeP.DSL:Register('wildimps', function()
  return NeP.DSL:Get('warlock.minions.type')('Wild Imp')
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

NeP.DSL:Register('spammable_seed', function ()
	-- use_seed,value=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>=3+raid_event.invulnerable.up|talent.siphon_life.enabled&spell_targets.seed_of_corruption>=5+raid_event.invulnerable.up|spell_targets.seed_of_corruption>=8+raid_event.invulnerable.up
	-- spammable_seed,value=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>=3|talent.siphon_life.enabled&spell_targets.seed_of_corruption>=5|spell_targets.seed_of_corruption>=8
	if NeP.DSL:Get('talent.enabled')(nil, '4,1') and NeP.DSL:Get('area.enemies')('target', '10') >= 3 or NeP.DSL:Get('talent.enabled')(nil, '2,3') and NeP.DSL:Get('area.enemies')('target', '10') >= 5 or NeP.DSL:Get('area.enemies')('target', '10') >= 8 then
		return true
	end
	return false
end)


-----------------
-- Classic WoW --
-----------------
NeP.DSL:Register('iswanding', function()
  return NeP._G.IsCurrentSpell(5019)
end)
