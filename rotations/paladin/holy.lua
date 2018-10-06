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

-- Cast that should be interrupted
local interrupts = {
	{ 'Hammer of Justice', nil, 'target'},
}

local dispel = {
	{ 'Cleanse', 'magicDispel', { 'tank', 'player', 'lowest', 'friendly'}}, 
	{ 'Cleanse', 'poisonDispel', { 'tank', 'player', 'lowest', 'friendly'}}, 
	{ 'Cleanse', 'diseaseDispel', { 'tank', 'player', 'lowest', 'friendly'}}, 
}

local survival = {
	--{ '#127834', 'UI(P_HP_check) & player.health <= UI(P_HP_spin)'}, -- Health Pot
	--{ '#Healthstone', 'UI(P_HP_check) & player.health <= UI(P_HP_spin)'},
	{ '#127835', 'UI(P_MP_check) & player.pmana <= UI(P_MP_spin)'}, -- Mana Pot
	{ 'Divine Protection', 'buff(Blessing of Sacrifice) || incdmg(5) >= { health.max * 0.40 }', 'player'},
}

local topUp = { 
	{ 'Holy Shock', nil, 'mouseover'},
	{ 'Flash of Light', nil, 'mouseover'},
}

local oocTopUp = {
	{ 'Light of Dawn', 'area(15,90).heal.infront >= 3 & player.buff(Rule of Law)', 'player'},
	{ 'Light of Dawn', 'area(15,90).heal.infront >= 3', 'player'},
	{ 'Holy Shock', 'health < 90', 'lowest'},
	{ 'Holy Light', 'health < 90 & !player.moving', 'lowest'},
}

local DPS = {
	{ '/startattack', '!isattacking'},
	{ 'Consecration', 'target.range <= 8 & target.enemy & !player.moving'},
	{ 'Holy Shock', 'UI(O_HS) & infront', 'target'},
	{ 'Holy Prism', nil, 'target'},
	{ 'Judgment', 'infront', 'target'},
	{ 'Crusader Strike', 'infront & inRange.spell'},
}

local cooldowns = {
	-- Need to rewrite for Raid and 5 Man
	{ 'Lay on Hands', 'UI(LoH) & health <= UI(L_LoH) & !debuff(Forbearance).any', { 'tank', 'lowest', 'friendly'}},
	
	-----------
	-- 5 man --
	-----------
	{{
		{ 'Aura Mastery', 'UI(AM) & area(40,40).heal >= 3', 'player'},
		{ 'Avenging Wrath', 'UI(AW) & area(35,65).heal >= 3 & spell(Holy Shock).cooldown = 0', 'player'},
		{ 'Avenging Crusader', 'UI(AW) & area(35,65).heal >= 3 & spell(Holy Shock).cooldown = 0 & inRange.spell(Crusader Strike) & talent(6,2)'},
		{ 'Holy Avenger', 'UI(HA) & area(40,75).heal >= 3 & spell(Holy Shock).cooldown = 0', 'player'},
	}, 'partycheck = 2'}, 
	
	----------
	-- Raid --
	----------
	{{
		{ 'Aura Mastery', 'UI(AM) & area(40,40).heal >= 4', 'player'},
		{ 'Avenging Wrath', 'UI(AW) & area(35,65).heal >= 4 & spell(Holy Shock).cooldown = 0', 'player'},
		{ 'Avenging Crusader', 'spell(Holy Shock).cooldown = 0 & target.range <= 8 & talent(6,2)', 'player'},
		{ 'Holy Avenger', 'UI(HA) & area(40,75).heal >= 3 & spell(Holy Shock).cooldown = 0', 'player'},
	}, 'partycheck = 3'}, 
	
	{ 'Blessing of Sacrifice', 'health <= UI(T_BoS) & incdmg(5) >= { health.actual * 0.50 }', { 'tank', 'tank2'}}, 
}

local tank = {
	{ 'Beacon of Light', '!buff(Beacon of Faith) & !buff(Beacon of Light) & !talent(7,3)', 'tank'},
	{ 'Beacon of Faith', '!buff(Beacon of Faith) & !buff(Beacon of Light) & !talent(7,3)', 'tank2'},
	{ 'Beacon of Faith', '!buff(Beacon of Faith) & !buff(Beacon of Light) & !talent(7,3) & !tank2.exists & partycheck < 3', 'player'},
	
	-- Bestow Faith
	{ 'Bestow Faith', '!buff & talent(1,2) & health <= 90', { 'tank', 'tank2'}},
}

local aoeHealing = {
	{ 'Beacon of Virtue', 'area(30,90).heal >= 3 & talent(7,3)', { 'tank', 'lowest', 'friendly'}},
	{ 'Rule of Law', 'area(22,90).heal.infront >= 3 & !buff & spell(Light of Dawn).cooldown = 0', 'player'},
	{ 'Light of Dawn', 'area(15,90).heal.infront >= 3 & buff(Rule of Law)', 'player'},
	{ 'Light of Dawn', 'area(15,90).heal.infront >= 3', 'player'},
	-- { 'Light of Dawn', 'player.buff(Divine Purpose)'}, -- Needs rewritten. I think there are two buffs
	{ 'Holy Prism', 'area(15,80).heal >= 3', { 'tank', 'lowest', 'friendly'}},
}

local healing = {
	{{ -- Aura of Sacrifice Rotation
		{ 'Avenging Wrath'},
		{ 'Holy Avenger'},
		{ 'Holy Shock', nil, 'lowest'},
		{ 'Light of Dawn'},
		{ 'Flash of Light', nil, 'lowest'},
	}, 'player.buff(Aura Mastery) & talent(5,2)'},
		
	{ aoeHealing},

	-- Infusion of Light --
	{ 'Flash of Light', 'lowest.health <= UI(L_FoL) & player.buff(Infusion of Light)', 'lowest'},
	{ 'Holy Light', 'player.buff(Infusion of Light).duration <= 3 & player.buff(Infusion of Light)', 'lowest'},
	-----------------------
	
	{ 'Light of the Martyr', '!player & health <= UI(T_LotM) & player.health >= UI(P_LotM)', { 'tank', 'tank2'}},
	{ 'Light of the Martyr', '!player & health <= UI(L_LotM) & player.health >= UI(P_LotM)', 'lowest'},
	{ 'Light of the Martyr', '!player & health <= UI(L_FoL) & player.buff(Divine Shield)', 'lowest'},
	
	{ 'Holy Shock', 'health <= UI(T_HS)', { 'tank', 'tank2'}},
	{ 'Holy Shock', 'health <= UI(L_HS)', 'lowest'},
	
	{ 'Judgment', 'infront & enemy & talent(5,1)', 'target'},
	
	-- Mana < 40
	{ '!/stopcasting','target(lowest) & casting.percent > 30 & casting(Flash of Light) & {{ lowest.health > { UI(L_FoL) * 0.5} & mana < 40} ||{  UI(L_FoL) * 0.75} & mana < 80}}}', 'player'},
	{ 'Flash of Light', 'player.mana < 40 & health <= { UI(T_FoL) * 0.5}', { 'tank', 'tank2'}},
	{ 'Flash of Light', 'player.mana < 40 & health <= { UI(L_FoL) * 0.5}', 'lowest'},
	
	-- Mana < 80
	{ 'Flash of Light', 'player.mana < 80 & health <= { UI(T_FoL) * 0.75}', { 'tank', 'tank2'}},
	{ 'Flash of Light', 'player.mana < 80 & health <= { UI(L_FoL) * 0.75}', 'lowest'},
	
	-- Mana < 100
	{ 'Flash of Light', 'health <= UI(T_FoL)', { 'tank', 'tank2'}},
	{ 'Flash of Light', 'health <= UI(L_FoL)', 'lowest'},
		
	{ 'Holy Light', 'health <= UI(T_HL)', { 'tank', 'tank2'}},
	{ 'Holy Light', 'health <= UI(L_HL)', 'lowest'},
}

local emergency = {
	{ '!Holy Shock', '!player.casting(Flash of Light)', 'lowest'},
	{ '!Flash of Light', '!player.moving & !player.casting(Flash of Light)', 'lowest'},
	{ '!Light of the Martyr', '!player & !player.casting(Flash of Light) & !player.casting(Flash of Light)', 'lowest'},
}

local moving = {
	{ aoeHealing},
	
	{{
		{ 'Light of the Martyr', '!player & health <= UI(T_LotM)', { 'tank', 'tank2'}},
		{ 'Light of the Martyr', '!player & health <= UI(L_LotM)', 'lowest'},
	}, 'player.health >= UI(P_LotM) || player.buff(Divine Shield)'},
	
	{ 'Holy Shock', 'health <= UI(T_HS)', { 'tank', 'tank2'}},
	{ 'Holy Shock', 'health <= UI(L_HS)', 'lowest'},
	
	{ 'Judgment', 'enemy & talent(5,1)', 'target'},
}

local manaRestore = {
	{ aoeHealing},
	
	-- Holy Shock
	{ 'Holy Shock', 'health <= UI(T_HS) / 2', { 'tank', 'tank2'}},
	{ 'Holy Shock', 'health <= UI(L_HS) / 2', 'lowest'},
	
	-- Flash of Light
	{ 'Flash of Light', 'health <= UI(T_FoL) / 2', { 'tank', 'tank2'}},
	{ 'Flash of Light', 'health <= UI(L_FoL) / 2', 'lowest'},
	
	-- Holy Light
	{ 'Holy Light', 'health <= UI(T_HL) / 2', { 'tank', 'tank2'}},
	{ 'Holy Light', 'health <= UI(L_HL) / 2', 'lowest'},
}

local inCombat = {
	{ pause, 'keybind(lalt)'},
	{ topUp, 'keybind(lcontrol)'},
	{ survival}, 
	{ interrupts, 'target.interruptAt(35)'},
	{ dispel, 'UI(G_Disp)'}, 
	{ cooldowns, 'toggle(cooldowns)'},
	{ emergency, 'lowest.health <= UI(G_CHP) & !player.casting(Flash of Light)'},
	{ tank},
	{ DPS, 'toggle(dps) & target.enemy & target.infront & lowest.health >= UI(G_DPS) || player.buff(Avenging Crusader) & toggle(dps) & target.enemy & target.infront'},
	{ moving, 'player.moving'},
	{ manaRestore, 'player.pmana < UI(P_MR)'},
	{ healing, '!player.moving & player.pmana >= UI(P_MR)'},
	{ DPS, 'toggle(dps) & target.enemy & target.infront'},
}

local outCombat = {
	-- Need to prevent this while eating
	{ tank},
	{ topUp, 'keybind(lcontrol)'},
	
	-- Precombat
	{ 'Bestow Faith', 'dbm(Pull in) <= 3', 'tank'},
	--{ '#Potion of Prolonged Power', '!player.buff & pull_timer <= 2'},
	
	{ oocTopUp, 'UI(G_OOC)'},
}

NeP.CR:Add(65, {
	name = '[Silver] Paladin - Holy',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.0.1',
 nep_ver = '1.11',
})