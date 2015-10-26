if GetObjectName(GetMyHero()) ~= "Ezreal" then return end

local d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget

OnTick(function(myHero)
	local target = GetCurrentTarget()
	
	if KeyIsDown(32) and ValidTarget(target) then

		if CanUseSpell(myHero,_Q) == READY and IsInDistance(target, GetCastRange(myHero,_Q))then
			-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
			local pred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),2000,250,GetCastRange(myHero,_Q),60,true,true)
			if pred.HitChance == 1 then
				CastSkillShot(_Q, pred.PredPos.x, pred.PredPos.y, pred.PredPos.z)
			end
		end

		if CanUseSpell(myHero,_W) == READY and IsInDistance(target, GetCastRange(myHero,_W))then
			-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
			local pred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1600,250,GetCastRange(myHero,_W),80,false,true)
			if pred.HitChance == 1 then
				CastSkillShot(_W, pred.PredPos.x, pred.PredPos.y, pred.PredPos.z)
			end
		end

	end
end)

PrintChat("simple ezreal script loaded")