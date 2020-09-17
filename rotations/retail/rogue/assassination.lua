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
	print('|cffADFF2F --- ')
	print('|cffADFF2F --- ')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {

}

local interrupts = {
	{ 'Kick', 'inRange.spell(Rupture) && infront', 'combatenemies'},
}

local tricks = {
	{ 'Tricks of the Trade', 'inRange.spell && !buff & !enemy', 'focus'},
	{ 'Tricks of the Trade', 'inRange.spell && !buff', 'tank'},
}

local survival = {
	{ 'Crimson Vial', 'player.health <= UI(cv) & player.energy >= 35'},
}

local cooldowns = {

	{ 'Vendetta', 'inRange.spell(Rupture) && infront && bosscheck == 1 && !player.stealthed', 'target'},
	{ 'Toxic Blade', 'inRange.spell(Rupture) && infront && player.combopoints < 5', 'target'},
}

local stealth = {
	{ 'Garrote', 'inRange.spell(Rupture) && infront && debuff.duration < 15', { 'target', 'combatenemies'}},
}

local rotation = {
	{ '/startattack', '!isattacking & target.enemy && !player.stealthed'},
	{ interrupts, 'interruptAt(35)'},
	{ cooldowns},
	{ 'Garrote', 'inRange.spell(Rupture) && infront && debuff.duration <= gcd && player.combopoints.deficit >= 1', { 'target', 'combatenemies'}},

	{ 'Rupture', 'inRange.spell(Rupture) && infront && player.combopoints >= 4 && debuff.duration <= 6', { 'target', 'combatenemies'}},

	{ 'Envenom', 'inRange.spell(Rupture) && infront && player.combopoints >= 4 && { energypercent >= 0.8 || debuff(Toxic Blade) || debuff(Vendetta) }', { 'target', 'combatenemies'}},
	{ 'Fan of Knives', 'player.area(15).enemies >= 4 && toggle(aoe) && player.combopoints.deficit >= 1', 'target'},
	{ 'Fan of Knives', 'player.area(15).enemies >= 3 && !debuff(Deadly Poison) && toggle(aoe) && player.combopoints.deficit >= 1', { 'target', 'combatenemies'}},
	{ 'Mutilate', 'inRange.spell(Rupture) && infront && player.area(8).enemies == 2 && !debuff(Deadly Poison) && toggle(aoe) && player.combopoints.deficit > 1', { 'target', 'combatenemies'}},
	{ 'Mutilate', 'inRange.spell(Rupture) && infront && player.combopoints.deficit > 1', 'target'},
}

local preCombat = {
	-- Poisons --
	{ 'Deadly Poison', 'buff.duration <= 600 && timeout(Poison,2) && !moving', 'player'},
	{ 'Crippling Poison', 'buff.duration <= 600 && timeout(Poison,2) && !moving', 'player'},

	{ tricks, 'dbm(Pull In) <= 4'}
}

local inCombat = {
	{ utility},
	{ tricks},
	{ survival},
	{ stealth, 'player.stealthed'},
	{ rotation},
	{ 'Poisoned Knife', 'inRange.spell && infront && energy.time_to_max <= gcd && !player.stealthed', 'target'},
}

local outCombat = {
	{ '%pause','PauseFor10 == 1'},
	{ 'Stealth', '!buff && !buff(Vanish) && timeout(stealth, 10) && UI(stealth)', 'player'},
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(259, {
	  name = '[Silver] Rogue - Assassination',
	    ic = inCombat,
	   ooc = outCombat,
	 	 gui = GUI,
		load = exeOnLoad,
 wow_ver = '8.1.5',
 nep_ver = '1.12',
})
