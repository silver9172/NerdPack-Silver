local GUI = {
	-- Toggles
	{type = 'header', text = 'Toggles', align = 'center'},
	{type = 'checkbox', text = 'Potion', key = 'pot', default = false},
	{type = 'checkbox', text = 'Auto Target Priority', key = 'prio', default = true},
	
	-- Survival
	{type = 'header', text = 'Survival', align = 'center'},
	{type = 'spinner', text = 'Victory Rush', key = 'vr', default_spin = 75},
	{type = 'spinner', text = 'Enraged Regeneration', key = 'er', default_spin = 40},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'ruler'},{type = 'spacer'},} 

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- |rSilver Warrior |cffADFF2FFury |r')
	print('|cffADFF2F --- |rMost Talents Supported')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {
	{ 'Heroic Leap', 'keybind(lcontrol)', 'mouseover.ground'}
}

local interrupts = {
	{ 'Pummel', 'inRange.spell && infront && interruptAt(35)', { 'target', 'enemies'}},
	{ 'Storm Bolt', 'inRange.spell && infront && interruptAt(35) && combat', { 'target', 'enemies'}},  
}

local utility = {
	{ 'Battle Shout', '!buff(Battle Shout).any', 'friendly'},
	{ 'Storm Bolt', 'inRange.spell && infront && stunEvent && combat', { 'target', 'enemies'}},  
}


local survival = {
	{ 'Victory Rush', 'player.health <= UI(vr)', 'target'}, 
	{ 'Enraged Regeneration', 'player.health <= UI(er)'}, 
}

local priorityTarget = {
	-- actions.single_target=siegebreaker
	{ 'Siegebreaker', 'inRange.spell && infront && priorityTarget', 'enemies'}, 
	-- actions.single_target+=/rampage,if=buff.recklessness.up|(talent.frothing_berserker.enabled|talent.carnage.enabled&(buff.enrage.remains<gcd|rage>90)|talent.massacre.enabled&(buff.enrage.remains<gcd|rage>90))
	{ 'Rampage', '{player.buff(Recklessness) || { talent(5,3) || talent(5,1) && { player.buff(Enrage) < gcd || player.rage > 90 } || talent(5,2) && { player.buff(Enrage).duration < gcd || player.rage > 90}}} && inRange.spell && infront && priorityTarget', 'enemies'}, 
	-- actions.single_target+=/execute,if=buff.enrage.up
	{ 'Execute', 'player.buff(Enrage) && inRange.spell && infront && priorityTarget', { 'target', 'enemies'}}, 
	-- actions.single_target+=/bloodthirst,if=buff.enrage.down
	{ 'Bloodthirst', '!player.buff(Enrage) && inRange.spell && infront && priorityTarget', 'enemies'}, 
	-- actions.single_target+=/raging_blow,if=charges=2
	{ 'Raging Blow', 'spell.charges = 2 && inRange.spell && infront && priorityTarget', 'enemies'}, 
	-- actions.single_target+=/bloodthirst
	{ 'Bloodthirst', 'inRange.spell && infront && priorityTarget', 'enemies'}, 
	-- actions.single_target+=/bladestorm,if=prev_gcd.1.rampage&(debuff.siegebreaker.up|!talent.siegebreaker.enabled)
	{ 'Bladestorm', 'lastgcd(Rampage) && { target.debuff(Siegebreaker) || !talent(7,3)} && inRange.spell(Bloodthirst) && infront && priorityTarget', 'enemies'}, 
	-- actions.single_target+=/dragon_roar,if=buff.enrage.up
	{ 'Dragon Roar', 'player.buff(Enrage) && inRange.spell(Bloodthirst) && infront && priorityTarget', 'enemies'}, 
	-- actions.single_target+=/raging_blow,if=talent.carnage.enabled|(talent.massacre.enabled&rage<80)|(talent.frothing_berserker.enabled&rage<90)
	{ 'Raging Blow', 'inRange.spell && infront && priorityTarget && { talent(5,1) || { talent(5,2) && rage < 80 || talent(5,3) && rage < 90} && inRange.spell && infront}', 'target'}, 
	-- actions.single_target+=/furious_slash,if=talent.furious_slash.enabled
	{ 'Furious Slash', 'talent(3,3) && inRange.spell && infront && priorityTarget', 'enemies'}, 
	-- actions.single_target+=/whirlwind
	{ 'Whirlwind', 'inRange.spell(Bloodthirst) && priorityTarget', 'enemies'}, 
}

local singleTarget = {
	-- actions.single_target=siegebreaker
	{ 'Siegebreaker', 'inRange.spell && infront', 'target'}, 
	-- actions.single_target+=/rampage,if=buff.recklessness.up|(talent.frothing_berserker.enabled|talent.carnage.enabled&(buff.enrage.remains<gcd|rage>90)|talent.massacre.enabled&(buff.enrage.remains<gcd|rage>90))
	{ 'Rampage', '{player.buff(Recklessness) || { talent(5,3) || talent(5,1) && { player.buff(Enrage) < gcd || player.rage > 90 } || talent(5,2) && { player.buff(Enrage).duration < gcd || player.rage > 90}}} && inRange.spell && infront', 'target'}, 
	-- actions.single_target+=/execute,if=buff.enrage.up
	{ 'Execute', 'player.buff(Enrage) && inRange.spell && infront', { 'target', 'enemies'}}, 
	-- actions.single_target+=/bloodthirst,if=buff.enrage.down
	{ 'Bloodthirst', '!player.buff(Enrage) && inRange.spell && infront', 'target'}, 
	-- actions.single_target+=/raging_blow,if=charges=2
	{ 'Raging Blow', 'spell.charges = 2 && inRange.spell && infront', 'target'}, 
	-- actions.single_target+=/bloodthirst
	{ 'Bloodthirst', 'inRange.spell && infront', 'target'}, 
	-- actions.single_target+=/bladestorm,if=prev_gcd.1.rampage&(debuff.siegebreaker.up|!talent.siegebreaker.enabled)
	{ 'Bladestorm', 'lastgcd(Rampage) && { target.debuff(Siegebreaker) || !talent(7,3)} && inRange.spell(Bloodthirst) && infront', 'target'}, 
	-- actions.single_target+=/dragon_roar,if=buff.enrage.up
	{ 'Dragon Roar', 'player.buff(Enrage) && inRange.spell(Bloodthirst) && infront', 'target'}, 
	-- actions.single_target+=/raging_blow,if=talent.carnage.enabled|(talent.massacre.enabled&rage<80)|(talent.frothing_berserker.enabled&rage<90)
	{ 'Raging Blow', 'inRange.spell && infront && { talent(5,1) || { talent(5,2) && rage < 80 || talent(5,3) && rage < 90} && inRange.spell && infront}', 'target'}, 
	-- actions.single_target+=/furious_slash,if=talent.furious_slash.enabled
	{ 'Furious Slash', 'talent(3,3) && inRange.spell && infront', 'target'}, 
	-- actions.single_target+=/whirlwind
	{ 'Whirlwind', 'inRange.spell(Bloodthirst)', 'target'}, 
}

local rotation = {
	-- actions=auto_attack
	{ '/startattack', '!isattacking & target.exists'},
	-- actions+=/charge
	-- # This is mostly to prevent cooldowns from being accidentally used during movement.
	-- actions+=/run_action_list,name=movement,if=movement.distance>5
	-- actions+=/heroic_leap,if=(raid_event.movement.distance>25&raid_event.movement.in>45)|!raid_event.movement.exists
	-- actions+=/potion
	{ '#Potion of Bursting Blood', 'UI(pot) && inRange.spell(Bloodthirst) && { player.sated && player.buff(Recklessness) || target.ttd <= 25 || player.lust}'},
	{ '#trinket1', 'buff(Recklessness)', 'player'}, 
	--{ '#trinket2', 'player.buff(Recklessness)', 'target.ground'}, 
	-- actions+=/furious_slash,if=talent.furious_slash.enabled&(buff.furious_slash.stack<3|buff.furious_slash.remains<3|(cooldown.recklessness.remains<3&buff.furious_slash.remains<9))
	{ 'Furious Slash', 'inRange.spell && talent(3,3) && { player.buff(Furious Slash).count < 3 || player.buff(Furious Slash).duration < 3 || { spell(Recklessness).cooldown < 3 && player.buff(Furious Slash).duration < 9}}', 'target'}, 
	-- actions+=/rampage,if=cooldown.recklessness.remains<3
	{ 'Rampage', 'spell(Recklessness).cooldown < 3 && toggle(cooldowns) && bosscheck >= 1 && inRange.spell', 'target'}, 
	-- actions+=/recklessness
	{ 'Recklessness', 'toggle(cooldowns) && bosscheck >= 1 && inRange.spell(Bloodthirst)', 'target'}, 
	-- actions+=/whirlwind,if=spell_targets.whirlwind>1&!buff.meat_cleaver.up
	{ 'Whirlwind', 'toggle(aoe) && player.area(8).enemies > 1 && !player.buff(Whirlwind) && inRange.spell(Bloodthirst)', 'target'}, 
	-- actions+=/blood_fury,if=buff.recklessness.up
	{ 'Blood Fury', 'player.buff(Recklessness) && inRange.spell(Bloodthirst)'}, 
	-- actions+=/berserking,if=buff.recklessness.up
	{ 'Berserking', 'player.buff(Recklessness) && inRange.spell(Bloodthirst)'}, 
	-- actions+=/lights_judgment,if=buff.recklessness.down
	{ 'Lights Judgment', 'player.buff(Recklessness) && inRange.spell(Bloodthirst)'}, 
	-- actions+=/fireblood,if=buff.recklessness.up
	{ 'Fireblood', 'player.buff(Recklessness) && inRange.spell(Bloodthirst)'}, 
	-- actions+=/ancestral_call,if=buff.recklessness.up
	{ 'Ancestral Call', 'player.buff(Recklessness) && inRange.spell(Bloodthirst)'}, 
	-- actions+=/run_action_list,name=single_target
	{ singleTarget}, 
}

local preCombat = {
	{ '#Potion of Bursting Blood', 'dbm(Pull in) <= 2 && dbm(Pull in) > 0', 'target'}, 
	{ 'Recklessness', 'dbm(Pull in) <= 1 && dbm(Pull in) > 0', 'target'}, 
}

local inCombat = {
	{ keybinds},
	{ interrupts, 'target.interruptAt(35)'},
	{ utility}, 
	{ survival}, 
	{ priorityTarget, 'UI(prio)'}, 
	{ rotation},
	{ 'Heroic Throw', 'inRange.spell && infront', 'target'}, 
}

local outCombat = {
	{ keybinds},	
	{ utility}, 
	{ preCombat}, 
}

NeP.CR:Add(72, {
	name = '[Silver] Warrior - Fury',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.1',
 nep_ver = '1.11',
})
