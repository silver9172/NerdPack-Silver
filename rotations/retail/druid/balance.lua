local GUI = {

}

local inCombat = {
	{ 'Moonfire', '!debuff && inRange.spell && combat', 'enemies'},
	{ 'Solar Wrath', 'inRange.spell', 'target'},
}

local outCombat = {

}

NeP.CR:Add(102, {
	name = '[Silver] Druid - Balance',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
