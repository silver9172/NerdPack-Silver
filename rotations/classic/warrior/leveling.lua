-- OPTIONAL!
-- List of all elements can be found at:
-- https://github.com/MrTheSoulz/NerdPack/wiki/Class-Interface
local GUI = {
  {type = "dropdown", text = "Role", key = "role", width = 100, list = {
  {key = "1", text = "Arms DPS"},
  {key = "2", text = "Prot Tanking"},
  {key = "3", text = "Fury DPS"},
  }, default = "1" },

  {type = 'header', text = 'Arms Settings', align = 'center'},

  {type = 'header', text = 'Prot Settings', align = 'center'},
  {type = 'checkbox', text = 'Thunder Clap', 		key = 'P_TC', 		default = false},
  -- Rage pool
  {type = 'spinner', 	text = 'Rage Pool', 						key = 'POOL', 	default = 20},
}

-- OPTIONAL!
local GUI_ST = {
  title='[Silver] Warrior',
  --width='256',
  --height='300',
  --color='A330C9'
}

-- This is executed on load
-- OPTIONAL!
local ExeOnLoad = function()
  -- This will print a message everytime the user selects your CR.
  NeP.Core:Print('Hello User!\nThanks for using [NeP] Warrior\nRemember this is just a basic routine.')
end

-- this is executed on unload
-- OPTIONAL!
local ExeOnUnload = function()
  -- This will print a message everytime the user selects your CR.
  NeP.Core:Print('Goodbye :(')
end

local defStance = {
  { 'Bloodrage','inRange.spell(Sunder Armor) && health >= 60','player'},
  { 'Shield Block','inRange.spell(Sunder Armor) && player.rage >= 10 && infront(player)','target'},

  -- Get sunder to 3 on target
  --{ 'Sunder Armor','debuff.count < 3 && player.rage >= 15','target'},

  { 'Demoralizing Shout','!debuff.any && distance <= 10 && player.rage >= 10 + UI(POOL)','enemies'},
  { 'Revenge','inRange.spell && player.rage >= 5 + UI(POOL) && infront(player)','target'},

  -- AoE tanking (More than 3)
  {{
    { 'Battle Shout','rage >= 10 && buff.duration.any < 120','player'},
    { '&Cleave','inRange.spell && player.rage >= 20 + UI(POOL) && infront(player)','target'},
  },'area(10).enemies > 3'},

  -- AoE tanking (More than 1). Check target first
  {{
    { 'Sunder Armor','inRange.spell && !debuff && infront(player) && player.rage >= 15 + UI(POOL) && infront(player)','target'},
    { 'Sunder Armor','inRange.spell && !debuff && infront(player) && player.rage >= 15 + UI(POOL) && infront(player)','enemies'},
    { 'Sunder Armor','inRange.spell && debuff.count < 2 && infront(player) && player.rage > 15 + UI(POOL) && infront(player)','target'},
    { 'Sunder Armor','inRange.spell && debuff.count < 2 && infront(player) && player.rage > 15 + UI(POOL) && infront(player)','enemies'},
    { 'Sunder Armor','inRange.spell && debuff.count < 3 && infront(player) && player.rage > 15 + UI(POOL) && infront(player)','target'},
    { 'Sunder Armor','inRange.spell && debuff.count < 3 && infront(player) && player.rage > 15 + UI(POOL) && infront(player)','enemies'},
    { 'Sunder Armor','inRange.spell && debuff.count < 4 && infront(player) && player.rage > 15 + UI(POOL) && infront(player)','target'},
    { 'Sunder Armor','inRange.spell && debuff.count < 4 && infront(player) && player.rage > 15 + UI(POOL) && infront(player)','enemies'},
    { 'Sunder Armor','inRange.spell && debuff.count < 5 && infront(player) && player.rage > 15 + UI(POOL) && infront(player)','target'},
    { 'Sunder Armor','inRange.spell && debuff.count < 5 && infront(player) && player.rage > 15 + UI(POOL) && infront(player)','enemies'},
    { '&Cleave','inRange.spell && player.rage >= 20 + UI(POOL) && infront(player)','target'},
  },'area(8).enemies > 1'},

  { 'Sunder Armor','inRange.spell && player.rage >= 15 + UI(POOL) && infront(player)','target'},
  { '&Heroic Strike','inRange.spell && player.rage > 50 + UI(POOL) && infront(player)','target'},
}

local battleStance = {
  { 'Bloodrage','health >= 60','player'},
  { 'Rend','!debuff && player.rage >= 10','target'},
  { 'Thunder Clap','!debuff && player.rage >= 20 && combat && distance <= 10 && toggle(aoe)','enemies'},
  { 'Sunder Armor','debuff.count < 5 && player.rage > 20','target'},
  { '&Heroic Strike','player.rage > 50','target'},
}

local InCombat = {
  { '&/startattack','!isattacking & target.exists && !dead','target'},
  { 'Battle Shout','!buff.any && distance <= 20 && player.rage >= 10','player'},

  -- Thunderclap stance dance
  { 'Thunder Clap','UI(role) == 2 && player.rage >= 20 && combat && distance <= 10 && !debuff && UI(T_TC) && toggle(aoe)','enemies'},

  -- Time to change Stance
  { 'Battle Stance','UI(role) == 1 && stance ~= 1','player'},
  { 'Defensive Stance','UI(role) == 2 && stance ~= 2','player'},

  { battleStance,'stance == 1'},
  { defStance,'stance == 2'},

  { 'Shoot Bow','inRange.spell && !player.moving','target'},
  { 'Shoot Gun','inRange.spell && !player.moving','target'},
}

--CR for out of combat
-- OPTIONAL!
local OutCombat = {
  -- Set to battle stance so that we can charge in
  { 'Battle Stance','stance ~= 1 && target.distance <= 20 && target.exists','player'},
}

-- Enter name and ID
-- this allows your cr to work on any language and at the same time remain readable
-- OPTIONAL!
local spell_ids = {}

local buffsBlacklist = {}
local debuffsBlacklist = {}

-- These are blacklisting exemples
-- (### means number)
-- OPTIONAL!
local blacklist = {
     units = {},
     buffs = buffsBlacklist,
     debuff = debuffsBlacklist,
}

-- SPEC_ID can be found on:
-- https://github.com/MrTheSoulz/NerdPack/wiki/Class-&-Spec-IDs
NeP.CR:Add(1, {
     wow_ver = '1.13.2', -- Optional!
     nep_ver = "2", -- Optional!
     name = '[Silver] Warrior',
     ic = InCombat, -- Optional!
     ooc= OutCombat, -- Optional!
     load = ExeOnLoad, -- Optional!
     unload = ExeOnUnload, -- Optional!
     gui= GUI, -- Optional!
     gui_st = GUI_ST, -- Optional!
     ids = spell_ids, -- Optional!
     blacklist = blacklist, -- Optional!
     pooling = true, -- Optional! [[This makes nep wait for a spell if the conditions are true but the spell is on cooldown.]]
})
