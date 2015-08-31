require 'Inspired'

local function castQ( target )
	-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
	pred = GetPredictionForPlayer(GetOrigin(target),target,GetMoveSpeed(target),math.huge,500,GetCastRange(myHero,_Q),200,false,true)
	if IsInDistance(target, GetCastRange(myHero,_Q)) and CanUseSpell(myHero,_Q) == READY and pred.HitChance == 1 then	
		CastSkillShot(_Q,pred.PredPos.x,pred.PredPos.y,pred.PredPos.z)
	end
end

local function castW( target )
	-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
	pred = GetPredictionForPlayer(GetOrigin(target),target,GetMoveSpeed(target),math.huge,500,GetCastRange(myHero,_W),800,false,true)
	if IsInDistance(target, GetCastRange(myHero,_W)) and CanUseSpell(myHero,_W) == READY and pred.HitChance == 1 then	
		CastSkillShot(_W,pred.PredPos.x,pred.PredPos.y,pred.PredPos.z)
	end
end

local function castE( target )
	-- open E
	if IsInDistance(target, GetCastRange(myHero,_E)) and CanUseSpell(myHero,_E) == READY and GotBuff(myHero,"KarthusDefile") <= 0 then
		CastTargetSpell(myHero, _E)
	end

	-- close E
	if not IsInDistance(target, GetCastRange(myHero,_E)) and GotBuff(myHero,"KarthusDefile") > 0 then
		CastTargetSpell(myHero, _E)
	end
end

local function killableInfo()
	-- no need show killable info when R in cd
	if CanUseSpell(myHero,_R) ~= READY then return end

	rDmg = 100 + GetCastLevel(myHero,_R) * 150 + GetBonusAP(myHero) * 0.6
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
  DrawText(info,40,500,0,0xffff0000) 
end

OnLoop(function(myHero)
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