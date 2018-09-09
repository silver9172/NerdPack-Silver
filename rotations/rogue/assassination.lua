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
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- Supported Talents')
	print('|cffADFF2F --- 1,1 / 2,1 / 3,3 / any / any / 6,1 or 6,2 / 7,1')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {

}

local interrupts = {
	{ 'Kick'},
	{ 'Arcane Torrent', 'target.range <= 8 & spell(Kick).cooldown > gcd & !prev_gcd(Kick)'},
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
	{ 'Blood Fury'},
	{ 'Beserking'}, 
}

local aoeRotation = {
	{ 'Rupture', 'player.combopoints >= 4 & debuff.duration <= 6 & range <= 8 & infront', 'target'},
	{ 'Rupture', 'player.combopoints >= 4 & debuff.duration <= 6 & count.enemies.debuffs <= 3 & range <= 8 & infront', 'enemies'},
	-- Vendetta
	{ 'Vendetta', 'toggle(cooldowns) & target.bosscheck >= 1 & debuff(Rupture)', 'target'}, 
	{ cooldowns, 'target.debuff(Vendetta)'}, 
	-- Garrote
	{ 'Garrote', 'debuff.duration <= 5.4 & range <= 8 & infront', 'target'},
	{ 'Garrote', 'debuff.duration <= 5.4 & count.enemies.debuffs <= 3 & range <= 8 & infront', 'enemies'},
	{ 'Crimson Tempest', '{ player.combopoints >= 4 & !talent(3,2) || player.combopoints >= 5 & talent(3,2)}', 'target'},
	{ 'Envenom', 'range <= 8 &  & infront & { player.combopoints >= 4 & !talent(3,2) || player.combopoints >= 5 & talent(3,2)}', 'target'},
	{ 'Poisoned Knife', 'player.buff(Sharpened Blades).count > 29 & infront', 'target'},
	{ 'Fan of Knives'}, 
}

local rotation = {
	{ 'Rupture', 'player.combopoints >= 4 & debuff.duration <= 6', 'target'},
	-- Vendetta
	{ 'Vendetta', 'toggle(cooldowns) & target.bosscheck >= 1 & debuff(Rupture)', 'target'}, 
	{ cooldowns, 'target.debuff(Vendetta)'}, 
	-- Vanish
	{ 'Garrote', 'debuff.duration <= 5.4', 'target'},
	{ 'Toxic Blade'},
	{ 'Exsanguinate', 'debuff(Rupture).duration >= 20 & debuff(Garrote) >= 9', 'target'}, 
	{ 'Envenom', '{ player.combopoints >= 4 & !talent(3,2) || player.combopoints >= 5 & talent(3,2)}', 'target'},
	{ 'Poisoned Knife', 'player.buff(Sharpened Blades).count > 29', 'target'},
	{ 'Fan of Knives', 'player.buff(Hidden Blades).count > 19', 'target'}, 
	{ 'Blindside'},
	{ 'Mutilate', 'player.deficit <= 45', 'target'}, 
}

local utility = {
	{ 'Tricks of the Trade', '!focus.buff & !focus.enemy', 'focus'},
	{ 'Tricks of the Trade', '!tank.buff', 'tank'},
}

local preCombat = {

}

local inCombat = {
	{ '/startattack', '!isattacking & target.enemy'},
	{ utility},
	{ keybinds},
	{ interrupts, 'target.interruptAt(35)'},
	{ survival},
	{ aoeRotation, 'player.area(10).enemies >= 2'}, 
	{ rotation, 'target.enemy'},
}

local outCombat = {
	-- Poisons --
	{ 'Deadly Poison', 'player.buff.duration <= 600 & !player.lastcast & !moving'},
	{ 'Crippling Poison', 'player.buff.duration <= 600 & !player.lastcast & !moving'},
	-------------

	{ 'Stealth', '!player.buff & !player.buff(Vanish)'},
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