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
	print('|cffADFF2F --- WIP')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {

}

local interrupts = {
	{ 'Disrupt'},
}

local survival = {

}

local cooldowns = {

}

local rotation = {
	-- Nemesis
	-- meta
	{ 'Immolation Aura'}, 
	{ 'Blade dance'}, 
	{ 'Felblade', 'player.fury >= 80', 'target'}, 
	{ 'Eye Beam'}, 
	{ 'Chaos Strike'}, 
	{ 'Demon\'s Bite'}, 
}

local utility = {

}

local preCombat = {

}

local inCombat = {
	{ '/startattack', '!isattacking & target.enemy'},
	{ utility},
	{ keybinds},
	{ utility},
	{ keybinds},
	{ interrupts, 'target.interruptAt(35)'},
	{ survival},
	{ rotation, 'target.enemy'},
}

local outCombat = {
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(577, {
	name = '[Silver] Demon Hunter - Havoc',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})