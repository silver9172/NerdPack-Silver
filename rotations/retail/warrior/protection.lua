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
	{ 'Pummel', 'interruptAt(35)', { 'target', 'enemies'}},
}

local utility = {
	{ 'Battle Shout', '!buff(Battle Shout).any', 'friendly'},
}

local activeMitigation = {
	{ 'Victory Rush', 'player.health <= 70'},
	
	{ 'Shield Block', 'player.spell.charges >= 1.9', 'target'}, -- Prevent cap
	{ 'Ignore Pain', 'player.rage >= 70'},
	--{ 'Shield Block', '!player.buff & player.incdmg.phys(4) >= { player.health.max * 0.2 }'},
	
	{ 'Demoralizing Shout', 'talent(6,1) && player.rage < 60 && inRange.spell(Shield Slam) && infront', 'target'},
	
	{ 'Demoralizing Shout', 'player.health <= 75 & player.incdmg(4) >= { player.health.max * 0.3 }', 'target'}, 
	{ 'Last Stand', 'player.health <= 50 & player.incdmg(4) >= { player.health.max * 0.6 }'}, 
}

local cooldowns = {
	{ 'Stoneform', 'player.incdmg(4) >= { player.health.max * 0.2 }'},
	{ 'Avatar'}, 
	-- { 'Beserker Rage'},
}

local avatarRotation = {
	{ 'Shield Slam', 'inRange.spell && infront', 'target'},
	{ 'Thunder Clap', 'inRange.spell(Shield Slam) && infront', 'target'},
	{ 'Revenge', 'player.buff(Revenge!) && inRange.spell && infront', 'target'},
	{ 'Devastate', 'inRange.spell && infront', 'target'},	
}

local aoeRotation = {
	{ 'Thunder Clap', 'inRange.spell(Shield Slam) && infront', 'target'},
	{ 'Revenge', 'inRange.spell(Shield Slam) && infront', 'target'},	
	{ 'Shield Slam', 'inRange.spell && infront', 'target'},
	{ 'Devastate', 'inRange.spell && infront', 'target'},	
}

local rotation = {
	{ 'Shield Slam', 'inRange.spell && infront', 'target'},
	{ 'Thunder Clap', 'inRange.spell(Shield Slam) && infront', 'target'},
	{ 'Revenge', 'player.buff(Revenge!) && inRange.spell(Shield Slam) && infront', 'target'},
	{ 'Devastate', 'inRange.spell && infront', 'target'},	
}

local inCombat = {
	{ '/startattack', '!isattacking & target.exists'},
	{ utility}, 
	{ interrupts, 'target.interruptAt(35)'},
	{ activeMitigation},
	{ cooldowns, 'toggle(cooldowns)'},
	{ avatarRotation, 'player.buff(Avatar) & talent(3,2)'},
	{ aoeRotation, 'player.area(8).enemies >= 2'},
	{ rotation, 'player.area(8).enemies < 2'},
	{ 'Heroic Throw', 'inRange.spell && infront', 'target'}, 
}

local outCombat = {
	{ utility}, 
}

NeP.CR:Add(73, {
	name = '[Silver] Warrior - Protection',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
