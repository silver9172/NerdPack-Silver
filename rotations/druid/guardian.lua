
local GUI = {
}

local exeOnLoad = function()
	NeP.Interface:AddToggle({
		key = 'dps',
		name = 'DPS',
		text = 'DPS while healing',
		icon = 'Interface\\Icons\\spell_holy_crusaderstrike',
	})
	NeP.Interface:AddToggle({
		key = 'disp',
		name = 'Dispell',
		text = 'ON/OFF Dispel All',
		icon = 'Interface\\ICONS\\spell_holy_purify', 
	})
end

local PreCombat = {

}

local Interrupts = {
	{'Skull Bash'},
	{'Typhoon', 'talent(4,3)&cooldown(Skull Bash).remains>gcd'},
	{'Mighty Bash', 'talent(4,1)&cooldown(Skull Bash).remains>gcd'},
}

local survival = {

}

local cooldowns = {

}

local combat = {
	{ 'Moonfire', 'player.buff(Galactic Guardian)'},
	{ 'Mangle'},
	{ 'Thrash'},
	{ 'Pulverize', 'target.debuff(Thrash).count >= 2'},
	{ 'Moonfire', '!target.debuff'},
	{ 'Swipe'},
	{ '&Maul', 'player.rage >= 90'},
}

local Keybinds = {
	-- Pause
	{'%pause', 'keybind(alt)'},
}

local inCombat = {
	{ combat}
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(104, {
	name = '[Silver] Druid - Guardian',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
