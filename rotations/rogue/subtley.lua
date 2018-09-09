local GUI = {
	-- General
	{type = 'header', 		text = 'General', align = 'center'},
	{type = 'checkbox',		text = 'Multi-Dot',						key = 'multi', 	default = true},
	{type = 'ruler'},{type = 'spacer'},
	
	-- Survival
	{type = 'header', 		text = 'Survival', align = 'center'},
	{type = 'spinner', 		text = 'Crimson Vial', 					key = 'cv', 	default_spin = 65},
	{type = 'checkspin', 	text = 'Health Potion', 				key = 'hp', 	default_check = true, default_spin = 25},
	{type = 'checkspin',	text = 'Healthstone', 					key = 'hs', 	default_check = true, default_spin = 25},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', 		text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'checkbox',		text = 'Vanish',						key = 'van', 	default = true},
	{type = 'checkbox',		text = 'Shadow Blades',					key = 'sb', 	default = true},
	{type = 'checkbox',		text = 'Potion of the Old War',			key = 'ow', 	default = true},
	{type = 'ruler'},{type = 'spacer'},} 

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- Supported Talents')
	print('|cffADFF2F --- 1,1 / 2,1 / 3,3 / any / any / 6,1 or 6,2 / 7,1')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {
	{ '%pause', 'keybind(alt)'}
}

local interrupts = {
	{ 'Kick'},
	{ 'Arcane Torrent', 'target.range <= 8 & spell(Kick).cooldown > gcd & !prev_gcd(Rebuke)'},
}

local survival = {
	{ 'Crimson Vial', 'player.health <= UI(cv) & player.energy >= 35'},
	{ 'Evasion', 'player.threat >= 100'},
	{ 'Feint', '!player.buff & player.health <= UI(cv) & player.xequipped(137069)'},
		
	-- Health Pot
	{ '#Ancient Healing Potion', 'UI(hp_check) & player.health <= UI(hp_spin)'},
	
	-- Healthstones
	{ '#Healthstone', 'UI(hs_check) & player.health <= UI(hs_spin)'},
	
	-- Tich
	{ 'Feint', '!player.buff & player.debuff(Carrion Plague)'},
}

local cooldowns = {
	--# Cooldowns
	--actions.cds=potion,name=old_war,if=buff.bloodlust.react|target.time_to_die<=25|buff.shadow_blades.up
	{ '#Potion of the Old War', 'UI(ow) & player.hashero & toggle(Cooldowns)'},
	{ '#Potion of the Old War', 'UI(ow) & target.ttd <= 25 & toggle(Cooldowns)'},
	{ '#Potion of the Old War', 'UI(ow) & player.buff(Shadow Blades) & player.sated & toggle(Cooldowns)'}, -- Dont want to use before hero
	--actions.cds+=/blood_fury,if=stealthed.rogue
	{ 'Blood Fury', 'player.stealthed'},
	--actions.cds+=/berserking,if=stealthed.rogue
	{ 'Berserking', 'player.stealthed'},
	--actions.cds+=/arcane_torrent,if=stealthed.rogue&energy.deficit>70
	{ 'Arcane Torrent', 'player.stealthed & player.deficit > 70'},
	--actions.cds+=/symbols_of_death,if=energy.deficit>=40-stealthed.all*30
	{ 'Symbols of Death', '{ deficit >= 40 & !player.stealthed} || { deficit >= 60 & player.stealthed}'}, 
	--actions.cds+=/shadow_blades,if=combo_points.deficit>=2+stealthed.all-equipped.mantle_of_the_master_assassin&(cooldown.sprint.remains>buff.shadow_blades.duration*0.5|mantle_duration>0|cooldown.shadow_dance.charges_fractional>variable.shd_fractionnal|cooldown.vanish.up|target.time_to_die<=buff.shadow_blades.duration*1.1)
	{ 'Shadow Blades', 'player.combopoints.deficit >= 2 & player.stealthed & toggle(Cooldowns) & !player.stealthed'},
	--actions.cds+=/goremaws_bite,if=combo_points.deficit>=2+stealthed.all-equipped.mantle_of_the_master_assassin&(cooldown.sprint.remains>buff.shadow_blades.duration*(0.4+equipped.denial_of_the_halfgiants*0.2)|mantle_duration>0|cooldown.shadow_dance.charges_fractional>variable.shd_fractionnal|cooldown.vanish.up|target.time_to_die<=buff.shadow_blades.duration*1.1)
	{ 'Goremaw\'s Bite', 'player.combopoints.deficit >= 2 & player.stealthed'},
	--actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|(raid_event.adds.in>40&combo_points.deficit>=cp_max_spend)
}

local build = {
	--# Builders
	--actions.build=shuriken_storm,if=spell_targets.shuriken_storm>=2
	{ 'Shuriken Storm', 'player.area(10).enemies >= 2 & toggle(aoe)'},
	--actions.build+=/gloomblade
	{ 'Gloomblade'},
	--actions.build+=/backstab
	{ 'Backstab'},
}

local finish = {
	--# Finishers
	--actions.finish=enveloping_shadows,if=buff.enveloping_shadows.remains<target.time_to_die&buff.enveloping_shadows.remains<=combo_points*1.8
	--actions.finish+=/death_from_above,if=spell_targets.death_from_above>=5
	{ 'Death from Above', 'target.area(8).enemies >= 5'},
	--actions.finish+=/nightblade,if=target.time_to_die-remains>8&(mantle_duration=0|remains<=mantle_duration)&((refreshable&(!finality|buff.finality_nightblade.up))|remains<tick_time*2)
	{ 'Nightblade', 'target.deathin > 8 & target.debuff.duration <= 4.5'},
	--actions.finish+=/nightblade,cycle_targets=1,if=target.time_to_die-remains>8&mantle_duration=0&((refreshable&(!finality|buff.finality_nightblade.up))|remains<tick_time*2)
	{ 'Nightblade', 'focus.enemy & focus.deathin > 8 & focus.debuff.duration <= 4.5 ', 'focus'},
	{ 'Nightblade', 'mouseover.enemy & focus.deathin > 8 & mouseover.debuff.duration <= 4.5 ', 'mouseover'},
	{ 'Nightblade', 'boss1.enemy & focus.deathin > 8 & boss1.debuff.duration <= 4.5 ', 'boss1'},
	{ 'Nightblade', 'boss2.enemy & focus.deathin > 8 & boss2.debuff.duration <= 4.5 ', 'boss2'},
	{ 'Nightblade', 'boss3.enemy & focus.deathin > 8 & boss3.debuff.duration <= 4.5 ', 'boss3'},
	--actions.finish+=/death_from_above
	{ 'Death from Above'},
	--actions.finish+=/eviscerate
	{ 'Eviscerate'},
}

local sprinted = { 
	--# Sprinted
	--actions.sprinted=cancel_autoattack
	{ '/stopattack', 'isattacking'},
	{ '%pause'},
	--actions.sprinted+=/use_item,name=draught_of_souls
}

local stealthCooldowns = {
	--# Stealth Cooldowns
	--actions.stealth_cds=vanish,if=mantle_duration=0&cooldown.shadow_dance.charges_fractional<variable.shd_fractionnal+(equipped.mantle_of_the_master_assassin&time<30)*0.3
	{ 'Vanish', '!player.buff(Master Assassin\'s Initiative) & player.spell(Shadow Dance).charges < 2.45 + { player.xequipped(144236) & time < 30} * 0.3'},
	--actions.stealth_cds+=/shadow_dance,if=charges_fractional>=variable.shd_fractionnal
	{ 'Shadow Dance', 'player.spell.charges >= 2.45'},
	--actions.stealth_cds+=/pool_resource,for_next=1,extra_amount=40
	{ '%pause', 'player.energy < 40'}, 
	--actions.stealth_cds+=/shadowmeld,if=energy>=40&energy.deficit>=10+variable.ssw_refund
	{ 'Shadowmeld', 'player.energy >= 40 & player.deficit >= 10 + variable.ssw_refund'},
	--actions.stealth_cds+=/shadow_dance,if=combo_points.deficit>=5-talent.vigor.enabled
	{ 'Shadow Dance', 'player.combopoints.deficit >= 5'},
}

local stealth_als = {
	--# Stealth Action List Starter
	--actions.stealth_als=call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold&(!equipped.shadow_satyrs_walk|cooldown.shadow_dance.charges_fractional>=variable.shd_fractionnal|energy.deficit>=10)
	{ stealthCooldowns, 'player.deficit <= variable.stealth_threshold'},
	--actions.stealth_als+=/call_action_list,name=stealth_cds,if=mantle_duration>2.3
	{ stealthCooldowns, 'player.buff(Master Assassin\'s Initiative).duration > 2.3'},
	--actions.stealth_als+=/call_action_list,name=stealth_cds,if=spell_targets.shuriken_storm>=5
	{ stealthCooldowns, 'player.area(10).enemies >= 5'},
	--actions.stealth_als+=/call_action_list,name=stealth_cds,if=(cooldown.shadowmeld.up&!cooldown.vanish.up&cooldown.shadow_dance.charges<=1)
	
	--actions.stealth_als+=/call_action_list,name=stealth_cds,if=target.time_to_die<12*cooldown.shadow_dance.charges_fractional*(1+equipped.shadow_satyrs_walk*0.5)
	{ stealthCooldowns, 'target.deathin < 12'},
}

local stealthed = {
	--# Stealthed Rotation
	--actions.stealthed+=/call_action_list,name=finish,if=combo_points>=5&(spell_targets.shuriken_storm>=2+talent.premeditation.enabled+equipped.shadow_satyrs_walk|(mantle_duration<=1.3&mantle_duration-gcd.remains>=0.3))
	{ finish, 'player.combopoints >= 5 & player.area(10).enemies >= 2 + prem.up'},
	--actions.stealthed+=/shuriken_storm,if=buff.shadowmeld.down&((combo_points.deficit>=3&spell_targets.shuriken_storm>=2+talent.premeditation.enabled+equipped.shadow_satyrs_walk)|(combo_points.deficit>=1+buff.shadow_blades.up&buff.the_dreadlords_deceit.stack>=29))
	{ 'Shuriken Storm', 'player.combopoints.deficit >= 3 & player.area(10) >= 2 + prem.up'},
	--actions.stealthed+=/call_action_list,name=finish,if=combo_points>=5&combo_points.deficit<2+talent.premeditation.enabled+buff.shadow_blades.up-equipped.mantle_of_the_master_assassin
	{ finish, 'player.combopoints >= 5 & player.combopoints.deficit < 2 + sb.up + prem.up'},
	--actions.stealthed+=/shadowstrike
	{ 'Shadowstrike'},
}

local simCraft = {
	{ survival},
	--# Executed every time the actor is available.
	--actions=run_action_list,name=sprinted,if=buff.faster_than_light_trigger.up
	{ sprinted, 'player.buff(Sprint).duration >= 5'},
	{ '/startattack', '!isattacking'},
	--actions+=/call_action_list,name=cds
	{ cooldowns},
	--# Fully switch to the Stealthed Rotation (by doing so, it forces pooling if nothing is available)
	--actions+=/run_action_list,name=stealthed,if=stealthed.all
	{ stealthed, 'player.stealthed'},
	--actions+=/nightblade,if=target.time_to_die>8&remains<gcd.max&combo_points>=4
	{ 'Nightblade', 'target.deathin > 8 & target.debuff.duration < gcd.max & player.combopoints >= 4'},
	--actions+=/sprint,if=!equipped.draught_of_souls&mantle_duration=0&energy.time_to_max>=1.5&cooldown.shadow_dance.charges_fractional<variable.shd_fractionnal&!cooldown.vanish.up&target.time_to_die>=8&(dot.nightblade.remains>=14|target.time_to_die<=45)
	{ 'Sprint', 'energy.time_to_max >= 1.5 & spell(Shadow Dance).charges < 2.45 & !spell(Vanish).cooldown & target.deathin >= 8 & target.debuff(Nightblade).duration >= 14'},
	--actions+=/sprint,if=equipped.draught_of_souls&trinket.cooldown.up&mantle_duration=0
	--actions+=/call_action_list,name=stealth_als,if=(combo_points.deficit>=2+talent.premeditation.enabled|cooldown.shadow_dance.charges_fractional>=2.9)
	{ stealth_als, 'player.combopoints.deficit >= 2 & !talent(6,1) || player.combopoints.deficit >= 3 & talent(6,1) || player.spell(Shadow Dance).charges >= 2.9'},
	--actions+=/call_action_list,name=finish,if=combo_points>=5|(combo_points>=4&combo_points.deficit<=2&spell_targets.shuriken_storm>=3&spell_targets.shuriken_storm<=4)
	{ finish, 'player.combopoints >= 5 || player.combopoints >= 4 & player.combopoints deficit <= 2 & player.area(10).enemies >= 3 & player.area(10).enemies <= 4'},
	--actions+=/call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold
	{ build, 'player.deficit <= variable.stealth_threshold || energy.time_to_max <= gcd'},
}

local utility = {
	{ 'Tricks of the Trade', '!focus.buff & !focus.enemy', 'focus'},
	{ 'Tricks of the Trade', '!tank.buff', 'tank'},
}

local preCombat = {
	{ 'Tricks of the Trade', '!focus.buff & pull_timer <= 4', 'focus'},
	{ 'Tricks of the Trade', '!tank.buff & pull_timer <= 4', 'tank'},
	--{ 'Symbols of Death', 'pull_timer <= 11'},
	{ '#Potion of the Old War', '!player.buff & pull_timer <= 2 & UI(ow) & toggle(cooldowns)'},
	{ 'Symbols of Death', 'pull_timer <= 1'},
	{ 'Shadowstep', 'pull_timer <= 0.1'},
}

local inCombat = {
	{ keybinds},
	{ interrupts, 'target.interruptAt(35)'},
	{ utility},
	{ simCraft}
}

local outCombat = {
	{ 'Stealth', '!player.buff & !player.buff(Vanish)'},
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(261, {
	name = '[Silver] Rogue - Subtley',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
