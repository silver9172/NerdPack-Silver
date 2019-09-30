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

local buff = {
  { 'Demon Skin','buff.duration <= 120','player'},

}

local InCombat = {
  { buff},

  -- Dots
  { 'Corruption','!debuff && combat','target'},
  { 'Corruption','!debuff && combat','enemies'},
  { 'Curse of Agony','!debuff && combat','target'},
  { 'Curse of Agony','!debuff && combat','enemies'},
  { '!Corruption','!debuff && combat && iswanding','target'},
  { '!Corruption','!debuff && combat && iswanding','enemies'},
  { '!Curse of Agony','!debuff && combat && iswanding','target'},
  { '!Curse of Agony','!debuff && combat && iswanding','enemies'},

  -- Wand
  { 'Shoot','!iswanding','target'},
}

--CR for out of combat
-- OPTIONAL!
local OutCombat = {
  { buff},

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
NeP.CR:Add(9, {
     wow_ver = '1.12', -- Optional!
     nep_ver = "2", -- Optional!
     name = '[Silver] Warlock',
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
