local GUI = {
	{type = 'header', 	text = 'Generic', align = 'center'},
	{type = 'ruler'},
	{type = 'checkbox',	text = 'Dispel Curses',		key = 'G_Curse', 	default = true},}

local keybinds = {
	{ 'Polymorph', 'keybind(control)', 'mouseover'},
}

local dispel = {
	{ 'Remove Curse', 'curseDispel', { 'lowest', 'friendly'}},
}

local interrupts = {
	{ 'Counterspell', 'interruptAt(75)', 'enemies'},
}

local utility = {
	{ 'Arcane Intellect', 'buff.duration.any <= 600 && timeout(ai,5)', 'friendly'},
	{ 'Summon Water Elemental', '!player.moving && !talent(1,2) && { pet.dead || !pet.exists}'},
	{ '/stopcasting', 'cancelCastingEvent', 'enemies'},
	{ 'Spellsteal', 'spellstealEvent', 'enemies'},
}

local survival = {
	{ 'Ice Barrier', 'buff.duration <= 15 && { player.incdmg(5) >= { player.health.actual * 0.25}} && combat', 'player'},
}

local items = {
	-- Trinkets
	{ '#159630', 'equipped(159630) && item(159630).usable && { player.buff(Icy Veins) || player.spell(Icy Veins).cooldown > 90}', 'player'},
	-- Rotcrusted Voodoo Doll
	{ '#159624', 'equipped(159624) && item(159624).usable && infront', 'target '},
	-- Other
	{ '#168973', 'equipped(168973) && item(168973).usable && { player.buff(Icy Veins) || player.spell(Icy Veins).cooldown > 45}', 'player'},
}

local movement = {
	{ 'Ice Floes', '!buff', 'player'},
	{ 'Flurry', 'player.buff(Icicles).count < 3 && player.buff(Brain Freeze)', 'target'},
	{ 'Ice Lance', nil, 'target'},
}

local aoe = {
	{ 'Frozen Orb', nil, 'target'},
	{ 'Comet Storm', nil, 'target'},
	{ 'Blizzard', nil, 'target.ground'},
}

local rotation = {
	{ 'Ice Lance', 'hasName(Explosives)', 'enemies'},
	{ items},
	{ interrupts},
	{ aoe, 'target.area(8).enemies >= 4'},
	{ 'Icy Veins', 'bosscheck == 1 && toggle(cooldowns)', 'target'},
	{ 'Flurry', 'player.buff(Icicles).count < 3 && player.buff(Brain Freeze)', 'target'},
	{ 'Ice Lance', 'player.buff(Fingers of Frost) || player.lastcast(Flurry)', 'target'},
	{ 'Ebonbolt', nil, 'target'},
	{ 'Frozen Orb', nil, 'target'},
	{ 'Comet Storm', nil, 'target'},
	{ 'Glacial Spike', 'player.buff(Brain Freeze)', 'target'},
	{ 'Frostbolt', nil, 'target'},
}

local preCombat = {
	{ pet, 'dbm(Pull in) <= 2 && dbm(Pull in) > 0'},
	{ 'Frostbolt', 'dbm(Pull in) <= 2 && dbm(Pull in) > 0', 'target'},
}

local inCombat = {
	{ keybinds},
	{ utility},
	{ dispel, 'UI(G_Curse)'},
	{ survival},
	{ movement, 'player.moving && inRange.spell(Frostbolt) && infront'},
	{ rotation, '!player.moving && inRange.spell(Frostbolt) && infront'},
}

local outCombat = {
	{ '%pause','PauseFor10 == 1'},
	{ keybinds},
	{ '%pause', 'player.buff(Refreshment)'},
	{ utility},
	{ preCombat},
}

NeP.CR:Add(64, {
	name = '[Silver !BETA!] MAGE - Frost!',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.3.7',
 nep_ver = '1.14',
})
