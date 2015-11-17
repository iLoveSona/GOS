-- known issue:
-- with OnCreateObj, if reload in game, we will lost all saved obj

local spellList = { LeeSin = _W, Katarina = _E, Jax = _Q }
local myHero = GetMyHero()
local name = GetObjectName(myHero)
local spellSlot = spellList[ name ]

-- only 3 champion can do ward jump now
if not spellSlot then return end

require 'MapPositionGOS'
local d = require 'DLib'
local GetEnemyHeroes = d.GetEnemyHeroes
local GetAllyHeroes = d.GetAllyHeroes

local submenu = menu.addItem(SubMenu.new("simple ward jump for "..name))
local key = submenu.addItem(MenuKeyBind.new("ward jump key", string.byte("Z")))
local detectWall = submenu.addItem(MenuBool.new("detect wall", true))
local debugmode = submenu.addItem(MenuBool.new("debug mode", false))
local drawWardRange = submenu.addItem(MenuBool.new("draw ward range", false))


-- local everything as much as possible for fps(not really work)
local GetOrigin = GetOrigin
local GetObjectName = GetObjectName
local GetObjectType = GetObjectType

local wardRange = 600
-- local debug = false
local debug = debugmode.getValue()

-- copy from perfect ward
local wardItems = {
	{ id = 3711, name = "Tracker's Knife"},
	{ id = 2303, name = "Eye of the Equinox"},
	{ id = 2301, name = "Eye of the Watchers"},
	{ id = 2302, name = "Eye of the Oasis"},
	{ id = 3340, name = "TrinketTotemLvl1"},--Warding Totem (Trinket)
	{ id = 3350, name = "TrinketTotemLvl2"},
	{ id = 3361, name = "TrinketTotemLvl3"},--Greater Stealth Totem (Trinket)
	{ id = 3362, name = "TrinketTotemLvl3B"},--Greater Vision Totem (Trinket)
	-- { id = 3363, name = ""},--Farsight Alteration
	{ id = 3154, name = "wrigglelantern"},--Wriggle's Lantern
	-- { id = 3160, name = "FeralFlare"},
	{ id = 2045, name = "ItemGhostWard"},--Ruby Sightstone
	{ id = 2049, name = "ItemGhostWard"},--Sightstone
	{ id = 2050, name = "ItemMiniWard"},--Explorer's Ward
	{ id = 2044, name = "sightward"},
	{ id = 2043, name = "VisionWard"}--Vision Ward
}

local jumpTarget
local wardLock
local mousePos
local wardpos
local maxPos 
local spellObj
local objectList = {}

-- modified from Inspired.lua
local function GetDistanceSqr(p1,p2)
    p2 = p2 or GetOrigin(myHero)
    local dx = p1.x - p2.x
    local dz = (p1.z or p1.y) - (p2.z or p2.y)
    return dx*dx + dz*dz
end

local function IsInDistance(r, p1, p2, fast)
		local fast = fast or false
		-- local fast = true
		if fast then
			-- faster check, but don't know why still fps drop...
			local p1y = p1.z or p1.y
			local p2y = p2.z or p2.y
			return (p1.x + r >= p2.x) and (p1.x - r <= p2.x) and (p1y + r >= p2y) and (p1y - r <= p2y)
		else
    	return GetDistanceSqr(p1, p2) < r*r
    end
end

-- modified from vayne.lua(Laiha)
local function calcMaxPos(pos)
	local origin = GetOrigin(myHero)
	local vectorx = pos.x-origin.x
	local vectory = pos.y-origin.y
	local vectorz = pos.z-origin.z
	local dist= math.sqrt(vectorx^2+vectory^2+vectorz^2)
	return {x = origin.x + wardRange * vectorx / dist ,y = origin.y + wardRange * vectory / dist, z = origin.z + wardRange * vectorz / dist}
end

local function validTarget( object )
	local objType = GetObjectType(object)
	
	-- need check type == ward, but rito set everything is minion lol	
	return (objType == Obj_AI_Hero or objType == Obj_AI_Minion) and IsVisible(object) and IsTargetable(object)
end

-- local function validTargetLee( object )
-- 	local objType = GetObjectType(object)
	
-- 	-- need check type == ward, but rito set everything is minion lol	
-- 	-- poor lee cannot jump to enemy
-- 	return (objType == Obj_AI_Hero or objType == Obj_AI_Minion) and IsVisible(object) and IsTargetable(object) and GetTeam(object) == GetTeam(myHero)
-- end

if name == "LeeSin" then 
	validTarget = function ( object )
		local objType = GetObjectType(object)
	
		-- need check type == ward, but rito set everything is minion lol	
		-- poor lee cannot jump to enemy
		return (objType == Obj_AI_Hero or objType == Obj_AI_Minion) and IsVisible(object) and IsTargetable(object) and GetTeam(object) == GetTeam(myHero)
	end
end

local function findWardSlot()
	local slot = nil
	for i,wardItem in pairs(wardItems) do
		slot = GetItemSlot(myHero,wardItem.id)
		if slot > 0 and CanUseSpell(myHero, slot) == READY then return slot end
	end
	return nil
end

local function putWard(pos0)	
	local slot = findWardSlot()
	if not slot then return end

	local pos = pos0
	if not IsInDistance(wardRange, pos) then
		pos = calcMaxPos(pos)
	end
	
	-- don't put ward in wall, or it might jump fail like noob
	if detectWall.getValue() then
		if MapPosition:inWall(pos) then return false end
	end

	if debug then DrawText("slot : "..slot,20,0,50,0xffffff00) end
	
	CastSkillShot(slot,pos.x,pos.y,pos.z)
	return true
end

local function drawDebugInfo()
	if mousePos then
		DrawCircle(mousePos.x,mousePos.y,mousePos.z,200,0,0,0xff00ff00)
	end
	if wardpos then
		DrawCircle(wardpos.x,wardpos.y,wardpos.z,200,0,0,0xffffff00)
	end
	if maxPos then
		DrawCircle(maxPos.x,maxPos.y,maxPos.z,200,0,0,0xffff0000)
	end
	DrawCircle( GetOrigin(myHero).x,GetOrigin(myHero).y,GetOrigin(myHero).z,GetCastRange(myHero,spellSlot),0,0,0xffffffff)

	if jumpTarget then
		DrawText("jumpTarget : "..GetObjectName(jumpTarget),20,0,100,0xffffff00)
	end

	if spellObj and spellObj.name then
		DrawText("spellObj : "..spellObj.name,20,0,200,0xffffff00)
	end

	if wardLock then
		DrawText("wardLock : "..wardLock,20,100,100,0xffffff00)
	end
end

local spellLock = nil

local function canWardJump()
	return not spellLock and CanUseSpell(myHero, spellSlot) == READY
end

if name == "LeeSin" then 
	canWardJump = function ()
		return not spellLock and CanUseSpell(myHero, spellSlot) == READY and GetCastName(myHero, spellSlot) ~= "blindmonkwtwo"
	end
end

function wardJump( pos )
	if canWardJump() then
		if jumpTarget then
			CastTargetSpell(jumpTarget, spellSlot)
			if debug then PrintChat(GetCastName(myHero, spellSlot).." GetTickCount "..GetTickCount()) end
			spellLock = GetTickCount()
		elseif not wardLock then
			if putWard(pos) then wardLock = GetTickCount() end
		end
	end
end

local function findTargetInList(list, pos)
	for _,object in pairs(list) do
	  if validTarget(object) and IsInDistance(200, GetOrigin(object), pos) then
	   	return object
	  end
	end
	return nil
end

local function GetJumpTargetHero(pos)
	local result = findTargetInList(GetEnemyHeroes(), pos)
	if result then return result end

	-- result = findTargetInList(GetAllyHeroes())
	-- if result then return result end
	-- return nil

	return findTargetInList(GetAllyHeroes(), pos)
end

if name == "LeeSin" then
	GetJumpTargetHero = function (pos)
		-- local result = findTargetInList(GetAllyHeroes(), pos)
		-- if result then return result end
		-- return nil

		return findTargetInList(GetAllyHeroes(), pos)
	end
end

local function GetJumpTarget()
	if wardLock then return findTargetInList(objectList, wardpos) end

	local pos = mousePos
	if not IsInDistance(wardRange, mousePos, GetOrigin(myHero)) then
		pos = maxPos
	end

	-- search hero
	local result = GetJumpTargetHero(pos)
	if result then return result end

	-- search minion
	-- result = findTargetInList(objectList, pos)
	-- if result then return result end

	-- return nil

	return findTargetInList(objectList, pos)
end

OnDraw(function()
	if debug then	drawDebugInfo()	end
	if drawWardRange.getValue() then 
		DrawCircle(GetOrigin(myHero),wardRange,0,0,0xffffffff) 
	end
end)

OnTick(function(myHero)
	mousePos = GetMousePos()
	maxPos = calcMaxPos(mousePos)

	jumpTarget = GetJumpTarget()	

	-- check spell name not lee W2
	if canWardJump() and jumpTarget and wardLock then
		CastTargetSpell(jumpTarget, spellSlot)
		if debug then PrintChat(GetCastName(myHero, spellSlot).." wardLock "..wardLock) end
		spellLock = GetTickCount()
	end

	if key.getValue() then
		wardJump(mousePos)
	end

	-- wardLock putWard every 500 ms
	if wardLock and (wardLock + 500) < GetTickCount()  then
		wardLock = nil
	end

	-- spellLock putWard every 500 ms
	if spellLock and (spellLock + 500) < GetTickCount()  then
		spellLock = nil
	end

	jumpTarget = nil
	spellObj = nil
	wardpos = nil
end)

OnObjectLoop(function(object,myHero)

	-- if jumpTarget then return end
	-- if not mousePos or not validTarget(object) then return end

	-- local objOrigin = GetOrigin(object)

 --  -- if wardpos and IsInDistance(200, objOrigin, wardpos) then
 --  -- 	jumpTarget = object
 --  -- 	return
 --  -- end

 --  local pos = mousePos
	-- if not IsInDistance(wardRange, mousePos, GetOrigin(myHero)) then
	-- 	pos = maxPos
	-- end
 --  if IsInDistance(200, objOrigin, pos) then
 --   	jumpTarget = object
 --   	return
 --  end
end)

OnProcessSpell(function(unit,spell)
	-- if not debug then return end

	-- TODO check spell == ward instead just check not hero spell
	if unit and unit == myHero and spell and not spell.name:lower():find("katarina") and not spell.name:lower():find("leesin") and not spell.name:lower():find("jax") then
		spellObj = spell
		wardpos = spellObj.endPos
	end
end)

OnCreateObj(function(object)
	local objType = GetObjectType(object)
	if objType == Obj_AI_Hero or objType == Obj_AI_Minion then
		objectList[object] = object
	end

	if debug then
		PrintChat(
			""..GetObjectBaseName(object).."  "..
			"IsVisible : "..tostring(IsVisible(object)).."  "..
			"GetTeam : "..GetTeam(object).."  "..
			"IsTargetable : "..tostring(IsTargetable(object)).."  "
			)
	end
end)

OnDeleteObj(function(object)
	local objType = GetObjectType(object)
	if objType == Obj_AI_Hero or objType == Obj_AI_Minion then
		objectList[object] = nil
	end
end)

PrintChat("simple ward jump for "..name.." loaded")