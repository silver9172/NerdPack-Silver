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
	print('|cffADFF2F --- |rSilver Warrior |cffADFF2FProtection |r')
	print('|cffADFF2F --- |rWIP')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {
	{ 'Heroic Leap', 'keybind(lcontrol)', 'target.ground'}
}

local interrupts = {
	{ 'Pummel'},
}

local utility = {
	-- Check player
	{ 'Battle Shout', '!buff.any', 'player'},
	
	-- Check party/raid
	{ 'Battle Shout', '!buff.any', 'lowest'},
	{ 'Battle Shout', '!buff.any', 'lowest2'},
	{ 'Battle Shout', '!buff.any', 'lowest3'},
	{ 'Battle Shout', '!buff.any', 'lowest4'},
	{ 'Battle Shout', '!buff.any', 'lowest5'},
	{ 'Battle Shout', '!buff.any', 'lowest6'},
	{ 'Battle Shout', '!buff.any', 'lowest7'},
	{ 'Battle Shout', '!buff.any', 'lowest8'},
	{ 'Battle Shout', '!buff.any', 'lowest9'},
	{ 'Battle Shout', '!buff.any', 'lowest10'},
	{ 'Battle Shout', '!buff.any', 'lowest11'},
	{ 'Battle Shout', '!buff.any', 'lowest12'},
	{ 'Battle Shout', '!buff.any', 'lowest13'},
	{ 'Battle Shout', '!buff.any', 'lowest14'},
	{ 'Battle Shout', '!buff.any', 'lowest15'},
	{ 'Battle Shout', '!buff.any', 'lowest16'},
	{ 'Battle Shout', '!buff.any', 'lowest17'},
	{ 'Battle Shout', '!buff.any', 'lowest18'},
	{ 'Battle Shout', '!buff.any', 'lowest19'},
	{ 'Battle Shout', '!buff.any', 'lowest20'},
	{ 'Battle Shout', '!buff.any', 'lowest21'},
	{ 'Battle Shout', '!buff.any', 'lowest22'},
	{ 'Battle Shout', '!buff.any', 'lowest23'},
	{ 'Battle Shout', '!buff.any', 'lowest24'},
	{ 'Battle Shout', '!buff.any', 'lowest25'},
}

local interrupts = {
	{ 'Pummel'},
	{ 'Arcane Torrent', 'target.range <=8 & spell(Pummel).cooldown > gcd & !prev_gcd(Pummel)'},
}

local activeMitigation = {
	{ 'Victory Rush', 'player.health <= 70'},
	
	{ 'Shield Block', 'player.spell.charges >= 2', 'target'}, -- Prevent cap
	--{ 'Shield Block', '!player.buff & player.incdmg.phys(4) >= { player.health.max * 0.2 }'},
	
	{ 'Demoralizing Shout', 'player.health <= 75 & player.incdmg(4) >= { player.health.max * 0.3 }', 'target'}, 
	{ 'Last Stand', 'player.health <= 50 & player.incdmg(4) >= { player.health.max * 0.6 }'}, 
}

local cooldowns = {
	{ 'Stoneform', 'player.incdmg(4) >= { player.health.max * 0.2 }'},
	{ 'Avatar'}, 
	-- { 'Beserker Rage'},
}

local avatarRotation = {
	{ 'Shield Slam'},
	{ 'Thunder Clap', 'range <= 8'},
	{ 'Revenge', 'player.buff(Revenge!)'},
	{ 'Ignore Pain', 'ignorepain < { player.health.max * 0.2 }'},
	{ 'Devastate'},	
}

local aoeRotation = {
	{ 'Thunder Clap', 'range < 8', 'target'},
	{ 'Revenge'},
	{ 'Shield Slam'},
	{ 'Ignore Pain', 'ignorepain < { player.health.max * 0.2 }'},
	{ 'Devastate'},
}

local rotation = {
	{ 'Shield Slam'},
	{ 'Thunder Clap', 'range <= 8'},
	{ 'Revenge', 'player.buff(Revenge!)'},
	{ 'Ignore Pain', 'ignorepain < { player.health.max * 0.2 }'},
	{ 'Devastate'},
}

local inCombat = {
	{ '/startattack', '!isattacking & target.exists'},
	{ interrupts, 'target.interruptAt(75)'},
	{ activeMitigation},
	{ cooldowns, 'toggle(cooldowns) & target.inmelee'},
	{ 'Heroic Throw', '!inmelee', 'target'}, 
	{ 'Ignore Pain', 'rage >= 90', 'player'}, -- Prevent rage cap
	{ avatarRotation, 'player.buff(Avatar) & talent(3,2)'},
	{ aoeRotation, 'player.area(8).enemies >= 2 & target.infront'},
	{ rotation, 'player.area(8).enemies < 2 & target.infront'},
}

local outCombat = {

}

NeP.CR:Add(73, {
	name = '[Silver] Warrior - Protection',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
