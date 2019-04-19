local GUI = {

}

local exeOnLoad = function()
	print('|cff74ba48MARKSMANSHIP|r')
	print('|cff74ba48Suggested Talents: NA')
end

local survival = {

}

local cooldowns = {

}

local petCare = {
	{ 'Mend Pet', 'health < 75 && !buff', 'pet'},
}

local interrupts = {
	{ 'Counter Shot'},
}

local misdirection = {
	{ 'Misdirection', 'range < 40 && !player.buff && focus.exists', 'focus'},
	{ 'Misdirection', 'range < 40 && !player.buff && tank.exists', 'tank'},
	{ 'Misdirection', 'range < 40 && !player.buff && !focus.exists && pet.exists', 'pet'},
}

local keybinds ={

}

local inCombat = {
	{ misdirection},
}

local outCombat = {

}

NeP.CR:Add(254, {
	name = '|cffFF7373[Silver]|r HUNTER - Marksmanship',
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad
})
