local GUI = {
	-- Survival
	{type = 'header', text = 'Toggles', align = 'center'},
	{type = 'checkbox', text = 'DPS', 					key = 'dps', 		default = true},
	{type = 'checkbox', text = 'Ghost Wolf', 			key = 'gw', 		default = true},
	{type = 'checkbox', text = 'Earth Elemental', 		key = 'ee', 		default = true},
	{type = 'ruler'},{type = 'spacer'},

	--Cooldowns
	{type = 'header', text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'checkbox', text = 'Healing Tide Totem',	key = 'htt', 		default = true},
	{type = 'ruler'},{type = 'spacer'},

	-- Healing
	{type = 'header', text = 'Healing', align = 'center'},
	{type = 'checkbox', text = 'Healing Rain', 			key = 'hr', 		default 	 = true},
	{type = 'spinner',  text = 'Emergency', 			key = 'eh', 		default_spin = 30},
	{type = 'spinner',  text = 'Riptide', 				key = 'rt', 		default_spin = 90},
	{type = 'spinner',  text = 'Healing Stream Totem', 	key = 'hst', 		default_spin = 95},
	{type = 'spinner',  text = 'Healing Wave', 			key = 'hw', 		default_spin = 80},
	{type = 'spinner',  text = 'Healing Surge', 		key = 'hs', 		default_spin = 50},
	{type = 'ruler'},{type = 'spacer'},}

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- ')
	print('|cffADFF2F --- ')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {
	{ 'Healing Rain', 'keybind(lcontrol)', 'mouseover.ground'},
	{ 'Spirit Link Totem', 'keybind(lalt)', 'mouseover.ground'}
}

local interrupts = {
	{ 'Wind Shear', 'interruptAt(35) && inRange.spell && infront && combat', { 'target', 'enemies'}},
}

local dispel = {
	{ 'Cleanse', 'magicDispel', { 'lowest', 'friendly'}},
	{ 'Cleanse', 'curseDispel', { 'lowest', 'friendly'}},
}

local utility = {
	-- Totems
	{ 'Earth Elemental', 'area(30,45).heal >= 4 && partycheck = 2 && UI(ee)', 'player'},

	-- Cap Totem
}

local cooldowns = {
	-- Healing Tide Totem
	{ 'Healing Tide Totem', 'UI(htt) && { area(40,35).heal >= 3 && partycheck = 2 || area(40,35).heal >= 6 && partycheck = 3}', 'player'},

	-- Spirit Link Totem
}

local earthShield = {
	-- Solo
	{ 'Earth Shield', 'player.buff.duration <= 4.5 && { partycheck = 1 || { partycheck = 2 && !tank1.exists } || { partycheck = 3 && !tank1.exists }}', 'player'},
	-- 5 man
	{ 'Earth Shield', 'tank.buff.duration <= 4.5 && partycheck = 2', 'tank'},
	-- Raid
	-- Only one tank
	{ 'Earth Shield', 'tank.buff.duration <= 4.5 & partycheck = 3 & !tank2.exists', 'tank'},
	-- If one tank is 20% lower than the other, swap ES
	{ 'Earth Shield', 'partycheck = 3 && { !tank1.buff && { tank1.health < { tank2.health * 0.8 }}}', 'tank1'},
	{ 'Earth Shield', 'partycheck = 3 && { !tank2.buff && { tank2.health < { tank1.health * 0.8 }}}', 'tank2'},
	-- If neither tank has ES, apply it to the one with lower health
	{ 'Earth Shield', 'partycheck = 3 && {{ !tank1.buff && !tank2.buff && { tank1.health <= tank2.health }}}', 'tank1'},
	{ 'Earth Shield', 'partycheck = 3 && {{ !tank1.buff && !tank2.buff && { tank2.health < tank1.health }}}', 'tank2'},
	-- If either tank is at 4.5 seconds or lower, reapply ES on the tank with the lower health
	{ 'Earth Shield', 'partycheck = 3 && tank1.buff.duration <= 4.5 && !tank2.buff && tank1.health <= tank2.health', 'tank1'},
	{ 'Earth Shield', 'partycheck = 3 && tank2.buff.duration <= 4.5 && !tank1.buff && tank2.health < tank1.health', 'tank2'},
}

local healing = {
	-- Emergency
	{ 'Healing Surge', 'health <= UI(eh) && !player.moving', { 'tank', 'lowest', 'friendly'}},

	-- Cooldowns
	{ earthShield, 'talent(2,3)'},
	{ 'Riptide', 'health <= UI(rt) && !buff', { 'tank', 'lowest', 'friendly'}},
	{ 'Healing Rain', 'target.area(10,90).heal >= 2 && !player.moving && UI(hr)', 'target.ground'},
	{ 'Healing Rain', 'tank.area(10,90).heal >= 2 && !player.moving && UI(hr)', 'tank.ground'},
	{ 'Healing Rain', 'lowest.area(10,90).heal >= 2 && !player.moving && UI(hr)', 'lowest.ground'},
	{ 'Healing Rain', 'friendly.area(10,90).heal >= 2 && !player.moving && UI(hr)', 'friendly.ground'},
	{ 'Unleash Life', ' health <= UI(hw)', { 'tank', 'lowest', 'friendly'}},
	{ 'Wellspring', 'area(12,85).heal.infront >= 3', 'player'},
	{ 'Cloudburst Totem', 'health <= UI(hst) && inRange.spell(Riptide) && !totem', { 'tank', 'lowest', 'friendly'}},
	{ 'Healing Stream Totem', 'health <= UI(hst) && inRange.spell(Riptide) && !totem', { 'tank', 'lowest', 'friendly'}},
	{ 'Earthen Wall Totem', 'area(12,65).heal > 3', 'player'},

	-- Standard
	{ 'Chain Heal', 'area(12,85).heal >= 2 && !player.moving', { 'tank', 'lowest', 'friendly'}},
	{ 'Healing Surge', 'health <= UI(hs) && !player.moving', { 'tank', 'lowest', 'friendly'}},
	{ 'Healing Wave', 'health <= UI(hw) && !player.moving', { 'tank', 'lowest', 'friendly'}},
}

local survival = {

}

local dps = {
	--{ '#trinket2', 'xequipped(128318) && inRange.spell(Flame Shock) && infront && combat', { 'target', 'enemies'}},
	{ 'Flame Shock', 'debuff.duration <= 6.3 && inRange.spell && infront(player) && combat', { 'target', 'enemies'}},
	{ 'Lava Burst', '{ player.buff(Lava Surge) || !player.moving} && debuff(Flame Shock).duration >= 2 && inRange.spell && infront(player)', { 'target', 'enemies'}},
	{ 'Chain Lightning', 'area(12).enemies >= 2 && inRange.spell && infront(player) && combat && toggle(aoe) && !player.moving', 'target'},
	{ 'Lightning Bolt', 'inRange.spell && infront(player) && combat && !player.moving', 'target'},
}

local inCombat = {
	{ keybinds},
	{ interrupts},
	{ utility},
	{ survival},
	{ healing},
	{ dps, 'UI(dps) && player.mana > 40'},
	{ 'Ghost Wolf', 'movingfor > 2 && !buff && UI(gw)', 'player'},
}

local outCombat = {
	{ keybinds},
	{ utility},
	{ dps, 'UI(dps) && player.mana > 40'},
	{ healing},
}

NeP.CR:Add(264, {
	name = '[Silver !BETA!] Shaman - Restoration',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.1.5',
 nep_ver = '1.12',
})
