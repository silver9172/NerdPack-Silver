local GUI = {
	-- General
	{type = 'header', 		text = 'General', align = 'center'},
	{type = 'checkbox',		text = 'Multi-Dot',						key = 'multi', 	default = true},
	{type = 'checkbox',		text = 'Sinister Circulation',			key = 'sin', 	default = true},
	{type = 'checkbox',		text = 'Mantle of the Master Assassin',	key = 'mantle', default = true},
	{type = 'ruler'},{type = 'spacer'},
	
	-- Survival
	{type = 'header', 		text = 'Survival', align = 'center'},
	{type = 'spinner', 		text = 'Crimson Vial', 					key = 'cv', 	default_spin = 65},
	{type = 'checkspin', 	text = 'Health Potion', 				key = 'hp', 	default_check = true, default_spin = 25},
	{type = 'checkspin',	text = 'Healthstone', 					key = 'hs', 	default_check = true, default_spin = 25},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', 		text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'checkbox',		text = 'Vanish',						key = 'van', 	default = true},
	{type = 'checkbox',		text = 'Vendetta',						key = 'ven', 	default = true},
	{type = 'checkbox',		text = 'Potion of the Old War',			key = 'ow', 	default = true},
	{type = 'ruler'},{type = 'spacer'},} 

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- Supported Talents')
	print('|cffADFF2F --- WIP')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {
	{ 'Infernal Strike', 'keybind(control)', 'cursor.ground'},
}

local interrupts = {
	{ 'Disrupt'},
}

local preCombat = {

}

local survival = {
	{ 'Soul Barrier', 'talent(7,3) & player.health <= 70'},
	{ 'Fel Devastation', 'talent(6,1) & player.health <= 60 & !player.moving'},
	{ '#trinket1', 'player.health <= 65'},
	{ '#trinket2', 'player.health <= 60'},
 	{ '#5512', 'item(5512).count >= 1 & player.health <= 60', 'player'}, --Health Stone
	{ 'Metamorphosis', 'player.health <= 40'},
}	

local legionEvents = {
	
}

	-- # Fiery Brand Rotation
	-- actions.brand=sigil_of_flame,if=cooldown.fiery_brand.remains<2
	-- actions.brand+=/infernal_strike,if=cooldown.fiery_brand.remains=0
	-- actions.brand+=/fiery_brand
	-- actions.brand+=/immolation_aura,if=dot.fiery_brand.ticking
	-- actions.brand+=/fel_devastation,if=dot.fiery_brand.ticking
	-- actions.brand+=/infernal_strike,if=dot.fiery_brand.ticking
	-- actions.brand+=/sigil_of_flame,if=dot.fiery_brand.ticking

local defensives = {
	-- # Defensives
	-- actions.defensives=demon_spikes
	{ 'Demon Spikes', '!player.buff(Demon Spikes) & player.spell.recharge <= 2'},
	-- actions.defensives+=/metamorphosis
	{ 'Metamorphosis'}, 
	-- actions.defensives+=/fiery_brand
	{ 'Fiery Brand'}, 
}

local normal = {
	-- # Normal Rotation
	-- actions.normal=infernal_strike
	-- actions.normal+=/spirit_bomb,if=soul_fragments>=4
	-- actions.normal+=/soul_cleave,if=!talent.spirit_bomb.enabled
	-- actions.normal+=/soul_cleave,if=talent.spirit_bomb.enabled&soul_fragments=0
	-- actions.normal+=/immolation_aura,if=pain<=90
	{ 'Immolation Aura', 'player.pain <= 90'},
	-- actions.normal+=/felblade,if=pain<=70
	{ 'Felblade', 'player.pain <= 70'},
	-- actions.normal+=/fracture,if=soul_fragments<=3
	{ 'Fracture', 'player.buff(Soul Fragments).count <= 3', 'target'}, 
	-- actions.normal+=/fel_devastation
	{ 'Fel Devastation'}, 
	-- actions.normal+=/soul_cleave
	{ 'Soul Cleave'},
	-- actions.normal+=/sigil_of_flame
	{ 'Sigil of Flame', nil, 'target.ground'},
	-- actions.normal+=/shear
	{ 'Shear'}, 
	-- actions.normal+=/throw_glaive
	{ 'Throw Glave'}, 
}

local rotation = {
	-- # Executed every time the actor is available.
	-- actions=auto_attack
	-- actions+=/consume_magic
	{ 'Consume Magic'}, 
	-- # ,if=!raid_event.adds.exists|active_enemies>1
	-- actions+=/use_item,slot=trinket1
	-- # ,if=!raid_event.adds.exists|active_enemies>1
	-- actions+=/use_item,slot=trinket2
	-- actions+=/call_action_list,name=brand,if=talent.charred_flesh.enabled
	-- actions+=/call_action_list,name=defensives
	{ defensives, 'range <= 8'},
	-- actions+=/call_action_list,name=normal
	{ normal}, 
}

local inCombat = {
	{ keybinds},
	{ '/startattack', '!isattacking & target.range < 10 & target.enemy & target.alive'},
	{ interrupts, 'target.interruptAt(45)'},
	{ rotation},
}

local outCombat = {
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(581, {
	name = '[Silver] Demon Hunter - Havoc',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})