local GUI = {
	-- Sotr
	--{type = 'header', text = 'Shield of the Righteous', align = 'center'},
	--{type = 'spinner', text = 'Use 2nd Charge', key = 'sotr', default_spin = 75},
	{type = 'ruler'},{type = 'spacer'},

	-- Light of the Protector
	--{type = 'header', text = 'Light of the Protector', align = 'center'},
	--{type = 'spinner', text = 'Light of the Protector', key = 'lotp', default_spin = 65},
	{type = 'ruler'},{type = 'spacer'},

	--Cooldowns
	{type = 'header', text = 'Cooldowns when toggled on', align = 'center'},
	--{type = 'checkspin', text = 'Use Ardent Defender', key = 'ad', default_check = true, default_spin = 25},
	--{type = 'checkspin', text = 'Use Eye of Tyr', key = 'eye', default_check = true, default_spin = 60},
	--{type = 'checkspin', text = 'Use Guardian of Ancient Kings', key = 'ak', default_check = true, default_spin = 35},
	{type = 'ruler'},{type = 'spacer'},}

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- |rSilver Warrior |cffADFF2FArms |r')
	print('|cffADFF2F --- |rWIP')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local interrupts = {
	{ 'Pummel'},
}

local utility = {
	-- Check player
	{ 'Battle Shout', 'buff.duration <= 600', 'friendly'},
}

local survival = {
	{ 'Victory Rush', 'player.health <= 80', 'target'},
}

local cooldowns = {

}

local cleaveRotation = {
	{ 'Sweeping Strikes', 'player.spell(Bladestorm).cooldown > 5', 'target'},
	{ 'Skullsplitter', 'player.rage > 60 & player.spell(Bladestorm).cooldown > 5', 'target'},
	{ 'Avatar', 'player.spell(Colossus Smash).cooldown = 0', 'target'},
	{ 'Colossus Smash'},
	{ 'Bladestorm', 'debuff(Colossus Smash)', 'target'},
	{ 'Execute'},
	{ 'Mortal Strike'},
	{ 'Overpower'},
	{ 'Slam', 'player.buff(Sweeping Strikes)', 'target'},
	{ 'Whirlwind'},
}

local aoeRotation = {
	{ 'Sweeping Strikes', 'player.spell(Bladestorm).cooldown > 5', 'target'},
	{ 'Skullsplitter', 'player.rage > 60 & player.spell(Bladestorm).cooldown > 5', 'target'},
	{ 'Avatar', 'player.spell(Colossus Smash).cooldown = 0', 'target'},
	{ 'Colossus Smash'},
	{ 'Bladestorm', 'debuff(Colossus Smash)', 'target'},
	{ 'Execute', 'player.buff(Sweeping Strikes)', 'target'},
	{ 'Mortal Strike', 'player.buff(Sweeping Strikes)', 'target'},
	{ 'Whirlwind', 'debuff(Colossus Smash)', 'target'},
	{ 'Overpower'},
	{ 'Whirlwind'},
}

local executeRotation = {
	{ 'Skullsplitter', 'player.rage < 60', 'target'},
	{ 'Avatar', 'player.spell(Colossus Smash).cooldown = 0', 'target'},
	{ 'Colossus Smash'},
	{ 'Bladestorm', 'player.rage < 30', 'target'},
	{ 'Mortal Strike', '{ talent(7,2) & player.buff(Overpower).count >= 2 } ||  !talent(7,2) & player.buff(Executioner\'s Precision).count >= 2', 'target'},
	{ 'Overpower'},
	{ 'Execute'},
}

local fiveTarget = {
	-- actions.five_target=skullsplitter,if=rage<60&(!talent.deadly_calm.enabled|buff.deadly_calm.down)
	{ 'Skullsplitter', 'player.rage < 60 && !player.buff(Deadly Calm) && !player.buff(Memory of Lucid Dreams)', { 'target', 'enemies'}},
	-- actions.five_target+=/ravager,if=(!talent.warbreaker.enabled|cooldown.warbreaker.remains<2)

	-- actions.five_target+=/colossus_smash,if=debuff.colossus_smash.down
	{ 'Colossus Smash', '!debuff(Colossus Smash)', { 'target', 'enemies'}},
	-- actions.five_target+=/warbreaker,if=debuff.colossus_smash.down
	{ 'Warbreaker', '!debuff(Colossus Smash)', { 'target', 'enemies'}},
	-- actions.five_target+=/bladestorm,if=buff.sweeping_strikes.down&(!talent.deadly_calm.enabled|buff.deadly_calm.down)&((debuff.colossus_smash.remains>4.5&!azerite.test_of_might.enabled)|buff.test_of_might.up)
	{ 'Bladestorm', 'inRange.spell(Mortal Strike) && { !player.buff(Sweeping Strikes) && { !talent(6,3) || !player.buff(Deadly Calm)} && {{ target.debuff(Colossus Smash).duration > 4.5} || player.buff(Test of Might)}}', 'target'},
	-- actions.five_target+=/deadly_calm
	{ 'Deadly Calm', 'inRange.spell(Mortal Strike)', 'target'},
	-- actions.five_target+=/cleave
	{ 'Cleave', 'inRange.spell', 'target'},
	-- actions.five_target+=/execute,if=(!talent.cleave.enabled&dot.deep_wounds.remains<2)|(buff.sudden_death.react|buff.stone_heart.react)&(buff.sweeping_strikes.up|cooldown.sweeping_strikes.remains>8)

	-- actions.five_target+=/mortal_strike,if=(!talent.cleave.enabled&dot.deep_wounds.remains<2)|buff.sweeping_strikes.up&buff.overpower.stack=2&(talent.dreadnaught.enabled|buff.executioners_precision.stack=2)

	-- actions.five_target+=/whirlwind,if=debuff.colossus_smash.up|(buff.crushing_assault.up&talent.fervor_of_battle.enabled)
	{ 'Whirlwind', 'inRange.spell(Mortal Strike) && { target.debuff(Collossus Smash) || player.buff(Crushing Assault) && talent(3,2)}', 'target'},
	-- actions.five_target+=/whirlwind,if=buff.deadly_calm.up|rage>60
	{ 'Whirlwind', 'inRange.spell(Mortal Strike) && { player.buff(Deadly Calm) || player.rage > 60}', 'target'},
	-- actions.five_target+=/overpower
	{ 'Overpower', 'inRange.spell', 'target'},
	-- actions.five_target+=/whirlwind
	{ 'Whirlwind', 'inRange.spell(Mortal Strike)', 'target'},
}

local singleTarget = {
	-- actions.single_target=rend,if=remains<=duration*0.3&debuff.colossus_smash.down
	{ 'Rend', 'debuff.duration <= 4 & !debuff(Colossus Smash)', { 'target', 'enemies'}},
	-- actions.single_target+=/skullsplitter,if=rage<60&buff.deadly_calm.down&buff.memory_of_lucid_dreams.down
	{ 'Skullsplitter', 'player.rage < 60 && !player.buff(Deadly Calm) && !player.buff(Memory of Lucid Dreams)', { 'target', 'enemies'}},
	-- actions.single_target+=/ravager,if=!buff.deadly_calm.up&(cooldown.colossus_smash.remains<2|(talent.warbreaker.enabled&cooldown.warbreaker.remains<2))

	-- actions.single_target+=/colossus_smash
	{ 'Colossus Smash', 'inRange.spell', { 'target', 'enemies'}},
	-- actions.single_target+=/warbreaker
	{ 'Warbreaker', 'inRange.spell', { 'target', 'enemies'}},
	-- actions.single_target+=/deadly_calm
	{ 'Deadly Calm', 'inRange.spell(Mortal Strike)', 'target'},
	-- actions.single_target+=/execute,if=buff.sudden_death.react
	{ 'Execute', 'player.buff(Sudden Death) && inRange.spell', { 'target', 'enemies'}},
	-- actions.single_target+=/bladestorm,if=cooldown.mortal_strike.remains&(!talent.deadly_calm.enabled|buff.deadly_calm.down)&((debuff.colossus_smash.up&!azerite.test_of_might.enabled)|buff.test_of_might.up)&buff.memory_of_lucid_dreams.down&rage<40
	{ 'Bladestorm', 'player.spell(Mortal Strikes).cooldown > 0 && { !talent(6,3) || !player.buff(Deadly Calm)} && {{ target.debuff(Colossus Smash)} || player.buff(Test of Might)} && !player.buff(Memory of Lucid Dreams) && player.rage < 40', 'target'},
	-- actions.single_target+=/cleave,if=spell_targets.whirlwind>2
	{ 'Cleave', 'player.area(8).enemies > 2 && inRange.spell(Mortal Strike)', { 'target', 'enemies'}},
	-- actions.single_target+=/overpower,if=(rage<30&buff.memory_of_lucid_dreams.up&debuff.colossus_smash.up)|(rage<70&buff.memory_of_lucid_dreams.down)
	{ 'Overpower', 'inRange.spell && { player.rage < 30 && player.buff(Memory of Lucid Dreams) && target.debuff(Collossus Smash)} || {player.rage < 70 && player.buff(Memory of Lucid Dreams)}', 'target'},
	-- actions.single_target+=/mortal_strike
	{ 'Mortal Strike', 'inRange.spell', { 'target', 'enemies'}},
	-- actions.single_target+=/whirlwind,if=talent.fervor_of_battle.enabled&(buff.memory_of_lucid_dreams.up|debuff.colossus_smash.up|buff.deadly_calm.up)
	{ 'Whirlwind', 'inRange.spell(Mortal Strike) && {talent(3,2) && { player.buff(Memory of Lucid Dreams) || target.debuff(Colossus Smash) || player.debuff(Deadly Calm)}}', 'target'},
	-- actions.single_target+=/overpower
	{ 'Overpower', 'inRange.spell', { 'target', 'enemies'}},
	-- actions.single_target+=/whirlwind,if=talent.fervor_of_battle.enabled&(buff.test_of_might.up|debuff.colossus_smash.down&buff.test_of_might.down&rage>60)
	{ 'Whirlwind', 'inRange.spell(Mortal Strike) && { talent(3,2) && { player.buff(Test of Might) || !target.debuff(Colossus Smash) && !target.debuff(Test of Might) && player.rage > 60}}', 'target'},
	-- actions.single_target+=/slam,if=!talent.fervor_of_battle.enabled
	{ 'Slam', '!talent(3,2) && inRange.spell', { 'target', 'enemies'}},
}


local rotation = {
	{ 'Skullsplitter', 'player.rage < 60 & player.spell(Bladestorm).cooldown > 0', 'target'},
	{ 'Rend', 'debuff.duration <= 4 & !debuff(Colossus Smash)', 'target'},
	{ 'Avatar', 'player.spell(Colossus Smash).cooldown = 0', 'target'},
	{ 'Colossus Smash'},
	{ 'Execute', 'player.buff(Sudden Death)', 'target'},
	{ 'Mortal Strike'},
	{ 'Bladestorm', 'debuff(Colossus Smash)', 'target'},
	{ 'Overpower'},
	{ 'Whirlwind', 'player.rage >= 60 & talent(3,2)', 'target'},
	{ 'Slam', 'player.rage >= 50 & !talent(3,2)', 'target'},
}

local inCombat = {
	{ '/startattack', '!isattacking & target.exists'},
	{ interrupts, 'target.interruptAt(75)'},
	{ utility},
	{ survival},
	{ cooldowns, 'toggle(cooldowns)'},
	--{ cleaveRotation, 'player.area(8).enemies > 1 & player.area(8).enemies < 4 & toggle(aoe)'},
	--{ aoeRotation, 'player.area(8).enemies >= 4 & toggle(aoe)'},
	--{ executeRotation, '{ target.health <= 20 & !talent(3,1) || target.health <= 35 & talent(3,1)}'},
	--{ rotation, 'target.health > 20 & !talent(3,1) || target.health > 35 & talent(3,1)'},


	{ singleTarget},

	{ 'Heroic Throw', 'range > 8 & infront', 'target'},
}

local outCombat = {
	{ utility},
}

NeP.CR:Add(71, {
	name = '[Silver] Warrior - Arms 8.3.7',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.3.7',
 nep_ver = '1.14',
})
