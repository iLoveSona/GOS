local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Karthus" then return end

local d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local CalcDamage = d.CalcDamage
local GetEnemyHeroes = d.GetEnemyHeroes

local function castQ( target )
	if IsInDistance(target, GetCastRange(myHero,_Q)) and CanUseSpell(myHero,_Q) == READY then	
		-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
		local pred = GetPredictionForPlayer(GetOrigin(target),target,GetMoveSpeed(target),math.huge,500,GetCastRange(myHero,_Q),200,false,true)
		if pred.HitChance == 1 then	
			CastSkillShot(_Q,pred.PredPos.x,pred.PredPos.y,pred.PredPos.z)
		end
	end
end

local function castW( target )
	if IsInDistance(target, GetCastRange(myHero,_W)) and CanUseSpell(myHero,_W) == READY then	
		-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
		local pred = GetPredictionForPlayer(GetOrigin(target),target,GetMoveSpeed(target),math.huge,500,GetCastRange(myHero,_W),800,false,true)
		if pred.HitChance == 1 then	
			CastSkillShot(_W,pred.PredPos.x,pred.PredPos.y,pred.PredPos.z)
		end
	end
end

local function castE( target )
	local isInDistance = IsInDistance(target, GetCastRange(myHero,_E))
	local eBuff = GotBuff(myHero,"KarthusDefile")

	-- open E
	if isInDistance and CanUseSpell(myHero,_E) == READY and eBuff <= 0 then
		CastTargetSpell(myHero, _E)
	end

	-- close E
	if not isInDistance and eBuff > 0 then
		CastTargetSpell(myHero, _E)
	end
end

local info = ""
local function killableInfo()
	-- no need show killable info when R in cd
	if CanUseSpell(myHero,_R) ~= READY then return end

	local rDmg = 100 + GetCastLevel(myHero,_R) * 150 + GetBonusAP(myHero) * 0.6
	-- info = "R dmg : "..rDmg .. "\n"
	info = ""
	for nID, enemy in pairs(GetEnemyHeroes()) do
		if IsObjectAlive(enemy) then
			realdmg = CalcDamage(myHero, enemy, 0, rDmg)
			hp = GetCurrentHP(enemy)
			if realdmg > hp then
				info = info..GetObjectName(enemy)
				if not IsVisible(enemy) then
					info = info.." maybe"
				end
				info = info.."  killable\n"
			end
			-- info = info..GetObjectName(enemy).."    HP:"..hp.."  dmg: "..realdmg.." "..killable.."\n"
		end
  end
  
end

OnDraw(function()
	DrawText(info,40,500,0,0xffff0000) 
end)

OnTick(function(myHero)
	killableInfo()

	local target = GetCurrentTarget()
	if ValidTarget(target) then
		if KeyIsDown(32) then
			castE(target)
			castW(target)
			castQ(target)
		end
	end
end)

PrintChat("simple karthus script loaded")