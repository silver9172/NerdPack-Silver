local GUI = {
	-- General
	{type = 'header', 		text = 'General', align = 'center'},
	{type = 'checkbox',		text = 'Multi-Dot',						key = 'multi', 	default = true},
	{type = 'checkbox',		text = 'Auto Stealth',						key = 'stealth', 	default = true},
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
	{ 'Kick', 'inRange.spell && interruptAt(35)', { 'target', 'enemies'}},
}

local tricks = {
	{ 'Tricks of the Trade', 'inRange.spell && !buff & !enemy', 'focus'},
	{ 'Tricks of the Trade', 'inRange.spell && !buff', 'tank'},
}

local survival = {
	{ 'Crimson Vial', 'player.health <= UI(cv) & player.energy >= 35'},
}

local cooldowns = {
	-- actions.cds=potion,if=buff.bloodlust.react|debuff.vendetta.up
	-- actions.cds+=/use_item,name=galecallers_boon,if=cooldown.vendetta.remains<=1&(!talent.subterfuge.enabled|dot.garrote.pmultiplier>1)|cooldown.vendetta.remains>45
	{ 'Blood Fury', 'inRange.spell(Mutilate) && target.debuff(Vendetta)', 'player'},
	{ 'Berserking', 'inRange.spell(Mutilate) && target.debuff(Vendetta)', 'player'},
	{ 'Fireblood', 'inRange.spell(Mutilate) && target.debuff(Vendetta)', 'player'},
	{ 'Ancestral Call', 'inRange.spell(Mutilate) && target.debuff(Vendetta)', 'player'},
	-- # If adds are up, snipe the one with lowest TTD. Use when dying faster than CP deficit or without any CP.
	-- actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=raid_event.adds.up&(target.time_to_die<combo_points.deficit*1.5|combo_points.deficit>=cp_max_spend)
	-- # If no adds will die within the next 30s, use MfD on boss without any CP.
	-- actions.cds+=/marked_for_death,if=raid_event.adds.in>30-raid_event.adds.duration&combo_points.deficit>=cp_max_spend
	-- # Vendetta outside stealth with Rupture up. With Subterfuge talent and Shrouded Suffocation power always use with buffed Garrote. With Nightstalker and Exsanguinate use up to 5s (3s with DS) before Vanish combo.
	-- actions.cds+=/vendetta,if=!stealthed.rogue&dot.rupture.ticking&(!talent.subterfuge.enabled|!azerite.shrouded_suffocation.enabled|dot.garrote.pmultiplier>1)&(!talent.nightstalker.enabled|!talent.exsanguinate.enabled|cooldown.exsanguinate.remains<5-2*talent.deeper_stratagem.enabled)
	{ 'Vendetta', 'inRange.spell(Mutilate) && !stealthed && bosscheck = 1 && debuff(Rupture).duration >= 7.2 && { !talent(2,2) || subGarrote } && { !talent(2,1) || !talent(6,3) || spell(Exsanguinate).cooldown < 5 }', 'target'},
	-- # Extra Subterfuge Vanish condition: Use when Garrote dropped on Single Target
	-- actions.cds+=/vanish,if=talent.subterfuge.enabled&!dot.garrote.ticking&variable.single_target
	{ 'Vanish', 'inRange.spell(Mutilate) && !stealthed && talent(2,2) && debuff(Garrote).duration <= 5.2 && single_target && bosscheck = 1', 'target'},
	-- # Vanish with Exsg + (Nightstalker, or Subterfuge only on 1T): Maximum CP and Exsg ready for next GCD
	-- actions.cds+=/vanish,if=talent.exsanguinate.enabled&(talent.nightstalker.enabled|talent.subterfuge.enabled&variable.single_target)&combo_points>=cp_max_spend&cooldown.exsanguinate.remains<1&(!talent.subterfuge.enabled|!azerite.shrouded_suffocation.enabled|dot.garrote.pmultiplier<=1)
	-- # Vanish with Nightstalker + No Exsg: Maximum CP and Vendetta up
	-- actions.cds+=/vanish,if=talent.nightstalker.enabled&!talent.exsanguinate.enabled&combo_points>=cp_max_spend&debuff.vendetta.up
	-- # Vanish with Subterfuge + (No Exsg or 2T+): No stealth/subterfuge, Garrote Refreshable, enough space for incoming Garrote CP
	-- actions.cds+=/vanish,if=talent.subterfuge.enabled&(!talent.exsanguinate.enabled|!variable.single_target)&!stealthed.rogue&cooldown.garrote.up&dot.garrote.refreshable&(spell_targets.fan_of_knives<=3&combo_points.deficit>=1+spell_targets.fan_of_knives|spell_targets.fan_of_knives>=4&combo_points.deficit>=4)
	-- # Vanish with Master Assasin: No stealth and no active MA buff, Rupture not in refresh range
	-- actions.cds+=/vanish,if=talent.master_assassin.enabled&!stealthed.all&master_assassin_remains<=0&!dot.rupture.refreshable
	-- # Shadowmeld for Shrouded Suffocation
	-- actions.cds+=/shadowmeld,if=!stealthed.all&azerite.shrouded_suffocation.enabled&dot.garrote.refreshable&dot.garrote.pmultiplier<=1&combo_points.deficit>=1
	-- # Exsanguinate when both Rupture and Garrote are up for long enough
	-- actions.cds+=/exsanguinate,if=dot.rupture.remains>4+4*cp_max_spend&!dot.garrote.refreshable
	-- actions.cds+=/toxic_blade,if=dot.rupture.ticking
	{ 'Toxic Blade', 'inRange.spell && infront(player) && debuff(Rupture)', 'target'},
}

local wowhead = {
	-- Use  Rupture at maximum combo points if  Exsanguinate is ready.
	-- Keep up  Garrote on as many targets as possible. Let it fall off before reapplying, if it was snapshot with  Subterfuge or Exsanguinate.
	{ 'Garrote', 'inRange.spell && infront(player) && debuff.duration <= 21 && player.buff(Subterfuge) && !subGarrote && combopoints.deficit >= 1', { 'target', 'enemies'}},
	{ 'Garrote', 'inRange.spell && infront(player) && debuff.duration <= 5.4 && !subGarrote && combopoints.deficit >= 1', 'target'},
	{ 'Garrote', 'inRange.spell && infront(player) && debuff.duration <= 5.4 && !subGarrote && combopoints.deficit >= 1 && toggle(cleave)', { 'target', 'enemies'}},
	{ 'Garrote', 'inRange.spell && infront(player) && debuff.duration <= 21 && player.buff(Subterfuge) && subGarrote && combopoints.deficit >= 1', 'target'},
	-- During  Subterfuge overwrite normal versions with empowered ones, no matter their remaining duration, but prefer targets without any or a shorter  Garrote up first.
	-- Keep up  Crimson Tempest (if talented) against 2 or more targets with four or more combo points. Refresh it only during the last 2s.
	-- Keep up  Rupture with four or more combo points on all targets. Let it fall off before reapplying, if it was snapshot with Nightstalker or  Exsanguinate.
	{ 'Rupture', 'inRange.spell && infront(player) && debuff.duration <= 7.2 && combopoints.deficit <= 1', 'target'},
	{ 'Rupture', 'inRange.spell && infront(player) && debuff.duration <= 7.2 && combopoints.deficit <= 1 && toggle(cleave)', { 'target', 'enemies'}},
	-- If talented into  Internal Bleeding and your target is stunnable (e.g. in dungeons), you will ideally want to use  Kidney Shot at 4+ combo points (5+ with  Deeper Stratagem) when ready. Make sure you are still helping your group with your stuns though and consider situation / plan ahead.
	-- Use  Envenom at four or more combo points (5+ with  Deeper Stratagem). Against a single target, with neither  Vendetta nor  Toxic Blade up, it is worth pooling to about 80% energy before using it.
	{ 'Envenom', 'inRange.spell && infront(player) && combopoints.deficit <= 1 && { target.debuff(Vendetta) || target.debuff(Toxic Blade) || deficit <= 25 + energy_regen_combined || !single_target } && { !talent(6,3) || talent(6,3) && spell(Exsanguinate).cooldown > 2 }', 'target'},
	-- Use  Fan of Knives at 4 or more targets.
	{ 'Fan of Knives', 'inRange.spell(Mutilate) && player.area(15).enemies >= 4 && toggle(aoe)', { 'target', 'enemies'}},
	-- Use  Fan of Knives at 3 targets if any of them has no  Deadly Poison ticking.
	{ 'Fan of Knives', 'inRange.spell(Mutilate) && player.area(15).enemies >= 3 && !debuff(Deadly Poison) && toggle(cleave)', { 'target', 'enemies'}},
	-- Use  Blindside (if talented) if you have the proc or your enemy has less than 35% health. With  Venom Rush it is only worth to use with the proc.
	{ 'Blindside', 'inRange.spell && infront(player) && { player.buff(Blindside) || !talent(6,1) && target.health < 35 }', 'target'},
	-- Use  Mutilate at 2 targets to re-apply  Deadly Poison to the second target.
	{ 'Mutilate', 'inRange.spell && infront(player) && debuff(Deadly Poison).duration < 3.6 && use_filler && player.area(15).enemies = 2', 'enemies'},
	-- Use  Mutilate on your main target.
	{ 'Mutilate', 'inRange.spell && infront(player) && use_filler', { 'target', 'enemies'}},
}

local preCombat = {
	-- Poisons --
	{ 'Deadly Poison', 'buff.duration <= 600 && timeout(Poison, 2) && !moving', 'player'},
	{ 'Crippling Poison', 'buff.duration <= 600 && timeout(Poison, 2) && !moving', 'player'},

	{ tricks, 'dbm(Pull In) <= 4'}
}

local inCombat = {
	{ '/startattack', '!isattacking & target.enemy'},
	{ utility},
	{ tricks},
	{ keybinds},
	{ interrupts},
	{ survival},
	{ cooldowns},
	{ wowhead},
}

local outCombat = {
	{ 'Stealth', '!buff && !buff(Vanish) && timeout(stealth, 4) && UI(stealth)', 'player'},
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
