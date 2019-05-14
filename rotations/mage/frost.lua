local GUI = {
	{type = 'header', 	text = 'Generic', align = 'center'},
	{type = 'ruler'},
	{type = 'checkbox',	text = 'Dispel Curses',		key = 'G_Curse', 	default = true},}

local keybinds = {
	{ 'Polymorph', 'keybind(control)', 'mouseover'},
}

local dispel = {
	{ 'Remove Curse', 'curseDispel', { 'tank', 'player', 'lowest', 'friendly'}},
}

local interrupts = {
	{ 'Counterspell', 'target.interruptAt(50) && combat', { 'target', 'enemies'}},
}

local buff = {
	{ 'Arcane Intellect', '!buff.any && !los', { 'tank', 'player', 'lowest', 'friendly'}},
	{ 'Summon Water Elemental', '!player.moving && !talent(1,2) && { pet.dead || !pet.exists}'},
}

local survival = {
	{ 'Ice Barrier', 'buff.duration <= 15 && !buff(Refreshment) && { player.incdmg(5) >= { player.health.max * 0.25}} && combat', 'player'},
	{ 'Freeze', 'target.area(8).enemmies >= 3 && bosscheck = 0 && range <= 40', 'target.ground'},
}

local cooldowns = {
	-- actions.cooldowns=time_warp
	-- actions.cooldowns+=/icy_veins
	{ 'Icy Veins'},
	-- actions.cooldowns+=/mirror_image
	{ 'Mirror Image'},
	-- actions.cooldowns+=/rune_of_power,if=time_to_die>10+cast_time&time_to_die<25
	{ 'Rune of Power', 'ttd > 10 + player.spell.casttime && ttd < 25', 'target'},
	-- # With Glacial Spike, Rune of Power should be used right before the Glacial Spike combo (i.e. with 5 Icicles and a Brain Freeze). When Ebonbolt is off cooldown, Rune of Power can also be used just with 5 Icicles.
	-- actions.cooldowns+=/rune_of_power,if=active_enemies=1&talent.glacial_spike.enabled&buff.icicles.stack=5&(buff.brain_freeze.react|talent.ebonbolt.enabled&cooldown.ebonbolt.remains<cast_time)
	{ 'Rune of Power', 'area(8).enemies = 1 && talent(7,3) && player.buff(Icicles).count = 5 && { player.buff(Brain Freeze) || talent(4,3) && player.spell(Ebonbolt).cooldown < player.spell.casttime', 'target'},
	-- # Without Glacial Spike, Rune of Power should be used before any bigger cooldown (Frozen Orb, Ebonbolt, Comet Storm, Ray of Frost) or when Rune of Power is about to reach 2 charges.
	-- actions.cooldowns+=/rune_of_power,if=active_enemies=1&!talent.glacial_spike.enabled&(prev_gcd.1.frozen_orb|talent.ebonbolt.enabled&cooldown.ebonbolt.remains<cast_time|talent.comet_storm.enabled&cooldown.comet_storm.remains<cast_time|talent.ray_of_frost.enabled&cooldown.ray_of_frost.remains<cast_time|charges_fractional>1.9)
	{ 'Rune of Power', 'area(8).enemies = 1 && !talent(7,3) && { lastgcd(Frozen Orb) || talent(4,3) && player.spell(Ebonbolt).cooldown < player.spell.casttime || talent(6,3) && player.spell(Comet Storm).cooldown < player.spell.casttime || talent(7,2) && player.spell(Ray of Frost).cooldown < player.spell.casttime || player.spell.charges > 1.9}', 'target'},
	-- # With 2 or more targets, use Rune of Power exclusively with Frozen Orb. This is the case even with Glacial Spike.
	-- actions.cooldowns+=/rune_of_power,if=active_enemies>1&prev_gcd.1.frozen_orb
	{ 'Rune of Power', 'area(8).enemies > 1 && lastgcd(Frozen Orb)', 'target'},
	-- actions.cooldowns+=/potion,if=prev_gcd.1.icy_veins|target.time_to_die<70
	-- actions.cooldowns+=/use_items
	{ '#trinket1'},
	{ '#trinket2'},
	-- actions.cooldowns+=/blood_fury
	{ 'Blood Fury'},
	-- actions.cooldowns+=/berserking
	{ 'Berserking'},
	-- actions.cooldowns+=/lights_judgment
	{ 'Lights Judgment'},
	-- actions.cooldowns+=/fireblood
	{ 'Fireblood'},
	-- actions.cooldowns+=/ancestral_call
	{ 'Ancestral Call'},
}

local movement = {
	-- actions.movement=blink,if=movement.distance>10
	-- actions.movement+=/ice_floes,if=buff.ice_floes.down
	{ 'Ice Floes', '!buff', 'player'},
}

local aoe = {
	-- actions.aoe=frozen_orb
	{ 'Frozen Orb', 'infront && range <= 40', 'target'},
	-- actions.aoe+=/blizzard
	{ 'Blizzard', '!player.moving', 'target.ground'},
	-- actions.aoe+=/comet_storm
	{ 'Comet Storm'},
	-- actions.aoe+=/ice_nova
	{ 'Ice Nova'},
	-- # Simplified Flurry conditions from the ST action list. Since the mage is generating far less Brain Freeze charges, the exact condition here isn't all that important.
	-- actions.aoe+=/flurry,if=prev_gcd.1.ebonbolt|buff.brain_freeze.react&(prev_gcd.1.frostbolt&(buff.icicles.stack<4|!talent.glacial_spike.enabled)|prev_gcd.1.glacial_spike)
	{ 'Flurry', '!player.moving && { lastgcd(Ebonbolt) || player.buff(Brain Freeze) && { lastgcd(Frostbolt) && { player.buff(Icicles).count < 4 || !talent(7,3) || lastgcd(Glacial Spike)}}}', 'target'},
	-- actions.aoe+=/ice_lance,if=buff.fingers_of_frost.react
	{ 'Ice Lance', 'player.buff(Fingers of Frost)', 'target'},
	-- # The mage will generally be generating a lot of FoF charges when using the AoE action list. Trying to delay Ray of Frost until there are no FoF charges and no active Frozen Orbs would lead to it not being used at all.
	-- actions.aoe+=/ray_of_frost
	{ 'Ray of Frost', '!player.moving', 'target'},
	-- actions.aoe+=/ebonbolt
	{ 'Ebonbolt', '!player.moving', 'target'},
	-- actions.aoe+=/glacial_spike
	{ 'Glacial Spike', '!player.moving', 'target'},
	-- # Using Cone of Cold is mostly DPS neutral with the AoE target thresholds. It only becomes decent gain with roughly 7 or more targets.
	-- actions.aoe+=/cone_of_cold
	-- actions.aoe+=/frostbolt
	{ 'Frostbolt', '!player.moving', 'target'},
	-- actions.aoe+=/call_action_list,name=movement
	{ movement, 'player.moving'},
	-- actions.aoe+=/ice_lance
	{ 'Ice Lance'},
}

local single = {
	-- # In some situations, you can shatter Ice Nova even after already casting Flurry and Ice Lance. Otherwise this action is used when the mage has FoF after casting Flurry, see above.
	-- actions.single=ice_nova,if=cooldown.ice_nova.ready&debuff.winters_chill.up
	{ 'Ice Nova', 'debuff(Winter\'s Chill)', 'target'},
	-- # Without GS, the mage just tries to shatter as many Frostbolts and Ebonbolts as possible. Forcing shatter on Frostbolt is still a small gain, so is not caring about FoF. Ice Lance is too weak to warrant delaying Brain Freeze Flurry.
	-- actions.single+=/flurry,if=!talent.glacial_spike.enabled&(prev_gcd.1.ebonbolt|buff.brain_freeze.react&prev_gcd.1.frostbolt)
	{ 'Flurry', '{ !talent(7,3) && { lastgcd(Ebonbolt) || player.buff(Brain Freeze) && lastgcd(Frostbolt)}}', 'target'},
	-- # With GS, the mage only shatters Frostbolt that would put them at 1-3 Icicle stacks, Ebonbolt if it would waste Brain Freeze charge (i.e. when the mage starts casting Ebonbolt with Brain Freeze active) and of course Glacial Spike. Difference between shattering Frostbolt with 1-3 Icicles and 1-4 Icicles is small, but 1-3 tends to be better in more situations (the higher GS damage is, the more it leans towards 1-3).
	-- actions.single+=/flurry,if=talent.glacial_spike.enabled&buff.brain_freeze.react&(prev_gcd.1.frostbolt&buff.icicles.stack<4|prev_gcd.1.glacial_spike|prev_gcd.1.ebonbolt)
	{ 'Flurry', '{ talent(7,3) && player.buff(Brain Freeze) && { lastgcd(Frostbolt) && player.buff(Icicles).count < 4 || lastgcd(Glacial Spike) || lastgcd(Ebonbolt)}}', 'target'},
	-- actions.single+=/frozen_orb
	{ 'Frozen Orb', 'infront && range <= 40', 'target'},
	-- # With Freezing Rain and at least 2 targets, Blizzard needs to be used with higher priority to make sure you can fit both instant Blizzards into a single Freezing Rain. Starting with three targets, Blizzard leaves the low priority filler role and is used on cooldown (and just making sure not to waste Brain Freeze charges) with or without Freezing Rain.
	-- actions.single+=/blizzard,if=active_enemies>2|active_enemies>1&cast_time=0&buff.fingers_of_frost.react<2
	{ 'Blizzard', '!player.moving && { area(8).enemies > 2 || area(8).enemies > 1 && player.spell.casttime = 0 && player.buff(Fingers of Frost).count < 2}', 'target.ground'},
	-- # Trying to pool charges of FoF for anything isn't worth it. Use them as they come.
	-- actions.single+=/ice_lance,if=buff.fingers_of_frost.react
	{ 'Ice Lance', 'player.buff(Fingers of Frost)', 'target'},
	-- actions.single+=/comet_storm
	{ 'Comet Storm'},
	-- # Without GS, Ebonbolt is used on cooldown. With GS, Ebonbolt is only used to fill in the blank spots when fishing for a Brain Freeze proc, i.e. the mage reaches 5 Icicles but still doesn't have a Brain Freeze proc.
	-- actions.single+=/ebonbolt,if=!talent.glacial_spike.enabled|buff.icicles.stack=5&!buff.brain_freeze.react
	{ 'Ebonbolt', '!player.moving && { !talent(7,3) || player.buff(Icicles).count = 5 && !player.buff(Brain Freeze)}', 'target'},
	-- # Ray of Frost is used after all Fingers of Frost charges have been used and there isn't active Frozen Orb that could generate more. This is only a small gain against multiple targets, as Ray of Frost isn't too impactful.
	-- actions.single+=/ray_of_frost,if=!action.frozen_orb.in_flight&ground_aoe.frozen_orb.remains=0
	--{ 'Ray of Frost', '
	-- # Blizzard is used as low priority filler against 2 targets. When using Freezing Rain, it's a medium gain to use the instant Blizzard even against a single target, especially with low mastery.
	-- actions.single+=/blizzard,if=cast_time=0|active_enemies>1
	{ 'Blizzard', '!player.moving && { player.spell.casttime = 0 || target.area(8).enemies > 1}', 'target.ground'},
	-- # Glacial Spike is used when there's a Brain Freeze proc active (i.e. only when it can be shattered). This is a small to medium gain in most situations. Low mastery leans towards using it when available. When using Splitting Ice and having another target nearby, it's slightly better to use GS when available, as the second target doesn't benefit from shattering the main target.
	-- actions.single+=/glacial_spike,if=buff.brain_freeze.react|prev_gcd.1.ebonbolt|active_enemies>1&talent.splitting_ice.enabled
	{ 'Glacial Spike', 'player.buff(Brain Freeze) || lastgcd(Ebonbolt) || area(8).enemeis > 1 7 talent(6,2)', 'target'},
	-- actions.single+=/ice_nova
	{ 'Ice Nova'},
	-- actions.single+=/flurry,if=azerite.winters_reach.enabled&!buff.brain_freeze.react&buff.winters_reach.react
	{ 'Flurry', '!player.buff(Brain Freeze) && player.buff(Winter\'s Reach)', 'target'},
	-- actions.single+=/frostbolt
	{ 'Frostbolt', '!player.moving', 'target'},
	-- actions.aoe+=/call_action_list,name=movement
	{ movement, 'player.moving'},
	-- actions.aoe+=/ice_lance
	{ 'Ice Lance'},
}

local rotation = {
	-- # Executed every time the actor is available.
	-- actions=counterspell
	{ interrupts, 'target.interruptAt(50)'},
	-- # If the mage has FoF after casting instant Flurry, we can delay the Ice Lance and use other high priority action, if available.
	-- actions+=/ice_lance,if=prev_gcd.1.flurry&brain_freeze_active&!buff.fingers_of_frost.react
	{ 'Ice Lance', 'lastgcd(Flurry) && player.buff(Brain Freeze) && !player.buff(Fingers of Frost)', 'target'},
	-- actions+=/call_action_list,name=cooldowns
	{ cooldowns, 'toggle(cooldowns) && bosscheck >= 1'},
	-- # The target threshold isn't exact. Between 3-5 targets, the differences between the ST and AoE action lists are rather small. However, Freezing Rain prefers using AoE action list sooner as it benefits greatly from the high priority Blizzard action.
	-- actions+=/call_action_list,name=aoe,if=active_enemies>3&talent.freezing_rain.enabled|active_enemies>4
	{ aoe, 'toggle(aoe) && { target.area(8).enemies > 3 && talent(6,1) || target.area(8).enemies > 4}'},
	-- actions+=/call_action_list,name=single
	{ single},
}

local preCombat = {
	{ 'Frostbolt', 'dbm(Pull in) <= 2 && dbm(Pull in) > 0', 'target'},
}

local inCombat = {
	{ keybinds},
	{ buff},
	{ dispel, 'UI(G_Curse)'},
	{ survival},
	{ rotation, 'infront(player)'},
}

local outCombat = {
	{ keybinds},
	{'%pause', 'player.buff(Refreshment)'},
	{ buff},
	{ survival},
	{ preCombat},
}

NeP.CR:Add(64, {
	name = 'MAGE - Frost',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad,
 wow_ver = '8.0.1',
 nep_ver = '1.11',
})
