-- OPTIONAL!
-- List of all elements can be found at:
-- https://github.com/MrTheSoulz/NerdPack/wiki/Class-Interface
local GUI = {
  {type = "dropdown", text = "Seal", key = "seal", width = 100, list = {
  {key = "1", text = "Righteousness"},
  {key = "2", text = "Prot Tanking"},
  {key = "3", text = "Fury DPS"},
  }, default = "1" },
  {type = "dropdown", text = "Aura", key = "aura", width = 100, list = {
  {key = "1", text = "Devotion"},
  {key = "2", text = "Prot Tanking"},
  {key = "3", text = "Fury DPS"},
  }, default = "1" },

  {type = 'header', text = 'Healing', align = 'center'},
  {type = 'text', text = 'Holy Light', align = 'center'},
  {type = 'spinner', 	text = 'Rank 1', key = 'HL1', 	default = 90},
}

-- OPTIONAL!
local GUI_ST = {
  title='[Silver] Paladin',
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
  -- Aura
  { 'Devotion Aura','stance == 1 and !buff && UI(aura) = 1','player'},
  -- Warrior
  { 'Blessing of Might','inRange.spell && isClass == 1 && !buff.any',{'target','friendly'}},
  -- Paladin
  { 'Blessing of Might','inRange.spell && isClass == 2 && !buff.any',{'target','friendly'}},
  -- Hunter
  { 'Blessing of Might','inRange.spell && isClass == 3 && !buff.any',{'target','friendly'}},
  -- Rogue
  { 'Blessing of Might','inRange.spell && isClass == 4 && !buff.any',{'target','friendly'}},
  -- Priest
  { 'Blessing of Wisdom','inRange.spell && isClass == 5 && !buff.any',{'target','friendly'}},
  -- Mage
  { 'Blessing of Wisdom','inRange.spell && isClass == 8 && !buff.any',{'target','friendly'}},
  -- Warlock
  { 'Blessing of Wisdom','inRange.spell && isClass == 9 && !buff.any',{'target','friendly'}},

  -- Do Might if Wisdom there
  { 'Blessing of Might','inRange.spell && !buff.any && buff(Blessing of Wisdom).any && !buff(Blessing of Wisdom)',{'target','friendly'}},
  -- Do wisdom if might already there
  { 'Blessing of Wisdom','inRange.spell && !buff.any && buff(Blessing of Might).any && !buff(Blessing of Might)',{'target','friendly'}},
}

local healing = {
  -- Spells seperated by ranks. Select heal % in GUI
  -- Holy Light
  { 'Holy Light(Rank 1)','inRange.spell && health <= UI(HL1)',{'lowest','friendly'}},
}

local dps = {
  { 'Seal of Righteousness','!buff && UI(seal) == 1','player'},
  { 'Judgement','inRange.spell','target'},
}

local InCombat = {
  { '&/startattack','!isattacking & target.exists && !dead','target'},
  { buff},

  { healing},
  { dps},
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
NeP.CR:Add(2, {
     wow_ver = '1.13.2', -- Optional!
     nep_ver = "2", -- Optional!
     name = '[Silver] Paladin',
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
