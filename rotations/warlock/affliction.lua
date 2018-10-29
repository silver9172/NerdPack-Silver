local GUI = {
	{type = 'header', 	text = 'Toggles', align = 'center'},
	{type = 'checkbox',	text = 'MultiDot (Bosses)',					key = 'MDb', 	default = true},
	{type = 'checkbox',	text = 'MultiDot (Mobs)',					key = 'MDm', 	default = true},
	{type = 'checkbox',	text = 'Burning Rush',						key = 'BR', 	default = true},}

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print("|cffADFF2F --- |rWARLOCK |cffADFF2FAffliction |r")
	print("|cffADFF2F --- |rRecommended Talents: 1/2 - 2/2 - 3/1 - 4/1 - 5/3 - 6/3 - 7/2")
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local survival = {
	{ '#Healthstone', 'health <= 40', 'player'},
	{ 'Unending Resolve', 'health <= 20', 'player'},
	{ 'Drain Life', 'player.health <= 40 & !player.moving', 'target'},
}

local petCare = {
	{ 'Summon Imp', '!talent(6,3) & !partycheck = 1 & !player.lastcast & { !pet.exists || pet.dead}'},
	{ 'Summon Voidwalker', '!talent(6,3) & partycheck = 1 & !player.lastcast & { !pet.exists || pet.dead}'},
	
	{ 'Summon Felhunter', 'talent(6,3) & !player.lastcast & { !pet.exists || pet.dead } & player.buff(Grimoire of Sacrifice).duration <= 600'},
	{ 'Grimoire of Sacrifice', '!player.buff & !player.lastcast & pet.exists & talent(6,3)'}, 
	
	{ 'Health Funnel', 'health <= 30 & alive & !player.moving', 'pet'}, 
} 

local interrupts = {
	{ 'Shadow Lock'},
}

local utility = {
	{ 'Shadowfury', 'target.area(8).enemies >= 3 & !player.moving', 'target.ground'}, 
}

local pvp = {

}

local cooldowns = {
	{ '#trinket1'},
	{ '#trinket2'},
	{ 'Blood Fury'}, 

	-- /dump NeP.DSL:Get('unstableAffliction')('target')

	-- Setup for Darkglare
	{ 'Unstable Affliction', 'player.spell(Summon Darkglare).cooldown <= 2.5 & !player.moving & toggle(cooldowns) & unstableAffliction < 3', 'target'}, 
	{ 'Phantom Singularity', 'unstableAffliction >= 3', 'target'},
	{ 'Summon Darkglare', 'debuff(Agony) & debuff(Corruption) & unstableAffliction >= 3', 'target'},
}

local agonyCycle = {
	{ 'Agony', 'enemy & debuff.duration <= 5.4 & range <= 40', 'focus'},
	{ 'Agony', 'combat & debuff.duration <= 5.4 & range <= 40 & deathin >= 7 & count.enemies.debuffs <= 5', 'enemies'},
}

local agony = {
	{ 'Agony', 'debuff.duration <= 5.4', 'target'},
	{ agonyCycle},
}

local corruptionCycle = {
	{ 'Corruption', 'enemy & debuff.duration <= 4.2 & range <= 40', 'focus'},
	{ 'Corruption', 'UI(MDm) & combat & { talent(2,2) & !debuff & deathin >= 7 || !talent(2,2) & debuff.duration <= 4.2}  & range <= 40 & deathin >= 7 & count.enemies.debuffs <= 5', 'enemies'},
}

local corruption = {
	{ 'Corruption', 'debuff.duration <= 4.2 & !talent(2,2)', 'target'},
	{ 'Corruption', '!debuff & talent(2,2)', 'target'},
	{ corruptionCycle, '!target.area(10).enemies >= 4'}, 
} 

local siphonCycle = {
	{ 'Siphon Life', 'enemy & debuff.duration <= 4.5 & range <= 40', 'focus'},
	{ 'Siphon Life', 'UI(MDm) & combat & debuff.duration <= 4.5 & range <= 40 & deathin >= 7 & count.enemies.debuffs <= 3', 'enemies'},
}

local siphon = {
	{ 'Siphon Life', 'debuff.duration <= 4.5', 'target'},
	{ siphonCycle}, 
}

local unstableAfflictionCycle = {
	{ 'Unstable Affliction', 'combat & debuff(Agony) & !debuff & range <= 40 & count.enemies.debuffs <= 5', 'enemies'},
}

local singleTarget = {
	{ agony},
	{ 'Unstable Affliction', 'player.shards >= 5 & !player.moving', 'target'},
	{ corruption},
	{ cooldowns, 'toggle(cooldowns) & target.bosscheck >= 1'}, 
	{ siphon},
	{ 'Unstable Affliction', 'player.shards >= 4 & !player.moving', 'target'},
	{ 'Haunt', '!player.moving'},
	{ 'Deathbolt'},
	{ 'Phantom Singularity'},
	{ 'Summon Darkglare', 'toggle(cooldowns) & debuff(Agony) & debuff(Corruption) & unstableAffliction >= 1 & bosscheck >= 1', 'target'},
	{ 'Unstable Affliction', '!debuff & !player.moving & !player.lastcast || unstableAffliction = 1 & debuff.duration <= 1 & !player.lastcast ', 'target'},
	{ 'Drain Life', 'player.buff(Inevitable Demise).count >= 100 & !player.moving', 'target'},
	{ 'Shadow Bolt', '!player.moving'},
}

local multiTarget = {
	{ agony},
	{ 'Seed of Corruption', '!player.lastcast & !debuff & area(10).enemies >= 2 & debuff(Corruption).duration <= 6.2 & !player.moving', 'target'},
	{ corruption, '!debuff(Seed of Corruption) & !player.lastcast(Seed of Corruption)'},
	{ cooldowns, 'toggle(cooldowns) & target.bosscheck >= 1'}, 
	{ 'Seed of Corruption', 'target.area(10).enemies >= 8 & player.shards >= 1', 'target'},
	{ 'Unstable Affliction', 'player.shards >= 5 & !player.moving', 'target'},
	{ 'Phantom Singularity'},
	{ unstableAfflictionCycle, '!player.moving & player.shards >= 2'}, 
	{ siphon},
	{ 'Shadow Bolt'},
}

local burningRush = {
	{ '/cancelaura Burning Rush', 'player.lastmoved >= .02 & player.buff(Burning Rush) || player.health < 40 & player.buff(Burning Rush)'},
	{ 'Burning Rush', 'player.movingfor >= 2 & !player.buff & player.health >= 60'},
}

local fillers = {
	-- actions.fillers=deathbolt
	-- actions.fillers+=/shadow_bolt,if=buff.movement.up&buff.nightfall.remains
	-- actions.fillers+=/agony,if=buff.movement.up&!(talent.siphon_life.enabled&(prev_gcd.1.agony&prev_gcd.2.agony&prev_gcd.3.agony)|prev_gcd.1.agony)
	-- actions.fillers+=/siphon_life,if=buff.movement.up&!(prev_gcd.1.siphon_life&prev_gcd.2.siphon_life&prev_gcd.3.siphon_life)
	-- actions.fillers+=/corruption,if=buff.movement.up&!prev_gcd.1.corruption&!talent.absolute_corruption.enabled
	-- actions.fillers+=/drain_life,if=(buff.inevitable_demise.stack>=90&(cooldown.deathbolt.remains>execute_time|!talent.deathbolt.enabled)&(cooldown.phantom_singularity.remains>execute_time|!talent.phantom_singularity.enabled)&(cooldown.dark_soul.remains>execute_time|!talent.dark_soul_misery.enabled)&(cooldown.vile_taint.remains>execute_time|!talent.vile_taint.enabled)&cooldown.summon_darkglare.remains>execute_time+10|buff.inevitable_demise.stack>30&target.time_to_die<=10)
	{ 'Drain Life', '{ player.buff(Inevitable Demise).count >= 90 & { player.spell(Deathbolt).cooldown > 5 || !talent(1,3)} & { player.spell(Phantom Singularity).cooldown > 5 || !talent(4,2)} & { player.spell(Dark Soul: Misery).cooldown > 5 || !talent(7,3)} & { player.spell(Vile taint).cooldown > 5 || !talent(4,3)} & player.spell(Summon Darkglare).cooldown > 5 + 10 || player.buff(Inevitable Demise).count > 30 & ttd <= 10}', 'target'}, 
	-- actions.fillers+=/drain_soul,interrupt_global=1,chain=1,cycle_targets=1,if=target.time_to_die<=gcd
	-- actions.fillers+=/drain_soul,interrupt_global=1,chain=1
	-- actions.fillers+=/shadow_bolt,cycle_targets=1,if=talent.shadow_embrace.enabled&talent.absolute_corruption.enabled&active_enemies=2&!debuff.shadow_embrace.remains&!action.shadow_bolt.in_flight
	-- actions.fillers+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&talent.absolute_corruption.enabled&active_enemies=2
	-- actions.fillers+=/shadow_bolt
	{ 'Shadow Bolt'}, 
}

local rotation = {
	-- actions=variable,name=spammable_seed,value=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>=3|talent.siphon_life.enabled&spell_targets.seed_of_corruption>=5|spell_targets.seed_of_corruption>=8
	-- actions+=/variable,name=padding,op=set,value=action.shadow_bolt.execute_time*azerite.cascading_calamity.enabled
	-- actions+=/variable,name=padding,op=reset,value=gcd,if=azerite.cascading_calamity.enabled&(talent.drain_soul.enabled|talent.deathbolt.enabled&cooldown.deathbolt.remains<=gcd)
	-- actions+=/potion,if=(talent.dark_soul_misery.enabled&cooldown.summon_darkglare.up&cooldown.dark_soul.up)|cooldown.summon_darkglare.up|target.time_to_die<30
	-- actions+=/use_items,if=!cooldown.summon_darkglare.up
	-- actions+=/fireblood,if=!cooldown.summon_darkglare.up
	-- actions+=/blood_fury,if=!cooldown.summon_darkglare.up
	-- actions+=/drain_soul,interrupt_global=1,chain=1,cycle_targets=1,if=target.time_to_die<=gcd&soul_shard<5
	-- actions+=/haunt
	-- actions+=/summon_darkglare,if=dot.agony.ticking&dot.corruption.ticking&(buff.active_uas.stack=5|soul_shard=0)&(!talent.phantom_singularity.enabled|cooldown.phantom_singularity.remains)
	-- actions+=/agony,cycle_targets=1,if=remains<=gcd
	{ 'Agony', 'debuff.duration <= gcd', 'target'},
	-- actions+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&talent.absolute_corruption.enabled&active_enemies=2&debuff.shadow_embrace.remains&debuff.shadow_embrace.remains<=execute_time*2+travel_time&!action.shadow_bolt.in_flight
	-- actions+=/phantom_singularity,if=time>40
	-- actions+=/vile_taint,if=time>20
	-- actions+=/seed_of_corruption,if=dot.corruption.remains<=action.seed_of_corruption.cast_time+time_to_shard+4.2*(1-talent.creeping_death.enabled*0.15)&spell_targets.seed_of_corruption_aoe>=3+talent.writhe_in_agony.enabled&!dot.seed_of_corruption.remains&!action.seed_of_corruption.in_flight
	-- actions+=/agony,cycle_targets=1,max_cycle_targets=6,if=talent.creeping_death.enabled&target.time_to_die>10&refreshable
	{ 'Agony', 'count.enemies.debuffs <= 6 & talent(7,2) & ttd > 10 & debuff.duration <= 5.4 & inRange.spell', 'enemies'},
	-- actions+=/agony,cycle_targets=1,max_cycle_targets=8,if=(!talent.creeping_death.enabled)&target.time_to_die>10&refreshable
	-- actions+=/siphon_life,cycle_targets=1,max_cycle_targets=1,if=refreshable&target.time_to_die>10&((!(cooldown.summon_darkglare.remains<=soul_shard*action.unstable_affliction.execute_time)&active_enemies>=8)|active_enemies=1)
	-- actions+=/siphon_life,cycle_targets=1,max_cycle_targets=2,if=refreshable&target.time_to_die>10&((!(cooldown.summon_darkglare.remains<=soul_shard*action.unstable_affliction.execute_time)&active_enemies=7)|active_enemies=2)
	-- actions+=/siphon_life,cycle_targets=1,max_cycle_targets=3,if=refreshable&target.time_to_die>10&((!(cooldown.summon_darkglare.remains<=soul_shard*action.unstable_affliction.execute_time)&active_enemies=6)|active_enemies=3)
	-- actions+=/siphon_life,cycle_targets=1,max_cycle_targets=4,if=refreshable&target.time_to_die>10&((!(cooldown.summon_darkglare.remains<=soul_shard*action.unstable_affliction.execute_time)&active_enemies=5)|active_enemies=4)
	-- actions+=/corruption,cycle_targets=1,if=active_enemies<3+talent.writhe_in_agony.enabled&refreshable&target.time_to_die>10
	-- actions+=/dark_soul
	-- actions+=/vile_taint
	-- actions+=/berserking
	-- actions+=/unstable_affliction,if=soul_shard>=5
	-- actions+=/unstable_affliction,if=cooldown.summon_darkglare.remains<=soul_shard*execute_time
	-- actions+=/phantom_singularity
	-- actions+=/call_action_list,name=fillers,if=(cooldown.summon_darkglare.remains<time_to_shard*(5-soul_shard)|cooldown.summon_darkglare.up)&time_to_die>cooldown.summon_darkglare.remains
	-- actions+=/seed_of_corruption,if=variable.spammable_seed
	{ 'Seed of Corruption', 'spammable_seed', 'target'}, 
	-- actions+=/unstable_affliction,if=!prev_gcd.1.summon_darkglare&!variable.spammable_seed&(talent.deathbolt.enabled&cooldown.deathbolt.remains<=execute_time&!azerite.cascading_calamity.enabled|soul_shard>=2&target.time_to_die>4+execute_time&active_enemies=1|target.time_to_die<=8+execute_time*soul_shard)
	-- actions+=/unstable_affliction,if=!variable.spammable_seed&contagion<=cast_time+variable.padding
	-- actions+=/unstable_affliction,cycle_targets=1,if=!variable.spammable_seed&(!talent.deathbolt.enabled|cooldown.deathbolt.remains>time_to_shard|soul_shard>1)&contagion<=cast_time+variable.padding
	-- actions+=/call_action_list,name=fillers
	{ fillers}, 
}


local inCombat = {
	{ burningRush, 'UI(BR)'},
	{ survival},
	{ utility}, 
	{ petCare},
	{ interrupts, 'target.interruptAt(50)'},
	-- { multiTarget, 'target.area(10).enemies >= 2 & toggle(aoe)'},
	-- { singleTarget, 'target.area(10).enemies < 2 & toggle(aoe) || !toggle(aoe)'},
	{ rotation}, 
}

local outCombat = {
	{ burningRush, 'UI(BR)'},
	{ survival},
	{ petCare},
}

NeP.CR:Add(265, {
      name = '[Silver] Warlock - Affliction',
        ic = inCombat,
       ooc = outCombat,
       gui = GUI,
      load = exeOnLoad,
   wow_ver = '8.0.1',
   nep_ver = '1.11',
})