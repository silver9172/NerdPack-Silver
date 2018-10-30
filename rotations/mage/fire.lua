local GUI = {
	{type = 'header', 	text = 'Generic', align = 'center'},
	{type = 'ruler'},
	{type = 'checkbox',	text = 'Dispel Curses',		key = 'G_Curse', 	default = true},
}

local dispel = {
	{ 'Remove Curse', 'curseDispel', { 'lowest', 'friendly'}}, 
}

local interrupts = {
	{ 'Counterspell', 'inRange.spell & interruptAt(75)', 'enemies'},
}

local utility = {
	{ 'Arcane Intellect', 'buff.duration <= 900', { 'lowest', 'friendly'}}, 
	{ '/stopcasting', 'cancelCastingEvent', 'enemies'}, 
	{ 'Spellsteal', 'spellstealEvent', 'enemies'}, 
}

local survival = {
	{ 'Blazing Barrier', 'buff.duration <= 15 & !buff(Replenishment) & incdmg(5) >= { player.health.max * 0.15 }', 'player'}, 
	--{ '#Healthstone', 'health <= 40', 'player'}, 
}

local activeTalents = {
	-- actions.active_talents=blast_wave,if=(buff.combustion.down)|(buff.combustion.up&action.fire_blast.charges<1)
	{ 'Blast Wave', '{ !player.buff(Combustion)} || player.buff(Combustion) & player.spell(Fire Blast).charges < 1', 'target'}, 
	-- actions.active_talents+=/meteor,if=cooldown.combustion.remains>40|(cooldown.combustion.remains>target.time_to_die)|buff.rune_of_power.up|firestarter.active
	{ 'Meteor', 'player.spell(Combustion).cooldown > 40 || { player.spell(Combustion).cooldown > ttd } || player.buff(Rune of Power) || health >= 90 & talent(1,1)', 'target.ground'}, 
	-- actions.active_talents+=/dragons_breath,if=talent.alexstraszas_fury.enabled&!buff.hot_streak.react
	{ 'Dragons Breath', 'range <= 12 & talent(4,2) & !player.buff(Hot Streak!)', 'target'}, 
	-- actions.active_talents+=/living_bomb,if=active_enemies>1&buff.combustion.down
	{ 'Living Bomb', 'area(10).enemies > 1 & !player.buff(Combustion)', 'target'}, 
}

local combustion = {
	-- actions.combustion_phase=lights_judgment,if=buff.combustion.down
	{ 'Light\'s Judgment', '!player.buff(Combustion)', 'target'}, 
	-- actions.combustion_phase+=/rune_of_power,if=buff.combustion.down
	{ 'Rune of Power', '!buff(Combustion)', 'player'}, 
	--{ 'Rune of Power', '!player.buff(Combustion) & { player.spell(Fire Blast).charges >= 1 & { talent(4,3) & player.spell(Phoenix Flames).charges >= 2 || !talent(4,3)} & { talent(3,3) & player.spell(Rune of Power).charges >= 1 || !talent(3,3)} & player.buff(Heating Up)}', 'target'}, 
	-- actions.combustion_phase+=/call_action_list,name=active_talents
	{ activeTalents}, 
	-- actions.combustion_phase+=/combustion
	{ 'Combustion', '{ talent(3,3) & totem(Rune of Power)} || !talent(3,3) & !buff', 'player'}, 
	--{ 'Combustion', 'player.spell(Fire Blast).charges >= 1 & { talent(4,3) & player.spell(Phoenix Flames).charges >= 2 || !talent(4,3)} & { talent(3,3) & player.lastcast(Rune of Power) || !talent(3,3)} & player.buff(Heating Up)', 'target'}, 
	-- actions.combustion_phase+=/potion
	-- actions.combustion_phase+=/blood_fury
	-- actions.combustion_phase+=/berserking
	-- actions.combustion_phase+=/fireblood
	-- actions.combustion_phase+=/ancestral_call
	-- actions.combustion_phase+=/use_items
	-- actions.combustion_phase+=/flamestrike,if=((talent.flame_patch.enabled&active_enemies>2)|active_enemies>6)&buff.hot_streak.react
	{ 'Flamestrike', '{{ talent(6,1) & target.area(8).enemies > 2} || target.area(8).enemies > 6 } & player.buff(Hot Streak!)', 'target.ground'}, 
	-- actions.combustion_phase+=/pyroblast,if=buff.pyroclasm.react&buff.combustion.remains>execute_time
	{ 'Pyroblast', '!player.moving & player.buff(Pyroclasm) & player.buff(Combustion).duration > player.execute_time', 'target'},
	-- actions.combustion_phase+=/pyroblast,if=buff.hot_streak.react
	{ 'Pyroblast', 'player.buff(Hot Streak!)', 'target'}, 
	-- actions.combustion_phase+=/fire_blast,if=buff.heating_up.react
	{ '&Fire Blast', 'player.buff(Heating Up) & inRange.spell', 'target'}, 
	-- actions.combustion_phase+=/phoenix_flames
	{ 'Phoenix Flames'},
	-- actions.combustion_phase+=/scorch,if=buff.combustion.remains>cast_time
	{ 'Scorch', 'player.buff(Combustion).duration > player.spell.casttime', 'target'}, 
	-- actions.combustion_phase+=/dragons_breath,if=!buff.hot_streak.react&action.fire_blast.charges<1
	{ 'Dragons Breath', 'range <= 12 & !buff(Hot Streak!) & player.spell(Fire Blast).charges < 1', 'target'}, 
	-- actions.combustion_phase+=/scorch,if=target.health.pct<=30&talent.searing_touch.enabled
	{ 'Scorch', 'health <= 30 & talent(1,3)', 'target'}, 
}

local rop = {
	-- actions.rop_phase=rune_of_power
	-- actions.rop_phase+=/flamestrike,if=((talent.flame_patch.enabled&active_enemies>1)|active_enemies>4)&buff.hot_streak.react
	{ 'Flamestrike', '{{ talent(6,1) & area(8).enemies > 1} || area(8).enemies > 4} & player.buff(Hot Streak!)', 'target.ground'}, 
	-- actions.rop_phase+=/pyroblast,if=buff.hot_streak.react
	{ 'Pyroblast', 'player.buff(Hot Streak!) & inRange.spell', 'target'}, 
	-- actions.rop_phase+=/call_action_list,name=active_talents
	{ activeTalents}, 
	-- actions.rop_phase+=/pyroblast,if=buff.pyroclasm.react&execute_time<buff.pyroclasm.remains&buff.rune_of_power.remains>cast_time
	{ 'Pyroblast', 'player.buff(Pyroclasm) & player.spell.casttime < player.buff(Pyroclasm).duration & totem(Rune of Power).duration > player.spell.casttime & inRange.spell', 'target'},
	-- actions.rop_phase+=/fire_blast,if=!prev_off_gcd.fire_blast&buff.heating_up.react&firestarter.active&charges_fractional>1.7
	{ '&Fire Blast', 'player.buff(Heating Up) & firestarter.active & player.spell.charges > 1.7 & inRange.spell', 'target'}, 
	-- actions.rop_phase+=/phoenix_flames,if=!prev_gcd.1.phoenix_flames&charges_fractional>2.7&firestarter.active
	{ 'Phoenix Flames', '!lastgcd & inRange.spell & player.spell.charges > 2.7 & firestarter.active', 'target'}, 
	-- actions.rop_phase+=/fire_blast,if=!prev_off_gcd.fire_blast&!firestarter.active
	{ '&Fire Blast', '!firestarter.active & inRange.spell', 'target'},  
	-- actions.rop_phase+=/phoenix_flames,if=!prev_gcd.1.phoenix_flames
	{ 'Phoenix Flames', '!lastgcd & inRange.spell', 'target'}, 
	-- actions.rop_phase+=/scorch,if=target.health.pct<=30&talent.searing_touch.enabled
	{ 'Scorch', 'health <= 30 & talent(1,3) & inRange.spell', 'target'}, 
	-- actions.rop_phase+=/dragons_breath,if=active_enemies>2
	{ 'Dragon\'s Breath', 'player.area(8).enemies > 2', 'target'}, 
	-- actions.rop_phase+=/flamestrike,if=(talent.flame_patch.enabled&active_enemies>2)|active_enemies>5
	{ 'Flamestrike', '{ talent(6,1) & area(8).enemies > 2} || area(8).enemies > 5', 'target.ground'}, 
	-- actions.rop_phase+=/fireball
	{ 'Fireball', 'inRange.spell & !player.moving', 'target'}, 
}

local standard = {
	-- actions.standard_rotation=flamestrike,if=((talent.flame_patch.enabled&active_enemies>1)|active_enemies>4)&buff.hot_streak.react
	{ 'Flamestrike', '{{ talent(6,1) & target.area(8).enemies > 1 } || target.area(8).enemies > 4} & player.buff(Hot Streak!)', 'target.ground'}, 
	-- actions.standard_rotation+=/pyroblast,if=buff.hot_streak.react&buff.hot_streak.remains<action.fireball.execute_time
	{ 'Pyroblast', 'player.buff(Hot Streak!) & player.buff(Hot Streak!).duration < player.spell(Fireball).casttime', 'target'}, 
	-- actions.standard_rotation+=/pyroblast,if=buff.hot_streak.react&firestarter.active&!talent.rune_of_power.enabled
	{ 'Pyroblast', 'player.buff(Hot Streak!) & { talent(1,1) & health >= 90 || !talent(1,1)} & !talent(3,3)', 'target'},  
	-- actions.standard_rotation+=/phoenix_flames,if=charges_fractional>2.7&active_enemies>2
	{ 'Phoenix Flames', 'player.spell.charges >= 2.7 & area(8).enemies > 2', 'target'}, 
	-- actions.standard_rotation+=/pyroblast,if=buff.hot_streak.react&(!prev_gcd.1.pyroblast|action.pyroblast.in_flight)
	{ 'Pyroblast', 'player.buff(Hot Streak!) & { !lastgcd(Pyroblast) || player.spell(Pyroblast).casttime = 0}', 'target'}, 
	-- actions.standard_rotation+=/pyroblast,if=buff.hot_streak.react&target.health.pct<=30&talent.searing_touch.enabled
	{ 'Pyroblast', 'player.buff(Hot Streak!) & health <= 30 & talent(1,3)', 'target'}, 
	-- actions.standard_rotation+=/pyroblast,if=buff.pyroclasm.react&execute_time<buff.pyroclasm.remains
	{ 'Pyroblast', '!player.moving & player.buff(Pyroclasm) & player.buff(Pyroclasm).duration > player.execute_time', 'target'},
	-- actions.standard_rotation+=/call_action_list,name=active_talents
	{ activeTalents}, 
	-- actions.standard_rotation+=/fire_blast,if=!talent.kindling.enabled&buff.heating_up.react&(!talent.rune_of_power.enabled|charges_fractional>1.4|cooldown.combustion.remains<40)&(3-charges_fractional)*(12*spell_haste)<cooldown.combustion.remains+3|target.time_to_die<4
	{ '&Fire Blast', '!talent(7,1) & player.buff(Heating Up) & { !talent(3,3) || player.spell.charges > 1.4 || player.spell(Combustion).cooldown < 40} & { 3 - player.spell.charges } * { 12 * player.haste} < player.spell(Combustion).cooldown + 3 || ttd < 4', 'target'}, 
	-- actions.standard_rotation+=/fire_blast,if=talent.kindling.enabled&buff.heating_up.react&(!talent.rune_of_power.enabled|charges_fractional>1.5|cooldown.combustion.remains<40)&(3-charges_fractional)*(18*spell_haste)<cooldown.combustion.remains+3|target.time_to_die<4
	{ '&Fire Blast', 'talent(7,1) & player.buff(Heating Up) & { !talent(3,3) || player.spell.charges > 1.5 || player.spell(Combustion).cooldown < 40} & { 3 - player.spell.charges } * { 18 * player.haste} < player.spell(Combustion).cooldown + 3 || ttd < 4', 'target'}, 
	-- actions.standard_rotation+=/phoenix_flames,if=(buff.combustion.up|buff.rune_of_power.up|buff.incanters_flow.stack>3|talent.mirror_image.enabled)&(4-charges_fractional)*13<cooldown.combustion.remains+5|target.time_to_die<10
	-- actions.standard_rotation+=/phoenix_flames,if=(buff.combustion.up|buff.rune_of_power.up)&(4-charges_fractional)*30<cooldown.combustion.remains+5
	-- actions.standard_rotation+=/phoenix_flames,if=charges_fractional>2.5&cooldown.combustion.remains>23
	{ 'Phoenix Flames', 'player.spell.charges >= 2.5 & player.spell(Combustion).cooldown > 23', 'target'}, 
	-- actions.standard_rotation+=/scorch,if=(target.health.pct<=30&talent.searing_touch.enabled)|(azerite.preheat.enabled&debuff.preheat.down)
	{ 'Scorch', '{ target.health <= 30 & talent(1,3)}', 'target'},
	-- actions.standard_rotation+=/fireball
	{ 'Fireball', '!player.moving', 'target'}, 
	-- actions.standard_rotation+=/scorch
	{ 'Scorch'}, 
}

local rotation = {
	-- # Executed every time the actor is available.
	-- actions=counterspell,if=target.debuff.casting.react
	{ interrupts},
	-- actions+=/time_warp,if=time=0&buff.bloodlust.down
	-- actions+=/mirror_image,if=buff.combustion.down
	{ 'Mirror Image', '!player.buff(Combustion)', 'target'}, 
	-- # Standard Talent RoP Logic.
	-- actions+=/rune_of_power,if=firestarter.active&action.rune_of_power.charges=2|cooldown.combustion.remains>40&buff.combustion.down&!talent.kindling.enabled|target.time_to_die<11|talent.kindling.enabled&(charges_fractional>1.8|time<40)&cooldown.combustion.remains>40
	{ 'Rune of Power', 'firestarter.active & player.spell.charges = 2 || player.spell(Combustion).cooldown > 40 & !player.buff(Combustion) & !talent(7,1) || talent(7,1) & { player.spell.charges > 1.8 || combat.time < 40} & player.spell(Combustion).cooldown > 40', 'target'}, 
	-- # RoP use while using Pyroclasm.
	-- actions+=/rune_of_power,if=buff.pyroclasm.react&(cooldown.combustion.remains>40|action.rune_of_power.charges>1)
	-- actions+=/call_action_list,name=combustion_phase,if=cooldown.combustion.remains<=action.rune_of_power.cast_time+(!talent.kindling.enabled*gcd)&(!talent.firestarter.enabled|!firestarter.active|active_enemies>=4|active_enemies>=2&talent.flame_patch.enabled)|buff.combustion.up
	{ combustion, 'player.spell(Combustion).cooldown <= player.spell(Rune of Power).casttime + { !talent(1,1) * gcd} & { !talent(1,1) || { talent(1,1) & target.health < 90} || target.area(8).enemies >= 4 || target.area(8).enemies >= 2 & talent(6,1)} || player.buff(Combustion)'},  
	-- actions+=/call_action_list,name=rop_phase,if=buff.rune_of_power.up&buff.combustion.down
	{ rop, 'totem(Rune of Power) & !player.buff(Combustion)'}, 
	-- actions+=/call_action_list,name=standard_rotationt	
	{ standard}, 
}

local preCombat = {
	{ 'Blazing Barrier', 'dbm(Pull in) & dbm(Pull in) < 6', 'player'}, 
	{ 'Pyroblast', 'dbm(Pull in) & dbm(Pull in) < 4.2', 'target'}, 
}

local inCombat = {
	{ dispel, 'UI(G_Curse)'},
	{ utility}, 
	{ survival}, 
	{ rotation}, 
}

local outCombat = {
	{ '%pause', 'player.buff(Replenishment)'},
	{ utility}, 
	{ preCombat}, 
}

NeP.CR:Add(63, {
	name = '[MAGE - Fire',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
