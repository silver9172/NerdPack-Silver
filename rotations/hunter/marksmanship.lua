local GUI = {

} 

local exeOnLoad = function()
	print('|cff74ba48MARKSMANSHIP|r')
	print('|cff74ba48 _')
	print('|cff74ba48 _')
	print('|cff74ba48 _')
	print('|cff74ba48Suggested Talents: NA')
end

local survival = {

}

local cooldowns = {
	{ 'Arcane Torrent', 'deficit >= 30'}, 
	{ 'Blood Fury', 'player.buff(Trueshot)'},
	{ 'Berserking', 'player.buff(Trueshot)'},
	
	-- Need Logic for here
	{ 'Trueshot', },
}

local petCare = {
	{ 'Mend Pet', '!pet.buff & pet.health <= 60', 'pet'},
}

local interrupts = {
	{ 'Counter Shot'},
}

local misdirection = {
	{ 'Misdirection', '!player.buff & !focus.exists & pet.exists & player.threat = 100', 'pet'},
	{ 'Misdirection', '!player.buff & focus.exists', 'focus'},
	{ 'Misdirection', '!player.buff & tank.exists & threat > 95', 'tank'},
}

local keybinds ={
	{ 'Binding Shot', 'keybind(control)', 'target.ground'},
	{ '%pause', 'keybind(alt)'},
}

local trickShot = {
	{ cooldowns, 'toggle(cooldowns) & player.focus > 95'}, 
	{ 'A Murder of Crows', 'health > 25 || health <= 20'},
	{ 'Windburst', '!debuff(Vulnerable) & !aimedshotwindow'},
	{ 'Marked Shot', 'player.focus >= 70 & !aimedshotwindow'},
	{ 'Aimed Shot', '{ !player.moving || player.buff(Lock and Load)} & aimedshotwindow'},
	{ 'Aimed Shot', '{ !player.moving || player.buff(Lock and Load)} & player.focus >= 95'},
	{ 'Multi-shot', 'toggle(aoe) & target.area(8).enemies >= 3'},
	{ 'Arcane Shot'},
}

local targetDie = {
	{ 'Windburst'},
	{ 'Aimed Shot', '{ !player.moving || player.buff(Lock and Load)} & debuff(Vulnerable).duration > player.spell.casttime & target.ttd > player.spell.castime'},
	{ 'Marked Shot'},
	{ 'Arcane Shot'},
	{ 'Sidewinders'},
}

local patient = {
	
}

local inCombat = {
	-- AUTO SHOT!
	{ misdirection},
	{ 'Volley', '!buff', 'player'},
	{ interrupts, 'target.interruptAt(35)'}, 
	-- ITEMS!
	{ trickShot},
	--{ targetDie},
}

local outCombat = {
	{ 'Volley', '!buff', 'player'},
}

NeP.CR:Add(254, {
	name = '|cffFF7373[Silver]|r HUNTER - Marksmanship',
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad
})