local GUI = {
	-- Survival
	{type = 'header', text = 'Survival', align = 'center'},
	{type = 'checkspin', text = 'Crimson Vial', key = 'cv', default_check = true, default_spin = 65},
	{type = 'checkspin', text = 'Riposte', key = 'rip', default_check = true, default_spin = 35},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'ruler'},{type = 'spacer'},} 

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- ')
	print('|cffADFF2F --- ')
	print('|cffADFF2F ----------------------------------------------------------------------|r')

end

local keybinds = {
	{ 'Grappling Hook', 'keybind(control)', 'cursor.ground'},
}

local interrupts = {
	{ 'Kick'},
	{ 'Gouge', '!player.lastcast(Kick)'},
	{ 'Between the Eyes', '!player.lastcast(Kick) & player.combopoints >= 1'},
	{ 'Arcane Torrent', 'target.range <= 8 & spell(Kick).cooldown > gcd & !prev_gcd(Rebuke)'},
}

local survival = {
	{ 'Crimson Vial', 'player.health <= UI(cv) & player.energy >= 35'},
	{ 'Riposte', 'player.health <= UI(rip)'},
}

local cooldowns = {
	{ 'Adrenaline Rush'},
	{ 'Curse of the Dreadblades', 'player.energy >= 60'},
	--{ 'Vanish', 'player.combopoints <= 4'},
}

local singleTarget = {
	{ 'Tricks of the Trade', '!focus.buff', 'focus'},
	{ 'Tricks of the Trade', '!tank.buff', 'tank'},
	
	{ 'Blade Flurry', 'player.area(7).enemies >= 2 & !player.buff(Blade Flurry) & toggle(aoe)'},
	{ 'Blade Flurry', 'player.area(7).enemies <= 1 & player.buff(Blade Flurry)'},
	{ 'Blade Flurry', '!toggle(aoe) & player.buff(Blade Flurry)'},
	
	-- Roll the Bones
	{ 'Roll the Bones', 'player.combopoints >= 4 & player.rtb <= 1'},
	
	{ 'Ghostly Strike', 'target.debuff.duration <= 4.5 & player.combopoints <= 5'},
		
	{ 'Saber Slash', 'player.buff(Hidden Blade) & player.combopoints <= 4'},
	{ cooldowns, 'toggle(cooldowns)'},
	{ 'Marked for Death', 'player.combopoints <= 1'},
	{ 'Run Through', 'player.combopoints >= 5 & player.buff(Broadsides)'},
	{ 'Run Through', 'player.combopoints >= 6'},
	{ 'Pistol Shot', 'player.buff(Opportunity) & player.combopoints <= 4'},
	{ 'Saber Slash', 'player.combopoints <= 5'}
}

local preCombat = {
	{ 'Marked for Death', 'pull_timer <= 10'},
	{ 'Tricks of the Trade', '!focus.buff & pull_timer <= 4', 'focus'},
	{ 'Tricks of the Trade', '!tank.buff & pull_timer <= 4', 'tank'},
	{ 'Roll the Bones', 'pull_timer <= 2 & player.rtb <= 1'},
	-- Potion goes here
	--{ 'Ambush', 'pull_timer <= 0'},
}

--[[
	Always open from Stealth Icon Stealth. This opener assumes you have  Icon Hidden Blade.

	-Cast Marked for Death Icon Marked for Death on the boss 10 seconds before the pull if no short lifespan adds will spawn in the opener.
	-Cast Roll the Bones Icon Roll the Bones at 2 seconds before the countdown.
	Use Potion of the Old War Icon Potion of the Old War potion.
	Cast Ambush Icon Ambush.
	-Cast Ghostly Strike Icon Ghostly Strike.
	If Bloodlust Icon Bloodlust is up, cast Saber Slash Icon Saber Slash (otherwise skip this Saber Slash).
	Activate Adrenaline Rush Icon Adrenaline Rush.
	Cast Saber Slash Icon Saber Slash.
	If your current Roll the Bones Icon Roll the Bones is 1 of or any combination of True Bearing Icon True Bearing, Shark Infested Waters Icon Shark Infested Waters, Jolly Roger Icon Jolly Roger, or Grand Melee Icon Grand Melee, then cast Run Through Icon Run Through. If not, instead cast Roll the Bones Icon Roll the Bones.
	Pool Energy until ~60 and activate  Icon Curse of the Dreadblades.
	Alternate between Saber Slash Icon Saber Slash and Run Through Icon Run Through. Only spend your Opportunity Icon Opportunity procs if you have insufficient Energy to cast Saber Slash Icon Saber Slash.
	With your last Saber Slash Icon Saber Slash during  Icon Curse of the Dreadblades you should reroll if you have only a single buff.
	Keep re-rolling until you have 2 buffs or True Bearing Icon True Bearing.
]]--

local inCombat = {
	{ 'Ambush', 'player.buff(Stealth)'},
	{ '/startattack', '!isattacking & !player.buff(Stealth)'},
	{ keybinds},
	{ survival},
	{ interrupts, 'target.interruptAt(30)'},
	{ singleTarget, '!player.buff(Stealth)'}
}

local outCombat = {
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(260, {
	name = '[Silver] Rogue - Outlaw',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
