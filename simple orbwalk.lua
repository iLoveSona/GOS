local myHero = GetMyHero()

d = require 'DLib'
local GetTarget = d.GetTarget

local baseAS = GetBaseAttackSpeed(myHero)

local nextAttackTime = 0
local isAttackOn = true
function canAttack(setting)
	if setting then
		isAttackOn = setting
	else
		return nextAttackTime < GetTickCount() and isAttackOn
	end
end

local isMoveOn = true
function canMove(setting)
	if setting then 
		isMoveOn = setting
	else
		return isMoveOn
	end
end

function resetAA()
	nextAttackTime = 0
end

local function getMyRange()
	return GetRange(myHero) + GetHitBox(myHero)
end

local function orbwalk()
	local target = GetTarget(getMyRange(), DAMAGE_PHYSICAL)
	if target and canAttack() then
		AttackUnit(target)
	elseif canMove() then
		MoveToXYZ(GetMousePos())
	end
end

local function CastOffensiveItems(unit)
  i = {3748, 3074, 3077, 3142, 3184}
  u = {3153, 3146, 3144}
  for _,k in pairs(i) do
    slot = GetItemSlot(GetMyHero(),k)
    if slot ~= nil and slot ~= 0 and CanUseSpell(GetMyHero(), slot) == READY then
      CastTargetSpell(GetMyHero(), slot)
      return true
    end
  end
  for _,k in pairs(u) do
    slot = GetItemSlot(GetMyHero(),k)
    if slot ~= nil and slot ~= 0 and CanUseSpell(GetMyHero(), slot) == READY then
      CastTargetSpell(unit, slot)
      return true
    end
  end
  return false
end

OnTick(function(myHero)
	if KeyIsDown(32) then
		orbwalk()
	end
end)

OnProcessSpellComplete(function(unit, spellProc)
  if unit == myHero and spellProc.name:lower():find("attack") then
  	if GetObjectType(spellProc.target) == Obj_AI_Hero then
  		CastOffensiveItems(unit)
  	end
   	nextAttackTime = GetTickCount() + 1000 / (GetAttackSpeed(unit) * baseAS)
  end
end)

PrintChat("simple orbwalk loaded")