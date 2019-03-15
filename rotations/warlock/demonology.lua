local GUI = {
	-- Sotr
	{type = 'header', text = 'Shield of the Righteous', align = 'center'},
	{type = 'spinner', text = 'Use 2nd Charge', key = 'sotr', default_spin = 75},
	{type = 'ruler'},{type = 'spacer'},

	-- Utility
	{type = 'header', text = 'Utility', align = 'center'},
	{type = 'checkspin', text = 'Healthstone', 		key = 'hs', 		default_spin = 50},
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
	print('|cffADFF2F --- |r[Silver] Warlock - |cffADFF2FDemonology v0.01 |r')
	print('|cffADFF2F --- |rKNOWN ISSUES:')
	print('|cffADFF2F --- |rImplosion not working')
	print('|cffADFF2F --- |rNo Demonic Tyrant support')
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
	{ '#Healthstone', 'UI(hs_check) && health <= UI(hs)', 'player'},
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

local build = {
	{ 'Soul Strike', 'inRange.spell', 'target'},
	{ 'Shadow Bolt', 'inRange.spell && !player.moving', 'target'},
}

local multiRotation = {
	{ 'Grimoire: Felguard', 'inRange.spell', 'target'},
	{ 'Summon Vilefiend', 'player.spell(Summon Demonic Tyrant).cooldown >= 45'},
	{ 'Call Dreadstalkers', 'inRange.spell && {!player.moving || player.buff(Demonic Calling)}', 'target'},
	-- Cast Summon Demonic Tyrant, on cooldown with as many of the above cooldown demons and Wild Imps out
	-- Cast Doom on all possible targets, if talented and mobs will live for at least 30s
	{ 'Implosion', 'inRange.spell && wildimps >= 6', 'target'},
	{ 'Demonbolt', 'inRange.spell && player.buff(Demonic Core) & player.shards <= 3', 'target'},
	{ 'Hand of Gul\'dan', 'inRange.spell && player.shards >= 3 & !player.moving && !player.lastcast(Hand of Gul\'dan).succeed', 'target'},
	{ build, 'shards < 5'},
}

local singleRotation = {
	{ 'Grimoire: Felguard', 'inRange.spell', 'target'},
	{ 'Summon Vilefiend', 'player.spell(Summon Demonic Tyrant).cooldown >= 45'},
	{ 'Demonic Strength', 'inRange.spell(Shadow Bolt) && pet.exists', 'pet'},
	{ 'Bilescourge Bombers', 'inRange.spell(Shadow Bolt)', 'target.ground'},
	{ 'Call Dreadstalkers', 'inRange.spell && {!player.moving || player.buff(Demonic Calling)}', 'target'},
	{ 'Hand of Gul\'dan', 'inRange.spell && player.shards >= 4 & !player.moving && !player.lastcast(Hand of Gul\'dan).succeed', 'target'},
	{ 'Demonbolt', 'inRange.spell && player.buff(Demonic Core).count >= 2 & player.shards <= 3'},
	{ 'Power Siphon', 'inRange.spell && warlock.minions.type(Wild Imp) >= 2', 'target'},
	{ 'Hand of Gul\'dan', 'inRange.spell && shards >= 3 & !player.moving && !player.lastcast(Hand of Gul\'dan).succeed', 'target'},
	{ build, 'shards < 5'},
}

local preCombat = {
	{ 'Demonbolt', 'dbm(Pull In) <= 4', 'target'}
}

local inCombat = {
	{ survival},
	{ petCare},
	{ multiRotation, 'target.area(8).enemies > 1'},
	{ singleRotation},
}

local outCombat = {
	{ petCare},
}

NeP.CR:Add(266, {
	     name = '[Silver] Warlock - Demonology v0.01',
	       ic = inCombat,
	      ooc = outCombat,
	      gui = GUI,
	  wow_ver = '8.1.5',
    nep_ver = '1.12',
			 load = exeOnLoad
})
