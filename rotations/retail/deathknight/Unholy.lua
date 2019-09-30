local GUI = {
	-- General
	{type = 'header', 		text = 'General', 					align = 'center'},

	{type = 'ruler'},{type = 'spacer'},
	
	-- Survival
	{type = 'header', 		text = 'Survival', 					align = 'center'},
	{type = 'spinner', 		text = 'Death Strike', 		key = 'ds', 	default_spin = 35},
	{type = 'ruler'},{type = 'spacer'},
	
	--Cooldowns
	{type = 'header', 		text = 'Cooldowns when toggled on', align = 'center'},
	{type = 'ruler'},{type = 'spacer'},} 

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print('|cffADFF2F --- Supported Talents')
	print('|cffADFF2F --- WIP')
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {
	{ 'Raise Ally', 'dead & friend & range <= 40 & keybind(lcontrol)', 'mouseover'},
}

local interrupts = {
	{ 'Mind Freeze'},
}

local preCombat = {

}

local survival = {
	{ 'Death Strike', 'player.health <= UI(ds) & player.buff(Dark Succor)', 'target'},
	{ 'Death Strike', 'player.health <= UI(ds) & player.runicpower > = 45', 'target'},
}

local standard = {
	--actions.standard=festering_strike,if=debuff.festering_wound.stack<=2&runic_power.deficit>5
	{ 'Festering Strike', 'debuff(Festering Wound).count <= 2 & deficit > 5', 'target'},
	--actions.standard+=/death_coil,if=!buff.necrosis.up&talent.necrosis.enabled&rune<=3
	{ 'Death Coil', '!player.buff(Necrosis) & talent(6,2) & runes <= 3', 'target'},
	--actions.standard+=/scourge_strike,if=buff.necrosis.react&debuff.festering_wound.stack>=1&runic_power.deficit>9
	{ 'Scourge Strike', 'player.buff(Necrosis) & debuff(Festering Wound).count >= 1 & deficit > 9', 'target'},
	--actions.standard+=/clawing_shadows,if=buff.necrosis.react&debuff.festering_wound.stack>=1&runic_power.deficit>9
	{ 'Clawing Shadows', 'player.buff(Necrosis) & debuff(Festering Wound).count >= 1 & deficit > 9', 'target'},
	--actions.standard+=/scourge_strike,if=buff.unholy_strength.react&debuff.festering_wound.stack>=1&runic_power.deficit>9
	{ 'Scourge Strike', 'player.buff(Unholy Strength) & debuff(Festering Wound).count >= 1 & deficit > 9', 'target'},
	--actions.standard+=/clawing_shadows,if=buff.unholy_strength.react&debuff.festering_wound.stack>=1&runic_power.deficit>9
	{ 'Clawing Shadows', 'player.buff(Unholy Strength) & debuff(Festering Wound).count >= 1 & deficit > 9', 'target'},
	--actions.standard+=/scourge_strike,if=rune>=2&debuff.festering_wound.stack>=1&runic_power.deficit>9
	{ 'Scourge Strike', 'runes >= 2 & debuff(Festering Wound).count >= 1 & deficit > 9', 'target'},
	--actions.standard+=/clawing_shadows,if=rune>=2&debuff.festering_wound.stack>=1&runic_power.deficit>9
	{ 'Clawing Shadows', 'runes >= 2 & debuff(Festering Wound).count >= 1 & deficit > 9', 'target'},
	--actions.standard+=/death_coil,if=talent.shadow_infusion.enabled&talent.dark_arbiter.enabled&!buff.dark_transformation.up&cooldown.dark_arbiter.remains>10
	{ 'Death Coil', 'talent(6,1) & talent(7,1) & !pet.buff(Dark Transformation) & player.spell(Dark Arbiter).cooldown > 10', 'target'},
	--actions.standard+=/death_coil,if=talent.shadow_infusion.enabled&!talent.dark_arbiter.enabled&!buff.dark_transformation.up
	{ 'Death Coil', 'talent(6,1) & !talent(7,1) & !pet.buff(Dark Transformation)', 'target'},
	--actions.standard+=/death_coil,if=talent.dark_arbiter.enabled&cooldown.dark_arbiter.remains>10
	{ 'Death Coil', 'talent(7,1) & player.spell(Dark Arbiter).cooldown > 10', 'target'},
	--actions.standard+=/death_coil,if=!talent.shadow_infusion.enabled&!talent.dark_arbiter.enabled
	{ 'Death Coil', '!talent(6,1) & !talent(7,1)', 'target'},
}

local aoe = {
	--actions.aoe=death_and_decay,if=spell_targets.death_and_decay>=2
	{ 'Death and Decay', 'target.area(10).enemies >= 2', 'target.ground'},
	--actions.aoe+=/epidemic,if=spell_targets.epidemic>4
	{ 'Epidemic', 'count(Virulent Plague).enemies.debuffs > 4'},
	--actions.aoe+=/scourge_strike,if=spell_targets.scourge_strike>=2&(dot.death_and_decay.ticking|dot.defile.ticking)
	{ 'Scourge Strike', 'area(10).enemies >= 2 & { player.buff(Death and Decay) || player.buff(Defile) }', 'target'},
	--actions.aoe+=/clawing_shadows,if=spell_targets.clawing_shadows>=2&(dot.death_and_decay.ticking|dot.defile.ticking)
	{ 'Clawing Shadows', 'area(10).enemies >= 2 & { player.buff(Death and Decay) || player.buff(Defile) }', 'target'},
	--actions.aoe+=/epidemic,if=spell_targets.epidemic>2
	{ 'Epidemic', 'count(Virulent Plague).enemies.debuffs > 2'},
}

local generic = {
	--actions.generic=dark_arbiter,if=!equipped.137075&runic_power.deficit<30
	{ 'Dark Arbiter', 'toggle(cooldowns) & !equipped(137075) & deficit < 30', 'target'},
	--actions.generic+=/dark_arbiter,if=equipped.137075&runic_power.deficit<30&cooldown.dark_transformation.remains<2
	{ 'Dark Arbiter', 'toggle(cooldowns) & equipped(137075) & deficit < 30 & player.spell(Dark Transformation).cooldown < 2', 'target'},
	--actions.generic+=/summon_gargoyle,if=!equipped.137075,if=rune<=3
	{ 'Summon Gargoyle', 'toggle(cooldowns) & !equipped(137075) & runes <= 3', 'target'},
	--actions.generic+=/chains_of_ice,if=buff.unholy_strength.up&buff.cold_heart.stack>19
	{ 'Chains of Ice', 'player.buff(Unholy Strength) & player.buff(Cold Heart).count > 19', 'target'},
	--actions.generic+=/summon_gargoyle,if=equipped.137075&cooldown.dark_transformation.remains<10&rune<=3
	{ 'Summon Gargoyle', 'toggle(cooldowns) & equipped(137075) & player.spell(Dark Transformation).cooldown < 10 & runes <= 3', 'target'},
	--actions.generic+=/soul_reaper,if=debuff.festering_wound.stack>=6&cooldown.apocalypse.remains<4
	{ 'Soul Reaper', 'debuff(Festering Wound).count >= 6 & player.spell(Apocalypse).cooldown < 4', 'target'},
	--actions.generic+=/apocalypse,if=debuff.festering_wound.stack>=6
	{ 'Apocalypse', 'toggle(cooldowns) & debuff(Festering Wound).count >= 6', 'target'},
	--actions.generic+=/death_coil,if=runic_power.deficit<10
	{ 'Death Coil', 'player.deficit < 10', 'target'},
	--actions.generic+=/death_coil,if=!talent.dark_arbiter.enabled&buff.sudden_doom.up&!buff.necrosis.up&rune<=3
	{ 'Death Coil', '!talent(7,1) & player.buff(Sudden Doom) & !player.buff(Necrosis) & runes <= 3', 'target'},
	--actions.generic+=/death_coil,if=talent.dark_arbiter.enabled&buff.sudden_doom.up&cooldown.dark_arbiter.remains>5&rune<=3
	{ 'Death Coil', 'talent(7,1) & player.buff(Sudden Doom) & { player.spell(Dark Arbiter).cooldown > 5 & toggle(cooldowns) || !toggle(cooldowns) } & runes <= 3', 'target'},
	--actions.generic+=/festering_strike,if=debuff.festering_wound.stack<6&cooldown.apocalypse.remains<=6
	{ 'Festering Strike', 'debuff(Festering Wound).count < 6 & player.spell(Apocalypse).cooldown <= 6 & toggle(cooldowns)', 'target'},
	--actions.generic+=/soul_reaper,if=debuff.festering_wound.stack>=3
	{ 'Soul Reaper', 'debuff(Festering Wound).count >= 3', 'target'},
	--actions.generic+=/festering_strike,if=debuff.soul_reaper.up&!debuff.festering_wound.up
	{ 'Festering Strike', 'debuff(Soul Reaper) & !debuff(Festering Wound)', 'target'},
	--actions.generic+=/scourge_strike,if=debuff.soul_reaper.up&debuff.festering_wound.stack>=1
	{ 'Scourge Strike', 'debuff(Soul Reaper) & debuff(Festering Wound).count >= 1', 'target'},
	--actions.generic+=/clawing_shadows,if=debuff.soul_reaper.up&debuff.festering_wound.stack>=1
	{ 'Clawing Shadows', 'debuff(Soul Reaper) & debuff(Festering Wound).count >= 1', 'target'},
	--actions.generic+=/defile
	{ 'Defile', nil, 'target.ground'},
	--actions.generic+=/call_action_list,name=aoe,if=active_enemies>=2
	{ aoe, 'toggle(aoe)'}, 
	--actions.generic+=/call_action_list,name=instructors,if=equipped.132448
	--actions.generic+=/call_action_list,name=standard,if=!talent.castigator.enabled&!equipped.132448
	{ standard, '!talent(3,2) & !equipped(132448)'},
	--actions.generic+=/call_action_list,name=castigator,if=talent.castigator.enabled&!equipped.132448
}

local valkyr = {
	--actions.valkyr=death_coil
	{ 'Death Coil', nil, 'target'},
	--actions.valkyr+=/apocalypse,if=debuff.festering_wound.stack=8
	{ 'Apocalypse', 'debuff(Festering Wound).count = 8', 'target'},
	--actions.valkyr+=/festering_strike,if=debuff.festering_wound.stack<8&cooldown.apocalypse.remains<5
	{ 'Festering Strike', 'debuff(Festering Wound).count < 8 & player.spell(Apocalypse).cooldown < 5', 'target'},
	--actions.valkyr+=/call_action_list,name=aoe,if=active_enemies>=2
	{ aoe, 'toggle(aoe)'}, 
	--actions.valkyr+=/festering_strike,if=debuff.festering_wound.stack<=3
	{ 'Festering Strike', 'debuff(Festering Wound).count <= 3', 'target'},
	--actions.valkyr+=/scourge_strike,if=debuff.festering_wound.up
	{ 'Scourge Strike', 'debuff(Festering Wound)', 'target'},
	--actions.valkyr+=/clawing_shadows,if=debuff.festering_wound.up
	{ 'Clawing Shadows', 'debuff(Festering Wound)', 'target'},
}

local pet = {
	{ 'Raise Dead', '!pet.exists || pet.dead'},
}

local inCombat = {
	{ keybinds},
	{ pet},
	{ survival}, 
	--actions=auto_attack
	{ '/startattack', '!isattacking & target.enemy'},
	--actions+=/mind_freeze
	{ interrupts, 'target.interruptAt(35)'},
	--actions+=/arcane_torrent,if=runic_power.deficit>20
	{ 'Arcane Torrent', 'player.deficit > 20'},
	--actions+=/blood_fury
	{ 'Blood Fury'},
	--actions+=/berserking
	{ 'Berserking'}, 
	--actions+=/use_items
	{ '#trinket1', 'target.inmelee & toggle(cooldowns)'},
	{ '#trinket2', 'target.inmelee & toggle(cooldowns)'},
	--actions+=/use_item,name=ring_of_collapsing_futures,if=(buff.temptation.stack=0&target.time_to_die>60)|target.time_to_die<60
	--actions+=/potion,if=buff.unholy_strength.react
	--actions+=/outbreak,target_if=!dot.virulent_plague.ticking
	{ 'Outbreak', 'debuff(Virulent Plague).duration <= 3.15', 'target'},
	--actions+=/army_of_the_dead
	{ 'Army of the Dead', 'toggle(cooldowns)', 'target'},
	--actions+=/dark_transformation,if=equipped.137075&cooldown.dark_arbiter.remains>165
	{ 'Dark Transformation', 'equipped(137075) & player.spell(Dark Arbiter).cooldown > 165', 'target'},
	--actions+=/dark_transformation,if=equipped.137075&!talent.shadow_infusion.enabled&cooldown.dark_arbiter.remains>55
	--actions+=/dark_transformation,if=equipped.137075&talent.shadow_infusion.enabled&cooldown.dark_arbiter.remains>35
	--actions+=/dark_transformation,if=equipped.137075&target.time_to_die<cooldown.dark_arbiter.remains-8
	--actions+=/dark_transformation,if=equipped.137075&cooldown.summon_gargoyle.remains>160
	--actions+=/dark_transformation,if=equipped.137075&!talent.shadow_infusion.enabled&cooldown.summon_gargoyle.remains>55
	--actions+=/dark_transformation,if=equipped.137075&talent.shadow_infusion.enabled&cooldown.summon_gargoyle.remains>35
	--actions+=/dark_transformation,if=equipped.137075&target.time_to_die<cooldown.summon_gargoyle.remains-8
	--actions+=/dark_transformation,if=!equipped.137075&rune<=3
	{ 'Dark Transformation', '!equipped(137075) & player.runes <= 3', 'target'},
	--actions+=/blighted_rune_weapon,if=rune<=3
	{ 'Blighted Rune Weapon', 'runes <= 3', 'target'},
	--actions+=/run_action_list,name=valkyr,if=talent.dark_arbiter.enabled&pet.valkyr_battlemaiden.active
	{ valkyr, 'talent(7,1) & player.totem(Val\'kyr Battlemaiden)'}, 
	--actions+=/call_action_list,name=generic
	{ generic},
}

local outCombat = {
	{ pet},
	{ keybinds},
	{ preCombat}
}

NeP.CR:Add(252, {
	name = '[Silver] Death Knight - Unholy',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})