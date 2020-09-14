local GUI = {
	{type = 'header', 	text = 'Generic', align = 'center'},
	{type = 'ruler'},
	{type = 'checkbox',	text = 'Dispel Curses',		key = 'G_Curse', 	default = true},
	{type = 'checkbox',	text = 'Timewarp (Experimental)',				key = 'G_TW', 		default = true},
}

local dispel = {
	{ 'Remove Curse', 'curseDispel', { 'lowest', 'friendly'}},
}

local interrupts = {
	{ 'Counterspell', 'inRange.spell & interruptAt(75)', 'enemies'},
}

local utility = {
	{ 'Arcane Intellect', 'buff.duration.any <= 600 && timeout(ai,5)', 'friendly'},
	{ '/stopcasting', 'cancelCastingEvent', 'enemies'},
	{ 'Spellsteal', 'spellstealEvent', 'enemies'},
	{ 'Time Warp', 'lustEvent && !player.sated && UI(G_TW)', 'target'},
	{ '%target', 'inRange.spell(Fireball) && infront && priorityTarget && !target.priorityTarget', { 'enemies', 'critters'}},
}

local survival = {
	{ 'Blazing Barrier', 'buff.duration <= 15 & !buff(Replenishment) & incdmg(5) >= { player.health.actual * 0.15 }', 'player'},
	--{ '#Healthstone', 'health <= 40', 'player'},
}

local preCombat = {
	{ 'Blazing Barrier', 'dbm(Pull in) & dbm(Pull in) < 6', 'player'},
	{ 'Pyroblast', 'dbm(Pull in) & dbm(Pull in) < 4', 'target'},
}

local items = {
	-- Trinkets
	{ '#159630', 'equipped(159630) && item(159630).usable && { player.buff(Combustion) || player.spell(Combustion).cooldown > 90}', 'player'},
	-- Rotcrusted Voodoo Doll
	{ '#159624', 'equipped(159624) && item(159624).usable && infront', 'target '},
	-- Other
	{ '#168973', 'equipped(168973) && item(168973).usable && { player.buff(Combustion) || player.spell(Combustion).cooldown > 45}', 'player'},
}

local rotation = {
	{ interrupts},
	-- Activate Memory of Lucid Dreams Combustion is off cooldown. (Use before RoP)
	{ 'Memory of Lucid Dreams', 'toggle(cooldowns) && inRange.spell(Scorch) && infront && bosscheck == 1 && player.spell(Combustion).cooldown <= 2', 'target'},
	-- Use Rune of Power when Combustion is off cooldown. (Wait till MoLD is used)
	{ 'Rune of Power', '!player.moving && player.spell(Combustion).cooldown <= 2 && { player.spell(Memory of Lucid Dreams).exists && player.buff(Memory of Lucid Dreams) || !player.spell(Memory of Lucid Dreams).exists} && inRange.spell(Scorch)', 'target'},
	-- Cast Meteor if Combustion is not coming off cooldown within the next 45 seconds, Combustion is off cooldown or Combustion is currently active. If Rune of Power is talented, only cast Meteor during Rune of Power.
	{ 'Meteor', '!target.moving && target.ttd > 11 && { player.spell(Combustion).cooldown > 45 || player.spell(Combustion).cooldown == 0 || player.buff(Combustion)} && { !talent(3,3) || talent(3,3) && player.buff(Rune of Power)}', 'target.ground'},
	-- Cast Combustion when it is off cooldown.
	{ '*Combustion', 'toggle(cooldowns) && inRange.spell(Scorch) && infront && bosscheck == 1 && { !player.moving && talent(3,3) && player.buff(Rune of Power) || player.moving && talent(3,3) || !talent(3,3)}', 'target'},
	{ items},
	-- Cast Rune of Power if it has 2 charges or will have 2 charges within 2 seconds.
	{ 'Rune of Power', 'toggle(cooldowns) && !player.moving && player.spell(Rune of Power).recharge <= gcd && inRange.spell(Scorch) && target.ttd > 15', 'target'},
	{ 'Rune of Power', 'toggle(cooldowns) && !player.moving && player.spell(Combustion).cooldown > 40 && inRange.spell(Scorch) && target.ttd > 15', 'target'},
	-- Cast Flamestrike when there are 5 or more targets stacked and you have Hot Streak (8+ while Combustion is active). If you have Flame Patch talented, cast Flamestrike on 2+ targets without Combustion, or 3+ with Combustion.
	{ 'Flamestrike', 'toggle(aoe) && { target.area(10).enemies >= 8 && player.buff(Combustion) && player.buff(Hot Streak!) || target.area(10).enemies >= 5 && !player.buff(Combustion) && player.buff(Hot Streak!)} && !talent(6,1)', 'target.ground'},
	{ 'Flamestrike', 'toggle(aoe) && { target.area(10).enemies >= 3 && player.buff(Combustion) && player.buff(Hot Streak!) || target.area(10).enemies >= 2 && !player.buff(Combustion) && player.buff(Hot Streak!)} && talent(6,1)', 'target.ground'},
	-- Cast Pyroblast when you have a Hot Streak proc.
	{ 'Pyroblast', 'inRange.spell && infront && player.buff(Hot Streak!)', 'target'},
	-- Cast Living Bomb if there are 3 or more targets stacked, and at least 1 of the targets will live for at least 8 seconds.
	{ 'Living Bomb', 'inRange.spell && infront && area(10).enemies >= 3', 'target'},
	-- Cast Dragon's Breath if Combustion is active and there is less than 1 second left on Combustion.
	{ 'Dragon\'s Breath', 'player.area(10).enemies.infront >= 1 && player.buff(Combustion).duration <= 1 && player.buff(Combustion)', 'target'},
	-- Cast Dragon's Breath if there are 3+ targets present
 	{ 'Dragon\'s Breath', 'player.area(10).enemies.infront >= 3', 'target'},
	-- Cast Fire Blast when you have Heating Up.
	{ '*Fire Blast', 'inRange.spell && infront && player.buff(Heating Up)', 'target'},
	-- Cast Scorch if the target is below 30% Health, to generate Heating Ups and Hot Streaks. (Talent Check)
	{ 'Scorch', 'inRange.spell && infront && hasName(Explosives)', { 'target', 'enemies'}},
	{ 'Scorch', 'inRange.spell && infront && health < 30 && combat', { 'target', 'enemies'}},
	-- Cast Fireball to generate Heating Up.
	{ 'Fireball', 'inRange.spell && infront && !player.moving', 'target'},
	-- Cast Scorch if you have to move and have no instant casts to burn.
	{ 'Scorch', 'inRange.spell && infront', 'target'},
}

local inCombat = {
	--a{ '%pause','PauseFor10 > 0'},
	{ dispel, 'UI(G_Curse)'},
	{ utility},
	{ survival},
	{ rotation},
}

local outCombat = {
	{ '%pause','PauseFor10 == 1'},
	{ '%pause', 'player.buff(Replenishment)'},
	{ utility},
	{ preCombat},
}

NeP.CR:Add(63, {
	name = '[Silver !BETA!] Mage - Fire!',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
	wow_ver = '8.4.7',
	nep_ver = '1.14',
})
