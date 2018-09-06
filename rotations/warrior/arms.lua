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
	{type = 'ruler'},{type = 'spacer'},

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- |rSilver Warrior |cffADFF2FProtection |r')
	print('|cffADFF2F --- |rMost Talents Supported')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local legionEvents = {

}

local interrupts = {
	{ 'Pummel'},
}

local cooldowns = {

}

local executeRotation = {
	{ 'Skullsplitter', 'player.rage < 60', 'target'},
	{ 'Colossus Smash'},
	{ 'Bladestorm', 'player.rage < 30', 'target'},
	{ 'Mortal Strike', '{ talent(7,2) & player.buff(Overpower).count >= 2 } ||  !talent(7,2) & player.buff(Executioner\'s Precision).count >= 2', 'target'}, 
	{ 'Overpower'},
	{ 'Execute'},
}

local rotation = {
	{ 'Skullsplitter', 'player.rage < 60', 'target'},
	{ 'Rend', 'debuff.duration <= 4 & !debuff(Colossus Smash)', 'target'},
	{ 'Colossus Smash'},
	{ 'Execute', 'player.buff(Sudden Death)', 'target'},
	{ 'Mortal Strike'},
	{ 'Bladestorm', 'debuff(Colossus Smash)', 'target'},
	{ 'Overpower'},
	{ 'Whirlwind', 'player.rage >= 60 & talent(3,2)', 'target'}, 
	{ 'Slam', 'player.rage >= 50 & !talent(3,2)', 'target'},
}

local inCombat = {
	{ '/startattack', '!isattacking & target.exists'},
	{ interrupts, 'target.interruptAt(75)'},
	{ cooldowns, 'toggle(cooldowns)'}, 
	{ executeRotation, 'inmelee & { target.health <= 20 & !talent(3,1) || target.health <= 35 & talent(3,1)}'}, 
	{ rotation, 'target.health > 20 & !talent(3,1) || target.health > 35 & talent(3,1)'},
	{ 'Heroic Throw', 'range > 8 & infront', 'target'}, 
}

local outCombat = {

}

NeP.CR:Add(71, {
	name = '[Silver] Warrior - Arms',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})