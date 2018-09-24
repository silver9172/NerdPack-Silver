local GUI = {
	-- Survival
	{type = 'header', text = 'Survival', align = 'center'},
	{type = 'checkspin', text = 'Crimson Vial', key = 'cv', default_check = true, default_spin = 65},
	{type = 'checkspin', text = 'Riposte', key = 'rip', default_check = true, default_spin = 35},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'ruler'},{type = 'spacer'},} 

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- ')
	print('|cffADFF2F --- ')
	print('|cffADFF2F ----------------------------------------------------------------------|r')

end

local keybinds = {
	{ 'Grappling Hook', 'keybind(control)', 'cursor.ground'},
}

local interrupts = {
	{ 'Kick'},
	{ 'Gouge', '!player.lastcast(Kick)'},
	{ 'Between the Eyes', '!player.lastcast(Kick) & player.combopoints >= 1'},
}

local survival = {
	{ 'Crimson Vial', 'player.health <= UI(cv) & player.energy >= 35'},
	{ 'Riposte', 'player.health <= UI(rip)'},
}

local build = {
	-- # Builders
	-- actions.build=pistol_shot,if=combo_points.deficit>=1+buff.broadside.up+talent.quick_draw.enabled&buff.opportunity.up
	{ 'Pistol Shot', 'combopoints.deficit >= 1 + player.buff(Broadside) + talent(1,2) & player.buff(Opportunity)', 'target'}, 
	-- actions.build+=/sinister_strike
	{ 'Sinister Strike'}, 
}

local cooldowns = {
	-- # Cooldowns
	-- actions.cds=potion,if=buff.bloodlust.react|target.time_to_die<=60|buff.adrenaline_rush.up
	-- actions.cds+=/blood_fury
	{ 'Blood Fury'}, 
	-- actions.cds+=/berserking
	-- actions.cds+=/fireblood
	-- actions.cds+=/ancestral_call
	-- actions.cds+=/adrenaline_rush,if=!buff.adrenaline_rush.up&energy.time_to_max>1
	-- actions.cds+=/marked_for_death,target_if=min:target.time_to_die,if=target.time_to_die<combo_points.deficit|((raid_event.adds.in>40|buff.true_bearing.remains>15-buff.adrenaline_rush.up*5)&!stealthed.rogue&combo_points.deficit>=cp_max_spend-1)
	-- # Blade Flurry on 2+ enemies. With adds: Use if they stay for 8+ seconds or if your next charge will be ready in time for the next wave.
	-- actions.cds+=/blade_flurry,if=spell_targets>=2&!buff.blade_flurry.up&(!raid_event.adds.exists|raid_event.adds.remains>8|cooldown.blade_flurry.charges=1&raid_event.adds.in>(2-cooldown.blade_flurry.charges_fractional)*25)
	
	-- actions.cds+=/ghostly_strike,if=variable.blade_flurry_sync&combo_points.deficit>=1+buff.broadside.up
	-- actions.cds+=/killing_spree,if=variable.blade_flurry_sync&(energy.time_to_max>5|energy<15)
	-- actions.cds+=/blade_rush,if=variable.blade_flurry_sync&energy.time_to_max>1
	-- # Using Vanish/Ambush is only a very tiny increase, so in reality, you're absolutely fine to use it as a utility spell.
	-- actions.cds+=/vanish,if=!stealthed.all&variable.ambush_condition
	-- actions.cds+=/shadowmeld,if=!stealthed.all&variable.ambush_condition
}

local finish = {
	-- actions.finish=slice_and_dice,if=buff.slice_and_dice.remains<target.time_to_die&buff.slice_and_dice.remains<(1+combo_points)*1.8
	{ 'Slice and Dice', 'buff.duration < target.ttd & buff.duration < { 1 + combopoints} * 1.8', 'player'},  
	-- actions.finish+=/roll_the_bones,if=(buff.roll_the_bones.remains<=3|variable.rtb_reroll)&(target.time_to_die>20|buff.roll_the_bones.remains<target.time_to_die)
	{ 'Roll the Bones', '{rtb_buffs.duration <= 3 || rtb_reroll > 0 } & {target.ttd > 20 || rtb_buffs.duration < target.ttd}', 'player'},
	
	-- # BTE with the Ruthless Precision buff from RtB or with the Ace Up Your Sleeve or Deadshot traits.
	-- actions.finish+=/between_the_eyes,if=buff.ruthless_precision.up|azerite.ace_up_your_sleeve.enabled|azerite.deadshot.enabled
	{ 'Between the Eyes', 'player.buff(Ruthless Precision', 'target'},
	-- actions.finish+=/dispatch
	{ 'Dispatch'}, 
}

local rotation = {
	-- # Executed every time the actor is available.
	-- # Reroll for 2+ buffs with Loaded Dice up. Otherwise reroll for 2+ or Grand Melee or Ruthless Precision.
	-- actions=variable,name=rtb_reroll,value=rtb_buffs<2&(buff.loaded_dice.up|!buff.grand_melee.up&!buff.ruthless_precision.up)
	-- actions+=/variable,name=ambush_condition,value=combo_points.deficit>=2+2*(talent.ghostly_strike.enabled&cooldown.ghostly_strike.remains<1)+buff.broadside.up&energy>60&!buff.skull_and_crossbones.up
	-- # With multiple targets, this variable is checked to decide whether some CDs should be synced with Blade Flurry
	-- actions+=/variable,name=blade_flurry_sync,value=spell_targets.blade_flurry<2&raid_event.adds.in>20|buff.blade_flurry.up
	-- actions+=/call_action_list,name=stealth,if=stealthed.all
	-- actions+=/call_action_list,name=cds
	-- # Finish at maximum CP. Substract one for each Broadside and Opportunity when Quick Draw is selected and MfD is not ready after the next second.
	-- actions+=/call_action_list,name=finish,if=combo_points>=cp_max_spend-(buff.broadside.up+buff.opportunity.up)*(talent.quick_draw.enabled&(!talent.marked_for_death.enabled|cooldown.marked_for_death.remains>1))
	{ finish, 'player.combopoints >= cp_max_spend - { player.buff(Broadside) + player.buff(Opportunity) } * { talent(1,2) & { !talent(3,3) || player.spell(Marked for Death).cooldown > 1 }}'}, 
	-- actions+=/call_action_list,name=build
	{ build}, 
	-- actions+=/arcane_torrent,if=energy.deficit>=15+energy.regen
	-- actions+=/arcane_pulse
	-- actions+=/lights_judgment
}

local preCombat = {
	{ 'Marked for Death', 'pull_timer <= 10'},
	{ 'Tricks of the Trade', '!focus.buff & pull_timer <= 4', 'focus'},
	{ 'Tricks of the Trade', '!tank.buff & pull_timer <= 4', 'tank'},
	{ 'Roll the Bones', 'pull_timer <= 2 & player.rtb <= 1'},
	-- Potion goes here
	--{ 'Ambush', 'pull_timer <= 0'},
}

local inCombat = {
	{ 'Ambush', 'player.buff(Stealth)'},
	{ '/startattack', '!isattacking & !player.buff(Stealth)'},
	{ keybinds},
	{ survival},
	{ interrupts, 'target.interruptAt(30)'},
	{ rotation}
}

local outCombat = {
	{ keybinds},
	--{ preCombat}
}

NeP.CR:Add(260, {
	name = '[Silver] Rogue - Outlaw',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
