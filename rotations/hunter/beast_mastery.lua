local GUI = {

} 

local exeOnLoad = function()
	print('|cff74ba48BEAST MASTERY|r')
	print('|cff74ba48 _')
	print('|cff74ba48 _')
	print('|cff74ba48 _')
	print('|cff74ba48Suggested Talents: NA')
end

local survival = {

}

local misdirection = {
	{ 'Misdirection', '!player.buff & !focus.exists & pet.exists & player.threat = 100', 'pet'},
	{ 'Misdirection', '!player.buff & focus.exists', 'focus'},
	{ 'Misdirection', '!player.buff & tank.exists & threat > 95', 'tank'},
}

local petAbilities = {
	{ 'Bite', 'player.spell.exists', 'target'},
	{ 'Claw', 'player.spell.exists', 'target'},
	{ 'Smack', 'player.spell.exists', 'target'}, 
}

local cooldowns = {
	{'Blood Fury'},
	{'Berserking'},
}

local interrupts = {
	{'Counter Shot'},
}

local keybinds = {
	{ 'Binding Shot', 'keybind(control)', 'target.ground'},
	{ '%pause', 'keybind(alt)'},
}

local rotation = {
	-- actions=auto_shot
	{ '/startattack', '!isshooting'}, 
	-- actions+=/use_items
	-- actions+=/berserking,if=cooldown.bestial_wrath.remains>30
	-- actions+=/blood_fury,if=cooldown.bestial_wrath.remains>30
	-- actions+=/ancestral_call,if=cooldown.bestial_wrath.remains>30
	-- actions+=/fireblood,if=cooldown.bestial_wrath.remains>30
	-- actions+=/lights_judgment
	-- actions+=/potion,if=buff.bestial_wrath.up&buff.aspect_of_the_wild.up
	-- actions+=/barbed_shot,if=pet.cat.buff.frenzy.up&pet.cat.buff.frenzy.remains<=gcd.max
	{ 'Barbed Shot', 'pet.buff(Frenzy) & pet.buff(Frenzy).duration <= gcd.max'}, 
	-- actions+=/a_murder_of_crows
	{ 'A Murder of Crows'},
	-- actions+=/spitting_cobra
	{ 'Spitting Cobra'},
	-- actions+=/stampede,if=buff.bestial_wrath.up|cooldown.bestial_wrath.remains<gcd|target.time_to_die<15
	{ 'Stampede', 'player.buff(Bestial Wrath) || player.spell(Bestial Wrath).cooldown < gcd || ttd < 15', 'target'},
	-- actions+=/aspect_of_the_wild
	-- actions+=/bestial_wrath,if=!buff.bestial_wrath.up
	{ 'Bestial Wrath', '!player.buff(Bestial Wrath)'}, 
	-- actions+=/multishot,if=spell_targets>2&(pet.cat.buff.beast_cleave.remains<gcd.max|pet.cat.buff.beast_cleave.down)
	{ 'Multi-shot', 'area(8).enemies > 2 & { player.buff(Beast Cleave).duration < gcd || !player.buff(Beast Cleave)}', 'target'}, 
	-- actions+=/chimaera_shot
	{ 'Chimaera Shot'},
	-- actions+=/kill_command
	{ 'Kill Command'},
	-- actions+=/dire_beast
	{ 'Dire Beast'},
	-- actions+=/barbed_shot,if=pet.cat.buff.frenzy.down&charges_fractional>1.4|full_recharge_time<gcd.max|target.time_to_die<9
	{ 'Barbed Shot', '!pet.buff(Frenzy) & player.spell.charges > 1.4 || player.spell.recharge < gcd || ttd < 9', 'target'}, 
	-- actions+=/multishot,if=spell_targets>1&(pet.cat.buff.beast_cleave.remains<gcd.max|pet.cat.buff.beast_cleave.down)
	{ 'Multi-shot', 'area(8).enemies > 1 & { player.buff(Beast Cleave).duration < gcd || !player.buff(Beast Cleave).duration}', 'target'},
	-- actions+=/cobra_shot,if=(active_enemies<2|cooldown.kill_command.remains>focus.time_to_max)&(buff.bestial_wrath.up&active_enemies>1|cooldown.kill_command.remains>1+gcd&cooldown.bestial_wrath.remains>focus.time_to_max|focus-cost+focus.regen*(cooldown.kill_command.remains-1)>action.kill_command.cost)
	{ 'Cobra Shot', '{ area(8).enemies < 2 || player.spell(Kill Command).cooldown > focus.time_to_max} & { player.buff(Bestial Wrath) & area(8).enemies > 1 || player.spell(Kill Command).cooldown > 1 + gcd & player.spell(Bestial Wrath).cooldown > focus.time_to_max || player.focus - 35 + focus.regen * { player.spell(Kill Command).cooldown - 1} > 30}', 'target'}, 

-- /cast !auto shot
-- /cast Cobra Shot
-- /script UIErrorsFrame:Clear();	
}

local inCombat = {
	{ misdirection},
	{ interrupts, 'target.interruptAt(35)'}, 
	{ petAbilities}, 
	{ rotation},
}

local outCombat = {
	{ Keybinds},
	{ 'Dismiss Pet', 'pet.exists & toggle(PetSummon) & !player.buff(Feign Death)'},
}

NeP.CR:Add(253, {
	name = '|cffFF7373[Silver]|r HUNTER - Beast Mastery',
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad
})
