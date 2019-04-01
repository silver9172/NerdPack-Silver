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
	{type = 'spinner', 	text = 'Healing Touch', 						key = 'tht',	default = 90},
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
	{ 'Efflorescence', 'keybind(control) && !player.lastcast', 'cursor.ground'},
	{ 'Ursol\'s Vortex', 'keybind(shift) && !player.lastcast', 'cursor.ground'},
}

local potions = {
	{ '#127834', 'UI(P_HP_check) && player.health <= UI(P_HP_spin)'}, -- Health Pot
	{ '#5512', 'UI(P_HP_check) && player.health <= UI(P_HP_spin)'}, -- Healthstone
	{ '#127835', 'UI(P_MP_check) && player.mana <= UI(P_MP_spin)'}, -- Mana Pot
}

local dispel = {
	{ 'Nature\'s Cure', 'magicDispel', 'friendly'},
	{ 'Nature\'s Cure', 'poisonDispel', 'friendly'},
	{ 'Nature\'s Cure', 'curseDispel', 'friendly'},
}

local dps = {
	{ 'Sunfire', '!los && debuff.duration <= 3.6 && player.mana >= 30 && inRange.spell && combat', 'enemies'},
	{ 'Moonfire', '!los && debuff.duration <= 4.8 && player.mana >= 30 && inRange.spell && combat', 'enemies'},
	{ 'Solar Wrath', '!los && !player.moving && inRange.spell', 'target'},
}

local cooldowns = {
	{ 'Innervate', 'mana <= 65 && !spell(Wild Growth).cooldown', 'player'},
	{ 'Ironbark', '!los && health <= UI(ib)', { 'tank', 'tank2'}},
	{ 'Barkskin', 'health <= 60', 'player'},
}

local emergency = {
	{ 'Swiftmend', '!los', 'loweset'},
	{ 'Regrowth', '!los', 'lowest'},
}

local rejuvSpam = {
	-- Apply Rejuv to players with debuffs
	{ 'Rejuvenation', '!los && magicDispel && !buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && magicDispel && !buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && poisonDispel && !buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && poisonDispel && !buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && curseDispel && !buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && curseDispel && !buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && diseaseDispel && !buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && diseaseDispel && !buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && tankEvent && !buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && tankEvent && !buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},

	-- Normal Spam
	{ 'Rejuvenation', '!los && health <= UI(lrejuv) && !buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && health <= UI(lrejuv) && !buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},

	-- Germination
	{ 'Rejuvenation', '!los && talent(6,2) && buff(Rejuvenation) && health <= UI(lgerm) && !buff(Rejuvenation (Germination))', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10'}},
}

local rejuvSpamLowMana = {
	{ 'Rejuvenation', '!los && health <= UI(trejuv) && !buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && health <= UI(trejuv) && !buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},

	{ 'Rejuvenation', '!los && talent(6,2) && buff(Rejuvenation) && health <= UI(lgerm) && !buff(Rejuvenation (Germination))', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
}

local innervate = {
	{ 'Wild Growth', '!los && toggle(AOE) && !player.moving', 'lowest'},
	{ 'Flourish', 'talent(7,3) && player.lastcast(Wild Growth)', 'player'},

	{ 'Rejuvenation', '!los && !buff.any', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},
	{ 'Rejuvenation', '!los && !buff', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},

	{ 'Rejuvenation', '!los && talent(6,3) && buff(Rejuvenation) && health <= 85 && !buff(Rejuvenation (Germination))', { 'tank1', 'tank2', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'lowest5', 'lowest6', 'lowest7', 'lowest8', 'lowest9', 'lowest10', 'friendly'}},

	{ 'Regrowth', '!los && health <= UI(lrg) && !player.moving', 'lowest'},
	{ 'Regrowth', '!los && !player.moving', 'lnbuff(Regrowth)'},
}

local lifebloom = {
	-- Solo
	{ 'Lifebloom', '!los && buff.duration <= 4.5 && { partycheck = 1 || { partycheck = 2 && !tank1.exists } || { partycheck = 3 && !tank1.exists }}', 'player'},
	-- 5 man
	{ 'Lifebloom', '!los && buff.duration <= 4.5 && partycheck = 2', 'tank'},
	-- Raid
	-- Only one tank
	{ 'Lifebloom', '!los && buff.duration <= 4.5 && partycheck = 3 && !tank2.exists', 'tank'},
	-- If one tank is 20% lower than the other, swap LB
	{ 'Lifebloom', '!los && partycheck = 3 && { !tank1.buff && { tank1.health < { tank2.health * 0.8 }}}', 'tank1'},
	{ 'Lifebloom', '!los && partycheck = 3 && { !tank2.buff && { tank2.health < { tank1.health * 0.8 }}}', 'tank2'},
	-- If neither tank has life bloom, apply it to the one with lower health
	{ 'Lifebloom', '!los && partycheck = 3 && {{ !tank1.buff && !tank2.buff && { tank1.health <= tank2.health }}}', 'tank1'},
	{ 'Lifebloom', '!los && partycheck = 3 && {{ !tank1.buff && !tank2.buff && { tank2.health < tank1.health }}}', 'tank2'},
	-- If either tank is at 4.5 seconds or lower, reapply LB on the tank with the lower health
	{ 'Lifebloom', '!los && partycheck = 3 && tank1.buff.duration <= 4.5 && !tank2.buff && tank1.health <= tank2.health', 'tank1'},
	{ 'Lifebloom', '!los && partycheck = 3 && tank2.buff.duration <= 4.5 && !tank1.buff && tank2.health < tank1.health', 'tank2'},
}

local moving = {
	{ lifebloom},
	{ 'Cenarion Ward', '!los && { tank1.health <= tank2.health } || !los && !tank2.exists}', 'tank1'},
	{ 'Cenarion Ward', '!los && { tank2.health < tank1.health }', 'tank2'},

	-- Rejuv
	{ rejuvSpam},

	{ 'Swiftmend', '!los && health <= UI(tsm)', { 'tank1', 'tank2', 'lowest', 'friendly'}},
}

local healing = {
	{ lifebloom },

	{ innervate, 'player.buff(Innervate).any'},
	-- AOE
	{ 'Wild Growth', '!los && area(40,85).heal >= 3 && toggle(AOE)', { 'tank1', 'tank2', 'lowest', 'friendly'}},
	{ 'Flourish', 'talent(7,3) && player.lastcast(Wild Growth)', 'player'},

	{ 'Regrowth', '!los && health <= UI(lrg) && player.buff(Clearcasting).duration >= player.spell(Regrowth).casttime', 'lnbuff(Regrowth)'},

	{ 'Cenarion Ward', '!los && { tank1.health <= tank2.health } || !los && !tank2.exists', 'tank1'},
	{ 'Cenarion Ward', '!los && { tank2.health < tank1.health }', 'tank2'},

	{ rejuvSpam},

	{ 'Swiftmend', '!los && health <= UI(tsm)', { 'tank1', 'tank2', 'lowest', 'friendly'}},

	{ 'Regrowth', '!los && health <= UI(lrg)', { 'tank1', 'tank2', 'lowest', 'friendly'}},
}

local efflorescence = {
	-- Place on a tank if it isnt up at all
	{ 'Efflorescence', '!totem(Efflorescence)', { 'tank.ground', 'tank2.ground',}},
	-- Place on viable target when about to expire
	{ 'Efflorescence', 'area(8,99).heal > 1 && totem(Efflorescence).duration <= 3', { 'target.ground', 'tank.ground', 'tank2.ground', 'friendly.ground'}},
}

local inCombat = {
	{ '/cancelaura Cat Form', 'buff(Cat Form)', 'player'},
	{ keybinds, 'keybind(shift) || keybind(control) || keybind(alt)'},
	{ encounters},
	{ dispel, 'toggle(disp)'},
	{ cooldowns},
	{ efflorescence},
	{ moving, 'player.moving'},
	{ healing, '!player.moving'},
	{ dps, 'target.enemy && target.health > 0 && toggle(dps)'},
}

local outCombat = {
	{ keybinds, 'keybind(shift) || keybind(control) || keybind(alt)'},
	{ lifebloom, '!buff(Cat Form) && dbm(Pull in) < 4'},
	{ rejuvSpam, '!buff(Cat Form)'},
	{ efflorescence},
}

NeP.CR:Add(105, {
  	 name = '[Silver] Druid - Restoration',
  		 ic = inCombat,
  		ooc = outCombat,
  		gui = GUI,
  	 load = exeOnLoad,
	wow_ver = '8.1.5',
	nep_ver = '1.12',
})
