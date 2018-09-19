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
	{ 'Consume Magic'},
	{ 'Arcane Torrent', 'target.range <= 8 & spell(Consume Magic).cooldown > gcd & !prev_gcd(Consume Magic)'},
}

local cooldowns = {

}
	
local simCraft = {

}

local utility = {

}

local preCombat = {

}

local survival = {
	{ 'Soul Barrier', 'talent(7,3) & player.health <= 70'},
	{ 'Fel Devastation', 'talent(6,1) & player.health <= 60 & !player.moving'},
	{ '#trinket1', 'player.health <= 65'},
	{ '#trinket2', 'player.health <= 60'},
 	{ '#5512', 'item(5512).count >= 1 & player.health <= 60', 'player'}, --Health Stone
	{ 'Metamorphosis', 'player.health <= 40'},
}	

local legionEvents = {
	
}

local rotation = {
	{ legionEvents},
	{ 'Fiery Brand', '!player.buff(Demon Spikes) & !player.buff(Metamorphosis)'},
	{ 'Demon Spikes', '!player.buff(Demon Spikes) & player.spell.recharge <= 2'},
	{ '!Empower Wards', 'target.casting.percent > 70'},
	{ 'Empower Wards', 'player.incdmg.magic(5) >= player.health.max*0.70'}, 
	{ 'Spirit Bomb', '!target.debuff(Frailty) & player.buff(Soul Fragments).count >= 1'},
	{ 'Soul Carver', 'target.debuff(Fiery Brand)'},
	{ 'Immolation Aura', 'player.pain <= 80'},
	{ 'Sigil of Flame', 'target.debuff.duration <= 2.5', 'target'},
	{ 'Infernal Strike', 'target.debuff(Sigil of Flame).duration <= 2.5 & player.spell(Sigil of Flame).cooldown >= 4 & player.spell(Sigil of Flame).cooldown <= 25 & !player.lastcast', 'player.ground'}, 
	{ 'Felblade', 'talent(3,1) & player.pain <= 70'},
	{ 'Soul Cleave', 'player.buff(Soul Fragments).count == 5 || player.incdmg(5) >= player.health.max*0.70 || player.pain >= 80'},
	{ 'Shear', 'player.buff(Blade Turning)'},
	{ 'Fracture', 'talent(4,2) & player.pain >= 60'},
	{ 'Shear'}
}

local inCombat = {
	{ '/startattack', '!isattacking & target.range < 10 & target.enemy & target.alive'},
	{ interrupts, 'target.interruptAt(50)'},
	{ 'Throw Glaive', '!inmelee', 'target'},
	{ rotation, 'target.inmelee'},
}

local outCombat = {
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(581, {
	name = '[Silver] Demon Hunter - Havoc',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})