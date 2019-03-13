local GUI = {
	-- Sotr
	{type = 'header', text = 'Shield of the Righteous', align = 'center'},
	{type = 'spinner', text = 'Use 2nd Charge', key = 'sotr', default_spin = 75},
	{type = 'ruler'},{type = 'spacer'},
	
	-- Light of the Protector
	{type = 'header', text = 'Light of the Protector', align = 'center'},
	{type = 'spinner', text = 'Light of the Protector', key = 'lotp', default_spin = 65},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'checkspin', text = 'Use Ardent Defender', key = 'ad', default_check = true, default_spin = 25},
	{type = 'checkspin', text = 'Use Eye of Tyr', key = 'eye', default_check = true, default_spin = 60},
	{type = 'checkspin', text = 'Use Guardian of Ancient Kings', key = 'ak', default_check = true, default_spin = 35},
	{type = 'ruler'},{type = 'spacer'},} 

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- |rSilver Paladin |cffADFF2FProtection |r')
	print('|cffADFF2F --- |rMost Talents Supported')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local interrupts = {

}

local activeMitigation = {
}

local cooldowns = {

}

local rotation = {	
	{ 'Keg Smash'}, 
	{ 'Blackout Strike'}, 
	{ 'Breath of Fire'},
	{ 'Tiger Palm', 'player.energy >= 65', 'target'},
	{ 'Chi Wave'},
	
}

local inCombat = {
	{ '/startattack', '!isattacking & target.exists'},
	{ target},
	{ interrupts, 'target.interruptAt(50)'},
	{ activeMitigation},
	{ cooldowns, 'toggle(cooldowns) & target.range <= 10'},
	{ rotation, 'target.infront'}
}

local outCombat = {

}

NeP.CR:Add(268, {
	name = '[Silver] Monk - Brewmaster',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
 wow_ver = '8.1',
 nep_ver = '1.11',
	load = exeOnLoad
})
