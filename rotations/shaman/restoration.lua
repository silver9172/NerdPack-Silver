local GUI = {
	-- Survival
	{type = 'header', text = 'Survival', align = 'center'},
	{type = 'spinner', text = 'Victory Rush', key = 'vr', default_spin = 75},
	{type = 'spinner', text = 'Enraged Regeneration', key = 'er', default_spin = 40},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'checkspin', text = 'Use Ardent Defender', key = 'ad', default_check = true, default_spin = 25},
	{type = 'checkspin', text = 'Use Eye of Tyr', key = 'eye', default_check = true, default_spin = 60},
	{type = 'checkspin', text = 'Use Guardian of Ancient Kings', key = 'ak', default_check = true, default_spin = 35},
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
	{ 'Pummel'},
}

local utility = {
	-- Check player
	{ 'Battle Shout', '!buff.any', 'player'},
	
	-- Check party/raid
	{ 'Battle Shout', '!buff.any', 'lowest'},
	{ 'Battle Shout', '!buff.any', 'lowest2'},
	{ 'Battle Shout', '!buff.any', 'lowest3'},
	{ 'Battle Shout', '!buff.any', 'lowest4'},
	{ 'Battle Shout', '!buff.any', 'lowest5'},
	{ 'Battle Shout', '!buff.any', 'lowest6'},
	{ 'Battle Shout', '!buff.any', 'lowest7'},
	{ 'Battle Shout', '!buff.any', 'lowest8'},
	{ 'Battle Shout', '!buff.any', 'lowest9'},
	{ 'Battle Shout', '!buff.any', 'lowest10'},
	{ 'Battle Shout', '!buff.any', 'lowest11'},
	{ 'Battle Shout', '!buff.any', 'lowest12'},
	{ 'Battle Shout', '!buff.any', 'lowest13'},
	{ 'Battle Shout', '!buff.any', 'lowest14'},
	{ 'Battle Shout', '!buff.any', 'lowest15'},
	{ 'Battle Shout', '!buff.any', 'lowest16'},
	{ 'Battle Shout', '!buff.any', 'lowest17'},
	{ 'Battle Shout', '!buff.any', 'lowest18'},
	{ 'Battle Shout', '!buff.any', 'lowest19'},
	{ 'Battle Shout', '!buff.any', 'lowest20'},
	{ 'Battle Shout', '!buff.any', 'lowest21'},
	{ 'Battle Shout', '!buff.any', 'lowest22'},
	{ 'Battle Shout', '!buff.any', 'lowest23'},
	{ 'Battle Shout', '!buff.any', 'lowest24'},
	{ 'Battle Shout', '!buff.any', 'lowest25'},
}

local cooldowns = {
	{ 'Blood Fury'}, 
	{ 'Recklessness'},
}

local survival = {
	{ 'Victory Rush', 'player.health <= UI(vr)', 'target'}, 
	{ 'Enraged Regeneration', 'player.health <= UI(er)'}, 
}

local rotation = {
	{ 'Whirlwind', 'player.area(8).enemies >= 2 & !player.buff(Whirlwind) & toggle(aoe)'},
	{ 'Rampage', 'player.buff(Siegebreaker) || player.rage >= 85 & !talent(5,1) & player.enrage = 0 || player.rage >= 75 & talent(5,1) & player.enrage = 0 || player.enrage > 0 & player.rage >= 95'},
	{ cooldowns, 'toggle(cooldowns) & target.bosscheck >= 1'}, 
	{ 'Siegebreaker', 'player.rage >= 65 & { player.buff(Recklessness) || player.spell(Recklessness).cooldown > 30 & bosscheck >= 1 || bosscheck = 0}', 'target'}, 
	{ 'Execute', 'player.buff(Enrage)'},
	{ 'Bloodthirst', '!player.buff(Enrage)'},
	{ 'Raging Blow', 'player.spell.charges >= 2'},
	{ 'Bloodthirst'}, 
	{ 'Dragon Roar', 'player.buff(Enrage)'}, 
	{ 'Bladestorm', 'player.buff(Enrage)'}, 
	{ 'Raging Blow'}, 
	{ 'Whirlwind'},
}

local inCombat = {
	{ keybinds},
	{ '/startattack', '!isattacking & target.exists'},
	{ interrupts, 'target.interruptAt(75)'},
	{ utility}, 
	{ survival}, 
	{ 'Heroic Throw', 'range > 8', 'target'}, 
	{ rotation},
}

local outCombat = {
	{ keybinds},	
	{ utility}, 
}

NeP.CR:Add(72, {
	name = '[Silver] Warrior - Fury',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.0.1',
 nep_ver = '1.11',
})
