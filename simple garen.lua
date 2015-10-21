local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Garen" then return end

require 'Interrupter'
d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local GetEnemyHeroes = d.GetEnemyHeroes
local CalcDamage = d.CalcDamage

local atkRange = GetRange(myHero)

-- testing
addInterrupterCallback(function(target, spellType, spell)
	if IsInDistance(target, atkRange) and CanUseSpell(myHero,_Q) == READY and spellType == CHANELLING_SPELLS then
		CastSpell(_Q)
		AttackUnit(target)
	end
end)

local rBuffTarget
OnUpdateBuff(function(object,buffProc)
	if buffProc.Name == "garenpassiveenemytarget" then
		-- PrintChat(GetObjectName(object).." "..buffProc.Name)
		rBuffTarget = GetObjectName(object)
	end
end)

local rDmgTable = {0.286, 0.333, 0.4}

OnTick(function(myHero)
	local rLv = GetCastLevel(myHero, _R)

	if CanUseSpell(myHero,_R) == READY then
		for _,target in pairs(GetEnemyHeroes()) do
			if ValidTarget(target, GetCastRange(myHero,_R)) then
				local hp = GetCurrentHP(target)
				local rDmg = 175 * rLv + ( GetMaxHP(target) - hp ) * rDmgTable[rLv]
				if GetObjectName(target) == rBuffTarget and rDmg > hp then
					CastTargetSpell(target, _R)
					break
				elseif CalcDamage(myHero, target, 0, rDmg) > hp then
					CastTargetSpell(target, _R)
					break
				end
			end
		end
	end
	
end)

OnProcessSpellComplete(function(unit, spell)
  if unit == myHero and spell.name:lower():find("attack") and KeyIsDown(32) then
   	if CanUseSpell(myHero,_Q) == READY then
   		CastSpell(_Q)
   	elseif CanUseSpell(myHero,_E) == READY and GetCastName(myHero, _E) == "GarenE" then
   		CastSpell(_E)
   	end
  end
end)

PrintChat("simple garen loaded")