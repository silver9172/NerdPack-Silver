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

local utility = {
	{ 'Tar Trap', 'inRange.spell(Cobra Shot) && infront(player) && !bosscheck', 'target.ground'},

}

local misdirection = {
	{ 'Misdirection', '!player.buff && focus.exists', 'focus'},
	{ 'Misdirection', '!player.buff && tank.exists', 'tank'},
	{ 'Misdirection', '!player.buff && !focus.exists && pet.exists', 'pet'},
}

local petAbilities = {
	{ '*/petattack', 'inRange.spell(Cobra Shot) && infront(player) && targettimeout(petattack, 20)', 'target'},
	{ 'Bite', 'player.spell.exists', 'target'},
	{ 'Claw', 'player.spell.exists', 'target'},
	{ 'Smack', 'player.spell.exists', 'target'},

	{ 'Mend Pet', 'health < 75 && !buff', 'pet'},
	{ 'Revive Pet', 'dead', 'pet'},
}

local cooldowns = {
	{'Blood Fury'},
	{'Berserking'},
}

local interrupts = {
	{'Counter Shot', 'inRange.spell && infront(player) && interruptAt(35)', { 'target', 'enemies'}},
}

local keybinds = {
	{ 'Binding Shot', 'keybind(control)', 'target.ground'},
	{ '%pause', 'keybind(alt)'},
}

local rotation = {
	-- actions=auto_shot
	{ '*/startattack', 'inRange.spell(Cobra Shot) && infront(player) && targettimeout(autoshot, 10)', 'target'},
	-- actions+=/use_items
	-- actions+=/berserking,if=cooldown.bestial_wrath.remains>30
	{ 'Berserking', 'inRange.spell(Cobra Shot) && infront(player) && spell(Bestial Wrath).cooldown > 30', 'target'},
	-- actions+=/blood_fury,if=cooldown.bestial_wrath.remains>30
	{ 'Blood Fury', 'inRange.spell(Cobra Shot) && infront(player) && spell(Bestial Wrath).cooldown > 30', 'target'},
	-- actions+=/ancestral_call,if=cooldown.bestial_wrath.remains>30
	{ 'Ancestral Call', 'inRange.spell(Cobra Shot) && infront(player) && spell(Bestial Wrath).cooldown > 30', 'target'},
	-- actions+=/fireblood,if=cooldown.bestial_wrath.remains>30
	{ 'Fireblood', 'inRange.spell(Cobra Shot) && infront(player) && spell(Bestial Wrath).cooldown > 30', 'target'},
	-- actions+=/potion,if=buff.bestial_wrath.up&buff.aspect_of_the_wild.up&(target.health.pct<35|!talent.killer_instinct.enabled)|target.time_to_die<25
	-- actions+=/barbed_shot,if=pet.cat.buff.frenzy.up&pet.cat.buff.frenzy.remains<=gcd.max|full_recharge_time<gcd.max&cooldown.bestial_wrath.remains
	{ 'Barbed Shot', 'inRange.spell(Cobra Shot) && infront(player) && pet.buff(Frenzy) && pet.buff(Frenzy).duration <= gcd', 'target'},
	-- actions+=/lights_judgment
	-- actions+=/spitting_cobra
	{ 'Spitting Cobra', 'inRange.spell && infront(player)', 'target'},
	-- actions+=/aspect_of_the_wild
	{ 'Aspect of the Wild', 'inRange.spell(Cobra Shot) && infront(player)', 'target'},
	-- actions+=/a_murder_of_crows,if=active_enemies=1
	{ 'A Murder of Crows', 'inRange.spell && infront(player) && area(15).enemies = 1', 'target'},
	-- actions+=/stampede,if=buff.aspect_of_the_wild.up&buff.bestial_wrath.up|target.time_to_die<15
	-- actions+=/multishot,if=spell_targets>2&gcd.max-pet.cat.buff.beast_cleave.remains>0.25
	{ 'Multi-Shot', 'inRange.spell && infront(player) && area(8).enemies > 2 && gcd - pet.buff(Beast Cleave).duration > 0.25', 'target'},
	-- actions+=/bestial_wrath,if=cooldown.aspect_of_the_wild.remains>20|target.time_to_die<15
	{ 'Bestial Wrath', 'inRange.spell(Cobra Shot) && infront(player) && { spell(Aspect of the Wild).cooldown > 20 || ttd < 15 }', 'target'},
	-- actions+=/barrage,if=active_enemies>1
	{ 'Barrage', 'inRange.spell(Cobra Shot) && infront(player) && area(8).enemies > 1', 'target'},
	-- actions+=/chimaera_shot,if=spell_targets>1
	{ 'Chimaera Shot', 'inRange.spell && infront(player) && area(8).enemies > 1', 'target'},
	-- actions+=/multishot,if=spell_targets>1&gcd.max-pet.cat.buff.beast_cleave.remains>0.25
	{ 'Multi-Shot', 'inRange.spell && infront(player) && area(8).enemies > 1 && gcd - pet.buff(Beast Cleave).duration > 0.25', 'target'},
	-- actions+=/kill_command
	{ 'Kill Command', 'inRange.spell && infront(player)', 'target'},
	-- actions+=/chimaera_shot
	{ 'Chimaera Shot', 'inRange.spell && infront(player)', 'target'},
	-- actions+=/a_murder_of_crows
	{ 'A Murder of Crows', 'inRange.spell && infront(player)', 'target'},
	-- actions+=/dire_beast
	{ 'Dire Beast', 'inRange.spell && infront(player)', 'target'},
	-- actions+=/barbed_shot,if=pet.cat.buff.frenzy.down&(charges_fractional>1.8|buff.bestial_wrath.up)|cooldown.aspect_of_the_wild.remains<6&azerite.primal_instincts.enabled|target.time_to_die<9
 	{ 'Barbed Shot', 'inRange.spell && infront(player) && { !pet.buff(Frenzy) && player.spell.charges > 1.4 || player.spell.recharge < gcd || ttd < 9}', 'target'},
	-- actions+=/barrage
	{ 'Barrage', 'inRange.spell(Cobra Shot) && infront(player)', 'target'},
	-- actions+=/cobra_shot,if=(active_enemies<2|cooldown.kill_command.remains>focus.time_to_max)&(focus-cost+focus.regen*(cooldown.kill_command.remains-1)>action.kill_command.cost|cooldown.kill_command.remains>1+gcd)&cooldown.kill_command.remains>1
	{ 'Cobra Shot', 'inRange.spell && infront(player) && {{ target.area(15).enemies < 2 || spell(Kill Command).cooldown > focus.time_to_max } && { focus - 35 + power.regen * { spell(Kill Command).cooldown - 1} > 30 || spell(Kill Command).cooldown > 1 + gcd} && spell(Kill Command).cooldown > 1}'},
	-- actions+=/arcane_torrent
}

local inCombat = {
	{ misdirection},
	{ interrupts},
	{ petAbilities},
	{ utility},
	{ rotation},
}

local outCombat = {
	{ Keybinds},
	{ 'Dismiss Pet', 'pet.exists && toggle(PetSummon) && !player.buff(Feign Death)'},
}

NeP.CR:Add(253, {
	name = '|cffFF7373[Silver]|r HUNTER - Beast Mastery',
	ic = inCombat,
	ooc = outCombat,
	gui = GUI,
	load = exeOnLoad
})
