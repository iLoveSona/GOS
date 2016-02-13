if _G.simpleOrbwalkLoaded then return end
local myHero = GetMyHero()

d = require 'DLib'
local GetTarget = d.GetTarget
local GetDistance = d.GetDistance
local IsInDistance = d.IsInDistance

local submenu = menu.addItem(SubMenu.new("simple orbwalk"))
local combo = submenu.addItem(MenuKeyBind.new("combo key", string.byte(" ")))

local baseAS = GetBaseAttackSpeed(myHero)

-- copy from inspired
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

local nextAttackTime = - math.huge
local isAttackOn = true
function canAttack(setting)
	if setting then
		isAttackOn = setting
	else
		return nextAttackTime < GetTickCount() and isAttackOn
	end
end

local nextMoveTime = - math.huge
local isMoveOn = true
function canMove(setting)
	if setting then 
		isMoveOn = setting
	else
		return nextMoveTime < GetTickCount() and isMoveOn
	end
end

local function getMyRange()
	return GetRange(myHero) + GetHitBox(myHero)
end

local function orbwalk()
	local target = GetTarget(getMyRange(), DAMAGE_PHYSICAL)
	if target and canAttack() then
    AttackUnit(target)
  elseif target and canMove() and CastOffensiveItems(target) then
    -- do nothing
	elseif canMove() then
		MoveToXYZ(GetMousePos())
	end
end

function resetAA()
  nextAttackTime = - math.huge
end

local resetAASpell = nil
function addResetAASpell(resetAASpell0)
  resetAASpell = resetAASpell0
end

local function castSmite()
  if Smite then
    local range = GetCastRange(myHero,Smite)
    local target = GetTarget(range, DAMAGE_PHYSICAL)
    if target and IsInDistance(target, range) and CanUseSpell(myHero, Smite) == READY then
      CastTargetSpell(target, Smite)
    end
  end
end

OnTick(function(myHero)
	if combo.getValue() then
    orbwalk()
    castSmite()
	end
end)

OnProcessSpellAttack(function(unit, spellProc)
  -- local name = spellProc.name
  -- if unit == myHero and (name:lower():find("attack") or name:find("XenZhaoThrust")) then
  if unit == myHero then  
    local windup = spellProc.windUpTime * 1000
  	if GetObjectType(spellProc.target) == Obj_AI_Hero then
      delay(function()
        if not combo.getValue() then return end
        if resetAASpell and not resetAASpell() then
          -- CastOffensiveItems(unit)
        end
      end, windup)  		
  	end
   	nextAttackTime = GetTickCount() + 1000 / (GetAttackSpeed(unit) * baseAS) + GetLatency()
    nextMoveTime = GetTickCount() + windup + GetLatency()
  end
end)

_G.simpleOrbwalkLoaded = true
PrintChat("simple orbwalk loaded")