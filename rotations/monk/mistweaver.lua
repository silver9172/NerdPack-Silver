local GUI = {
	{type = 'header', 	text = 'Generic', align = 'center'},
	{type = 'checkbox', 	text = 'Auto Dispel (BFA Only)', 				key = 'Disp', 	default = false},
	--{type = 'spinner', 	text = 'DPS while lowest health%', 				key = 'G_DPS', 	default = 70},
	--{type = 'spinner', 	text = 'Critical health%', 						key = 'CHP', 	default = 30},
	--{type = 'spinner', 	text = 'Mana Restore', 							key = 'P_MR', 	default = 20},
	{type = 'ruler'}, {type = 'spacer'},
	
	--------------------------------
	-- Toggles
	--------------------------------
	{type = 'header', 		text = 'Cooldowns', align = 'center'},
	{type = 'checkspin', 	text = 'Life Cocoon', 					key = 'LC', 	default_check = true, default_spin = 25},
	--{type = 'checkbox', 	text = 'Auto Ress out of combat', 				key = 'rezz', 	default = false},
	{type = 'ruler'}, {type = 'spacer'},
		
	--------------------------------
	-- Healing Values
	--------------------------------
	{type = 'header', 		text = 'Healing', align = 'center'},
	{type = 'spinner', 		text = 'Soothing Mist (Health %)', 		key = 'L_SM',	default = 95},
	{type = 'spinner', 		text = 'Renewing Mist (Health %)', 		key = 'L_RM',	default = 95},
	{type = 'spinner', 		text = 'Enveloping Mist (Health %)', 	key = 'L_EM', 	default = 90},
	{type = 'spinner', 		text = 'Vivify (Health %)', 			key = 'L_Vi', 	default = 70},
}

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- Silver Monk - Mistweaver')
	print('|cffADFF2F --- Most Talents Supported')
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

local dispel = {
	{ 'Detox', 'magicDispel', { 'lowest', 'friendly'}},
	{ 'Detox', 'poisonDispel', { 'lowest', 'friendly'}},
	{ 'Detox', 'diseaseDispel', { 'lowest', 'friendly'}},
}

local cooldowns = {
	{ 'Arcane Torrent', 'inRange.spell(Tiger Palm) & purgeEvent', 'enemies'}, 
	{ '&Revival', 'toggle(cooldowns) & {area(40,50).heal > 7 || area(40,80).heal > 11 || area(40,85).heal > 15 || area(40,70).heal > 10 || area(40,60).heal>8||area(40,65).heal > 6 || area(40,30).heal > 4 || area(40,20).heal > 2}', 'player'},
	{ 'Thunder Focus Tea'},
	{ 'Chi Burst', 'area(15,90).heal.infront >= 3'},
	
	{ '&Life Cocoon', 'buff(buff(Soothing Mist) && health <= UI(LC) && UI(LC_check)', { 'tank','tank2','lowest', 'friendly'}},
	{ 'Life Cocoon', 'health <= UI(LC) && UI(LC_check)', { 'tank','tank2','lowest', 'friendly'}},
}

local moving = {
	{ 'Renewing Mist', 'health <= UI(L_RM) & !buff', { 'tank','tank2','lowest','lowest2','lowest3','lowest4','lowest5','lowest6','lowest7','lowest8','lowest9','lowest10','friendly'}},
	
	{ 'Essence Font', 'toggle(AOE) & area(30,85).heal >= 3', 'player'},
}

local healing = {
	{ 'Renewing Mist', 'health <= UI(L_RM) & !buff', { 'tank','tank2','lowest','lowest2','lowest3','lowest4','lowest5','lowest6','lowest7','lowest8','lowest9','lowest10','friendly'}},
	{ '!Renewing Mist', 'health <= UI(L_RM) & !buff && { player.channeling(Soothing Mist) || player.channeling(Crackling Jade Lightning)}', { 'tank','tank2','lowest','lowest2','lowest3','lowest4','lowest5','lowest6','lowest7','lowest8','lowest9','lowest10','friendly'}},
	
	{ 'Essence Font', 'toggle(AOE) & area(30,75).heal >= 3', 'player'},
	{ '!Essence Font', 'toggle(AOE) && area(30,75).heal >= 3 && { player.channeling(Soothing Mist) || player.channeling(Crackling Jade Lightning)}', 'player'},
	
	{ '&Vivify', 'area(40,80).heal >= 3 & toggle(AOE) && !buff(Renewing Mists) && buff(Soothing Mist) && player.channeling(Soothing Mist)', { 'tank','tank2','lowest', 'friendly'}},
	{ 'Vivify', 'area(40,80).heal >= 3 & toggle(AOE) && !buff(Renewing Mists)', { 'tank','tank2','lowest', 'friendly'}},

	-- Needs adjusted so that it doesnt keep recasting to different people every GCD
	{ '&Soothing Mist', 'health <= UI(L_SM) && !buff(Soothing Mist) && player.channeling(Soothing Mist).percent > 50 && { !talent(7,3) || talent(7,3) && !target.inRange.spell(Tiger Palm)}', { 'tank','tank2','lowest', 'friendly'}},
	{ 'Soothing Mist', 'health <= UI(L_SM) && { !talent(7,3) || talent(7,3) && !target.inRange.spell(Tiger Palm)}', { 'tank','tank2','lowest','friendly'}},
	
	-- Never hard cast Enveloping Mist
	{ '&Enveloping Mist', 'health <= UI(L_EM) & !buff && buff(Soothing Mist) && player.channeling(Soothing Mist)', { 'tank','tank2','lowest','lowest2','lowest3','lowest4','lowest5','lowest6','lowest7','lowest8','lowest9','lowest10','friendly'}},
	
	{ '&Vivify', 'health <= UI(L_Vi) && buff(Soothing Mist) && player.channeling(Soothing Mist)', { 'tank','tank2','lowest', 'friendly'}},
	{ '!Vivify', 'health <= UI(L_Vi) && !buff(Soothing Mist) && { player.channeling(Soothing Mist).percent > 25 || player.channeling(Crackling Jade Lightning)}', { 'tank','tank2','lowest', 'friendly'}},
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
	{ 'Crackling Jade Lightning', 'inRange.spell && !player.moving', 'target'},                                                                                                                                                                                                          
}

local inCombat = {
	{ keybinds},
	{ dispel, 'UI(Disp)'}, 
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
 nep_ver = '1.12',
	load = exeOnLoad
})
