local GUI = {
	-- Sotr
	{type = 'header', text = 'Shield of the Righteous', align = 'center'},
	{type = 'spinner', text = 'Use 2nd Charge', key = 'sotr', default_spin = 75},
	{type = 'ruler'},{type = 'spacer'},
	
	-- Light of the Protector
	{type = 'header', text = 'Light of the Protector', align = 'center'},
	{type = 'spinner', text = 'Light of the Protector', key = 'lotp', default_spin = 65},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'checkspin', text = 'Use Ardent Defender', key = 'ad', default_check = true, default_spin = 25},
	{type = 'checkspin', text = 'Use Eye of Tyr', key = 'eye', default_check = true, default_spin = 60},
	{type = 'checkspin', text = 'Use Guardian of Ancient Kings', key = 'ak', default_check = true, default_spin = 35},
	{type = 'ruler'},{type = 'spacer'},
} 

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- |rSilver Demo Warlock |cffADFF2FProtection |r')
	print('|cffADFF2F --- |rMost Talents Supported')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {
	-- Pause
	{'%pause', 'keybind(alt)'},
}

local burningRush = {
	{ '/cancelaura Burning Rush', 'player.lastmoved > 1 & player.buff'},
	{ 'Burning Rush', 'player.movingfor > 1 & !player.buff'},
}

local survival = {
	--{ '#Healthstone', 'health <= 40', 'player'},
	{ 'Unending Resolve', 'health <= 20', 'player'},
	{ 'Drain Life', 'player.health <= 40 & !player.moving', 'target'},
}

local trinkets = {
	--Top Trinket usage if UI enables it.
	{'#trinket1'},
	--Bottom Trinket usage if UI enables it.
	{'#trinket2'}
}

local petCare = {
	{ 'Summon Felguard', '!pet.exists & !player.lastcast}'},
	{ 'Health Funnel', 'health <= 30 & alive & !player.moving', 'pet'}, 
} 

local rotation = {
	{ 'Call Dreadstalkers', '!player.moving || player.buff(Demonic Calling)', 'target'},
	{ 'Demonic Strength',},
	{ 'Summon Vilefiend', 'player.spell(Summon Demonic Tyrant).cooldown >= 45'},
	{ 'Hand of Gul\'dan', 'player.shards >= 4 & !player.moving', 'target'},
	{ 'Demonbolt', 'player.buff(Demonic Core) & player.shards <= 3'},
	{ 'Hand of Gul\'dan', 'player.shards >= 3 & !player.moving', 'target'},
	{ 'Shadow Bolt', '!player.moving', 'target'}
}

local moving = {
	
}


local inCombat = {
	{ survival},
	{ petCare},
	{ rotation},
}

local outCombat = {
	{ petCare}, 
}

NeP.CR:Add(266, {
	name = '[Silver] Warlock - Demonology v0.01', 
	ic = inCombat, 
	ooc = outCombat,
	gui = GUI,
	load = exeLoad,
	wow_ver = '8.0.1',
    nep_ver = '1.11',
})