local GUI = {
	-- Sotr
	{type = 'header', text = 'Shield of the Righteous', align = 'center'},
	{type = 'spinner', text = 'Use 2nd Charge', key = 'sotr', default_spin = 75},
	{type = 'ruler'},{type = 'spacer'},
	
	-- Light of the Protector
	{type = 'header', text = 'Light of the Protector', align = 'center'},
	{type = 'spinner', text = 'Light of the Protector', key = 'lotp', default_spin = 65},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'checkspin', text = 'Use Ardent Defender', key = 'ad', default_check = true, default_spin = 25},
	{type = 'checkspin', text = 'Use Eye of Tyr', key = 'eye', default_check = true, default_spin = 60},
	{type = 'checkspin', text = 'Use Guardian of Ancient Kings', key = 'ak', default_check = true, default_spin = 35},
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
	{ 'Battle Shout', 'buff.duration <= 600', 'player'},
	
	-- Check party/raid
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest2'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest3'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest4'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest5'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest6'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest7'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest8'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest9'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest10'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest11'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest12'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest13'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest14'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest15'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest16'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest17'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest18'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest19'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest20'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest21'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest22'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest23'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest24'},
	{ 'Battle Shout', 'buff.duration <= 600', 'lowest25'},
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
	{ cleaveRotation, 'player.area(8).enemies > 1 & player.area(8).enemies < 4 & toggle(aoe)'}, 
	{ aoeRotation, 'player.area(8).enemies >= 4 & toggle(aoe)'},
	{ executeRotation, '{ target.health <= 20 & !talent(3,1) || target.health <= 35 & talent(3,1)}'}, 
	{ rotation, 'target.health > 20 & !talent(3,1) || target.health > 35 & talent(3,1)'},
	{ 'Heroic Throw', 'range > 8 & infront', 'target'}, 
}

local outCombat = {

}

NeP.CR:Add(71, {
	name = '[Silver] Warrior - Arms',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.0.1',
 nep_ver = '1.11',
})
