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
	
local events = {
	----------------
	---- 5 Mans ----
	----------------
	-- Tank Dummy
	{ 'Shield of the Righteous', 'player.buff.duration <= 2.5 & casting(Uber Strike) & !player.lastcast', 'target'},
}


local interrupts = {
	{ 'Rebuke'},
	{ 'Hammer of Justice', 'spell(Rebuke).cooldown > gcd'},
}

local activeMitigation = {
	-- Shield of the Righteous
	{ 'Shield of the Righteous', 'player.spell(Shield of the Righteous).charges = 3 & !player.buff & range <= 8 & threat == 100 & !talent(7,2)', 'target'},
	{ 'Shield of the Righteous', 'player.spell(Shield of the Righteous).charges = 3 & !player.buff & target.range <= 8 & target.threat == 100 & talent(7,2) & !player.spell(Seraphim).cooldown = 0'},
	-- Use 2nd charge
	{ 'Shield of the Righteous', '!player.buff & player.incdmg(5) >= { player.health.max * 0.25 } & player.spell.charges >= 2 & target.range <= 8 & target.threat == 100'},
	
	-- Light of the Protector
	{ 'Light of the Protector', 'health <= UI(lotp)', 'player'},
	{ 'Light of the Protector', 'health <= UI(lotp)', 'tank'},
	{ 'Light of the Protector', 'health <= UI(lotp)', 'tank2'},
	{ 'Light of the Protector', 'health <= UI(lotp)', 'lowest'},
}

local cooldowns = {
	{ events},
	
	{ 'Bastion of Light', 'player.spell(Shield of the Righteous).charges < 1'},
	
	-- All health based. Uncheck in UI to use only manually
	{ 'Ardent Defender', 'UI(ad_check) & player.health <= UI(ad_spin) & !target.debuff(Eye of Tyr) & !player.buff(Guardian of Ancient Kings)'},
	{ 'Guardian of Ancient Kings', 'UI(ak_check) & player.health <= UI(ak_spin) & !target.debuff(Eye of Tyr) & !player.buff(Ardent Defender)'},

	{ 'Seraphim', 'player.spell(Shield of the Righteous).charges > 2'},
	
	{ 'Avenging Wrath', '!talent(7,2) & target.range <= 10'},
	{ 'Avenging Wrath', 'talent(7,2) & player.buff(Seraphim) & target.range <= 10'},

	-- Add UI toggle for LoH
	{ 'Lay on Hands', 'player.health < 15'},
	--{ 'Lay on Hands', 'lowest.health < 15'},
}

local rotation = {
	{ 'Judgment'},
	{ 'Consecration', 'player.area(8).enemies > 0 & !buff', 'target'}, 
	{ 'Avenger\'s Shield'}, 
	{ 'Hammer of the Righteous'},
	{ 'Consecration', 'player.area(8).enemies > 0', 'target'},
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
	{ '#Potion of Prolonged Power', '!player.buff & pull_timer <= 2'},
}

NeP.CR:Add(66, {
	name = '[Silver] Paladin - Protection',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
