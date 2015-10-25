local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Varus" then return end

local d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local GetTarget = d.GetTarget

local submenu = menu.addItem(SubMenu.new("simple varus"))
local combo = submenu.addItem(MenuKeyBind.new("combo key", string.byte(" ")))

require 'Interrupter'
addInterrupterCallback(function(target, spellType, spell)
	if IsInDistance(target, GetCastRange(myHero,_R)) and CanUseSpell(myHero,_R) == READY then
		if spellType == GAPCLOSER_SPELLS and GetDistance(spell.startPos) > GetDistance(spell.endPos) then
			CastSkillShot(_R, spell.endPos)
		end
	end
end)

local isCastingQ = false
local qTime = 0
local qRangeMin = 925
local qRangeMax = 1625
local function castQ(target0)
	local target = target0 or GetTarget(qRangeMax, DAMAGE_MAGIC)
	if not target then return end
	if IsInDistance(target, qRangeMax) and CanUseSpell(myHero,_Q) == READY then
		local qRange = qRangeMin + (GetGameTimer() - qTime) * 350
		if qRange > qRangeMax then	qRange = qRangeMax end
		-- PrintChat(tostring(qRange))

		-- start castQ
		if not isCastingQ then
			local mousePos = GetMousePos()
      CastSkillShot(_Q,mousePos)
      return
    end

    -- release castQ
    if IsInDistance(target, qRange) then 
    	-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
    	local pred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1850,250,qRange,70,false,true)
    	if pred.HitChance == 1 then 
    		CastSkillShot2(_Q,pred.PredPos)
    	end
		end
	end
end

OnTick(function(myHero)
	if combo.getValue() then
		castQ()
	end
end)

OnUpdateBuff(function(object,buffProc)
	if object == myHero and buffProc.Name == "VarusQ" then
		isCastingQ = true
		qTime = buffProc.StartTime
	end
end)

OnRemoveBuff(function(object,buffProc)
	if object == myHero and buffProc.Name == "VarusQ" then
		isCastingQ = false
	end
end)

PrintChat("simple varus loaded")