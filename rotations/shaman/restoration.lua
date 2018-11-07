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
	print('|cffADFF2F --- ')
	print('|cffADFF2F --- ')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {

}

local interrupts = {

}

local utility = {

}

local cooldowns = {
}

local survival = {

}

local rotation = {

}

local inCombat = {
	{ keybinds},
	{ interrupts, 'target.interruptAt(75)'},
	{ utility}, 
	{ survival}, 
	{ rotation},
}

local outCombat = {
	{ keybinds},	
	{ utility}, 
}

NeP.CR:Add(264, {
	name = '[Silver] Shaman - Restoration',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.0.1',
 nep_ver = '1.11',
})
