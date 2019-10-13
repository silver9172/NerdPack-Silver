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
  {type = 'spinner', 	text = 'Energy Pool', key = 'POOL', 	default = 20},
}

-- OPTIONAL!
local GUI_ST = {
  title='[Silver] Rogue',
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

local stealth = {
  { 'Garrote','inRange.spell && behind','target'},
}

local rotation = {
  { '&/startattack','!isattacking & target.exists'},

  { 'Riposte','inRange.spell(Sinister Strike) && player.energy >= 10 + UI(POOL)','target'},

  { 'Slice and Dice','inRange.spell(Sinister Strike) && player.buff.duration <= 1.5 && player.combopoints >= 0 && player.energy >= 25 + UI(POOL)','target'},
  { 'Eviscerate','inRange.spell && player.combopoints == 5 && player.energy >= 35 + UI(POOL) && infront(player)','target'},
  { 'Sinister Strike','inRange.spell && player.energy >= 45 + UI(POOL) && player.combopoints < 5 && infront(player)','target'},

  { 'Shoot Bow','inRange.spell','target'},
  { 'Shoot Gun','inRange.spell','target'},
  { 'Throw','inRange.spell','target'},
}

local InCombat = {

  { stealth,'player.buff(Stealth)'},
  { rotation,'!player.buff(Stealth)'},
}

local OutCombat = {
  { stealth,'player.buff(Stealth)'},
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
NeP.CR:Add(4, {
     wow_ver = '1.13.2', -- Optional!
     nep_ver = "2", -- Optional!
     name = '[Silver] Rogue',
     ic = InCombat, -- Optional!
     ooc= OutCombat, -- Optional!
     load = ExeOnLoad, -- Optional!
     unload = ExeOnUnload, -- Optional!
     gui= GUI, -- Optional!
     gui_st = GUI_ST, -- Optional!
     ids = spell_ids, -- Optional!
     blacklist = blacklist, -- Optional!
     pooling = false, -- Optional! [[This makes nep wait for a spell if the conditions are true but the spell is on cooldown.]]
})
