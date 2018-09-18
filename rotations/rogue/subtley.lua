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
	print('|cffADFF2F --- WIP')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {
	{ '%pause', 'keybind(alt)'}
}

local interrupts = {
	{ 'Kick'},
}

local survival = {
	{ 'Crimson Vial', 'player.health <= UI(cv) & player.energy >= 35'},
	{ 'Evasion', 'player.threat >= 100'},
		
	-- Health Pot
	--{ '#Ancient Healing Potion', 'UI(hp_check) & player.health <= UI(hp_spin)'},
	
	-- Healthstones
	--{ '#Healthstone', 'UI(hs_check) & player.health <= UI(hs_spin)'},
}

local utility = {
	{ 'Tricks of the Trade', '!focus.buff & !focus.enemy', 'focus'},
	{ 'Tricks of the Trade', '!tank.buff', 'tank'},
}

local preCombat = {
	{ 'Tricks of the Trade', '!focus.buff & pull_timer <= 4', 'focus'},
	{ 'Tricks of the Trade', '!tank.buff & pull_timer <= 4', 'tank'},
	--{ 'Symbols of Death', 'pull_timer <= 11'},
	--{ '#Potion of the Old War', '!player.buff & pull_timer <= 2 & UI(ow) & toggle(cooldowns)'},
	{ 'Symbols of Death', 'pull_timer <= 1'},
}

-------------------------------------------------
------------------- Sim Craft -------------------
-------------------------------------------------

local build = {
	--# Shuriken Toss at 29+ Sharpened Blades stacks. 1T at Rank 1, up to 4 at Rank 2, up to 5 at Rank 3
	--actions.build=shuriken_toss,if=buff.sharpened_blades.stack>=29&spell_targets.shuriken_storm<=1+3*azerite.sharpened_blades.rank=2+4*azerite.sharpened_blades.rank=3
	--actions.build+=/shuriken_storm,if=spell_targets.shuriken_storm>=2|buff.the_dreadlords_deceit.stack>=29
	{ 'Shuriken Storm', 'player.area(10).enemies >= 2 || player.buff(The Dreadlords Deceit).count >= 29', 'target'}, 
	--actions.build+=/gloomblade
	{ 'Gloomblade'},
	--actions.build+=/backstab
	{ 'Backstab'}, 
}

local cooldowns = {
	--actions.cds=potion,if=buff.bloodlust.react|target.time_to_die<=60|(buff.vanish.up&(buff.shadow_blades.up|cooldown.shadow_blades.remains<=30))
	--actions.cds+=/blood_fury,if=stealthed.rogue
	{ 'Blood Fury', 'player.stealthed & target.bosscheck >= 1'}, 
	--actions.cds+=/berserking,if=stealthed.rogue
	{ 'Berserking', 'player.stealthed & target.bosscheck >= 1'}, 
	--actions.cds+=/fireblood,if=stealthed.rogue
	{ 'Fireblood', 'player.stealthed & target.bosscheck >= 1'}, 
	--actions.cds+=/ancestral_call,if=stealthed.rogue
	{ 'Ancestral Call', 'player.stealthed & target.bosscheck >= 1'}, 
	--actions.cds+=/symbols_of_death,if=dot.nightblade.ticking
	{ 'Symbols of Death', 'target.debuff(Nightblade)', 'player'},
	--actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit

	--actions.cds+=/marked_for_death,if=raid_event.adds.in>30&!stealthed.all&combo_points.deficit>=cp_max_spend
	{ 'Marked for Death', '!player.stealthed & combopoints.deficit >= 5', 'target'}, 
	--actions.cds+=/shadow_blades,if=combo_points.deficit>=2+stealthed.all
	{ 'Shadow Blades', 'combopoints.deficit >= 2 + stealthed & target.bosscheck >= 1', 'player'}, 
	--actions.cds+=/shuriken_tornado,if=spell_targets>=3&dot.nightblade.ticking&buff.symbols_of_death.up&buff.shadow_dance.up
	{ 'Shuriken Tornado', 'player.area(10).enemies >= 3 & debuff(Nightblade) & player.buff(Symbols of Death) & player.buff(Shadow Dance)', 'target'},
	--actions.cds+=/shadow_dance,if=!buff.shadow_dance.up&target.time_to_die<=5+talent.subterfuge.enabled
	{ 'Shadow Dance', '!buff & target.ttd <= 5 + talent(2,2)', 'player'}, 
}

local finish = {
	--# Keep up Nightblade if it is about to run out. Do not use NB during Dance, if talented into Dark Shadow.
	--actions.finish=nightblade,if=(!talent.dark_shadow.enabled|!buff.shadow_dance.up)&target.time_to_die-remains>6&remains<tick_time*2&(spell_targets.shuriken_storm<4|!buff.symbols_of_death.up)
	{ 'Nightblade', 'range <= 8 & & infront & { !talent(6,1) || !player.buff(Shadow Dance)} & ttd > 6 & debuff.duration < 6 & { player.area(10).enemies < 4 || !player.buff(Symbols of Death)}', 'target'},  
	--# Multidotting outside Dance on targets that will live for the duration of Nightblade with refresh during pandemic if you have less than 6 targets or play with Secret Technique.
	--actions.finish+=/nightblade,cycle_targets=1,if=spell_targets.shuriken_storm>=2&(spell_targets.shuriken_storm<=5|talent.secret_technique.enabled)&!buff.shadow_dance.up&target.time_to_die>=(5+(2*combo_points))&refreshable
	{ 'Nightblade', 'range <= 8 & & infront & player.area(10).enemies >= 2 & { player.area(10).enemies <= 5 || talent(7,2) } & !player.buff(Shadow Dance) & ttd >= { 5+{2*player.combopoints}} & debuff.duration <= 4.8', 'enemies'},
	--# Refresh Nightblade early if it will expire during Symbols. Do that refresh if SoD gets ready in the next 5s.
	--actions.finish+=/nightblade,if=remains<cooldown.symbols_of_death.remains+10&cooldown.symbols_of_death.remains<=5&target.time_to_die-remains>cooldown.symbols_of_death.remains+5
	
	--# Secret Technique during Symbols. With Dark Shadow and multiple targets also only during Shadow Dance (until threshold in next line).
	--actions.finish+=/secret_technique,if=buff.symbols_of_death.up&(!talent.dark_shadow.enabled|spell_targets.shuriken_storm<2|buff.shadow_dance.up)
	{ 'Secret Technique', 'player.buff(Symbols of Death) & { !talent(6,1) || player.area(10).enemies < 2 || player.buff(Shadow Dance)}', 'target'}, 
	--# With enough targets always use SecTec on CD.
	--actions.finish+=/secret_technique,if=spell_targets.shuriken_storm>=2+talent.dark_shadow.enabled+talent.nightstalker.enabled
	{ 'Secret Technique', 'player.area(10).enemies >= 2 + talent(6,1) + talent(2,1)', 'target'}, 
	--actions.finish+=/eviscerate
	{ 'Eviscerate', 'range <= 8 & infront', 'target'},
}

local stealthCooldowns = {
	--# Stealth Cooldowns
	--# Helper Variable
	--actions.stealth_cds=variable,name=shd_threshold,value=cooldown.shadow_dance.charges_fractional>=1.75
	--# Vanish unless we are about to cap on Dance charges. Only when Find Weakness is about to run out.
	--actions.stealth_cds+=/vanish,if=!variable.shd_threshold&debuff.find_weakness.remains<1
	{ 'Vanish', '!variable.shd_threshold & target.debuff(Find Weakness).duration < 1 & toggle(cooldowns) & bosscheck = 1 & partycheck > 1 & talent(1,2)'},
	--# Pool for Shadowmeld + Shadowstrike unless we are about to cap on Dance charges. Only when Find Weakness is about to run out.
	--actions.stealth_cds+=/pool_resource,for_next=1,extra_amount=40
	--actions.stealth_cds+=/shadowmeld,if=energy>=40&energy.deficit>=10&!variable.shd_threshold&debuff.find_weakness.remains<1
	--# With Dark Shadow only Dance when Nightblade will stay up. Use during Symbols or above threshold.
	--actions.stealth_cds+=/shadow_dance,if=(!talent.dark_shadow.enabled|dot.nightblade.remains>=5+talent.subterfuge.enabled)&(variable.shd_threshold|buff.symbols_of_death.remains>=1.2|spell_targets>=4&cooldown.symbols_of_death.remains>10)
	{ 'Shadow Dance', '{ !talent(6,1) || target.debuff(Nightblade).duration >= 5 + talent(2,2)} & { variable.shd_threshold || buff(Symbols of Death).duration >= 1.2 || player.area(8).enemies >= 4 & spell(Symbols of Death).cooldown > 10}', 'player'}, 
	--actions.stealth_cds+=/shadow_dance,if=target.time_to_die<cooldown.symbols_of_death.remains
	{ 'Shadow Dance', 'target.ttd < spell.(Symbols of Death).cooldown', 'player'}, 
}

local stealthed = {
	--# If stealth is up, we really want to use Shadowstrike to benefits from the passive bonus, even if we are at max cp (from the precombat MfD).
	--actions.stealthed=shadowstrike,if=buff.stealth.up
	{ 'Shadowstrike', 'player.buff(Stealth) & range <= 8 & infront', 'target'}, 
	--# Finish at 4+ CP without DS, 5+ with DS, and 6 with DS after Vanish
	--actions.stealthed+=/call_action_list,name=finish,if=combo_points.deficit<=1-(talent.deeper_stratagem.enabled&buff.vanish.up)
	{ finish, 'combopoints.deficit <= 1 - { talent(3,2) & player.buff(Vanish)}'},  
	--# At 2 targets with Secret Technique keep up Find Weakness by cycling Shadowstrike.
	--actions.stealthed+=/shadowstrike,cycle_targets=1,if=talent.secret_technique.enabled&talent.find_weakness.enabled&debuff.find_weakness.remains<1&spell_targets.shuriken_storm=2&target.time_to_die-remains>6
	{ 'Shadowstrike', 'talent(7,2) & talent(1,2) & debuff(Find Weakness).duration < 1 & player.area(10).enemies = 2 & ttd > 6', 'enemies'}, 
	--actions.stealthed+=/shuriken_storm,if=spell_targets.shuriken_storm>=3
	{ 'Shuriken Storm', 'player.area(10).enemies >= 3', 'target'},
	--actions.stealthed+=/shadowstrike
	{ 'Shadowstrike', 'range <= 8 & infront', 'target'},
} 

local simCraft = {
	--# Executed every time the actor is available.
	--# Check CDs at first
	--actions=call_action_list,name=cds
	{ cooldowns, 'target.range <= 8 & target.enemy'}, 
	--# Run fully switches to the Stealthed Rotation (by doing so, it forces pooling if nothing is available).
	--actions+=/run_action_list,name=stealthed,if=stealthed.all
	{ stealthed, 'player.stealthed'}, 
	--# Apply Nightblade at 2+ CP during the first 10 seconds, after that 4+ CP if it expires within the next GCD or is not up
	--actions+=/nightblade,if=target.time_to_die>6&remains<gcd.max&combo_points>=4-(time<10)*2
	{ 'Nightblade', 'ttd > 6 & debuff.duration < gcd & combopoints >= 4 - { combat.time < 10} * 2', 'target'}, 
	--# Consider using a Stealth CD when reaching the energy threshold and having space for at least 4 CP
	--actions+=/call_action_list,name=stealth_cds,if=energy.deficit<=variable.stealth_threshold&combo_points.deficit>=4
	{ stealthCooldowns, 'player.deficit <= variable.stealth_threshold & combopoints.deficit >= 4'},
	--# Finish at 4+ without DS, 5+ with DS (outside stealth)
	{ finish, 'combopoints.deficit <= 1 & !player.stealthed'}, 
	--actions+=/call_action_list,name=finish,if=combo_points>=4+talent.deeper_stratagem.enabled|target.time_to_die<=1&combo_points>=3
	{ finish, 'combopoints >= 4 + talent(3,2) || target.ttd <= 1 & combopoints >= 3'},
	--# Use a builder when reaching the energy threshold (minus 40 if none of Alacrity, Shadow Focus, and Master of Shadows is selected)
	--actions+=/call_action_list,name=build,if=energy.deficit<=variable.stealth_threshold-40*!(talent.alacrity.enabled|talent.shadow_focus.enabled|talent.master_of_shadows.enabled)
	{ build, 'player.deficit <= variable.stealth_threshold - 40 * { !talent(6,2) || !talent(2,3) || !talent(7,1)}'}, 
	--# Lowest priority in all of the APL because it causes a GCD
	--actions+=/arcane_torrent,if=energy.deficit>=15+energy.regen
	--actions+=/arcane_pulse
	--actions+=/lights_judgment
}


local inCombat = {
	{ '/startattack', '!isattacking & target.enemy'},
	{ keybinds},
	{ survival}, 
	{ interrupts, 'target.interruptAt(35)'},
	{ utility},
	-- { rotation}
	{ simCraft}, 
}

local outCombat = {
	{ 'Stealth', '!player.buff & !player.buff(Vanish)'},
	{ keybinds},
	--{ preCombat}
}

NeP.CR:Add(261, {
	name = '[Silver] Rogue - Subtley',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
