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
	{ 'Rupture', 'combopoints.deficit <= 1 & debuff.duration <= 6', 'target'},
	{ 'Rupture', 'combopoints.deficit <= 1 & debuff.duration <= 6 & count.enemies.debuffs < 3 & range <= 8 & infront & enemy & toggle(cleave)', 'enemies'},
	{ 'Envenom', 'combopoints.deficit <= 1 & { player.area(8).enemies >= 2 || target.debuff(Vendetta) || target.debuff(Toxic Blade) || player.deficit < 40}', 'target'}, 
	{ 'Fan of Knives', 'toggle(aoe) & { player.buff(Hidden Blades).count >= 19 || player.area(10).enemies > 2}', 'target'}, 
	{ 'Blindside', 'combopoints.deficit < 1 || player.deficit < 40', 'target'}, 
	{ 'Mutilate', 'combopoints.deficit >= 2 || player.deficit < 40', 'target'}, 
} 

local aoeRotation = {
	{ 'Rupture', 'player.combopoints >= 4 & debuff.duration <= 6 & range <= 8 & infront', 'target'},
	{ 'Rupture', 'player.combopoints >= 4 & debuff.duration <= 6 & count.enemies.debuffs <= 3 & range <= 8 & infront & enemy', 'enemies'},
	-- Vendetta
	{ cooldowns}, 
	-- Garrote
	{ 'Garrote', 'debuff.duration <= 5.4 & range <= 8 & infront', 'target'},
	{ 'Garrote', 'debuff.duration <= 5.4 & count.enemies.debuffs <= 3 & range <= 8 & infront & enemy', 'enemies'},
	{ 'Crimson Tempest', '{ player.combopoints >= 4 & !talent(3,2) || player.combopoints >= 5 & talent(3,2)}', 'target'},
	{ 'Envenom', 'range <= 8 &  & infront & { player.combopoints >= 4 & !talent(3,2) || player.combopoints >= 5 & talent(3,2)}', 'target'},
	{ 'Poisoned Knife', 'player.buff(Sharpened Blades).count > 29 & infront', 'target'},
	{ 'Fan of Knives'}, 
}

local rotation = {
	{ 'Rupture', 'player.combopoints >= 4 & debuff.duration <= 6', 'target'},
	{ 'Rupture', 'player.combopoints >= 4 & debuff.duration <= 6 & count.enemies.debuffs <= 3 & range <= 8 & infront & enemy & toggle(cleave)', 'enemies'},
	{ cooldowns}, 
	-- Vanish
	{ 'Garrote', 'debuff.duration <= 5.4', 'target'},
	{ 'Garrote', 'debuff.duration <= 5.4 & count.enemies.debuffs <= 3 & range <= 8 & infront & enemy & toggle(cleave)', 'enemies'},
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
	{ wowhead}, 
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