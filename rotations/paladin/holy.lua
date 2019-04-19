local GUI = {
	{type = 'header', 	text = 'Generic', align = 'center'},
	{type = 'spinner', 	text = 'DPS while lowest health%', 				key = 'G_DPS', 	default = 70},
	{type = 'spinner', 	text = 'Critical health%', 						key = 'G_CHP', 	default = 30},
	{type = 'spinner', 	text = 'Mana Restore', 							key = 'P_MR', 	default = 20},
	{type = 'checkbox',	text = 'Offensive Holy Shock',					key = 'O_HS', 	default = false},
	{type = 'checkbox',	text = 'Auto Dispel',							key = 'G_Disp', default = true},
	{type = 'checkbox',	text = 'Top Up Out of Combat',					key = 'G_OOC',  default = true},
	{type = 'ruler'}, {type = 'spacer'},

	--------------------------------
	-- Toggles
	--------------------------------
	{type = 'header', 	text = 'Toggles', align = 'center'},
	{type = 'checkbox',	text = 'Avenging Wrath',						key = 'AW', 	default = false},
	{type = 'checkbox',	text = 'Aura Mastery',							key = 'AM', 	default = false},
	{type = 'checkbox',	text = 'Holy Avenger',							key = 'HA', 	default = false},
	{type = 'checkbox',	text = 'Lay on Hands',							key = 'LoH', 	default = false},
	--{type = 'checkbox',	text = 'Encounter Support',						key = 'ENC', 	default = true},
	{type = 'checkspin',text = 'Healing Potion/Healthstone',			key = 'P_HP', 	default = false},
	{type = 'checkspin',text = 'Mana Potion',							key = 'P_MP', 	default = false},
	{type = 'spinner',	text = 'Health for LotM',						key = 'P_LotM', default = 40},
	{type = 'ruler'}, {type = 'spacer'},

	--------------------------------
	-- TANK
	--------------------------------
	{type = 'header', 	text = 'Tank', align = 'center'},
	{type = 'spinner', 	text = 'Blessing of Sacrifice (Health %)', 		key = 'T_BoS', 	default = 30},
	{type = 'spinner', 	text = 'Light of the Martyr (Health %)', 		key = 'T_LotM', default = 35},
	{type = 'spinner', 	text = 'Holy Shock (Health %)', 				key = 'T_HS', 	default = 90},
	{type = 'spinner', 	text = 'Flash of Light (Health %)', 			key = 'T_FoL', 	default = 75},
	{type = 'spinner', 	text = 'Holy Light (Health %)', 				key = 'T_HL', 	default = 90},
	{type = 'ruler'}, {type = 'spacer'},

	--------------------------------
	-- LOWEST
	--------------------------------
	{type = 'header', 	text = 'Lowest', align = 'center'},
	{type = 'spinner', 	text = 'Lay on Hands (Health %)', 				key = 'L_LoH', 	default = 10},
	{type = 'spinner', 	text = 'Holy Shock (Health %)', 				key = 'L_HS', 	default = 90},
	{type = 'spinner', 	text = 'Light of the Martyr (Health %)', 		key = 'L_LotM', default = 40},
	{type = 'spinner', 	text = 'Light of the Martyr moving (Health %)', key = 'L_LotMm',default = 65},
	{type = 'spinner', 	text = 'Flash of Light (Health %)', 			key = 'L_FoL', 	default = 70},
	{type = 'spinner', 	text = 'Holy Light (Health %)', 				key = 'L_HL', 	default = 90},
}

local exeOnLoad = function()
	NeP.Interface:AddToggle({
		key = 'dps',
		name = 'DPS',
		text = 'DPS while healing',
		icon = 'Interface\\Icons\\spell_holy_crusaderstrike',
	})
end

local dispel = {
	{ 'Cleanse', 'magicDispel', { 'lowest', 'friendly'}},
	{ 'Cleanse', 'poisonDispel', { 'lowest', 'friendly'}},
	{ 'Cleanse', 'diseaseDispel', { 'lowest', 'friendly'}},
}

local survival = {
	--{ '#127834', 'UI(P_HP_check) && player.health <= UI(P_HP_spin)'}, -- Health Pot
	--{ '#Healthstone', 'UI(P_HP_check) && player.health <= UI(P_HP_spin)'},
	--{ '#127835', 'UI(P_MP_check) && player.pmana <= UI(P_MP_spin)'}, -- Mana Pot
	{ 'Divine Protection', 'buff(Blessing of Sacrifice) || incdmg(5) >= { health.max * 0.40 }', 'player'},
}

local topUp = {
	{ 'Holy Shock', nil, 'mouseover'},
	{ 'Flash of Light', nil, 'mouseover'},
}

local oocTopUp = {
	{ 'Light of Dawn', 'area(15,90).heal.infront >= 3 && player.buff(Rule of Law)', 'player'},
	{ 'Light of Dawn', 'area(15,90).heal.infront >= 3', 'player'},
	{ 'Holy Shock', 'health < 90', { 'lowest', 'friendly'}},
	{ 'Holy Light', 'health < 90 && !player.moving', { 'lowest', 'friendly'}},
}

local DPS = {
	{ '/startattack', '!isattacking'},
	{ 'Consecration', 'player.area(8).enemies >= 1 && !player.moving', { 'target', 'enemies'}},
	{ 'Holy Shock', '{UI(O_HS) || player.buff(Avenging Crusader) || partycheck = 1} && infront(player) && inRange.spell && combat', { 'target', 'enemies'}},
	{ 'Holy Prism', 'infront(player) && inRange.spell && combat', { 'target', 'enemies'}},
	{ 'Judgment', 'infront(player) && inRange.spell && combat', { 'target', 'enemies'}},
	{ 'Crusader Strike', 'infront(player) && inRange.spell && combat', { 'target', 'enemies'}},
}

local cooldowns = {
	-- Need to rewrite for Raid and 5 Man
	{ 'Lay on Hands', 'UI(LoH) && health <= UI(L_LoH) && !debuff(Forbearance).any', { 'tank', 'lowest', 'friendly'}},

	-----------
	-- 5 man --
	-----------
	{{
		{ 'Aura Mastery', 'UI(AM) && area(40,40).heal >= 3', 'player'},
		{ 'Avenging Wrath', 'UI(AW) && area(35,65).heal >= 3 && spell(Holy Shock).cooldown = 0 && !talent(6,2)', 'player'},
		{ 'Avenging Crusader', 'UI(AW) && area(35,65).heal >= 3 && player.spell(Holy Shock).cooldown = 0 && inRange.spell(Crusader Strike) && talent(6,2) && talent(6,2)', 'target'},
		{ 'Holy Avenger', 'UI(HA) && area(40,75).heal >= 3 && spell(Holy Shock).cooldown = 0', 'player'},
	}, 'partycheck = 2'},

	----------
	-- Raid --
	----------
	{{
		{ 'Aura Mastery', 'UI(AM) && area(40,40).heal >= 4', 'player'},
		{ 'Avenging Wrath', 'UI(AW) && area(35,65).heal >= 3 && spell(Holy Shock).cooldown = 0 && !talent(6,2)', 'player'},
		{ 'Avenging Crusader', 'UI(AW) && area(35,65).heal >= 3 && player.spell(Holy Shock).cooldown = 0 && inRange.spell(Crusader Strike) && talent(6,2) && talent(6,2)', 'target'},
		{ 'Holy Avenger', 'UI(HA) && area(40,75).heal >= 3 && spell(Holy Shock).cooldown = 0', 'player'},
	}, 'partycheck = 3'},

	--{ '#trinket1', nil, 'mouseover.ground'},

	{ 'Blessing of Sacrifice', 'health <= UI(T_BoS) && incdmg(5) >= { health.actual * 0.50 }', { 'tank', 'tank2'}},
}

local tank = {
	{ 'Beacon of Light', '!buff(Beacon of Faith) && !buff(Beacon of Light) && !talent(7,3)', 'tank'},
	{ 'Beacon of Faith', '!buff(Beacon of Faith) && !buff(Beacon of Light) && !talent(7,3)', 'tank2'},
	{ 'Beacon of Faith', '!buff(Beacon of Faith) && !buff(Beacon of Light) && !talent(7,3) && !tank2.exists && partycheck < 3', 'player'},

	-- Bestow Faith
	{ 'Bestow Faith', '!buff && talent(1,2) && health <= 90', { 'tank', 'tank2'}},
}

local aoeHealing = {
	{ 'Beacon of Virtue', 'area(30,90).heal >= 3 && talent(7,3)', { 'tank', 'lowest', 'friendly'}},
	{ 'Rule of Law', 'area(22,90).heal.infront >= 3 && !buff && spell(Light of Dawn).cooldown = 0', 'player'},
	{ 'Light of Dawn', 'area(15,90).heal.infront >= 3 && buff(Rule of Law)', 'player'},
	{ 'Light of Dawn', 'area(15,90).heal.infront >= 3', 'player'},
	-- { 'Light of Dawn', 'player.buff(Divine Purpose)'}, -- Needs rewritten. I think there are two buffs
	{ 'Holy Prism', 'area(15,80).heal >= 3', { 'tank', 'lowest', 'friendly'}},
}

local healing = {
	{{ -- Aura of Sacrifice Rotation
		{ 'Avenging Wrath'},
		{ 'Holy Avenger'},
		{ 'Holy Shock', nil, { 'lowest', 'friendly'}},
		{ 'Light of Dawn'},
		{ 'Flash of Light', nil, { 'lowest', 'friendly'}},
	}, 'player.buff(Aura Mastery) && talent(5,2)'},

	{ aoeHealing},

	-- Infusion of Light --
	{ 'Flash of Light', 'health <= UI(L_FoL) && player.buff(Infusion of Light) && { !lowest.buff(Beacon of Light) || !lowest.buff(Beacon of Faith) || !lowest.buff(Beacon of Virtue)}', 'lowest'},
	{ 'Flash of Light', 'health <= UI(L_FoL) && player.buff(Infusion of Light) && { !friendly.buff(Beacon of Light) || !friendly.buff(Beacon of Faith) || !friendly.buff(Beacon of Virtue)}', 'friendly'},
	{ 'Flash of Light', 'health <= UI(L_FoL) && player.buff(Infusion of Light)', { 'lowest', 'friendly'}},

	-- Dont waste buff
	{ 'Holy Light', 'player.buff(Infusion of Light).duration <= 3 && player.buff(Infusion of Light)', { 'lowest', 'friendly'}},
	-----------------------

	{ 'Light of the Martyr', '!self && health <= UI(T_LotM) && player.health >= UI(P_LotM)', { 'tank', 'tank2'}},
	{ 'Light of the Martyr', '!self && health <= UI(L_LotM) && player.health >= UI(P_LotM)', { 'lowest', 'friendly'}},
	{ 'Light of the Martyr', '!self && health <= UI(L_FoL) && player.buff(Divine Shield)', { 'lowest', 'friendly'}},

	-- Cast on people without beacons first
	{ 'Holy Shock', 'health <= UI(L_HS) && { !lowest.buff(Beacon of Light) || !lowest.buff(Beacon of Faith) || !lowest.buff(Beacon of Virtue)}', 'lowest'},
	{ 'Holy Shock', 'health <= UI(L_HS) && { !friendly.buff(Beacon of Light) || !friendly.buff(Beacon of Faith) || !friendly.buff(Beacon of Virtue)}', 'friendly'},

	-- Ignore beacon checks (Heal members with beacon if no one else actually needs healed)
	{ 'Holy Shock', 'health <= UI(T_HS)', { 'tank', 'tank2'}},
	{ 'Holy Shock', 'health <= UI(L_HS)', { 'lowest', 'friendly'}},

	{ 'Judgment', 'infront(player) && enemy && talent(5,1) || infront(player) && enemy && graceOfJusticar && area(8,95).heal >= 1', 'target'},

	-- Cast on people without beacons first
	{ 'Flash of Light', 'health <= UI(L_FoL) && { !lowest.buff(Beacon of Light) || !lowest.buff(Beacon of Faith) || !lowest.buff(Beacon of Virtue)}', 'lowest'},
	{ 'Flash of Light', 'health <= UI(L_FoL) && { !friendly.buff(Beacon of Light) || !friendly.buff(Beacon of Faith) || !friendly.buff(Beacon of Virtue)}', 'friendly'},
	{ 'Holy Light', 'health <= UI(L_HL) && { !lowest.buff(Beacon of Light) || !lowest.buff(Beacon of Faith) || !lowest.buff(Beacon of Virtue)}', 'lowest'},
	{ 'Holy Light', 'health <= UI(L_HL) && { !friendly.buff(Beacon of Light) || !friendly.buff(Beacon of Faith) || !friendly.buff(Beacon of Virtue)}', 'friendly'},

	-- Ignore beacon checks (Heal members with beacon if no one else actually needs healed)
	{ 'Flash of Light', 'health <= UI(T_FoL)', { 'tank', 'tank2'}},
	{ 'Flash of Light', 'health <= UI(L_FoL)', { 'lowest', 'friendly'}},
	{ 'Holy Light', 'health <= UI(T_HL)', { 'tank', 'tank2'}},
	{ 'Holy Light', 'health <= UI(L_HL)', { 'lowest', 'friendly'}},
}

local emergency = {
	{ '!Holy Shock', '!player.casting(Flash of Light)', { 'lowest', 'friendly'}},
	{ '!Flash of Light', '!player.moving && !player.casting(Flash of Light)', { 'lowest', 'friendly'}},
	{ '!Light of the Martyr', '!self && !player.casting(Flash of Light) && !player.casting(Flash of Light)', { 'lowest', 'friendly'}},
}

local moving = {
	{ aoeHealing},

	{{
		{ 'Light of the Martyr', '!self && health <= UI(T_LotM)', { 'tank', 'tank2'}},
		{ 'Light of the Martyr', '!self && health <= UI(L_LotM)', { 'lowest', 'friendly'}},
	}, 'player.health >= UI(P_LotM) || player.buff(Divine Shield)'},

	-- Cast on people without beacons first
	{ 'Holy Shock', 'health <= UI(L_HS) && { !lowest.buff(Beacon of Light) || !lowest.buff(Beacon of Faith) || !lowest.buff(Beacon of Virtue)}', 'lowest'},
	{ 'Holy Shock', 'health <= UI(L_HS) && { !friendly.buff(Beacon of Light) || !friendly.buff(Beacon of Faith) || !friendly.buff(Beacon of Virtue)}', 'friendly'},

	-- Ignore beacon checks (Heal members with beacon if no one else actually needs healed)
	{ 'Holy Shock', 'health <= UI(T_HS)', { 'tank', 'tank2'}},
	{ 'Holy Shock', 'health <= UI(L_HS)', { 'lowest', 'friendly'}},

	{ 'Judgment', 'enemy && talent(5,1)', 'target'},
}

local manaRestore = {
	{ aoeHealing},

	-- Holy Shock
	{ 'Holy Shock', 'health <= UI(T_HS) / 2', { 'tank', 'tank2'}},
	{ 'Holy Shock', 'health <= UI(L_HS) / 2', { 'lowest', 'friendly'}},

	-- Flash of Light
	{ 'Flash of Light', 'health <= UI(T_FoL) / 2', { 'tank', 'tank2'}},
	{ 'Flash of Light', 'health <= UI(L_FoL) / 2', { 'lowest', 'friendly'}},

	-- Holy Light
	{ 'Holy Light', 'health <= UI(T_HL) / 2', { 'tank', 'tank2'}},
	{ 'Holy Light', 'health <= UI(L_HL) / 2', { 'lowest', 'friendly'}},
}

local inCombat = {
	{ '/stopcasting', 'cancelCastingEvent', 'enemies'},
	{ topUp, 'keybind(lcontrol)'},
	{ survival},
	{ dispel, 'UI(G_Disp)'},
	{ cooldowns, 'toggle(cooldowns)'},
	{ emergency, 'lowest.health <= UI(G_CHP) && !player.casting(Flash of Light)'},
	{ tank},
	{ DPS, 'toggle(dps) && target.enemy && lowest.health > UI(G_DPS) || player.buff(Avenging Crusader) && toggle(dps) && target.enemy'},
	{ moving, 'player.moving'},
	{ manaRestore, 'player.mana < UI(P_MR)'},
	{ healing, '!player.moving && player.mana >= UI(P_MR)'},
	{ DPS, 'toggle(dps) && target.enemy'},
}

local outCombat = {
	-- Need to prevent this while eating
	{ tank},
	{ topUp, 'keybind(lcontrol)'},

	--{ '#trinket1', 'keybind(alt)', 'cursor.ground'},

	-- Precombat
	{ 'Bestow Faith', 'dbm(Pull in) <= 2', 'tank'},

	{ oocTopUp, 'UI(G_OOC)'},
}

NeP.CR:Add(65, {
	name = '[Silver] Paladin - Holy',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.1.5',
 nep_ver = '1.12',
})
