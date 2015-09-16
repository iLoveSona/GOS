-- modify from SimpleLib.lua(iCreative)
CHANELLING_SPELLS = {
    ["Caitlyn"]                     = {_R},
    ["Katarina"]                    = {_R},
    ["MasterYi"]                    = {_W},
    ["FiddleSticks"]                = {_W, _R},
    ["Galio"]                       = {_R},
    ["Lucian"]                      = {_R},
    ["MissFortune"]                 = {_R},
    ["VelKoz"]                      = {_R},
    ["Nunu"]                        = {_R},
    ["Shen"]                        = {_R},
    ["Karthus"]                     = {_R},
    ["Malzahar"]                    = {_R},
    ["Pantheon"]                    = {_R},
    ["Warwick"]                     = {_R},
    ["Xerath"]                      = {_Q, _R},
    ["Varus"]                       = {_Q},
    ["TahmKench"]                   = {_R},
    ["TwistedFate"]                 = {_R},
    ["Janna"]                       = {_R}
}

GAPCLOSER_SPELLS = {
    ["Aatrox"]                      = {_Q},
    ["Akali"]                       = {_R},
    ["Alistar"]                     = {_W},
    ["Amumu"]                       = {_Q},
    ["Corki"]                       = {_W},
    ["Diana"]                       = {_R},
    ["Elise"]                       = {_Q, _E},
    ["FiddleSticks"]                = {_R},
    ["Ezreal"]                      = {_E},
    ["Fiora"]                       = {_Q},
    ["Fizz"]                        = {_Q},
    ["Gnar"]                        = {_E},
    ["Gragas"]                      = {_E},
    ["Graves"]                      = {_E},
    ["Hecarim"]                     = {_R},
    ["Irelia"]                      = {_Q},
    ["JarvanIV"]                    = {_Q, _R},
    ["Jax"]                         = {_Q},
    ["Jayce"]                       = {_Q},
    ["Katarina"]                    = {_E},
    ["Kassadin"]                    = {_R},
    ["Kennen"]                      = {_E},
    ["KhaZix"]                      = {_E},
    ["Lissandra"]                   = {_E},
    ["LeBlanc"]                     = {_W, _R},
    ["LeeSin"]                      = {_Q, _W},
    ["Leona"]                       = {_E},
    ["Lucian"]                      = {_E},
    ["Malphite"]                    = {_R},
    ["MasterYi"]                    = {_Q},
    ["MonkeyKing"]                  = {_E},
    ["Nautilus"]                    = {_Q},
    ["Nocturne"]                    = {_R},
    ["Olaf"]                        = {_R},
    ["Pantheon"]                    = {_W, _R},
    ["Poppy"]                       = {_E},
    ["RekSai"]                      = {_E},
    ["Renekton"]                    = {_E},
    ["Riven"]                       = {_Q, _E},
    ["Rengar"]                      = {_R},
    ["Sejuani"]                     = {_Q},
    ["Sion"]                        = {_R},
    ["Shen"]                        = {_E},
    ["Shyvana"]                     = {_R},
    ["Talon"]                       = {_E},
    ["Thresh"]                      = {_Q},
    ["Tristana"]                    = {_W},
    ["Tryndamere"]                  = {_E},
    ["Udyr"]                        = {_E},
    ["Volibear"]                    = {_Q},
    ["Vi"]                          = {_Q},
    ["XinZhao"]                     = {_E},
    ["Yasuo"]                       = {_E},
    ["Zac"]                         = {_E},
    ["Ziggs"]                       = {_W},
}

local spellText = { "Q", "W", "E", "R" }

local callback = nil
local myTeam = GetTeam(GetMyHero())

local d = require 'DLib'
local GetEnemyHeroes = d.GetEnemyHeroes
local CHANELLING_SPELLS_enemy = {}
local GAPCLOSER_SPELLS_enemy = {}
local submenu = menu.addItem(SubMenu.new("interrupter"))

local submenuGapClose = submenu.addItem(SubMenu.new("gap close spell"))
local submenuChannell = submenu.addItem(SubMenu.new("chanelling spell"))

local loaded = false
d.initCallback(function(result)
    if result then
        for _,enemy in pairs(GetEnemyHeroes()) do
            local name = GetObjectName(enemy)
            
            local list = GAPCLOSER_SPELLS[name]
            if list then
                for _, spellSlot in pairs(list) do
                    GAPCLOSER_SPELLS_enemy[name..spellSlot] = submenuGapClose.addItem(MenuBool.new(name.." "..spellText[spellSlot+1], true))
                end
            end
            list = CHANELLING_SPELLS[name]
            if list then
                for _, spellSlot in pairs(list) do
                    CHANELLING_SPELLS_enemy[name..spellSlot] = submenuChannell.addItem(MenuBool.new(name.." "..spellText[spellSlot+1], true))
                end
            end
            -- PrintChat(name)
        end
        loaded = true
        PrintChat("[interrupter] : loaded")
    end
end)

OnProcessSpell(function(unit, spell)    
    if not loaded and not callback or not unit or GetObjectType(unit) ~= Obj_AI_Hero  or GetTeam(unit) == myTeam then return end
    local unitName = GetObjectName(unit)
    local unitChanellingSpells = CHANELLING_SPELLS[unitName]
    local unitGapcloserSpells = GAPCLOSER_SPELLS[unitName]
    local spellName = spell.name

    if unitChanellingSpells then
        for _, spellSlot in pairs(unitChanellingSpells) do
            -- PrintChat(spell.name.." "..GetCastName(unit, spellSlot))
            if spellName == GetCastName(unit, spellSlot) and CHANELLING_SPELLS_enemy[unitName..spellSlot].getValue() then callback(unit, CHANELLING_SPELLS, spell) end
        end
    elseif unitGapcloserSpells then
        for _, spellSlot in pairs(unitGapcloserSpells) do
            if spellName == GetCastName(unit, spellSlot) and GAPCLOSER_SPELLS_enemy[unitName..spellSlot].getValue() then callback(unit, GAPCLOSER_SPELLS, spell) end
        end
    end
end)

function addInterrupterCallback( callback0 )
	callback = callback0
end

PrintChat("[interrupter] : loading...")