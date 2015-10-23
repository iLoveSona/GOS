local myHero = GetMyHero()

d = require 'DLib'
local GetTarget = d.GetTarget

local submenu = menu.addItem(SubMenu.new("simple orbwalk"))
local combo = submenu.addItem(MenuKeyBind.new("combo key", string.byte(" ")))

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

function resetAA()
  nextAttackTime = 0
  if combo.getValue() then
    orbwalk()
  end
end

-- modify from inspired
local function CastOffensiveItems(unit)
  i = {3748, 3074, 3077, 3142, 3184}
  u = {3153, 3146, 3144}
  for _,k in pairs(i) do
    slot = GetItemSlot(GetMyHero(),k)
    if slot ~= nil and slot ~= 0 and CanUseSpell(myHero, slot) == READY then
      CastTargetSpell(myHero, slot)
      return true
    end
  end
  for _,k in pairs(u) do
    slot = GetItemSlot(myHero,k)
    if slot ~= nil and slot ~= 0 and CanUseSpell(myHero, slot) == READY then
      CastTargetSpell(unit, slot)
      return true
    end
  end
  return false
end

OnTick(function(myHero)
	if combo.getValue() then
		orbwalk()
	end
end)

OnProcessSpellComplete(function(unit, spellProc)
  if unit == myHero and spellProc.name:lower():find("attack") then
  	if GetObjectType(spellProc.target) == Obj_AI_Hero then
  		CastOffensiveItems(unit)
  	end
   	nextAttackTime = GetTickCount() + 1000 / (GetAttackSpeed(unit) * baseAS)
    if combo.getValue() then
      orbwalk()
    end
  end
end)

PrintChat("simple orbwalk loaded")