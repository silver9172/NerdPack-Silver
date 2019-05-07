local _, Silver = ...
local _G = _G
local NeP = NeP

--------------
-- Dispells --
--------------

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

  -- BoD
  or NeP.DSL:Get('debuff.any')(unit, 'Searing Embers')
  or NeP.DSL:Get('debuff.any')(unit, 'Hex of Lethargy')

  -- Crucible
  or NeP.DSL:Get('debuff.count.any')(unit, 'Promises of Power') >= 5

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
	or NeP.DSL:Get('debuff.any')(unit, 'Virulent Pathogen') and NeP.DSL:Get('area.friendly')(unit, 'Virulent Pathogen') and NeP.DSL:Get('area.friendly')(unit,'8') == 0
end)

NeP.DSL:Register('curseDispel', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('debuff.duration.any')(unit, 'Unstable Hex') <= 4 and NeP.DSL:Get('debuff.any')(unit, 'Unstable Hex') and NeP.DSL:Get('area.friendly')(unit,'8') == 0
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

------------------------
-- Priority Targeting --
------------------------
NeP.DSL:Register('priorityHeal', function(unit)

end)

NeP.DSL:Register('priorityTarget', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	return NeP.DSL:Get('name')(unit,'Explosives')
	-- Atal'Dazar
	or NeP.DSL:Get('name')(unit,'Spirit of Gold')
	-- Kings Rest
	or NeP.DSL:Get('name')(unit,'Healing Tide Totem')
	------------------
	---- BFA Raids ---
	------------------
	or NeP.DSL:Get('name')(unit,'Coalesced Blood')

  ------------------
  ----- testing ----
  ------------------
  or NeP.DSL:Get('name')(unit,'Raider\'s Training Dummy')
end)

-----------
-- Stuns --
-----------

NeP.DSL:Register('stunEvent', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('name')(unit,'Spirit of Gold')
	or NeP.DSL:Get('name')(unit,'Shieldbearer of Zul') and NeP.DSL:Get('channeling')(unit,'Bulwark of Juju')

	or NeP.DSL:Get('name')(unit,'Orb Guardian')

	------------------
	---- BFA Raids ---
	------------------
	or NeP.DSL:Get('name')(unit,'Colatile Droplet')
end)

----------------------
-- SpellSteal/Purge --
----------------------

NeP.DSL:Register('spellstealEvent', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('buff.any')(unit,'Gilded Claws')
	or NeP.DSL:Get('buff.any')(unit,'Gathered Souls')
	or NeP.DSL:Get('buff.any')(unit,'Dino Might')

	-- Freehold
	or NeP.DSL:Get('buff.any')(unit,'Healing Balm')

	-- King's Rest
	or NeP.DSL:Get('buff.any')(unit,'Induce Regeneration')

	-- Shrine of the Storm
	or NeP.DSL:Get('buff.any')(unit,'Tidal Surge')
	or NeP.DSL:Get('buff.any')(unit,'Spirit\'s Swiftness')
	or NeP.DSL:Get('buff.any')(unit,'Mending Rapids')
	or NeP.DSL:Get('buff.any')(unit,'Reanimated Bones')
	or NeP.DSL:Get('buff.any')(unit,'Detect Thoughts')
	or NeP.DSL:Get('buff.any')(unit,'Consuming Void')

	-- Siege of Boralus
	or NeP.DSL:Get('buff.any')(unit,'Watertight Shell')
	or NeP.DSL:Get('buff.any')(unit,'Bolstering Shout')

	-- Temple of Sethraliss
	or NeP.DSL:Get('buff.any')(unit,'Electrified Scales')
	or NeP.DSL:Get('buff.any')(unit,'Embryonic Vigor')
	or NeP.DSL:Get('buff.any')(unit,'Accumulate Charge')

	-- The MOTHERLODE!!
	or NeP.DSL:Get('buff.any')(unit,'Earth Shield')
	or NeP.DSL:Get('buff.any')(unit,'Tectonic Barrier')
	or NeP.DSL:Get('buff.any')(unit,'Azerite Injection')
	or NeP.DSL:Get('buff.any')(unit,'Overcharge')

	-- Tol Dagor
	or NeP.DSL:Get('buff.any')(unit,'Watery Dome')
	or NeP.DSL:Get('buff.any')(unit,'Darkstep')
	or NeP.DSL:Get('buff.any')(unit,'Motivating Cry')
	or NeP.DSL:Get('buff.any')(unit,'Inner Flames')

	-- Underrot
	or NeP.DSL:Get('buff.any')(unit,'Gift of G\'huun')
	or NeP.DSL:Get('buff.any')(unit,'Bone Shield')

	-- Waycrest Manor
	or NeP.DSL:Get('buff.any')(unit,'Soul Fetish')
	or NeP.DSL:Get('buff.any')(unit,'Spirited Defense')
	or NeP.DSL:Get('buff.any')(unit,'Consume Fragments')

	------------------
	---- BFA Raids ---
	------------------

end)

NeP.DSL:Register('purgeEvent', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('buff.any')(unit,'Gilded Claws')
	or NeP.DSL:Get('buff.any')(unit,'Gathered Souls')
	or NeP.DSL:Get('buff.any')(unit,'Dino Might')

	-- Freehold
	or NeP.DSL:Get('buff.any')(unit,'Healing Balm')

	-- King's Rest
	or NeP.DSL:Get('buff.any')(unit,'Bound by Shadow')
	or NeP.DSL:Get('buff.any')(unit,'Seduction')
	or NeP.DSL:Get('buff.any')(unit,'Induce Regeneration')

	-- Shrine of the Storm
	or NeP.DSL:Get('buff.any')(unit,'Tidal Surge')
	or NeP.DSL:Get('buff.any')(unit,'Spirit\'s Swiftness')
	or NeP.DSL:Get('buff.any')(unit,'Mending Rapids')
	or NeP.DSL:Get('buff.any')(unit,'Reanimated Bones')
	or NeP.DSL:Get('buff.any')(unit,'Detect Thoughts')
	or NeP.DSL:Get('buff.any')(unit,'Consuming Void')

	-- Siege of Boralus
	or NeP.DSL:Get('buff.any')(unit,'Watertight Shell')
	or NeP.DSL:Get('buff.any')(unit,'Bolstering Shout')

	-- Temple of Sethraliss
	or NeP.DSL:Get('buff.any')(unit,'Electrified Scales')
	or NeP.DSL:Get('buff.any')(unit,'Embryonic Vigor')
	or NeP.DSL:Get('buff.any')(unit,'Accumulate Charge')

	-- The MOTHERLODE!!
	or NeP.DSL:Get('buff.any')(unit,'Earth Shield')
	or NeP.DSL:Get('buff.any')(unit,'Tectonic Barrier')
	or NeP.DSL:Get('buff.any')(unit,'Azerite Injection')
	or NeP.DSL:Get('buff.any')(unit,'Overcharge')

	-- Tol Dagor
	or NeP.DSL:Get('buff.any')(unit,'Watery Dome')
	or NeP.DSL:Get('buff.any')(unit,'Darkstep')
	or NeP.DSL:Get('buff.any')(unit,'Motivating Cry')
	or NeP.DSL:Get('buff.any')(unit,'Inner Flames')

	-- Underrot
	or NeP.DSL:Get('buff.any')(unit,'Gift of G\'huun')
	or NeP.DSL:Get('buff.any')(unit,'Bone Shield')

	-- Waycrest Manor
	or NeP.DSL:Get('buff.any')(unit,'Soul Fetish')
	or NeP.DSL:Get('buff.any')(unit,'Spirited Defense')
	or NeP.DSL:Get('buff.any')(unit,'Consume Fragments')
end)

--------------------
-- Tank AM Events --
--------------------

NeP.DSL:Register('tankEvent', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('buff.any')(unit, 'Gilded Claws')
	or NeP.DSL:Get('casting')(unit, 'Serrated Teeth')
	or NeP.DSL:Get('casting')(unit, 'Skewer')
	or NeP.DSL:Get('casting')(unit, 'Venomfang Strike')
	or NeP.DSL:Get('debuff.any')('player', 'Venomfang Strike')

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

-----------------
-- Misc Checks --
-----------------

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


NeP.DSL:Register('cancelCastingEvent', function(unit)
	------------------
	-- BFA Dungeons --
	------------------
	-- Atal'Dazar
	return NeP.DSL:Get('casting')(unit,'Shattering Bellow')

	------------------
	---- BFA Raids ---
	------------------
	or NeP.DSL:Get('casting')(unit,'Mind-Numbing Chatter')
end)
