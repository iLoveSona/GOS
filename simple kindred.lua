local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Kindred" then return end

local d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local GetTarget = d.GetTarget
local GetDistance = d.GetDistance

local myRange = GetRange(myHero) + GetHitBox(myHero)

local qRange = GetCastRange(myHero,_Q)
-- PrintChat("qRange "..qRange)

-- modified from vayne.lua(Laiha)
local function calcMaxPos(pos)
	local origin = GetOrigin(myHero)
	local vectorx = pos.x-origin.x
	local vectory = pos.y-origin.y
	local vectorz = pos.z-origin.z
	local dist= math.sqrt(vectorx^2+vectory^2+vectorz^2)
	return {x = origin.x + qRange * vectorx / dist ,y = origin.y + qRange * vectory / dist, z = origin.z + qRange * vectorz / dist}
end

local function castQ()
	local target = GetCurrentTarget()
	local mousePos = GetMousePos()

	if GetDistance(mousePos, GetOrigin(myHero)) > qRange then
		mousePos = calcMaxPos(mousePos)
	end

	if (GetDistance(mousePos, GetOrigin(target)) <= 500) and ValidTarget(target) and CanUseSpell(myHero,_Q) == READY then
		CastSkillShot(_Q, mousePos)
	end
end

local wRange = GetCastRange(myHero,_W)
-- PrintChat("wRange "..wRange)
local function castW()
	local target = GetCurrentTarget()
	if ValidTarget(target, myRange) and CanUseSpell(myHero,_W) == READY then
		CastSpell(_W)
	end
end

local eRange = GetCastRange(myHero,_E)
-- PrintChat("eRange "..eRange)
local function castE()
	local target = GetTarget(eRange, DAMAGE_PHYSICAL)
	if target and CanUseSpell(myHero, _E) == READY then
		CastTargetSpell(target,_E)
	end
end

OnTick(function(myHero)
	if KeyIsDown(32) then
		local target = GetCurrentTarget()
		if Smite and ValidTarget(target, GetCastRange(myHero,Smite)) and CanUseSpell(myHero, Smite) == READY then
			CastTargetSpell(target, Smite)
		end
		castQ()
		castW()
		castE()
	end
end)

PrintChat("simple kindred loaded")