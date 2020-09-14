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

local finish = {

}

local rotation = {

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
