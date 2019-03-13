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

local burningRush = {
	{ '/cancelaura Burning Rush', 'player.lastmoved >= .02 & player.buff(Burning Rush) || player.health < 40 & player.buff(Burning Rush)'},
	{ 'Burning Rush', 'player.movingfor >= 2 & !player.buff & player.health >= 60'},
}

local cooldowns = {
	-- actions.cooldowns=potion,if=(talent.dark_soul_misery.enabled&cooldown.summon_darkglare.up&cooldown.dark_soul.up)|cooldown.summon_darkglare.up|target.time_to_die<30
	-- actions.cooldowns+=/use_items,if=!cooldown.summon_darkglare.up,if=cooldown.summon_darkglare.remains>70|time_to_die<20|((buff.active_uas.stack=5|soul_shard=0)&(!talent.phantom_singularity.enabled|cooldown.phantom_singularity.remains)&(!talent.deathbolt.enabled|cooldown.deathbolt.remains<=gcd|!cooldown.deathbolt.remains)&!cooldown.summon_darkglare.remains)
	-- actions.cooldowns+=/fireblood,if=!cooldown.summon_darkglare.up
	-- actions.cooldowns+=/blood_fury,if=!cooldown.summon_darkglare.up
}

local db_refresh = {
	-- actions.db_refresh=siphon_life,line_cd=15,if=(dot.siphon_life.remains%dot.siphon_life.duration)<=(dot.agony.remains%dot.agony.duration)&(dot.siphon_life.remains%dot.siphon_life.duration)<=(dot.corruption.remains%dot.corruption.duration)&dot.siphon_life.remains<dot.siphon_life.duration*1.3
	-- actions.db_refresh+=/agony,line_cd=15,if=(dot.agony.remains%dot.agony.duration)<=(dot.corruption.remains%dot.corruption.duration)&(dot.agony.remains%dot.agony.duration)<=(dot.siphon_life.remains%dot.siphon_life.duration)&dot.agony.remains<dot.agony.duration*1.3
	-- actions.db_refresh+=/corruption,line_cd=15,if=(dot.corruption.remains%dot.corruption.duration)<=(dot.agony.remains%dot.agony.duration)&(dot.corruption.remains%dot.corruption.duration)<=(dot.siphon_life.remains%dot.siphon_life.duration)&dot.corruption.remains<dot.corruption.duration*1.3
}
	
local dots = {
	-- actions.dots=seed_of_corruption,if=dot.corruption.remains<=action.seed_of_corruption.cast_time+time_to_shard+4.2*(1-talent.creeping_death.enabled*0.15)&spell_targets.seed_of_corruption_aoe>=3+raid_event.invulnerable.up+talent.writhe_in_agony.enabled&!dot.seed_of_corruption.remains&!action.seed_of_corruption.in_flight
	
	-- actions.dots+=/agony,target_if=min:remains,if=talent.creeping_death.enabled&active_dot.agony<6&target.time_to_die>10&(remains<=gcd|cooldown.summon_darkglare.remains>10&(remains<5|!azerite.pandemic_invocation.rank&refreshable))
	-- actions.dots+=/agony,target_if=min:remains,if=!talent.creeping_death.enabled&active_dot.agony<8&target.time_to_die>10&(remains<=gcd|cooldown.summon_darkglare.remains>10&(remains<5|!azerite.pandemic_invocation.rank&refreshable))
	-- actions.dots+=/siphon_life,target_if=min:remains,if=(active_dot.siphon_life<8-talent.creeping_death.enabled-spell_targets.sow_the_seeds_aoe)&target.time_to_die>10&refreshable&(!remains&spell_targets.seed_of_corruption_aoe=1|cooldown.summon_darkglare.remains>soul_shard*action.unstable_affliction.execute_time)
	--{ 'Siphon Life', '
	--{ 'Siphon Life', '{ count.enemies.debuffs <= 8 - talent.enabled(7,2) - talent.enabled(4,1)} && ttd > 10 && debuff.duration <= 4.5 && 
	-- actions.dots+=/corruption,cycle_targets=1,if=spell_targets.seed_of_corruption_aoe<3+raid_event.invulnerable.up+talent.writhe_in_agony.enabled&(remains<=gcd|cooldown.summon_darkglare.remains>10&refreshable)&target.time_to_die>10 
	{ 'Corruption', 'area(10).enemies < 3 + talent.enabled(2,1) && { target.debuff(Corruption).duration <= gcd || spell(Summon Darkglare).cooldown > 10 && target.debuff(Corruption).duration <= 4.2 } && ttd > 10', 'target'}, 
	{ 'Corruption', 'area(10).enemies < 3 + talent.enabled(2,1) && { enemies.debuff(Corruption).duration <= gcd || spell(Summon Darkglare).cooldown > 10 && enemies.debuff(Corruption).duration <= 4.2 } && ttd > 10', 'enemies'},
}
	
	
local fillers = {	
	-- actions.fillers=unstable_affliction,line_cd=15,if=cooldown.deathbolt.remains<=gcd*2&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up&cooldown.summon_darkglare.remains>20
	-- actions.fillers+=/call_action_list,name=db_refresh,if=talent.deathbolt.enabled&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up&(dot.agony.remains<dot.agony.duration*0.75|dot.corruption.remains<dot.corruption.duration*0.75|dot.siphon_life.remains<dot.siphon_life.duration*0.75)&cooldown.deathbolt.remains<=action.agony.gcd*4&cooldown.summon_darkglare.remains>20
	-- actions.fillers+=/call_action_list,name=db_refresh,if=talent.deathbolt.enabled&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up&cooldown.summon_darkglare.remains<=soul_shard*action.agony.gcd+action.agony.gcd*3&(dot.agony.remains<dot.agony.duration*1|dot.corruption.remains<dot.corruption.duration*1|dot.siphon_life.remains<dot.siphon_life.duration*1)
	-- actions.fillers+=/deathbolt,if=cooldown.summon_darkglare.remains>=30+gcd|cooldown.summon_darkglare.remains>140
	-- actions.fillers+=/shadow_bolt,if=buff.movement.up&buff.nightfall.remains
	-- actions.fillers+=/agony,if=buff.movement.up&!(talent.siphon_life.enabled&(prev_gcd.1.agony&prev_gcd.2.agony&prev_gcd.3.agony)|prev_gcd.1.agony)
	-- actions.fillers+=/siphon_life,if=buff.movement.up&!(prev_gcd.1.siphon_life&prev_gcd.2.siphon_life&prev_gcd.3.siphon_life)
	-- actions.fillers+=/corruption,if=buff.movement.up&!prev_gcd.1.corruption&!talent.absolute_corruption.enabled
	-- actions.fillers+=/drain_life,if=(buff.inevitable_demise.stack>=40-(spell_targets.seed_of_corruption_aoe-raid_event.invulnerable.up>2)*20&(cooldown.deathbolt.remains>execute_time|!talent.deathbolt.enabled)&(cooldown.phantom_singularity.remains>execute_time|!talent.phantom_singularity.enabled)&(cooldown.dark_soul.remains>execute_time|!talent.dark_soul_misery.enabled)&(cooldown.vile_taint.remains>execute_time|!talent.vile_taint.enabled)&cooldown.summon_darkglare.remains>execute_time+10|buff.inevitable_demise.stack>10&target.time_to_die<=10)
	-- actions.fillers+=/haunt
	{ 'Haunt'}, 
	-- actions.fillers+=/drain_soul,interrupt_global=1,chain=1,interrupt=1,cycle_targets=1,if=target.time_to_die<=gcd
	-- actions.fillers+=/drain_soul,target_if=min:debuff.shadow_embrace.remains,chain=1,interrupt_if=ticks_remain<5,interrupt_global=1,if=talent.shadow_embrace.enabled&variable.maintain_se&!debuff.shadow_embrace.remains
	-- actions.fillers+=/drain_soul,target_if=min:debuff.shadow_embrace.remains,chain=1,interrupt_if=ticks_remain<5,interrupt_global=1,if=talent.shadow_embrace.enabled&variable.maintain_se
	-- actions.fillers+=/drain_soul,interrupt_global=1,chain=1,interrupt=1
	-- actions.fillers+=/shadow_bolt,cycle_targets=1,if=talent.shadow_embrace.enabled&variable.maintain_se&!debuff.shadow_embrace.remains&!action.shadow_bolt.in_flight
	-- actions.fillers+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&variable.maintain_se
	-- actions.fillers+=/shadow_bolt
	{ 'Shadow Bolt'}, 
}

local spenders = {
	-- actions.spenders=unstable_affliction,if=cooldown.summon_darkglare.remains<=soul_shard*execute_time&(!talent.deathbolt.enabled|cooldown.deathbolt.remains<=soul_shard*execute_time)
	-- actions.spenders+=/call_action_list,name=fillers,if=(cooldown.summon_darkglare.remains<time_to_shard*(6-soul_shard)|cooldown.summon_darkglare.up)&time_to_die>cooldown.summon_darkglare.remains
	-- actions.spenders+=/seed_of_corruption,if=variable.use_seed
	{ 'Seed of Corruption', 'spammable_seed && combat', { 'target', 'enemies'}}, 
	-- actions.spenders+=/unstable_affliction,if=!variable.use_seed&!prev_gcd.1.summon_darkglare&(talent.deathbolt.enabled&cooldown.deathbolt.remains<=execute_time&!azerite.cascading_calamity.enabled|(soul_shard>=5&spell_targets.seed_of_corruption_aoe<2|soul_shard>=2&spell_targets.seed_of_corruption_aoe>=2)&target.time_to_die>4+execute_time&spell_targets.seed_of_corruption_aoe=1|target.time_to_die<=8+execute_time*soul_shard)
	-- actions.spenders+=/unstable_affliction,if=!variable.use_seed&contagion<=cast_time+variable.padding
	-- actions.spenders+=/unstable_affliction,cycle_targets=1,if=!variable.use_seed&(!talent.deathbolt.enabled|cooldown.deathbolt.remains>time_to_shard|soul_shard>1)&(!talent.vile_taint.enabled|soul_shard>1)&contagion<=cast_time+variable.padding&(!azerite.cascading_calamity.enabled|buff.cascading_calamity.remains>time_to_shard)
}



local rotation = {
	-- actions=variable,name=use_seed,value=talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>=3+raid_event.invulnerable.up|talent.siphon_life.enabled&spell_targets.seed_of_corruption>=5+raid_event.invulnerable.up|spell_targets.seed_of_corruption>=8+raid_event.invulnerable.up
	-- actions+=/variable,name=padding,op=set,value=action.shadow_bolt.execute_time*azerite.cascading_calamity.enabled
	-- actions+=/variable,name=padding,op=reset,value=gcd,if=azerite.cascading_calamity.enabled&(talent.drain_soul.enabled|talent.deathbolt.enabled&cooldown.deathbolt.remains<=gcd)
	-- actions+=/variable,name=maintain_se,value=spell_targets.seed_of_corruption_aoe<=1+talent.writhe_in_agony.enabled+talent.absolute_corruption.enabled*2+(talent.writhe_in_agony.enabled&talent.sow_the_seeds.enabled&spell_targets.seed_of_corruption_aoe>2)+(talent.siphon_life.enabled&!talent.creeping_death.enabled&!talent.drain_soul.enabled)+raid_event.invulnerable.up
	-- actions+=/call_action_list,name=cooldowns
	{ cooldowns}, 
	-- actions+=/drain_soul,interrupt_global=1,chain=1,cycle_targets=1,if=target.time_to_die<=gcd&soul_shard<5
	-- actions+=/haunt,if=spell_targets.seed_of_corruption_aoe<=2+raid_event.invulnerable.up
	-- actions+=/summon_darkglare,if=dot.agony.ticking&dot.corruption.ticking&(buff.active_uas.stack=5|soul_shard=0)&(!talent.phantom_singularity.enabled|dot.phantom_singularity.remains)&(!talent.deathbolt.enabled|cooldown.deathbolt.remains<=gcd|!cooldown.deathbolt.remains|spell_targets.seed_of_corruption_aoe>1+raid_event.invulnerable.up)
	-- actions+=/deathbolt,if=cooldown.summon_darkglare.remains&spell_targets.seed_of_corruption_aoe=1+raid_event.invulnerable.up
	-- actions+=/agony,target_if=min:dot.agony.remains,if=remains<=gcd+action.shadow_bolt.execute_time&target.time_to_die>8
	-- actions+=/unstable_affliction,target_if=!contagion&target.time_to_die<=8
	{ 'Unstable Affliction', '!debuff && ttd <= 8 && combat', { 'target', 'enemies'}}, 
	-- actions+=/drain_soul,target_if=min:debuff.shadow_embrace.remains,cancel_if=ticks_remain<5,if=talent.shadow_embrace.enabled&variable.maintain_se&debuff.shadow_embrace.remains&debuff.shadow_embrace.remains<=gcd*2
	-- actions+=/shadow_bolt,target_if=min:debuff.shadow_embrace.remains,if=talent.shadow_embrace.enabled&variable.maintain_se&debuff.shadow_embrace.remains&debuff.shadow_embrace.remains<=execute_time*2+travel_time&!action.shadow_bolt.in_flight
	-- actions+=/phantom_singularity,target_if=max:target.time_to_die,if=time>35&target.time_to_die>16*spell_haste
	-- actions+=/vile_taint,target_if=max:target.time_to_die,if=time>15&target.time_to_die>=10
	-- actions+=/unstable_affliction,target_if=min:contagion,if=!variable.use_seed&soul_shard=5
	
	-- actions+=/seed_of_corruption,if=variable.use_seed&soul_shard=5
	{ 'Seed of Corruption', 'spammable_seed && shoulshards = 5 && combat', { 'target', 'enemies'}}, 
	-- actions+=/call_action_list,name=dots
	{ dots}, 
	-- actions+=/phantom_singularity,if=time<=35
	-- actions+=/vile_taint,if=time<15
	-- actions+=/dark_soul,if=cooldown.summon_darkglare.remains<10&dot.phantom_singularity.remains|target.time_to_die<20+gcd|spell_targets.seed_of_corruption_aoe>1+raid_event.invulnerable.up
	-- actions+=/berserking
	{ 'Berserking'}, 
	-- actions+=/call_action_list,name=spenders
	{ spenders}, 
	-- actions+=/call_action_list,name=fillers
	{ fillers}, 
	
	
	
	
	
	{ 'Agony', 'count.enemies.debuffs <= 6 && talent(7,2) && debuff.duration <= 5.4 && ttd > 10 && inRange.spell && combat', { 'target', 'enemies'}},
	-- actions+=/agony,cycle_targets=1,max_cycle_targets=8,if=(!talent.creeping_death.enabled)&target.time_to_die>10&refreshable
	{ 'Agony', 'count.enemies.debuffs <= 8 && !talent(7,2) && debuff.duration <= 5.4 && ttd > 10 && inRange.spell && combat', { 'target', 'enemies'}},
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