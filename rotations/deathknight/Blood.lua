local GUI = {
	-- General
	{type = 'header', 		text = 'General', align = 'center'},

	{type = 'ruler'},{type = 'spacer'},
	
	-- Survival
	{type = 'header', 		text = 'Survival', align = 'center'},

	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', 		text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'ruler'},{type = 'spacer'},} 

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- Supported Talents')
	print('|cffADFF2F --- WIP')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {

}

local interrupts = {
	{ 'Mind Freeze'},
}

local preCombat = {

}

local survival = {
	{ 'Vampiric Blood', 'player.health <= 40'},
	{ 'Icebound Fortitude', 'player.health <= 20'},
	{ 'Dancing Rune Weapon', 'talent(1,2) & player.spell(Blooddrinker).cooldown > 10 || !talent(1,2)', 'target'}, 
}

local rotation = {
	{ 'Marrowrend', 'player.buff(Bone Shield).duration <= 3', 'target'},
	{ 'Death Strike', 'player.health.missing > player.deathstrike || player.runicpower >= 115', 'target'}, 
	-- Need more
	{ 'Blooddrinker', '!player.buff(Dancing Rune Weapon)', 'target'},
	{ 'Blood Boil', 'player.spell.charges >= 2', 'target'},
	{ 'Blood Boil', '!debuff(Blood Plague)', 'enemies'},
	{ 'Marrowrend', 'player.buff(Bone Shield).count <= 6', 'target'},
	{ 'Rune Strike', 'talent(1,3) & player.spell.charges >= 2 & runes <= 3', 'target'}, 
	{ 'Death and Decay', 'target.area(8).enemies >= 3 & runes >= 3', 'target.ground'}, 
	{ 'Heart Strike', 'runes >= 3', 'target'},
	{ 'Blood Boil', 'player.buff(Dancing Rune Weapon)', 'target'}, 
	{ 'Death and Decay', 'player.buff(Crimson Scourge)', 'target.ground'},
	{ 'Blood Boil', nil, 'target'},
	{ 'Rune Strike', 'talent(1,3)', 'target'},
}

local inCombat = {
	{ '/startattack', '!isattacking & target.enemy'},
	{ survival}, 
	{ interrupts, 'target.interruptAt(35)'},
	{ 'Death\'s Caress', '!inmelee & !debuff(Blood Plague)', 'target'},
	{ '#trinket1', 'target.inmelee'},
	{ '#trinket2', 'target.inmelee'},
	{ rotation, 'target.inmelee'}, 
}

local outCombat = {
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(250, {
	name = '[Silver] Death Knight - Blood',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})