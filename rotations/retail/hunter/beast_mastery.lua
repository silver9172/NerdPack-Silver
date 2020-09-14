local GUI = {

}

local exeOnLoad = function()
	print('|cff74ba48BEAST MASTERY|r')
	print('|cff74ba48Suggested Talents: NA')
end

local survival = {
	{ 'Exhilaration', 'health <= 60', 'player'},
}

local utility = {
	--{ 'Tar Trap', 'inRange.spell(Cobra Shot) && infront(player) && bosscheck = 0', 'target.ground'},
	{ '%target', 'inRange.spell(Cobra Shot) && infront(player) && priorityTarget && !target.priorityTarget', { 'combatenemies', 'critters'}},
	{ 'Concussive Shot', 'isplayer && debuff.duration <= gcd', 'target'},
}

local misdirection = {
	{ 'Misdirection', 'inRange.spell && !player.buff && focus.exists', 'focus'},
	{ 'Misdirection', 'inRange.spell && !player.buff && tank.exists', 'tank'},
	{ 'Misdirection', 'inRange.spell && !player.buff && !focus.exists && !tank.exists && pet.exists', 'pet'},
}

local petAbilities = {
	{ '*/petattack', 'inRange.spell(Cobra Shot) && infront(player) && targettimeout(petattack, 20)', 'target'},
	{ 'Bite', 'player.spell.exists && targettimeout(pet,1)', 'target'},
	{ 'Claw', 'player.spell.exists && targettimeout(pet,1)', 'target'},
	{ 'Smack', 'player.spell.exists && targettimeout(pet,1)', 'target'},

	{ 'Mend Pet', 'health < 75 && !buff', 'pet'},
	{ 'Revive Pet', 'dead', 'pet'},
}

local interrupts = {
	{ 'Counter Shot', 'interruptAt(35)', { 'target', 'combatenemies'}},
	{ 'Intimidation', 'player.spell(Counter Shot).cooldown > gcd && interruptAt(35) && isplayer', { 'target', 'combatenemies'}},
}

local keybinds = {
	{ 'Tar Trap', 'keybind(control)', 'curser.ground'},
	{ '%pause', 'keybind(alt)'},
}

local items = {
	-- Looms
	{ '#128318', 'equipped(128318) && item(128318).usable', 'target'},
}

local rotation = {
	{ utility},
	{ '*/startattack', 'inRange.spell(Cobra Shot) && infront && targettimeout(autoshot, 2)', 'target'},
	{ interrupts},
	{ items},
	{ 'Barbed Shot', 'pet.buff(Frenzy).duration <= gcd && pet.buff(Frenzy).count >= 1 || player.spell.charges == 2', 'target'},
	{ petAbilities, 'pet.exists'},
	{ 'Multi-Shot', 'area(8).enemies >= 3 && pet.buff(Beast Cleave).duration <= gcd && toggle(aoe)', 'target'},
	{ 'Aspect of the Wild', 'bosscheck == 1', 'target'},
	{ 'Bestial Wrath', 'pet.exists', 'target'},
	{ 'Kill Command', 'pet.exists && targettimeout(kc,1)', 'target'},
	{ 'Multi-Shot', 'area(80).enemies >= 2 && pet.buff(Beast Cleave).duration <= gcd && toggle(aoe)', 'target'},
	{ 'Barbed Shot', 'player.spell.charges == 1 && player.spell.recharge <= gcd'},
	{ 'Cobra Shot', 'player.spell(Kill Command).cooldown > 2 || player.timetomax <= gcd', 'target'},
}

local preCombat = {
	{ misdirection, 'dbm(Pull In) <= 2'},
	{ 'Bestial Wrath', 'dbm(Pull In) <= 1.5'},
	{ '#Battle Potion of Agility', 'dbm(Pull In) <= 1'},
}

local inCombat = {
	{ keybinds},
	{ misdirection, '!isplayer'},
	{ survival},
	{ rotation, 'inRange.spell(Cobra Shot) && infront'},
}

local outCombat = {
	{ keybinds},
	{ preCombat},
	{ 'Dismiss Pet', 'pet.exists && toggle(PetSummon) && !player.buff(Feign Death)'},
}

NeP.CR:Add(253, {
	name = '[Silver !BETA!] HUNTER - Beast Mastery',
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad
})
