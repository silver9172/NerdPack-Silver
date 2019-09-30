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
	-- LOWEST
	--------------------------------
	{type = 'header', 	text = 'Lowest', align = 'center'},
	{type = 'spinner', 	text = 'Rejuv', 								key = 'lrejuv', default = 90},
	{type = 'spinner', 	text = 'Germ', 									key = 'lgerm', 	default = 75},
	{type = 'spinner', 	text = 'Swiftmend', 							key = 'lsm', 	default = 90},
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

local blanket = {
	"tank1", "tank2", "lowest", "lowest2", "lowest3", "lowest4", "lowest5", "lowest6", "lowest7", "lowest8", "lowest9", "lowest10", "friendly"
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

local catDamage = {
	{ 'Rip', 'inRange.spell && infront(player) && debuff.duration <= 7.2 && combopoints.deficit = 0', {'target', 'enemies'}},
	{ 'Ferocious Bite', 'inRange.spell && infront(player) && combopoints.deficit = 0', 'target'},
	{ 'Rake', 'inRange.spell && infront(player) && debuff.duration <= 4.5 && combopoints.deficit >= 1', {'target', 'enemies'}},
	{ 'Swipe', 'inRange.spell(Shred) && infront(player) && combopoints.deficit >= 1', 'target'},
	{ 'Shred', 'inRange.spell && infront(player) && combopoints.deficit >= 1', {'target', 'enemies'}},
}

local dps = {
	{ 'Sunfire', 'debuff.duration <= 3.6 && player.mana >= 30 && inRange.spell && combat', 'enemies'},
	{ 'Moonfire', 'debuff.duration <= 4.8 && player.mana >= 30 && inRange.spell && combat', 'enemies'},
	--{ 'Moonfire', 'inRange.spell && infront(player) && debuff.duration <= 4.8', 'target'},
	--{ 'Sunfire', 'inRange.spell && infront(player) && debuff.duration <= 3.6', {'target', 'enemies'}},

	{ 'Cat Form', '!buff && talent(3,2) && target.range <= 4.5', 'player'},
	{ catDamage, 'player.buff(Cat Form)'},

	{ 'Solar Wrath', 'inRange.spell && infront(player) && !player.moving && { !talent(3,2) || !inRange.spell(Shred) }', 'target'},
}

local cooldowns = {
	{ 'Innervate', 'mana <= 65 && !spell(Wild Growth).cooldown', 'player'},
	{ 'Ironbark', 'health <= UI(ib)', { 'tank', 'tank2'}},
	{ 'Barkskin', 'health <= 60', 'player'},
}

local emergency = {
	{ 'Swiftmend', nil, 'loweset'},
	{ 'Regrowth', nil, 'lowest'},
}

local rejuvSpam = {
	-- Apply Rejuv to players with debuffs
	{ 'Rejuvenation', 'magicDispel && !buff.any', blanket},
	{ 'Rejuvenation', 'poisonDispel && !buff.any', blanket},
	{ 'Rejuvenation', 'curseDispel && !buff.any', blanket},
	{ 'Rejuvenation', 'diseaseDispel && !buff.any', blanket},
	{ 'Rejuvenation', 'tankEvent && !buff.any', blanket},
	{ 'Rejuvenation', 'magicDispel && !buff', blanket},
	{ 'Rejuvenation', 'poisonDispel && !buff', blanket},
	{ 'Rejuvenation', 'curseDispel && !buff', blanket},
	{ 'Rejuvenation', 'diseaseDispel && !buff', blanket},
	{ 'Rejuvenation', 'tankEvent && !buff', blanket},

	-- Normal Spam
	{ 'Rejuvenation', 'health <= UI(lrejuv) && !buff.any', blanket},
	{ 'Rejuvenation', 'health <= UI(lrejuv) && !buff', blanket},

	-- Germination
	{ 'Rejuvenation', 'talent(7,2) && buff(Rejuvenation) && health <= UI(lgerm) && !buff(Rejuvenation (Germination)).any', blanket},
	{ 'Rejuvenation', 'talent(7,2) && buff(Rejuvenation) && health <= UI(lgerm) && !buff(Rejuvenation (Germination))', blanket},
}

local rejuvSpamLowMana = {
	{ 'Rejuvenation', 'health <= UI(lrejuv) && !buff.any', blanket},
	{ 'Rejuvenation', 'health <= UI(lrejuv) && !buff', blanket},

	{ 'Rejuvenation', 'talent(7,2) && buff(Rejuvenation) && health <= UI(lgerm) && !buff(Rejuvenation (Germination)).any', blanket},
	{ 'Rejuvenation', 'talent(7,2) && buff(Rejuvenation) && health <= UI(lgerm) && !buff(Rejuvenation (Germination))', blanket},
}

local innervate = {
	{ 'Wild Growth', 'toggle(AOE) && !player.moving', 'lowest'},
	{ 'Flourish', 'talent(7,3) && player.lastcast(Wild Growth)', 'player'},

	{ 'Rejuvenation', '!buff.any', blanket},
	{ 'Rejuvenation', '!buff',  blanket},

	{ 'Rejuvenation', 'talent(7,2) && buff(Rejuvenation) && health <= 85 && !buff(Rejuvenation (Germination))',  blanket},

	{ 'Regrowth', 'health <= UI(lrg) && !player.moving', 'lowest'},
	{ 'Regrowth', '!player.moving', 'lnbuff(Regrowth)'},
}

local lifebloom = {
	-- Solo
	{ 'Lifebloom', 'buff.duration <= 4.5 && { partycheck = 1 || { partycheck = 2 && !tank1.exists } || { partycheck = 3 && !tank1.exists }}', 'player'},
	-- 5 man
	{ 'Lifebloom', 'buff.duration <= 4.5 && partycheck = 2', 'tank'},
	-- Raid
	-- Only one tank
	{ 'Lifebloom', 'buff.duration <= 4.5 && partycheck = 3 && !tank2.exists', 'tank'},
	-- If one tank is 20% lower than the other, swap LB
	{ 'Lifebloom', 'partycheck = 3 && { !tank1.buff && { tank1.health < { tank2.health * 0.8 }}}', 'tank1'},
	{ 'Lifebloom', 'partycheck = 3 && { !tank2.buff && { tank2.health < { tank1.health * 0.8 }}}', 'tank2'},
	-- If neither tank has life bloom, apply it to the one with lower health
	{ 'Lifebloom', 'partycheck = 3 && {{ !tank1.buff && !tank2.buff && { tank1.health <= tank2.health }}}', 'tank1'},
	{ 'Lifebloom', 'partycheck = 3 && {{ !tank1.buff && !tank2.buff && { tank2.health < tank1.health }}}', 'tank2'},
	-- If either tank is at 4.5 seconds or lower, reapply LB on the tank with the lower health
	{ 'Lifebloom', 'partycheck = 3 && tank1.buff.duration <= 4.5 && !tank2.buff && tank1.health <= tank2.health', 'tank1'},
	{ 'Lifebloom', 'partycheck = 3 && tank2.buff.duration <= 4.5 && !tank1.buff && tank2.health < tank1.health', 'tank2'},
}

local moving = {
	{ lifebloom},
	{ 'Cenarion Ward', '{ tank1.health <= tank2.health } || !tank2.exists}', 'tank1'},
	{ 'Cenarion Ward', '{ tank2.health < tank1.health }', 'tank2'},

	-- Rejuv
	{ rejuvSpam},

	{ 'Swiftmend', 'health <= UI(tsm)', { 'tank1', 'tank2', 'lowest', 'friendly'}},
}

local healing = {
	{ lifebloom },

	{ innervate, 'player.buff(Innervate).any'},
	-- AOE
	{ 'Wild Growth', 'area(40,85).heal >= 3 && toggle(AOE)', { 'tank1', 'tank2', 'lowest', 'friendly'}},
	{ 'Flourish', 'talent(7,3) && player.lastcast(Wild Growth)', 'player'},

	{ 'Regrowth', 'health <= UI(lrg) && player.buff(Clearcasting).duration >= player.spell(Regrowth).casttime', 'lnbuff(Regrowth)'},

	{ 'Cenarion Ward', '{ tank1.health <= tank2.health } || !tank2.exists', 'tank1'},
	{ 'Cenarion Ward', '{ tank2.health < tank1.health }', 'tank2'},

	{ rejuvSpam},

	{ 'Swiftmend', 'health <= UI(tsm)', { 'tank1', 'tank2', 'lowest', 'friendly'}},

	{ 'Regrowth', 'health <= UI(lrg)', { 'tank1', 'tank2', 'lowest', 'friendly'}},
}

local efflorescence = {
	-- Place on viable target when about to expire, prefer melee target
	{ 'Efflorescence', 'friendly.area(8,95).heal > 1 && totem(Efflorescence).duration <= 3', 'friendly.ground'},

	-- Place on a melee if it isnt up at all
	-- { 'Efflorescence', 'totem(Efflorescence).duration <= 3 && melee', 'target.ground'},
	-- { 'Efflorescence', 'totem(Efflorescence).duration <= 3 && melee', 'friendly.ground'},
	-- { 'Efflorescence', 'totem(Efflorescence).duration <= 3', 'tank.ground'},

	-- Testing
	--{ 'Efflorescence', 'totem(Efflorescence).duration <= 3', 'friendly.ground'},
}

local inCombat = {
	--{ '/cancelaura Cat Form', 'buff(Cat Form)', 'player'},
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
