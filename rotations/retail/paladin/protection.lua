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

local dispel = {
	{ 'Cleanse Toxins', 'poisonDispel', { 'lowest', 'friendly'}},
	{ 'Cleanse Toxins', 'diseaseDispel', { 'lowest', 'friendly'}},
}

local priorityTarget = {
	{ 'Avenger\'s Shield', 'priorityTarget & inRange.spell & area(10).enemies 12>= 2', 'enemies'},
	{ 'Judgment', 'priorityTarget & inRange.spell & { talent(2,2) & player.spell.charges >= 2} || priorityTarget & inRange.spell & !talent(2,2)', 'enemies' },
	{ 'Consecration', 'priorityTarget & inRange.spell(Hammer of the Righteous) & !player.buff', 'enemies'},
	{ 'Judgment', 'priorityTarget & inRange.spell', 'enemies'},
	{ 'Avenger\'s Shield', 'priorityTarget & inRange.spell', 'enemies'},
	{ 'Hammer of the Righteous', 'priorityTarget & inRange.spell', 'enemies'},
	{ 'Consecration', 'priorityTarget & inRange.spell(Hammer of the Righteous)', 'enemies'},
}

local utility = {
	-- Use charge of SotR for events that need AM up
	{ 'Shield of the Righteous', 'inRange.spell(Hammer of the Righteous) & tankEvent & player.buff.duration < 2', 'enemies'},
	{ 'Arcane Torrent', 'inRange.spell(Hammer of the Righteous) & purgeEvent', 'enemies'},
	{ 'Hammer of Justice', 'stunEvent', 'enemies'},
	{ 'Blessing of Protection', 'bopEvent & !debuff(Forbearance).any', 'friendly'},
}

local interrupts = {
	{ 'Rebuke', 'inRange.spell & interruptAt(35)', 'enemies'},
	{ 'Avenger\'s Shield', '{ player.spell(Rebuke).cooldown > gcd & inRange.spell(Rebuke) || !inRange.spell(Rebuke) } & interruptAt(35) && infront', 'enemies'},
	{ 'Hammer of Justice', '{ player.spell(Rebuke).cooldown > gcd & inRange.spell(Rebuke) || !inRange.spell(Rebuke) } & interruptAt(35)', 'enemies'},
}

local cooldowns = {
	-- Shield of the Righteous
	{ 'Shield of the Righteous', 'inRange.spell(Hammer of the Righteous) & player.spell(Shield of the Righteous).charges >= 2.7 & !player.buff & !talent(7,3)', 'target'},
	{ 'Shield of the Righteous', 'inRange.spell(Hammer of the Righteous) & player.spell(Shield of the Righteous).charges >= 2.7 & !player.buff & talent(7,3) & player.spell(Seraphim).cooldown > 0', 'target'},
	-- Use 2nd charge
	{ 'Shield of the Righteous', 'inRange.spell(Hammer of the Righteous) & !player.buff & player.incdmg(5) >= { player.health.max * 0.25 } & player.spell.charges >= 2 & target.range <= 8 & target.threat == 100'},

	-- Light of the Protector
	{ 'Light of the Protector', 'health <= UI(lotp)', { 'player', 'tank', 'tank2', 'lowest'}},

	{ 'Bastion of Light', 'player.spell(Shield of the Righteous).charges < 1'},

	-- All health based. Uncheck in UI to use only manually
	{ 'Ardent Defender', 'UI(ad_check) & player.health <= UI(ad_spin) & !target.debuff(Eye of Tyr) & !player.buff(Guardian of Ancient Kings)'},
	{ 'Guardian of Ancient Kings', 'UI(ak_check) & player.health <= UI(ak_spin) & !target.debuff(Eye of Tyr) & !player.buff(Ardent Defender)'},

	{ 'Seraphim', 'inRange.spell(Hammer of the Righteous) & player.spell(Shield of the Righteous).charges > 2', 'target'},

	{ 'Avenging Wrath', 'inRange.spell(Hammer of the Righteous) & player.buff(Consecration) & !talent(7,3) & target.range <= 10'},
	{ 'Avenging Wrath', 'inRange.spell(Hammer of the Righteous) & player.buff(Consecration) & talent(7,3) & player.buff(Seraphim) & target.range <= 10'},

	-- Add UI toggle for LoH
	{ 'Lay on Hands', 'health < 15', { 'player', 'tank', 'tank2', 'lowest'}},
}

local rotation = {
	{ 'Avenger\'s Shield', 'inRange.spell & area(10).enemies 12 >= 2 && infront(player)', 'target'},
	{ 'Judgment', 'inRange.spell && talent(2,2) && player.spell.charges >= 2 && infront(player) || inRange.spell && !talent(2,2) && infront', 'target' },
	{ 'Consecration', 'inRange.spell(Hammer of the Righteous) && !player.buff', 'target'},
	{ 'Consecration', 'inRange.spell(Hammer of the Righteous) && player.totem.duration <= 2 && player.buff', 'target'},
	{ 'Judgment', 'inRange.spell && infront(player)', 'target'},
	{ 'Avenger\'s Shield', 'inRange.spell && infront(player)', 'target'},
	{ 'Hammer of the Righteous', 'inRange.spell && infront(player)', 'target'},
	{ 'Consecration', 'inRange.spell(Hammer of the Righteous)', 'target'},
}

local inCombat = {
	{ '/startattack', '!isattacking & target.exists'},
	{ interrupts},
	{ utility},
	{ dispel},
	{ cooldowns, 'toggle(cooldowns) & target.range <= 5'},
	{ priorityTarget},
	{ rotation}
}

local outCombat = {

}

NeP.CR:Add(66, {
	name = '[Silver !BETA!] Paladin - Protection',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.1.5',
 nep_ver = '1.12',
})
