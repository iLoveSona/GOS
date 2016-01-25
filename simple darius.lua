local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Darius" then return end

require 'Interrupter'
d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local GetEnemyHeroes = d.GetEnemyHeroes
local GetTarget = d.GetTarget
local GetDistance = d.GetDistance

local submenu = menu.addItem(SubMenu.new("simple darius"))
local combo = submenu.addItem(MenuKeyBind.new("combo key", string.byte(" ")))
local drawQCircle = submenu.addItem(MenuBool.new("draw Q circle", false))

addInterrupterCallback(function(target, spellType, spell)
	if IsInDistance(target, GetCastRange(myHero, _E)) and CanUseSpell(myHero,_E) == READY and spellType == CHANELLING_SPELLS then
		CastSkillShot(_E,GetOrigin(target))
	end
end)

OnDraw(function(myHero)
	if drawQCircle.getValue() then
		DrawCircle(GetOrigin(myHero),205+GetHitBox(myHero),0,0,0xffff0000)
		DrawCircle(GetOrigin(myHero),425,0,0,0xffff0000)
	end
end)

local rBuffTable = {}
OnUpdateBuff(function(object,buffProc)
	if buffProc.Name == "dariushemo" and GetObjectType(object) == Obj_AI_Hero then
		-- PrintChat("OnUpdateBuff:"..GetObjectName(object).." "..buffProc.Count)
		rBuffTable[GetObjectName(object)] = buffProc.Count
	end
end)

OnRemoveBuff(function(object,buffProc)
	if buffProc.Name == "dariushemo" and GetObjectType(object) == Obj_AI_Hero then
		-- PrintChat("OnRemoveBuff:"..GetObjectName(object).." "..buffProc.Count)
		rBuffTable[GetObjectName(object)] = 0
	end
end)

local rRange = GetCastRange(myHero, _R)
local function castR()
	local rLv = GetCastLevel(myHero, _R)
	local bonusAD = GetBonusDmg(myHero)

	if CanUseSpell(myHero,_R) == READY then
		for _,target in pairs(GetEnemyHeroes()) do
			if ValidTarget(target, rRange) then
				local count = rBuffTable[GetObjectName(target)] or 0
				local rDmg = 100 * rLv + 0.75 * bonusAD + (20 * rLv + bonusAD * 0.15) * count
				if rDmg > GetCurrentHP(target) then
					CastTargetSpell(target, _R)
					break
				end
			end
		end
	end
end

local function castQ()
	local target = GetTarget(400, DAMAGE_PHYSICAL)
	if target and CanUseSpell(myHero, _Q) == READY then
		CastSpell(_Q)
	end
end

local eRange = GetCastRange(myHero, _E)
local activeERange = GetRange(myHero) + GetHitBox(myHero) + 100
local function castE()
	local target = GetTarget(eRange, DAMAGE_PHYSICAL)
	if target and CanUseSpell(myHero, _E) == READY and GetDistance(target) > activeERange then
		CastSkillShot(_E,GetOrigin(target))
	end
end

require('simple orbwalk')
OnTick(function(myHero)
	castR()
		
	if combo.getValue() then
		castE()
		if CanUseSpell(myHero, _W) ~= READY then
			castQ()
		end
	end

end)

OnProcessSpellComplete(function(unit, spell)
  if unit == myHero and spell.name:lower():find("attack") and combo.getValue() and CanUseSpell(myHero,_W) == READY then
   	CastSpell(_W)
  end
end)

OnProcessSpell(function(unit, spell)
	if unit == myHero and spell.name == "DariusNoxianTacticsONH" then
		resetAA()
  end
end)

PrintChat("simple darius loaded")