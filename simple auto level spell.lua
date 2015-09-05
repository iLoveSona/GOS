require ("DLib")

local spellTable = {_Q, _W, _E, _R}
-- local spellTablePre3 = {_Q, _W, _E}

local name = GetObjectName(GetMyHero())

local submenu = menu.addItem(SubMenu.new("simple auto level spell for "..name))
local disableAtLv1 = submenu.addItem(MenuBool.new("disable auto level spell at Lv1", true))
local submenuSpellTablePre3 = submenu.addItem(SubMenu.new("level spell sequence before Lv3"))
local submenuSpellTablePre3List = {
	submenuSpellTablePre3.addItem(MenuStringList.new("Lv1", {"Q", "W", "E", "R"}, 1)),
	submenuSpellTablePre3.addItem(MenuStringList.new("Lv2", {"Q", "W", "E", "R"}, 2)),
	submenuSpellTablePre3.addItem(MenuStringList.new("Lv3", {"Q", "W", "E", "R"}, 3))
}
local submenuSpellTable = submenu.addItem(SubMenu.new("level spell sequence after Lv3"))
local submenuSpellTableList = {
	submenuSpellTable.addItem(MenuStringList.new("first", {"Q", "W", "E", "R"}, 4)),
 	submenuSpellTable.addItem(MenuStringList.new("second", {"Q", "W", "E", "R"}, 1)),
	submenuSpellTable.addItem(MenuStringList.new("third", {"Q", "W", "E", "R"}, 2)),
 	submenuSpellTable.addItem(MenuStringList.new("last", {"Q", "W", "E", "R"}, 3))
 }
submenu.addItem(MenuSeparator.new("You need F6F6 after change the setting"))

local spellSequence = {
	spellTable[submenuSpellTableList[1].getValue()],
	spellTable[submenuSpellTableList[2].getValue()],
	spellTable[submenuSpellTableList[3].getValue()],
	spellTable[submenuSpellTableList[4].getValue()],
}
local spellSequencePre3 = {
	spellTable[submenuSpellTablePre3List[1].getValue()],
	spellTable[submenuSpellTablePre3List[2].getValue()],
	spellTable[submenuSpellTablePre3List[3].getValue()],
}

-- local function init()
-- 	spellSequence = {
-- 		spellTable[submenuSpellTableList[1].getValue()],
-- 		spellTable[submenuSpellTableList[2].getValue()],
-- 		spellTable[submenuSpellTableList[3].getValue()],
-- 		spellTable[submenuSpellTableList[4].getValue()],
-- 	}
-- 	spellSequencePre3 = {
-- 		spellTable[submenuSpellTablePre3List[1].getValue()],
-- 		spellTable[submenuSpellTablePre3List[2].getValue()],
-- 		spellTable[submenuSpellTablePre3List[3].getValue()],
-- 	}
-- end

-- init()

-- PrintChat(spellSequence[1]..spellSequence[2]..spellSequence[3]..spellSequence[4])
local lv = 0

local function doLevelSpellPre3()
	LevelSpell(spellSequencePre3[lv])
end

local function doLevelSpell()
	for _,slot in pairs(spellSequence) do
		if LevelSpell(slot) then break end
	end
end

OnLoop(function(myHero)
	local newLv = GetLevel(myHero)

	-- only level spell when level up
	if lv == newLv then return end
	lv = newLv

	if disableAtLv1.getValue() and lv == 1 then return end
	-- if lv < 6 then return end
	if lv <= 3 and spellSequencePre3 then
		doLevelSpellPre3()
	else
		doLevelSpell()
	end

	
end)

-- api table
local s = {}

 function s.setLvSpellSequence(m_spellSequence, m_spellSequencePre3, m_disableAtLv1)
	-- TODO should change the menu value instead just change list directly
	spellSequence = m_spellSequence
	spellSequencePre3 = m_spellSequencePre3
	disableAtLv1.setValue(m_disableAtLv1 or false)
	-- init()

	PrintChat("simple auto level spell for "..name.." lib mode ON, menu setting will overwrite by script")
	return true
end

PrintChat("simple auto level spell for "..name.." loaded")

return s