local GUI = {
	-- Light of the Protector
	{type = 'header', text = 'Light of the Protector', align = 'center'},
	{type = 'spinner', text = 'Light of the Protector', key = 'lotp', default_spin = 65},
	{type = 'ruler'},{type = 'spacer'},

	--Cooldowns
	{type = 'header', text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'header', text = 'Incoming Dmg & Over 5 Secs', align = 'center'},
	{type = 'spinner', text = 'SOTR 2nd Charge', key = 'sotr', default_spin = 15},
	{type = 'spinner', text = 'SOTR 3rd Charge', key = 'sotr3', default_spin = 25},
	{type = 'checkspin', text = 'Use Ardent Defender', key = 'ad', default_check = true, default_spin = 25},
	{type = 'checkspin', text = 'Use Guardian of Ancient Kings', key = 'ak', default_check = true, default_spin = 35},
	{type = 'ruler'},{type = 'spacer'},}

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- |rSilver Paladin |cffADFF2FProtection |r')
	print('|cffADFF2F --- |rMost Talents Supported')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local dispel = {
	{ 'Cleanse Toxins', 'poisonDispel', { 'lowest', 'friendly'}},
	{ 'Cleanse Toxins', 'diseaseDispel', { 'lowest', 'friendly'}},
}

local utility = {
	-- Use charge of SotR for events that need AM up
	{ 'Shield of the Righteous', 'inRange.spell(Rebuke) && infront && tankEvent && player.buff.duration < 2', 'combatenemies'},
	{ 'Arcane Torrent', 'inRange.spell(Rebuke) && purgeEvent', 'combatenemies'},
	{ 'Hammer of Justice', 'inRange.spell && stunEvent', 'combatenemies'},
	{ 'Blessing of Protection', 'bopEvent && !debuff(Forbearance).any', 'friendly'},
}

local interrupts = {
	{ 'Rebuke', 'inRange.spell && interruptAt(35) && infront', 'combatenemies'},
	{ 'Avenger\'s Shield', '{ player.spell(Rebuke).cooldown > gcd && inRange.spell(Rebuke) && interruptAt(65) || !inRange.spell(Rebuke) } && interruptAt(65) && infront}', 'combatenemies'},
	{ 'Hammer of Justice', '{ player.spell(Rebuke).cooldown > gcd && inRange.spell(Rebuke) && interruptAt(65) || !inRange.spell(Rebuke) } && interruptAt(65)}', 'combatenemies'},
	{ 'Blinding Light', 'player.spell(Rebuke).cooldown > gcd && range <= 10 && interruptAt(65)', 'combatenemies'},
}

local cooldowns = {
	-- Shield of the Righteous
	{ 'Shield of the Righteous', 'inRange.spell(Rebuke) && player.spell(Shield of the Righteous).charges >= 2.7 && !player.buff && !talent(7,3)', 'target'},
	{ 'Shield of the Righteous', 'inRange.spell(Rebuke) && player.spell(Shield of the Righteous).charges >= 2.7 && !player.buff && talent(7,3) && player.spell(Seraphim).cooldown > 0', 'target'},
	-- Use 2nd charge
	{ 'Shield of the Righteous', 'inRange.spell(Rebuke) && !player.buff && { player.incdmg(5) >= { player.health.actual * { UI(sotr) * 0.01}}} && player.spell.charges >= 2', 'target'},
	-- Use 3rd Charge (When we'll have SoTR back up by the time that the buff ends)
	{ 'Shield of the Righteous', 'inRange.spell(Rebuke) && !player.buff && { player.incdmg(5) >= { player.health.actual * { UI(sotr3) * 0.01}}} && player.spell.charges >= 1 && player.spell.recharge <= 4', 'target'},

	-- Light of the Protector
	{ 'Light of the Protector', 'health <= UI(lotp)', { 'player', 'tank', 'tank2', 'lowest'}},

	{ 'Bastion of Light', 'player.spell(Shield of the Righteous).charges < 1'},

	{ 'Ardent Defender', '!player.buff(Guardian of Ancient Kings) && { player.incdmg(5) >= { player.health.actual * { UI(ad_spin) * 0.01}}}'},
	{ 'Guardian of Ancient Kings', '!player.buff(Ardent Defender) && { player.incdmg(5) >= { player.health.actual * { UI(ak_spin) * 0.01}}}'},

	{ 'Seraphim', 'inRange.spell(Rebuke) && player.spell(Shield of the Righteous).charges > 2', 'target'},

	{ 'Avenging Wrath', 'inRange.spell(Rebuke) && player.buff(Consecration) && !talent(7,3) && bosscheck == 1', 'target'},
	{ 'Avenging Wrath', 'inRange.spell(Rebuke) && player.buff(Consecration) && talent(7,3) && player.buff(Seraphim) && bosscheck == 1', 'target'},

	-- Add UI toggle for LoH
	{ 'Lay on Hands', 'health < 15', { 'player', 'tank', 'tank2', 'lowest'}},
}

local essences = {
	-- Concentrated Flame
	{ 'Concentrated Flame', 'inRange.spell && infront', 'target'},
}

local items = {
	-- Razbubk's Big Red Button
	{ '#159611', 'equipped(159611) && item(159611).usable && inRange.spell(Rebuke) && infront', 'target.ground'},
}

local rotation = {
	-- Shield of the Righteous
	{ 'Shield of the Righteous', 'inRange.spell(Rebuke) && player.spell(Shield of the Righteous).charges >= 2.7 && !player.buff && !talent(7,3)', 'target'},
	{ 'Shield of the Righteous', 'inRange.spell(Rebuke) && player.spell(Shield of the Righteous).charges >= 2.7 && !player.buff && talent(7,3) && player.spell(Seraphim).cooldown > 0', 'target'},

	{ items},
	{ essences},
	{ 'Avenger\'s Shield', 'inRange.spell && infront && area(8).combatenemies >= 2', { 'target', 'combatenemies'}},
	{ 'Consecration', 'inRange.spell(Rebuke) && player.buff < gcd', { 'target', 'combatenemies'}},
	{ 'Judgment', 'inRange.spell && infront && player.spell(Shield of the Righteous).recharge > 4', { 'target', 'combatenemies'}},
	{ 'Avenger\'s Shield', 'inRange.spell && infront', 'target'},
	{ 'Hammer of the Righteous', 'inRange.spell(Rebuke) && infront', { 'target', 'combatenemies'}},
	{ 'Consecration', 'inRange.spell(Rebuke)', { 'target', 'combatenemies'}},
}

local preCombat = {
	{ 'Avenging Wrath', 'dbm(Pull in) < 1', 'player'},
}

local inCombat = {
	{ '/startattack', '!isattacking && target.exists'},
	{ interrupts},
	{ utility},
	{ dispel},
	{ cooldowns, 'toggle(cooldowns) && inRange.spell(Rebuke)'},
	{ rotation},
}

local outCombat = {

}

NeP.CR:Add(66, {
	name = '[Silver !BETA!!!] Paladin - Protection',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.1.5',
 nep_ver = '1.14  ',
})
