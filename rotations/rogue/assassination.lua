local GUI = {
	-- General
	{type = 'header', 		text = 'General', align = 'center'},
	{type = 'checkbox',		text = 'Multi-Dot',						key = 'multi', 	default = true},
	{type = 'checkbox',		text = 'Sinister Circulation',			key = 'sin', 	default = true},
	{type = 'checkbox',		text = 'Mantle of the Master Assassin',	key = 'mantle', default = true},
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
	{type = 'checkbox',		text = 'Vendetta',						key = 'ven', 	default = true},
	{type = 'checkbox',		text = 'Potion of the Old War',			key = 'ow', 	default = true},
	{type = 'ruler'},{type = 'spacer'},} 

local exeOnLoad = function()
	NeP.Interface:AddToggle({
		key  = 'cleave',
		name = 'Cleave',
		text = 'Cleave targets close by while doing single target damage',
		icon = 'Interface\\ICONS\\ability_rogue_rupture',
	})
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- Supported Talents')
	print('|cffADFF2F --- 1,1 / 2,1 / 3,3 / any / any / 6,1 or 6,2 / 7,1')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {

}

local interrupts = {
	{ 'Kick'},
}

local survival = {
	{ 'Feint', 'boss1.buff(Blood of the Father) & !player.buff'},

	{ 'Crimson Vial', 'player.health <= UI(cv) & player.energy >= 35'},
	
	-- Health Pot
	--{ '#Ancient Healing Potion', 'UI(hp_check) & player.health <= UI(hp_spin)'},
	
	-- Healthstones
	--{ '#Healthstone', 'UI(hs_check) & player.health <= UI(hs_spin)'},
}

local cooldowns = {
	{ 'Blood Fury', 'debuff(Vendetta)', 'target'},
	{ 'Beserking', 'debuff(Vendetta)', 'target'}, 
	{ 'Vendetta', 'target.bosscheck >= 1 & debuff(Rupture) & player.energy <= 80', 'target'}, 
}

local stealth = {
	{ 'Rupture', 'combopoints.deficit <= 1 & { talent(2,1) || talent(2,2)} & talent(6,3)', 'target'}, 
	{ 'Garrote', '{talent(2,2) & talent(6,3)} & combopoints.deficit >= 2 & combopoints.deficit >= 2 || player.buff(Subterfuge).duration <= gcd & combopoints.deficit >= 2', 'target'},
}

local vanish = {
	{ 'Vanish', 'talent(6,3) & { talent(2,1) || talent(2,2)} & player.combopoints = 5 & player.spell(Exsanguinate).cooldown = 0', 'target'},
	{ 'Vanish', 'talent(2,1) & combopoints.deficit = 0 & debuff(Vendetta)', 'target'},
	{ 'Vanish', 'talent(2,2) & debuff(Garrote).duration <= 5.4 & player.combopoints < 5', 'target'},
	{ 'Vanish', 'talent(2,3) & debuff(Rupture).duration > 6', 'target'}, 
}

local wowhead = {
	{ stealth, 'player.buff(Stealth)'},
	{ 'Marked for Death', 'player.combopoints < 3 & range <= 8', 'enemies'}, 
	{ cooldowns, 'toggle(cooldowns)'},
	{ vanish, 'toggle(cooldowns) & bosscheck = 1 & partycheck > 1'},
	{ 'Exsanguinate', 'debuff(Rupture).duration >= 20 & debuff(Garrote) >= 9', 'target'}, 
	{ 'Toxic Blade', 'debuff(Rupture)', 'target'}, 
	{ 'Rupture', 'talent(6,3) & debuff < 26 & player.spell(Exsanguinate).cooldown < 1', 'target'},
	-- Needs work
	{ 'Garrote', 'debuff.duration <= 5.4 & combopoints.deficit >= 2', 'target'},
	{ 'Garrote', 'debuff.duration <= 5.4 & combopoints.deficit >= 2 & count.enemies.debuffs < 3 & range <= 8 & infront & enemy & toggle(cleave)', 'enemies'},
	{ 'Crimson Tempest', 'combopoints.deficit <= 1 & debuff.duration <= 2', 'target'},
	{ 'Rupture', '{combopoints.deficit <= 1 & debuff.duration <= 6} || { !debuff & bosscheck = 1}', 'target'},
	{ 'Rupture', 'combopoints.deficit <= 1 & debuff.duration <= 6 & count.enemies.debuffs < 3 & range <= 8 & infront & enemy & toggle(cleave)', 'enemies'},
	{ 'Envenom', 'combopoints.deficit <= 1 & { player.area(8).enemies >= 2 || target.debuff(Vendetta) || target.debuff(Toxic Blade) || player.deficit < 40}', 'target'}, 
	{ 'Fan of Knives', 'toggle(aoe) & { player.buff(Hidden Blades).count >= 19 || player.area(10).enemies > 2}', 'target'}, 
	{ 'Blindside', 'combopoints.deficit < 1 || player.deficit < 40', 'target'}, 
	{ 'Mutilate', 'combopoints.deficit >= 2 || player.deficit < 40', 'target'}, 
} 

local SCcooldowns = {
	-- # Cooldowns
	-- actions.cds=potion,if=buff.bloodlust.react|target.time_to_die<=60|debuff.vendetta.up&cooldown.vanish.remains<5
	-- actions.cds+=/use_item,name=galecallers_boon
	-- actions.cds+=/use_item,name=lustrous_golden_plumage
	-- actions.cds+=/blood_fury,if=debuff.vendetta.up
	{ 'Blood Fury', 'debuff(Vendetta)', 'target'},
	-- actions.cds+=/berserking,if=debuff.vendetta.up
	{ 'Beserking', 'debuff(Vendetta)', 'target'}, 
	-- actions.cds+=/fireblood,if=debuff.vendetta.up
	{ 'Fireblood', 'debuff(Vendetta)', 'target'}, 
	-- actions.cds+=/ancestral_call,if=debuff.vendetta.up
	{ 'Ancestral Call', 'debuff(Vendetta)', 'target'}, 
	-- actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit*1.5|(raid_event.adds.in>40&combo_points.deficit>=cp_max_spend)
	
	-- actions.cds+=/vendetta,if=dot.rupture.ticking
	{ 'Vendetta', 'target.bosscheck >= 1 & debuff(Rupture).duration > 6', 'target'}, 
	-- # Vanish with Exsg + (Nightstalker, or Subterfuge only on 1T): Maximum CP and Exsg ready for next GCD
	-- actions.cds+=/vanish,if=talent.exsanguinate.enabled&(talent.nightstalker.enabled|talent.subterfuge.enabled&spell_targets.fan_of_knives<2)&combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1
	{ 'Vanish', 'bosscheck = 1 & partycheck > 1 & talent(6,3) & { talent(2,1) || talent(2,2) & player.area(10).enemies < 2} & combopoints >= cp_max_spend & player.spell(Exsanguinate).cooldown < 1', 'target'}, 
	-- # Vanish with Nightstalker + No Exsg: Maximum CP and Vendetta up
	-- actions.cds+=/vanish,if=talent.nightstalker.enabled&!talent.exsanguinate.enabled&combo_points>=cp_max_spend&debuff.vendetta.up
	{ 'Vanish', 'bosscheck = 1 & partycheck > 1 & !talent(2,1) & !talent(6,3) & combopoints.deficit <= 1 & debuff(Vendetta)', 'target'},
	-- # Vanish with Subterfuge + (No Exsg or 2T+): No stealth/subterfuge, Garrote Refreshable, enough space for incoming Garrote CP
	-- actions.cds+=/vanish,if=talent.subterfuge.enabled&(!talent.exsanguinate.enabled|spell_targets.fan_of_knives>=2)&!stealthed.rogue&cooldown.garrote.up&dot.garrote.refreshable&(spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives|spell_targets.fan_of_knives>=4&combo_points.deficit>=4)
	{ 'Vanish', 'bosscheck = 1 & partycheck > 1 & talent(2,2) & { !talent(6,3) || player.area(10).enemies >= 2 & toggle(aoe)} & !player.stealthed & player.spell(Garrote).cooldown = 0 & debuff(Garrote).duration <= 5.4 & { player.area(10).enemies <= 3 & combopoints.deficit >= 1 + player.area(10).enemies || player.area(10).enemies >= 4 & combopoints.deficit >=4 & toggle(aoe)', 'target'},
	-- # Vanish with Master Assasin: No stealth and no active MA buff, Rupture not in refresh range
	-- actions.cds+=/vanish,if=talent.master_assassin.enabled&!stealthed.all&master_assassin_remains<=0&!dot.rupture.refreshable
	{ 'Vanish', 'bosscheck = 1 & partycheck > 1 & talent(2,3) & player.stealthed & !player.buff(Master Assassin) & debuff(Rupture).duration >= 6', 'target'}, 
	-- # Exsanguinate when both Rupture and Garrote are up for long enough
	-- actions.cds+=/exsanguinate,if=dot.rupture.remains>4+4*cp_max_spend&!dot.garrote.refreshable
	{ 'Exsanguinate', 'debuff(Rupture).duration > 4 + 4 * cp_max_spend & debuff(Garrote).duration >= 5.4', 'target'}, 
	-- actions.cds+=/toxic_blade,if=dot.rupture.ticking
	{ 'Toxic Blade', 'debuff(Rupture) > 6', 'target'},
}

local direct = {
	-- # Direct damage abilities
	-- # Envenom at 4+ (5+ with DS) CP. Immediately on 2+ targets, with Vendetta, or with TB; otherwise wait for some energy. Also wait if Exsg combo is coming up.
	-- actions.direct=envenom,if=combo_points>=4+talent.deeper_stratagem.enabled&(debuff.vendetta.up|debuff.toxic_blade.up|energy.deficit<=25+variable.energy_regen_combined|spell_targets.fan_of_knives>=2)&(!talent.exsanguinate.enabled|cooldown.exsanguinate.remains>2)
	-- actions.direct+=/variable,name=use_filler,value=combo_points.deficit>1|energy.deficit<=25+variable.energy_regen_combined|spell_targets.fan_of_knives>=2
	-- # Poisoned Knife at 29+ stacks of Sharpened Blades. Up to 4 targets with Rank 1, more otherwise.
	-- actions.direct+=/poisoned_knife,if=variable.use_filler&buff.sharpened_blades.stack>=29&(azerite.sharpened_blades.rank>=2|spell_targets.fan_of_knives<=4)
	-- actions.direct+=/fan_of_knives,if=variable.use_filler&(buff.hidden_blades.stack>=19|spell_targets.fan_of_knives>=2+stealthed.rogue|buff.the_dreadlords_deceit.stack>=29)
	-- actions.direct+=/blindside,if=variable.use_filler&(buff.blindside.up|!talent.venom_rush.enabled)
	{ 'Blindside', 'use_filler & { player.buff(Blindside) || !talent(6,1)}', 'target'},
	-- actions.direct+=/mutilate,if=variable.use_filler
	{ 'Mutilate', 'use_filler', 'target'}, 
}

	-- # Damage over time abilities
	-- # Special Rupture setup for Exsg
	-- actions.dot=rupture,if=talent.exsanguinate.enabled&((combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1)|(!ticking&(time>10|combo_points>=2)))
	-- # Garrote upkeep, also tries to use it as a special generator for the last CP before a finisher
	-- actions.dot+=/pool_resource,for_next=1
	-- actions.dot+=/garrote,cycle_targets=1,if=(!talent.subterfuge.enabled|!(cooldown.vanish.up&cooldown.vendetta.remains<=4))&combo_points.deficit>=1&refreshable&(pmultiplier<=1|remains<=tick_time)&(!exsanguinated|remains<=tick_time*2)&(target.time_to_die-remains>4&spell_targets.fan_of_knives<=1|target.time_to_die-remains>12)
	-- # Crimson Tempest only on multiple targets at 4+ CP when running out in 2s (up to 4 targets) or 3s (5+ targets)
	-- actions.dot+=/crimson_tempest,if=spell_targets>=2&remains<2+(spell_targets>=5)&combo_points>=4
	-- # Keep up Rupture at 4+ on all targets (when living long enough and not snapshot)
	-- actions.dot+=/rupture,cycle_targets=1,if=combo_points>=4&refreshable&(pmultiplier<=1|remains<=tick_time)&(!exsanguinated|remains<=tick_time*2)&target.time_to_die-remains>4

	-- # Stealthed Actions
	-- # Nighstalker, or Subt+Exsg on 1T: Snapshot Rupture; Also use Rupture over Envenom if it's not applied (Opener)
	-- actions.stealthed=rupture,if=combo_points>=4&(talent.nightstalker.enabled|talent.subterfuge.enabled&talent.exsanguinate.enabled&spell_targets.fan_of_knives<2|!ticking)&target.time_to_die-remains>6
	-- actions.stealthed+=/envenom,if=combo_points>=cp_max_spend
	-- # Subterfuge: Apply or Refresh with buffed Garrotes
	-- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&refreshable&(!exsanguinated|remains<=tick_time*2)&target.time_to_die-remains>2
	-- # Subterfuge: Override normal Garrotes with snapshot versions
	-- actions.stealthed+=/garrote,cycle_targets=1,if=talent.subterfuge.enabled&remains<=10&pmultiplier<=1&!exsanguinated&target.time_to_die-remains>2
	-- # Subterfuge + Exsg: Even override a snapshot Garrote right after Rupture before Exsanguination
	-- actions.stealthed+=/pool_resource,for_next=1
	-- actions.stealthed+=/garrote,if=talent.subterfuge.enabled&talent.exsanguinate.enabled&cooldown.exsanguinate.remains<1&prev_gcd.1.rupture&dot.rupture.remains>5+4*cp_max_spend

local simCraft = {
	-- # Executed every time the actor is available.
	-- actions=variable,name=energy_regen_combined,value=energy.regen+poisoned_bleeds*7%(2*spell_haste)
	-- actions+=/call_action_list,name=stealthed,if=stealthed.rogue
	-- actions+=/call_action_list,name=cds
	-- actions+=/call_action_list,name=dot
	-- actions+=/call_action_list,name=direct
	{ direct}, 
	-- actions+=/arcane_torrent,if=energy.deficit>=15+variable.energy_regen_combined
	-- actions+=/arcane_pulse
	-- actions+=/lights_judgment
}
	
local utility = {
	{ 'Tricks of the Trade', '!buff & !enemy', 'focus'},
	{ 'Tricks of the Trade', '!buff', 'tank'},
}

local preCombat = {

}

local inCombat = {
	{ '/startattack', '!isattacking & target.enemy'},
	{ utility},
	{ keybinds},
	{ interrupts, 'target.interruptAt(35)'},
	{ survival},
	{ simCraft}, 
	--{ wowhead}, 
	--{ aoeRotation, 'player.area(10).enemies >= 2 & toggle(aoe)'}, 
	--{ rotation, 'target.enemy'},
	--{ 'Poisoned Knife'}, 
}

local outCombat = {
	-- Poisons --
	{ 'Deadly Poison', 'player.buff.duration <= 600 & !player.lastcast & !player.moving'},
	{ 'Crippling Poison', 'player.buff.duration <= 600 & !player.lastcast & !player.moving'},
	-------------

	--{ 'Stealth', '!player.buff & !player.buff(Vanish) & !lastcast'},
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(259, {
	name = '[Silver] Rogue - Assassination',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.0.1',
 nep_ver = '1.11',
})