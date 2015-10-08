-- rework from Deftsu's Baseult

local myHero = GetMyHero()
local name = GetObjectName(myHero)

d = require 'DLib'
local CalcDamage = d.CalcDamage
local GetDistance = d.GetDistance

local spellData = {
	["Ashe"] = {
		delay = 250,
		missileSpeed = 1600,
		damage = function(target) return CalcDamage(myHero, target, 0, 75 + 175*GetCastLevel(myHero,_R) + GetBonusAP(myHero)) end
	},
	["Draven"] = {
		delay = 400,
		missileSpeed = 2000,
		damage = function(target) return CalcDamage(myHero, target, 75 + 100*GetCastLevel(myHero,_R) + 1.1*GetBonusDmg(myHero)) end
	},
	["Ezreal"] = {
		delay = 1000,
		missileSpeed = 2000,
		-- damage = function(target) return CalcDamage(myHero, target, 0, 200 + 150*GetCastLevel(myHero,_R) + .9*GetBonusAP(myHero)+GetBonusDmg(myHero)) end,
		damage = function(target) return CalcDamage(myHero, target, 0, (45*GetCastLevel(myHero,_R)+ 60 + (0.27*GetBonusAP(myHero)) + (0.30*GetBonusDmg(myHero)))) end
	},
	["Jinx"] = {
		delay = 600,
		-- missileSpeed = (GetDistance(enemyBasePos) / (1 + (GetDistance(enemyBasePos)-1500)/2500)),
		missileSpeed = 2300,
		damage = function(target) return CalcDamage(myHero, target, (GetMaxHP(target)-GetCurrentHP(target))*(0.2+0.05*GetCastLevel(myHero, _R)) + 150 + 100*GetCastLevel(myHero,_R) + GetBonusDmg(myHero)) end
	}	
}

local mySpellData = spellData[name]
if not mySpellData then return end

local basePos = {
	[100] = Vector(14340, 171, 14390),
	[200] = Vector(400, 200, 400)
}

local team = GetTeam(myHero)
local enemyBasePos = basePos[team]
local spellDelay = mySpellData.delay
local missileSpeed = mySpellData.missileSpeed
local damage = mySpellData.damage

-- local target
-- OnLoop(function(myHero)
-- 	if target then
-- 		DrawText("BaseUlt on "..GetObjectName(target),40,500,0,0xffff0000) 
-- 		DelayAction(function() target = nil end, 8000)
-- 	end
-- end)

local recallPos
OnProcessRecall(function(Object,recallProc)
	if GetTeam(Object) ~= team and CanUseSpell(myHero, _R) == READY and damage(Object) > GetCurrentHP(Object) then
		-- target = Object
		local timeToRecall = recallProc.totalTime
		local timeToHit = spellDelay + (GetDistance(enemyBasePos) * 1000 / missileSpeed)
		if timeToRecall > timeToHit then
			recallPos = Vector(Object)				
			delay(
				function() 
					if recallPos == Vector(Object) then
						CastSkillShot(_R, enemyBasePos.x, enemyBasePos.y, enemyBasePos.z)
						-- recallPos = nil
					end
				end, 
				timeToRecall-timeToHit
			)
		end
	end
end)

PrintChat("Baseult for "..name.." loaded")