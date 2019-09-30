local GUI = {
	{type = 'header', 	text = 'Toggles', align = 'center'},
	{type = 'checkbox',	text = 'MultiDot (Bosses)',					key = 'MDb', 	default = true},
	{type = 'checkbox',	text = 'MultiDot (Mobs)',					key = 'MDm', 	default = true},
	{type = 'checkbox',	text = 'Burning Rush',						key = 'BR', 	default = true},
}

local exeOnLoad = function()
	print('|cffADFF2F ----------------------------------------------------------------------|r')
	print("|cffADFF2F --- |rWARLOCK |cffADFF2FAffliction |r")
	print("|cffADFF2F --- |rRecommended Talents: 1/2 - 2/2 - 3/1 - 4/1 - 5/3 - 6/3 - 7/2")
	print('|cffADFF2F ----------------------------------------------------------------------|r')
end

local keybinds = {
	-- Pause
	{ '%pause', 'keybind(alt)'},
}

local burningRush = {
	{ '%cancelbuff(Burning Rush)', '!moving && buff(Burning Rush)', 'player'},
	{ 'Burning Rush', 'player.movingfor > 1 & !player.buff'},
}

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

local cds = {
	-- actions.cds=summon_infernal,if=target.time_to_die>=210|!cooldown.dark_soul_instability.remains|target.time_to_die<=30+gcd|!talent.dark_soul_instability.enabled
	{ 'Summon Infernal', 'ttd >= 210 || !spell(Dark Soul: Instability).cooldown || ttd <= 30 + gcd || !talent(7,3)', 'target.ground'},
	-- actions.cds+=/dark_soul_instability,if=target.time_to_die>=140|pet.infernal.active|target.time_to_die<=20+gcd
	{ 'Dark Soul: Instability', 'ttd >= 140 || spell(Summon Infernal).cooldown < 180 && spell(Summon Infernal).cooldown > 150 || ttd >= 20 + gcd', 'target'},
	-- actions.cds+=/potion,if=pet.infernal.active|target.time_to_die<65
	-- actions.cds+=/berserking
	{ 'Berserking', 'inRange.spell(Incinerate)', 'player'},
	-- actions.cds+=/blood_fury
	{ 'Blood Fury', 'inRange.spell(Incinerate)', 'player'},
	-- actions.cds+=/fireblood
	{ 'Fireblood', 'inRange.spell(Incinerate)', 'player'},
	-- actions.cds+=/use_items
}

local cata = {
	-- actions.cata=call_action_list,name=cds
	{ cds, 'toggle(cooldowns)'},
	-- actions.cata+=/rain_of_fire,if=soul_shard>=4.5
	{ 'Rain of Fire', 'inRange.spell(Incinerate) && shards >= 4.5', 'target.ground'},
	-- actions.cata+=/cataclysm
	{ 'Cataclysm', 'inRange.spell(Incinerate) && !player.moving && targettimeout(imo,2)', 'target.ground'},
	-- actions.cata+=/immolate,if=talent.channel_demonfire.enabled&!remains&cooldown.channel_demonfire.remains<=action.chaos_bolt.execute_time
	{ 'Immolate', 'inRange.spell && combat && infront(player) && !player.moving && talent(7,2) && !debuff && spell(Channel Demonfire).cooldown <= spell(Chaos Bolt).casttime', 'target'},
	-- actions.cata+=/channel_demonfire,if=!buff.active_havoc.remains
	{ 'Channel Demonfire', 'inRange.spell(Incinerate) && infront(player) && !player.moving && !enemies.debuff(Havoc)', 'target'},
	-- actions.cata+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=8+raid_event.invulnerable.up&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
	{ 'Havoc', 'inRange.spell && combat && !target && ttd > 10 && target.area(10).enemies <= 8 && talent(6,3) && { spell(Summon Infernal).cooldown < 180 && spell(Summon Infernal).cooldown > 160}', { 'focus', 'enemies'}},
	-- actions.cata+=/havoc,if=spell_targets.rain_of_fire<=8+raid_event.invulnerable.up&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
	{ 'Havoc', 'inRange.spell && combat && !target && target.area(10).enemies <= 8 && talent(6,2) && { spell(Summon Infernal).cooldown < 180 && spell(Summon Infernal).cooldown > 160}', { 'focus', 'enemies'}},
	-- actions.cata+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&talent.grimoire_of_supremacy.enabled&pet.infernal.remains>execute_time&active_enemies<=8+raid_event.invulnerable.up&((108*(spell_targets.rain_of_fire+raid_event.invulnerable.up)%3)<(240*(1+0.08*buff.grimoire_of_supremacy.stack)%2*(1+buff.active_havoc.remains>execute_time)))
	--{ 'Chaos Bolt', 'inRange.spell && infront(player) && !player.moving && { !debuff(Havoc) || player.area(30).enemies < 2} && talent(6,3) && enemies.debuff(Havoc).duration > spell.casttime && area(10).enemies <= 8', {'target', 'enemies'}},
	-- actions.cata+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4+raid_event.invulnerable.up
	{ 'Havoc', 'inRange.spell && combat && !target && ttd > 10 && target.area(10).enemies <= 4', { 'focus', 'enemies'}},
	-- actions.cata+=/havoc,if=spell_targets.rain_of_fire<=4+raid_event.invulnerable.up
	{ 'Rain of Fire', 'inRange.spell(Incinerate) && target.area(10).enemies <= 4', 'target.ground'},
	-- actions.cata+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&buff.active_havoc.remains>execute_time&spell_targets.rain_of_fire<=4+raid_event.invulnerable.up
	{ 'Chaos Bolt', 'inRange.spell && combat && infront(player) && !player.moving && { !debuff(Havoc) || player.area(30).enemies < 2} && enemies.debuff(Havoc).duration > spell.casttime && area(10).enemies <= 4', {'target', 'enemies'}},
	-- actions.cata+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&refreshable&remains<=cooldown.cataclysm.remains
	{ 'Immolate', 'inRange.spell && combat && !player.moving && { !debuff(Havoc) || player.area(30).enemies < 2} && debuff.duration <= 5.4 && debuff.duration <= spell(Cataclysm).cooldown && ttd > 6 && count.enemies.debuffs <= 8 && infront(player) && targettimeout(imo,2)', { 'target', 'enemies'}},
	-- actions.cata+=/rain_of_fire
	{ 'Rain of Fire', 'inRange.spell(Incinerate)', 'target.ground'},
	-- actions.cata+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains
	{ 'Soul Fire', 'inRange.spell && combat && infront(player)&& { !debuff(Havoc) || player.area(30).enemies < 2}', {'target', 'enemies'}},
	-- actions.cata+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains
	{ 'Conflagrate', 'inRange.spell && combat && infront(player) && { !debuff(Havoc) || player.area(30).enemies < 2}', {'target', 'enemies'}},
	-- actions.cata+=/shadowburn,cycle_targets=1,if=!debuff.havoc.remains&((charges=2|!buff.backdraft.remains|buff.backdraft.remains>buff.backdraft.stack*action.incinerate.execute_time))
	{ 'Shadowburn', 'inRange.spell && combat && infront(player) && { !debuff(Havoc) || player.area(30).enemies < 2} && {{ spell.charges = 2 || !player.buff(Backdraft) || player.buff(Backdraft).duration > player.buff(Backdraft).count * spell(Incinerate).castime}}', {'target', 'enemies'}},
	-- actions.cata+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
	{ 'Incinerate', 'inRange.spell && combat && infront(player) && !player.moving && { !debuff(Havoc) || player.area(30).enemies < 2}', {'target', 'enemies'}},
}

local fnb = {
	-- actions.fnb=call_action_list,name=cds
	{ cds, 'toggle(cooldowns)'},
	-- actions.fnb+=/rain_of_fire,if=soul_shard>=4.5
	{ 'Rain of Fire', 'inRange.spell(Incinerate) && shards >= 4.5', 'target.ground'},
	-- actions.fnb+=/immolate,if=talent.channel_demonfire.enabled&!remains&cooldown.channel_demonfire.remains<=action.chaos_bolt.execute_time
	{ 'Immolate', 'inRange.spell && combat && infront(player) && !player.moving && talent(7,2) && !debuff && spell(Channel Demonfire).cooldown <= spell(Chaos Bolt).casttime', 'target'},
	-- actions.fnb+=/channel_demonfire,if=!buff.active_havoc.remains
	{ 'Channel Demonfire', 'inRange.spell(Incinerate) && infront(player) && !player.moving && !enemies.debuff(Havoc)', 'target'},
	-- actions.fnb+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4+raid_event.invulnerable.up&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
	{ 'Havoc', 'inRange.spell && combat && !target && ttd > 10 && target.area(10).enemies <= 8 && talent(6,3) && { spell(Summon Infernal).cooldown < 180 && spell(Summon Infernal).cooldown > 160}', { 'focus', 'enemies'}},
	-- actions.fnb+=/havoc,if=spell_targets.rain_of_fire<=4+raid_event.invulnerable.up&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
	{ 'Havoc', 'inRange.spell && combat && !target && target.area(10).enemies <= 8 && talent(6,2) && { spell(Summon Infernal).cooldown < 180 && spell(Summon Infernal).cooldown > 160}', { 'focus', 'enemies'}},
	-- actions.fnb+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&talent.grimoire_of_supremacy.enabled&pet.infernal.remains>execute_time&active_enemies<=4+raid_event.invulnerable.up&((108*(spell_targets.rain_of_fire+raid_event.invulnerable.up)%3)<(240*(1+0.08*buff.grimoire_of_supremacy.stack)%2*(1+buff.active_havoc.remains>execute_time)))
	-- actions.fnb+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4+raid_event.invulnerable.up
	{ 'Havoc', 'inRange.spell && combat && !target && ttd > 10 && target.area(10).enemies <= 4', { 'focus', 'enemies'}},
	-- actions.fnb+=/havoc,if=spell_targets.rain_of_fire<=4+raid_event.invulnerable.up
	{ 'Rain of Fire', 'inRange.spell(Incinerate) && target.area(10).enemies <= 4', 'target.ground'},
	-- actions.fnb+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&buff.active_havoc.remains>execute_time&spell_targets.rain_of_fire<=4+raid_event.invulnerable.up

	-- actions.fnb+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&refreshable&spell_targets.incinerate<=8+raid_event.invulnerable.up

	-- actions.fnb+=/rain_of_fire
	{ 'Rain of Fire', 'inRange.spell(Incinerate)', 'target.ground'},
	-- actions.fnb+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains&spell_targets.incinerate<=3+raid_event.invulnerable.up
	{ 'Soul Fire', 'inRange.spell && combat && infront(player) && !player.moving && { !debuff(Havoc) || player.area(30).enemies < 2} && area(10).enemies <= 3', { 'target', 'enemies'}},
	-- actions.fnb+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains&(talent.flashover.enabled&buff.backdraft.stack<=2|spell_targets.incinerate<=7+raid_event.invulnerable.up|talent.roaring_blaze.enabled&spell_targets.incinerate<=9+raid_event.invulnerable.up)
	-- actions.fnb+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
	{ 'Incinerate', 'inRange.spell && combat && infront(player) && !player.moving && { !debuff(Havoc) || player.area(30).enemies < 2}', {'target', 'enemies'}},
}

local inf = {
	-- actions.inf=call_action_list,name=cds
	-- actions.inf+=/rain_of_fire,if=soul_shard>=4.5
	-- actions.inf+=/cataclysm
	-- actions.inf+=/immolate,if=talent.channel_demonfire.enabled&!remains&cooldown.channel_demonfire.remains<=action.chaos_bolt.execute_time
	-- actions.inf+=/channel_demonfire,if=!buff.active_havoc.remains
	-- actions.inf+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=4+raid_event.invulnerable.up+talent.internal_combustion.enabled&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
	-- actions.inf+=/havoc,if=spell_targets.rain_of_fire<=4+raid_event.invulnerable.up+talent.internal_combustion.enabled&talent.grimoire_of_supremacy.enabled&pet.infernal.active&pet.infernal.remains<=10
	-- actions.inf+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&talent.grimoire_of_supremacy.enabled&pet.infernal.remains>execute_time&spell_targets.rain_of_fire<=4+raid_event.invulnerable.up+talent.internal_combustion.enabled&((108*(spell_targets.rain_of_fire+raid_event.invulnerable.up)%(3-0.16*(spell_targets.rain_of_fire+raid_event.invulnerable.up)))<(240*(1+0.08*buff.grimoire_of_supremacy.stack)%2*(1+buff.active_havoc.remains>execute_time)))
	-- actions.inf+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&spell_targets.rain_of_fire<=3+raid_event.invulnerable.up&(talent.eradication.enabled|talent.internal_combustion.enabled)
	-- actions.inf+=/havoc,if=spell_targets.rain_of_fire<=3+raid_event.invulnerable.up&(talent.eradication.enabled|talent.internal_combustion.enabled)
	-- actions.inf+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&buff.active_havoc.remains>execute_time&spell_targets.rain_of_fire<=3+raid_event.invulnerable.up&(talent.eradication.enabled|talent.internal_combustion.enabled)
	-- actions.inf+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&refreshable
	-- actions.inf+=/rain_of_fire
	-- actions.inf+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains
	-- actions.inf+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains
	-- actions.inf+=/shadowburn,cycle_targets=1,if=!debuff.havoc.remains&((charges=2|!buff.backdraft.remains|buff.backdraft.remains>buff.backdraft.stack*action.incinerate.execute_time))
	-- actions.inf+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
}

local rotation = {
	-- # Executed every time the actor is available.
	-- actions=run_action_list,name=cata,if=spell_targets.infernal_awakening>=3+raid_event.invulnerable.up&talent.cataclysm.enabled
	{ cata, 'target.area(10).enemies >= 3 && talent(4,3)'},
	-- actions+=/run_action_list,name=fnb,if=spell_targets.infernal_awakening>=3+raid_event.invulnerable.up&talent.fire_and_brimstone.enabled
	{ fnb, 'target.area(10).enemies >= 3 && talent(4,2)'},
	-- actions+=/run_action_list,name=inf,if=spell_targets.infernal_awakening>=3+raid_event.invulnerable.up&talent.inferno.enabled
	-- actions+=/cataclysm
	{ 'Cataclysm', 'inRange.spell(Incinerate) && !player.moving && targettimeout(imo,2)', 'target.ground'},
	-- actions+=/immolate,cycle_targets=1,if=!debuff.havoc.remains&(refreshable|talent.internal_combustion.enabled&action.chaos_bolt.in_flight&remains-action.chaos_bolt.travel_time-5<duration*0.3)
	{ 'Immolate', 'inRange.spell && combat && infront(player) && !player.moving && { !debuff(Havoc) || player.area(30).enemies < 2} && debuff.duration <= 5.4 && targettimeout(imo,2)', { 'target', 'enemies'}},
	{ 'Immolate', 'inRange.spell && combat && infront(player) && !player.moving && { !debuff(Havoc) || player.area(30).enemies < 2} && talent(2,2) && lastcast(Chaos Bolt) && targettimeout(imo,2)', 'target'},
	-- actions+=/call_action_list,name=cds
	{ cds, 'toggle(cooldowns)'},
	-- actions+=/channel_demonfire,if=!buff.active_havoc.remains
	{ 'Channel Demonfire', 'inRange.spell(Incinerate) && combat && infront(player) && !player.moving && !enemies.debuff(Havoc)', 'target'},
	-- actions+=/havoc,cycle_targets=1,if=!(target=sim.target)&target.time_to_die>10&active_enemies>1+raid_event.invulnerable.up
	{ 'Havoc', 'ttd > 10 && combat&& area(40).enemies > 1', {'focus', 'enemies'}},
	-- actions+=/havoc,if=active_enemies>1+raid_event.invulnerable.up
	-- actions+=/soul_fire,cycle_targets=1,if=!debuff.havoc.remains
	{ 'Soul Fire', 'inRange.spell && combat && infront(player)&& { !debuff(Havoc) || player.area(30).enemies < 2}', {'target', 'enemies'}},
	-- actions+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&execute_time+travel_time<target.time_to_die&(trinket.proc.intellect.react&trinket.proc.intellect.remains>cast_time|trinket.proc.mastery.react&trinket.proc.mastery.remains>cast_time|trinket.proc.versatility.react&trinket.proc.versatility.remains>cast_time|trinket.proc.crit.react&trinket.proc.crit.remains>cast_time|trinket.proc.spell_power.react&trinket.proc.spell_power.remains>cast_time)
	{ 'Chaos Bolt', 'inRange.spell && combat && infront(player) && { !debuff(Havoc) || player.area(30).enemies < 2} && spell.casttime < ttd && player.procReact', {'target', 'enemies'}},
	-- actions+= chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&execute_time+travel_time<target.time_to_die&
	{ 'Chaos Bolt', 'inRange.spell && combat && infront(player) && { !debuff(Havoc) || player.area(30).enemies < 2} && spell.casttime < ttd', {'target', 'enemies'}},
	--(trinket.stacking_proc.intellect.react&trinket.stacking_proc.intellect.remains>cast_time|trinket.stacking_proc.mastery.react&trinket.stacking_proc.mastery.remains>cast_time|trinket.stacking_proc.versatility.react&trinket.stacking_proc.versatility.remains>cast_time|trinket.stacking_proc.crit.react&trinket.stacking_proc.crit.remains>cast_time|trinket.stacking_proc.spell_power.react&trinket.stacking_proc.spell_power.remains>cast_time)
	{ 'Chaos Bolt', 'inRange.spell && combat && infront(player) && { !debuff(Havoc) || player.area(30).enemies < 2} && spell.casttime < ttd && player.procReact', {'target', 'enemies'}},
	-- actions+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&execute_time+travel_time<target.time_to_die&(cooldown.summon_infernal.remains>=20|!talent.grimoire_of_supremacy.enabled)&(cooldown.dark_soul_instability.remains>=20|!talent.dark_soul_instability.enabled)&(talent.eradication.enabled&debuff.eradication.remains<=cast_time|buff.backdraft.remains|talent.internal_combustion.enabled)
	-- actions+=/chaos_bolt,cycle_targets=1,if=!debuff.havoc.remains&execute_time+travel_time<target.time_to_die&(soul_shard>=4|buff.dark_soul_instability.remains>cast_time|pet.infernal.active|buff.active_havoc.remains>cast_time)
	{ 'Chaos Bolt', 'inRange.spell && combat && infront(player) && { !debuff(Havoc) || player.area(30).enemies < 2} && spell.casttime < ttd && { shards >= 4 || player.buff(Dark Soul: Instability).duration > spell.casttime || spell(Summon Infernal).cooldown < 180 && spell(Summon Infernal).cooldown > 150 || enemies.debuff(Havoc).duration > spell.casttime}', {'target', 'enemies'}},
	-- actions+=/conflagrate,cycle_targets=1,if=!debuff.havoc.remains&((talent.flashover.enabled&buff.backdraft.stack<=2)|(!talent.flashover.enabled&buff.backdraft.stack<2))
	{ 'Conflagrate', 'inRange.spell && combat && infront(player) && { !debuff(Havoc) || player.area(30).enemies < 2} && {{ talent(1,1) && player.buff(Backdraft).count <= 2} || { !talent(1,1) && player.buff(Backdraft).count < 2}}', {'target', 'enemies'}},
	-- actions+=/shadowburn,cycle_targets=1,if=!debuff.havoc.remains&((charges=2|!buff.backdraft.remains|buff.backdraft.remains>buff.backdraft.stack*action.incinerate.execute_time))
	{ 'Shadowburn', 'inRange.spell && combat && infront(player) && { !debuff(Havoc) || player.area(30).enemies < 2} && {{ spell.charges = 2 || !player.buff(Backdraft) || player.buff(Backdraft).duration > player.buff(Backdraft).count * spell(Incinerate).castime}}', {'target', 'enemies'}},
	-- actions+=/incinerate,cycle_targets=1,if=!debuff.havoc.remains
	{ 'Incinerate', 'inRange.spell && combat && infront(player) && !player.moving && { !debuff(Havoc) || player.area(30).enemies < 2}', {'target', 'enemies'}},
}

local inCombat = {
--{ burningRush},
	{ survival},
	{ petCare},
	{ interrupts, 'target.interruptAt(50)'},
	{ cooldowns, 'toggle(cooldowns)'},
	{ rotation},
}

local outCombat = {
	--{ burningRush},
	{ keybinds},
	{ petCare},
}

NeP.CR:Add(267, {
      name = '[Silver] Warlock - Destruction',
        ic = inCombat,
       ooc = outCombat,
       gui = GUI,
      load = exeOnLoad,
   wow_ver = '8.0.1',
   nep_ver = '1.11',
})
