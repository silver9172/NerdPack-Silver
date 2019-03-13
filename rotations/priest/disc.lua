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
	-- LOWEST
	--------------------------------
	{type = 'header', 	text = 'Lowest', align = 'center'},
	{type = 'spinner', 	text = 'Power Word: Shield (Health %)', 		key = 'L_PWS', 	default = 50},
	{type = 'spinner', 	text = 'Shadowmend (Health %)', 				key = 'L_SM', 	default = 50},
	{type = 'spinner', 	text = 'Penance (Health %)', 					key = 'L_P', 	default = 50},
	{type = 'spinner', 	text = 'Atonement(Health %)', 					key = 'L_At',	default = 95},
	{type = 'spinner', 	text = 'Flash of Light (Health %)', 			key = 'L_FoL', 	default = 70},
	{type = 'spinner', 	text = 'Holy Light (Health %)', 				key = 'L_HL', 	default = 90},
}

local exeOnLoad = function()
	NeP.Interface:AddToggle({
		key  = 'dps',
		name = 'DPS',
		text = 'DPS while healing',
		icon = 'Interface\\Icons\\spell_holy_crusaderstrike',
	})
end

-- Cast that should be interrupted
local interrupts = {

}

local dispel = {
	{ 'Purify', 'magicDispel', { 'tank', 'player', 'lowest', 'friendly'}}, 
	{ 'Purify', 'diseaseDispel', { 'tank', 'player', 'lowest', 'friendly'}}, 
}

local utility = {
	{ 'Power Word: Fortitude', '!buff.any && !los', { 'tank', 'player', 'lowest', 'friendly'}}, 
}

local dps = {
	{ 'Shadow Word: Pain', 'count.enemies.debuffs <= 2 && range <= 40 && debuff.duration <= 4.8 && ttd >= 10 && !los && combat', {'target', 'enemies'}}, 
	{ 'Schism', 'range <= 40 && combat && infront && !player.moving && ttd >= 15 && !los ', { 'target', 'enemies'}},  
	{ 'Power Word: Solace', 'range <= 40 && combat && infront && !los ', { 'target', 'enemies'}},  
	{ 'Penance', 'range <= 40 && combat && infront && !los', { 'target', 'enemies'}},  
	{ 'Smite', 'range <= 40 && !player.moving && combat && infront && !los ', {'target', 'enemies'}},
}

local cooldowns = {

}

local healing = {
	-- Emergency (High Damage, Direct Heals)
	{ 'Power Word: Shield', '!debuff(Weakened Soul) && !buff && health <= UI(L_PWS) && !los', { 'tank', 'lowest', 'lowest2', 'lowest3', 'lowest4', 'friendly'}},
	{ 'Penance', 'health <= UI(L_P) && !los', { 'tank', 'player', 'lowest', 'friendly'}},
	{ 'Shadow Mend', 'health <= UI(L_SM) && !player.moving && !los', { 'tank', 'player', 'lowest', 'friendly'}},
	
	{ 'Power Word: Radiance', 'count(Atonement).friendly.buffs <= 3 && area(30,90).heal >= 3', { 'tank', 'player', 'lowest', 'friendly'}},
	
	{ dps, 'count(Atonement).friendly.buffs >= 4'}, 
	
	-- Apply Atonement
	{ 'Power Word: Shield', '!debuff(Weakened Soul) && buff(Atonement).duration <= 5 && health <= UI(L_At) && count(Atonement).friendly.buffs <= 3 && !los', { 'lowest', 'lowest2', 'lowest3', 'lowest4', 'friendly'}},

	{ dps}, 
}

local moving = {

}

local inCombat = {
	{ utility}, 
	{ healing}, 
	{ dps}, 
}

local outCombat = {
	{ utility}, 
	{ dps}
}

NeP.CR:Add(256, {
	name = '[Silver] Priest - Disc (Beta)',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.1',
 nep_ver = '1.11',
})