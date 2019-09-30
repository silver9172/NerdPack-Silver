local GUI = {
	-- General
	{type = 'header', 		text = 'General', align = 'center'},

	{type = 'ruler'},{type = 'spacer'},
	
	-- Survival
	{type = 'header', 		text = 'Survival', align = 'center'},

	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', 		text = 'Cooldowns when toggled on', align = 'center'},
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

}

local standard = {
	{ 'Remorseless Winter'}, 
	{ 'Frost Strike', 'player.spell(Remorseless Winter).cooldown <= 2 * gcd & talent(6,1)', 'target'}, 
	{ 'Howling Blast', 'player.buff(Rime)', 'target'}, 
	{ 'Obliterate', '!player.buff(Frozen Pulse) & talent(4,2)', 'target'}, 
	{ 'Frost Strike', 'deficit < { 15 + talent(2,1) * 3}', 'target'},
		
}

local preCombat = {

}

local inCombat = {
	{ '/startattack', '!isattacking & target.enemy'},
	
	
	
	
	{ standard}, 
}

local outCombat = {
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(251, {
	name = '[Silver] Death Knight - Frost',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})