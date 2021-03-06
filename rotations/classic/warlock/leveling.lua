-- OPTIONAL!
-- List of all elements can be found at:
-- https://github.com/MrTheSoulz/NerdPack/wiki/Class-Interface
local GUI = {
  {type = "dropdown", text = "Pet", key = "pet", width = 100, list = {
  {key = "0", text = "None"},
  {key = "1", text = "Imp"},
  {key = "2", text = "Voidwalker"},
  }, default = "1" },

  {type = 'header', text = 'Arms Settings', align = 'center'},

  {type = 'header', text = 'Class Settings', align = 'center'},
  {type = 'spinner', text = 'Wand Start', 		key = 'wand', 		default = 25},
  {type = 'spinner', text = 'Shard Count', 		key = 'shard', 		default = 5},
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

local petCare = {
  { '/petattack','targettimeout(pet,1) && pet.exists && combat && distance <= 35','target'}
}

local buff = {
  { 'Demon Skin','buff.duration <= 120','player'},

}

local rotation = {
  { '!Drain Soul','inRange.spell && !player.moving && health <= 10 && !player.channeling(Drain Soul) && {shardCount < UI(shard) || player.mana <= 45}','target'},

  { 'Immolate','inRange.spell && !player.moving && targettimeout(immo,1.6) && !debuff','target'},
  { 'Immolate','inRange.spell && !player.moving && targettimeout(immo,1.6) && !debuff && combat && toggle(aoe)','enemies'},
  { 'Corruption','inRange.spell && targettimeout(corrupt,1.6) && !debuff','target'},
  { 'Corruption','inRange.spell && targettimeout(corrupt,1.6) && !debuff && combat && toggle(aoe)','enemies'},
  { 'Curse of Agony','inRange.spell && targettimeout(agony,1.6) && !debuff','target'},
  { 'Curse of Agony','inRange.spell && targettimeout(agony,1.6) && !debuff && combat && toggle(aoe)','enemies'},

  { 'Shadow Bolt','inRange.spell && !player.moving && player.mana > UI(wand)','target'},
  -- Wand
  { 'Shoot','targettimeout(wand,1) && inRange.spell && !player.moving && !iswanding && !lastcast.succeed && !lastcast && player.mana <= UI(wand) && spell.cooldown(Shadow Bolt) = 0','target'},
}

local InCombat = {
  { petCare},
  { buff},
  { 'Life Tap','player.mana <= UI(wand) && player.health > 65','target'},
  { rotation},
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
     pooling = false, -- Optional! [[This makes nep wait for a spell if the conditions are true but the spell is on cooldown.]]
})
