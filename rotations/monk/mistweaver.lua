local GUI = {
	{type = 'header', 	text = 'Generic', align = 'center'},
	{type = 'spinner', 	text = 'DPS while lowest health%', 				key = 'G_DPS', 	default = 70},
	{type = 'spinner', 	text = 'Critical health%', 						key = 'G_CHP', 	default = 30},
	{type = 'spinner', 	text = 'Mana Restore', 							key = 'P_MR', 	default = 20},
	{type = 'checkbox',	text = 'Offensive Holy Shock',					key = 'O_HS', 	default = false},
	{type = 'ruler'}, {type = 'spacer'},
	
	--------------------------------
	-- Toggles
	--------------------------------
	{type = 'header', 	text = 'Toggles', align = 'center'},
	{type = 'checkbox',	text = 'Avenging Wrath',						key = 'AW', 	default = false},
	{type = 'checkbox',	text = 'Aura Mastery',							key = 'AM', 	default = false},
	{type = 'checkbox',	text = 'Holy Avenger',							key = 'HA', 	default = false},
	{type = 'checkbox',	text = 'Lay on Hands',							key = 'LoH', 	default = false},
	{type = 'checkbox',	text = 'Encounter Support',						key = 'ENC', 	default = true},
	{type = 'checkspin',text = 'Healing Potion/Healthstone',			key = 'P_HP', 	default = false},
	{type = 'checkspin',text = 'Mana Potion',							key = 'P_MP', 	default = false},
	{type = 'spinner',	text = 'Health for LotM',						key = 'P_LotM', default = 40},
	{type = 'checkbox', text = 'Auto Ress out of combat', 				key = 'rezz', 	default = false},
	{type = 'ruler'}, {type = 'spacer'},
		
	--------------------------------
	-- TANK
	--------------------------------
	{type = 'header', 	text = 'Tank', align = 'center'},
	{type = 'spinner', 	text = 'Renewing Mist (Health %)', 				key = 'T_RM', 	default = 95},
	{type = 'spinner', 	text = 'Enveloping Mist (Health %)', 			key = 'T_HS', 	default = 90},
	{type = 'spinner', 	text = 'Effuse (Health %)', 					key = 'T_Ef', 	default = 75},
	{type = 'ruler'}, {type = 'spacer'},
	
	--------------------------------
	-- LOWEST
	--------------------------------
	{type = 'header', 	text = 'Lowest', align = 'center'},
	{type = 'spinner', 	text = 'Soothing Mist (Health %)', 				key = 'L_SM',	default = 95},
	{type = 'spinner', 	text = 'Renewing Mist (Health %)', 				key = 'L_RM',	default = 95},
	{type = 'spinner', 	text = 'Enveloping Mist (Health %)', 			key = 'L_EM', 	default = 90},
	{type = 'spinner', 	text = 'Vivify (Health %)', 					key = 'L_Vi', 	default = 70},
}

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- |rSilver Paladin |cffADFF2FProtection |r')
	print('|cffADFF2F --- |rMost Talents Supported')
	print('|cffADFF2F ----------------------------------------------------------------------|r')

	NeP.Interface:AddToggle({
		key = 'dps',
		name = 'DPS',
		text = 'DPS while healing',
		icon = 'Interface\\Icons\\spell_holy_crusaderstrike',
	})
	NeP.Interface:AddToggle({
		key = 'disp',
		name = 'Dispell',
		text = 'ON/OFF Dispel All',
		icon = 'Interface\\ICONS\\spell_holy_purify', 
	})
end

local keybinds = {
	{ '!Summon Jade Serpent Statue', 'keybind(control)', 'cursor.ground'},
}

local interrupts = {

}

local cooldowns = {
	{ '&Revival', 'toggle(cooldowns) & {area(40,50).heal > 7 || area(40,80).heal > 11 || area(40,85).heal > 15 || area(40,70).heal > 10 || area(40,60).heal>8||area(40,65).heal > 6 || area(40,30).heal > 4 || area(40,20).heal > 2}', 'player'},
	{ 'Thunder Focus Tea'},
	{ 'Chi Burst', 'area(15,90).heal.infront >= 3'},
}

local moving = {
	{ 'Renewing Mist', 'health <= UI(L_RM) & !buff', { 'tank','tank2','lowest','lowest2','lowest3','lowest4','lowest5','lowest6','lowest7','lowest8','lowest9','lowest10','friendly'}},
	
	{ 'Essence Font', 'toggle(AOE) & player.area(30,85).heal >= 3', 'lowestp'},
}

local healing = {
	{ 'Renewing Mist', 'health <= UI(L_RM) & !buff', { 'tank','tank2','lowest','lowest2','lowest3','lowest4','lowest5','lowest6','lowest7','lowest8','lowest9','lowest10','friendly'}},
	{ '!Renewing Mist', 'health <= UI(L_RM) & !buff && { player.channeling(Soothing Mist) || player.channeling(Crackling Jade Lightning)}', { 'tank','tank2','lowest','lowest2','lowest3','lowest4','lowest5','lowest6','lowest7','lowest8','lowest9','lowest10','friendly'}},
	
	{ 'Essence Font', 'toggle(AOE) & area(30,75).heal >= 3', 'player'},
	{ '!Essence Font', 'toggle(AOE) && area(30,75).heal >= 3 && { player.channeling(Soothing Mist) || player.channeling(Crackling Jade Lightning)}', 'player'},
	
	{ '&Vivify', 'area(40,80).heal >= 3 & toggle(AOE) && !buff(Renewing Mists) && buff(Soothing Mist) && player.channeling(Soothing Mist)', { 'tank','tank2','lowest', 'friendly'}},
	{ 'Vivify', 'area(40,80).heal >= 3 & toggle(AOE) && !buff(Renewing Mists)', { 'tank','tank2','lowest', 'friendly'}},

	{ '!Soothing Mist', 'health <= UI(L_SM) && !buff(Soothing Mist) && { player.channeling(Soothing Mist) || player.channeling(Crackling Jade Lightning)} && { !talent(7,3) || talent(7,3) && !target.inRange.spell(Tiger Palm)}', { 'tank','tank2','lowest', 'friendly'}},
	{ 'Soothing Mist', 'health <= UI(L_SM) && { !talent(7,3) || talent(7,3) && !target.inRange.spell(Tiger Palm)}', { 'tank','tank2','lowest','friendly'}},
	
	{ '&Enveloping Mist', 'health <= UI(L_EM) & !buff && buff(Soothing Mist) && player.channeling(Soothing Mist)', { 'tank','tank2','lowest','lowest2','lowest3','lowest4','lowest5','lowest6','lowest7','lowest8','lowest9','lowest10','friendly'}},
	
	{ '&Vivify', 'health <= UI(L_Vi) && buff(Soothing Mist) && player.channeling(Soothing Mist)', { 'tank','tank2','lowest', 'friendly'}},
	{ '!Vivify', 'health <= UI(L_Vi) && !buff(Soothing Mist) && { player.channeling(Soothing Mist) || player.channeling(Crackling Jade Lightning)}', { 'tank','tank2','lowest', 'friendly'}},
	{ 'Vivify', 'health <= UI(L_Vi)', { 'tank','tank2','lowest', 'friendly'}},
}

local lowMana = {

}

local thunderFocusTea = {

	{ '&Enveloping Mist', 'health <= UI(L_EM) & !buff && buff(Soothing Mist) && player.channeling(Soothing Mist)', { 'tank','tank2','lowest','lowest2','lowest3','lowest4','lowest5','lowest6','lowest7','lowest8','lowest9','lowest10','friendly'}},
}

local dps = {
	{ '/startattack', '!isattacking & inRange.spell(Tiger Palm) && target.enemy & target.alive'},
	{ 'Rising Sun Kick', 'inRange.spell'}, 
	{ 'Tiger Palm', 'inRange.spell && player.buff(Teachings of the Monastery).count <= 2', 'target'},
	{ 'Blackout Kick', 'inRange.spell && player.buff(Teachings of the Monastery)', 'target'},
	{ 'Crackling Jade Lightning', 'inRange.spell && player.moving', 'target'},                                                                                                                                                                                                          
}

local inCombat = {
	{ keybinds},
	--{ '%dispelall', 'toggle(disp) & spell(Detox).cooldown = 0'},
	{ cooldowns, 'toggle(cooldowns)'}, 
	{ moving, 'player.moving'}, 
	--{ thunderFocusTea, 'player.buff(Thunder Focus Tea)'}, 
	--{ lowMana, '!player.moving & player.mana <= UI(P_MR)'},
	{ healing, '!player.moving'},
	{ dps, 'toggle(dps) && target.enemy'},
}

local outCombat = {
	{ keybinds},
	{ moving, 'player.moving'}, 
	{ healing, '!player.moving'},
}

NeP.CR:Add(270, {
	name = '[Silver] Monk - Mistweaver',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
 wow_ver = '8.1',
 nep_ver = '1.11',
	load = exeOnLoad
})
