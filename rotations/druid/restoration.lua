-- Contact Silver9172 on the Nerdpack Discord with any issues
-- Updated to patch 7.2.5, needs raid testing and feedback

local GUI = {  
	--------------------------------
	-- Generic
	--------------------------------
	{type = 'header', 	text = 'Generic', align = 'center'},
	{type = 'spinner', 	text = 'Critical health%', 						key = 'ch', 	default = 30},
	{type = 'spinner', 	text = 'Mana Restore', 							key = 'P_MR', 	default = 20},
	
	--------------------------------
	-- Toggles
	--------------------------------
	{type = 'header', 	text = 'Toggles', align = 'center'},
	{type = 'checkbox',	text = 'Encounter Support',						key = 'ENC', 	default = true},
	{type = 'checkspin',text = 'Healing Potion/Healthstone',			key = 'P_HP', 	default = true},
	{type = 'checkspin',text = 'Mana Potion',							key = 'P_MP', 	default = true},
	{type = 'ruler'}, {type = 'spacer'},

	--------------------------------
	-- TANK
	--------------------------------
	{type = 'header', 	text = 'Tank', align = 'center'},											
	{type = 'spinner', 	text = 'Rejuv', 								key = 'trejuv', default = 100},
	{type = 'spinner', 	text = 'Germ', 									key = 'tgerm', 	default = 90},
	{type = 'spinner', 	text = 'Swiftmend', 							key = 'tsm', 	default = 90},
	{type = 'spinner', 	text = 'Healing touch)', 						key = 'tht',	default = 90},
	{type = 'spinner', 	text = 'Regrowth', 								key = 'trg', 	default = 60},
	{type = 'spinner', 	text = 'Ironbark', 								key = 'ib', 	default = 25},
	{type = 'ruler'}, {type = 'spacer'},
	
	--------------------------------
	-- LOWEST
	--------------------------------
	{type = 'header', 	text = 'Lowest', align = 'center'},
	{type = 'spinner', 	text = 'Rejuv', 								key = 'lrejuv', default = 90},
	{type = 'spinner', 	text = 'Germ', 									key = 'lgerm', 	default = 75},
	{type = 'spinner', 	text = 'Swiftmend', 							key = 'lsm', 	default = 90},
	{type = 'spinner', 	text = 'Healing touch)', 						key = 'lht',	default = 90},
	{type = 'spinner', 	text = 'Regrowth', 								key = 'lrg', 	default = 60},
}

local exeOnLoad = function()
	print('|cffFACC2E [Silver] Druid - Restoration loaded|r')
	print('|cffFACC2E Contact Silver9172 on the Nerdpack Discord with any issues |r')
	print('|cffFACC2E Updated to patch 7.2.5, needs raid testing and feedback |r')
	print('|cffFACC2E Have a nice day!|r')
	NeP.Interface:AddToggle({
		key  = 'dps',
		name = 'DPS',
		text = 'DPS while healing',
		icon = 'Interface\\Icons\\spell_holy_crusaderstrike',
	})
	NeP.Interface:AddToggle({
		key  = 'disp',
		name = 'Dispell',
		text = 'ON/OFF Dispel All',
		icon = 'Interface\\ICONS\\spell_holy_purify', 
	})
end

local keybinds = {
	{ '%pause', 'keybind(alt)'},
	{ 'Efflorescence', 'keybind(control) & !player.lastcast', 'cursor.ground'},
	{ 'Ursol\'s Vortex', 'keybind(shift) & !player.lastcast', 'cursor.ground'},
}

local potions = {
	{ '#127834', 'UI(P_HP_check) & player.health <= UI(P_HP_spin)'}, -- Health Pot
	{ '#5512', 'UI(P_HP_check) & player.health <= UI(P_HP_spin)'}, -- Healthstone
	{ '#127835', 'UI(P_MP_check) & player.mana <= UI(P_MP_spin)'}, -- Mana Pot
}

local dps = {
	{ 'Moonfire', '!debuff & player.mana >= 30 & inRange.spell & combat', 'enemies'},
	{ 'Sunfire', '!debuff & player.mana >= 30 & inRange.spell & combat', 'enemies'},
	{ 'Solar Wrath', '!player.moving & inRange.spell', 'target'},
}

local cooldowns = {
	{ 'Innervate', 'player.mana <= 65 & !player.spell(Wild Growth).cooldown'},
	{ 'Ironbark', 'health <= UI(ib)', { 'tank', 'tank2'}},
	{ 'Barkskin', 'health <= 60', 'player'},
	
	-- Kara Healing Trinket
	{ '#trinket1', 'xequipped(142158) & player.area(15,75).heal >= 3'},
}

local emergency = {
	{ 'Swiftmend', nil, 'loweset'},
	{ 'Regrowth', nil, 'lowest'},
}

local rejuvSpam = {
	{ 'Rejuvenation', 'health <= UI(trejuv) & !buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', 'health <= UI(trejuv) & !buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	
	{ 'Rejuvenation', 'talent(6,3) & buff(Rejuvenation) & health <= UI(lgerm) & !buff(Rejuvenation (Germination))', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10'}},
}

local rejuvSpamLowMana = {
	{ 'Rejuvenation', 'health <= UI(trejuv) & !buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', 'health <= UI(trejuv) & !buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	
	{ 'Rejuvenation', 'talent(6,3) & buff(Rejuvenation) & health <= UI(lgerm) & !buff(Rejuvenation (Germination))', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
}

local innervate = {
	{ 'Wild Growth', 'toggle(AOE) & !player.moving', 'lowest'},
	{ 'Essence of G\'Hanir', 'player.area(40,85).heal >= 3 & lastcast(Wild Growth)', 'player'}, 
	{ 'Flourish', 'talent(7,3) & player.lastcast(Wild Growth)', 'player'}, 

	{ 'Rejuvenation', '!buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	
	{ 'Rejuvenation', 'talent(6,3) & buff(Rejuvenation) & health <= 85 & !buff(Rejuvenation (Germination))', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	
	{ 'Regrowth', 'health <= UI(lrg) & !player.moving', 'lowest'},
	{ 'Regrowth', '!player.moving', 'lnbuff(Regrowth)'},
}

local lifebloom = {
	-- Solo
	{ 'Lifebloom', 'player.buff.duration <= 4.5 & { partycheck = 1 || { partycheck = 2 & !tank1.exists } || { partycheck = 3 & !tank1.exists }}', 'player'},
	-- 5 man
	{ 'Lifebloom', 'tank.buff.duration <= 4.5 & partycheck = 2', 'tank'},
	-- Raid
	-- Only one tank
	{ 'Lifebloom', 'tank.buff.duration <= 4.5 & partycheck = 3 & !tank2.exists', 'tank'},
	-- If one tank is 20% lower than the other, swap LB
	{ 'Lifebloom', 'partycheck = 3 & { !tank1.buff & { tank1.health < { tank2.health * 0.8 }}}', 'tank1'},
	{ 'Lifebloom', 'partycheck = 3 & { !tank2.buff & { tank2.health < { tank1.health * 0.8 }}}', 'tank2'},
	-- If neither tank has life bloom, apply it to the one with lower health
	{ 'Lifebloom', 'partycheck = 3 & {{ !tank1.buff & !tank2.buff & { tank1.health <= tank2.health }}}', 'tank1'},
	{ 'Lifebloom', 'partycheck = 3 & {{ !tank1.buff & !tank2.buff & { tank2.health < tank1.health }}}', 'tank2'},
	-- If either tank is at 4.5 seconds or lower, reapply LB on the tank with the lower health
	{ 'Lifebloom', 'partycheck = 3 & tank1.buff.duration <= 4.5 & !tank2.buff & tank1.health <= tank2.health', 'tank1'},
	{ 'Lifebloom', 'partycheck = 3 & tank2.buff.duration <= 4.5 & !tank1.buff & tank2.health < tank1.health', 'tank2'},
}

local moving = {
	{ lifebloom},
	{ 'Cenarion Ward', '{ tank1.health <= tank2.health } || !tank2.exists}', 'tank1'},
	{ 'Cenarion Ward', '{ tank2.health < tank1.health }', 'tank2'},
	
	-- Rejuv
	{ rejuvSpamLowMana, 'player.mana < UI(P_MR)'},
	{ rejuvSpam, 'player.mana >= UI(P_MR)'},
	
	{ 'Swiftmend', 'health <= UI(tsm)', { 'tank1', 'tank2', 'lowest', 'friendly'}},
}

local healing = {
	{ lifebloom }, 
	
	{ 'Cenarion Ward', '{ tank1.health <= tank2.health } || !tank2.exists}', 'tank1'},
	{ 'Cenarion Ward', '{ tank2.health < tank1.health }', 'tank2'},
	
	{ innervate, 'player.buff(Innervate).any'},
	
	-- AOE
	{ 'Wild Growth', 'area(40,85).heal >= 3 & toggle(AOE)', { 'tank1', 'tank2', 'lowest', 'friendly'}},
	{ 'Flourish', 'talent(7,3) & player.lastcast(Wild Growth)', 'player'},
	
	{ emergency, 'lowest.health <= UI(ch)'}, 
	
	{ 'Regrowth', 'health <= UI(lrg) & player.buff(Clearcasting).duration >= player.spell(Regrowth).casttime', 'lowest'},
	{ 'Regrowth', 'player.buff(Clearcasting).duration >= player.spell(Regrowth).casttime', 'lnbuff(Regrowth)'},
	
	-- Rejuv
	{ rejuvSpamLowMana, 'player.mana < UI(P_MR)'},
	{ rejuvSpam, 'player.mana >= UI(P_MR)'},
	
	{ 'Swiftmend', 'health <= UI(tsm)', { 'tank1', 'tank2', 'lowest', 'friendly'}},
	
	{ 'Flourish', 'talent(7,3) & lowest6.buff(Rejuvenation) & lowest6.health <= 50', 'player'},
	
	{ 'Regrowth', 'health <= UI(trg)', { 'tank1', 'tank2', 'lowest', 'friendly'}},
}

local efflorescence = {
	{ 'Efflorescence', 'area(8,99).heal > 1 & totem(Efflorescence).duration <= 3', 'friendly.ground'}, 
}

local inCombat = {
	{ '/cancelaura Cat Form', 'buff(Cat Form)', 'player'},
	--{ 'Rejuvenation', nil, 'lnbuff(Rejuvenation)'},
	{ keybinds, 'keybind(shift) || keybind(control) || keybind(alt)'},
	{ encounters},
	--{ '%dispelall', 'toggle(disp) & spell(Nature\'s Cure).cooldown = 0'},
	{ cooldowns},
	{ efflorescence}, 
	{ moving, 'player.moving'},
	{ healing, '!player.moving'},
	{ dps, 'target.enemy & target.health > 0 & toggle(dps)'},
}

local outCombat = {
	{ keybinds, 'keybind(shift) || keybind(control) || keybind(alt)'},
	{ lifebloom, '!buff(Cat Form)'}, 
	{ rejuvSpam, '!buff(Cat Form)'},
	{ efflorescence}, 
	--{ encounters}, -- Testing
	--{ 'Rejuvenation', nil, 'lnbuff(Rejuvenation)'},
	--{ 'Regrowth', nil, 'lnbuff(Regrowth)'},
}

NeP.CR:Add(105, {
  name = '[Silver] Druid - Restoration',
  ic = inCombat,
  ooc = outCombat,
  gui = GUI,
  load = exeOnLoad
})
