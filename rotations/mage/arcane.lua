local GUI = {
	{type = 'header', 	text = 'Generic', align = 'center'},
	{type = 'ruler'},
	{type = 'checkbox',	text = 'Dispel Curses',		key = 'G_Curse', 	default = true},
	{type = 'spinner',	text = 'Conserve Mana %:',	key = 'P_LotM', 	default = 40},
}

local dispel = {
	{ 'Remove Curse', 'curseDispel', { 'tank', 'player', 'lowest', 'friendly'}}, 
}

local buff = {
	{ 'Arcane Intellect', 'buff.duration <= 600', { 'lowest', 'friendly'}}, 
}

local interrupts = {
	{ 'Counterspell'},
}

local survival = {
	{ 'Blazing Barrier', 'buff.duration <= 15 & !buff(Replenishment)', 'player'}, 
}

	-- # Increment our burn phase counter. Whenever we enter the `burn` actions without being in a burn phase, it means that we are about to start one.
	-- actions.burn=variable,name=total_burns,op=add,value=1,if=!burn_phase
	-- actions.burn+=/start_burn_phase,if=!burn_phase
	-- # End the burn phase when we just evocated.
	-- actions.burn+=/stop_burn_phase,if=burn_phase&prev_gcd.1.evocation&target.time_to_die>variable.average_burn_length&burn_phase_duration>0
	-- actions.burn+=/mirror_image
	-- actions.burn+=/charged_up,if=buff.arcane_charge.stack<=1&(!set_bonus.tier20_2pc|cooldown.presence_of_mind.remains>5)
	-- actions.burn+=/nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.rune_of_power.down&buff.arcane_power.down
	-- actions.burn+=/lights_judgment,if=buff.arcane_power.down
	-- actions.burn+=/rune_of_power,if=!buff.arcane_power.up&(mana.pct>=50|cooldown.arcane_power.remains=0)&(buff.arcane_charge.stack=buff.arcane_charge.max_stack)
	-- actions.burn+=/arcane_power
	-- actions.burn+=/use_items,if=buff.arcane_power.up|target.time_to_die<cooldown.arcane_power.remains
	-- actions.burn+=/blood_fury
	-- actions.burn+=/berserking
	-- actions.burn+=/fireblood
	-- actions.burn+=/ancestral_call
	-- actions.burn+=/presence_of_mind
	-- actions.burn+=/arcane_orb,if=buff.arcane_charge.stack=0|(active_enemies<3|(active_enemies<2&talent.resonance.enabled))
	-- actions.burn+=/arcane_barrage,if=(active_enemies>=3|(active_enemies>=2&talent.resonance.enabled))&(buff.arcane_charge.stack=buff.arcane_charge.max_stack)
	-- actions.burn+=/arcane_explosion,if=active_enemies>=3|(active_enemies>=2&talent.resonance.enabled)
	-- actions.burn+=/arcane_barrage,if=variable.pressure_rotation&buff.arcane_charge.stack=buff.arcane_charge.max_stack
	-- actions.burn+=/arcane_missiles,if=(buff.clearcasting.react&mana.pct<=95)&variable.pressure_rotation=0,chain=1
	-- actions.burn+=/arcane_blast
	-- # Now that we're done burning, we can update the average_burn_length with the length of this burn.
	-- actions.burn+=/variable,name=average_burn_length,op=set,value=(variable.average_burn_length*variable.total_burns-variable.average_burn_length+(burn_phase_duration))%variable.total_burns
	-- actions.burn+=/evocation,interrupt_if=mana.pct>=97|(buff.clearcasting.react&mana.pct>=92)
	-- # For the rare occasion where we go oom before evocation is back up. (Usually because we get very bad rng so the burn is cut very short)
	-- actions.burn+=/arcane_barrage

local conserve = {
	-- actions.conserve=mirror_image
	-- actions.conserve+=/charged_up,if=buff.arcane_charge.stack=0
	-- actions.conserve+=/presence_of_mind,if=set_bonus.tier20_2pc&buff.arcane_charge.stack=0
	-- actions.conserve+=/nether_tempest,if=(refreshable|!ticking)&buff.arcane_charge.stack=buff.arcane_charge.max_stack&buff.rune_of_power.down&buff.arcane_power.down
	-- actions.conserve+=/arcane_orb,if=buff.arcane_charge.stack<=2&(cooldown.arcane_power.remains>10|active_enemies<=2)
	-- # Arcane Blast shifts up in priority when running rule of threes.
	-- actions.conserve+=/arcane_blast,if=buff.rule_of_threes.up&buff.arcane_charge.stack>=3
	-- actions.conserve+=/rune_of_power,if=buff.arcane_charge.stack=buff.arcane_charge.max_stack&(full_recharge_time<=execute_time|recharge_time<=cooldown.arcane_power.remains|target.time_to_die<=cooldown.arcane_power.remains)
	-- actions.conserve+=/arcane_missiles,if=mana.pct<=95&buff.clearcasting.react&variable.pressure_rotation=0,chain=1
	-- # During conserve, we still just want to continue not dropping charges as long as possible.So keep 'burning' as long as possible (aka conserve_mana threshhold) and then swap to a 4x AB->Abarr conserve rotation. This is mana neutral for RoT, mana negative with arcane familiar. If we do not have 4 AC, we can dip slightly lower to get a 4th AC.
	-- actions.conserve+=/arcane_barrage,if=((buff.arcane_charge.stack=buff.arcane_charge.max_stack)&(mana.pct<=variable.conserve_mana|variable.pressure_rotation)|(talent.arcane_orb.enabled&cooldown.arcane_orb.remains<=gcd&cooldown.arcane_power.remains>10))|mana.pct<=(variable.conserve_mana-10)
	-- # Supernova is barely worth casting, which is why it is so far down, only just above AB. 
	-- actions.conserve+=/supernova,if=mana.pct<=95
	-- # Keep 'burning' in aoe situations until conserve_mana pct. After that only cast AE with 3 Arcane charges, since it's almost equal mana cost to a 3 stack AB anyway. At that point AoE rotation will be AB x3 -> AE -> Abarr
	-- actions.conserve+=/arcane_explosion,if=active_enemies>=3&(mana.pct>=variable.conserve_mana|buff.arcane_charge.stack=3)
	-- actions.conserve+=/arcane_blast
	{ 'Arcane Blast'}, 
	-- actions.conserve+=/arcane_barrage
	{ 'Arcane Barrage'},
}

local movement = {
	-- actions.movement=shimmer,if=movement.distance>=10
	-- actions.movement+=/blink,if=movement.distance>=10
	-- actions.movement+=/presence_of_mind
	-- actions.movement+=/arcane_missiles
	-- actions.movement+=/arcane_orb
	-- actions.movement+=/supernova
	{ 'Supernova'}, 
}
	
	-- # Executed before combat begins. Accepts non-harmful actions only.
	-- actions.precombat=flask
	-- actions.precombat+=/food
	-- actions.precombat+=/augmentation
	-- actions.precombat+=/arcane_intellect
	-- actions.precombat+=/summon_arcane_familiar
	-- # conserve_mana is the mana percentage we want to go down to during conserve. It needs to leave enough room to worst case scenario spam AB only during AP.
	-- actions.precombat+=/variable,name=conserve_mana,op=set,value=35,if=talent.overpowered.enabled
	-- actions.precombat+=/variable,name=conserve_mana,op=set,value=45,if=!talent.overpowered.enabled
	-- actions.precombat+=/snapshot_stats
	-- actions.precombat+=/mirror_image
	-- actions.precombat+=/potion
	-- actions.precombat+=/arcane_blast
	
	-- # Executed every time the actor is available.
	-- # Interrupt the boss when possible.
	-- actions=counterspell,if=target.debuff.casting.react
	-- actions+=/time_warp,if=time=0&buff.bloodlust.down
	-- # Swap to the 'Arcane Pressure' rotation when we got enough traits for it. This implies stuff like no longer casting Arcane Missiles, and throwing out Arcane Barrage whenever we got 4 AC.
	-- actions+=/variable,name=pressure_rotation,op=set,value=(azerite.arcane_pressure.rank>=2|(talent.resonance.enabled&active_enemies>=2))&target.health.pct<=35
	-- # Start a burn phase when important cooldowns are available. Start with 4 arcane charges, unless there's a good reason not to. (charged up)
	-- actions+=/call_action_list,name=burn,if=burn_phase|target.time_to_die<variable.average_burn_length|(cooldown.arcane_power.remains=0&cooldown.evocation.remains<=variable.average_burn_length&(buff.arcane_charge.stack=buff.arcane_charge.max_stack|(talent.charged_up.enabled&cooldown.charged_up.remains=0)))
	-- actions+=/call_action_list,name=conserve,if=!burn_phase
	-- actions+=/call_action_list,name=movement

local inCombat = {
	{ buff}, 
	{ dispel, 'UI(G_Curse)'},
	{ survival}, 
	{ rotation}, 
}

local outCombat = {
	{'%pause', 'player.buff(Replenishment)'},
	{ buff}, 
	{ survival}, 
	--{ preCombat}, 
}

NeP.CR:Add(62, {
	name = 'Mage - Arcane',
	  ic = inCombat,
	 ooc = outCombat,
	 gui = GUI,
	load = exeOnLoad
})
