local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Xerath" then return end
-- known issue:
-- dead buff(kog, karthus) cause get target fail
-- recall cause pred fail(way point bug? only happen with AI)

d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local CalcDamage = d.CalcDamage
local GetTarget = d.GetTarget
local GetEnemyHeroes = d.GetEnemyHeroes
local GetDistance = d.GetDistance

local debug = false
local DrawDebugText = DrawText
if not debug then DrawDebugText = function ( ... ) end end

local submenu = menu.addItem(SubMenu.new("simple xerath"))

local comboMenu = submenu.addItem(SubMenu.new("combo settings"))
local comboKey = comboMenu.addItem(MenuKeyBind.new("Combo Key", string.byte(" ")))
local comboSpellOrder = comboMenu.addItem(SubMenu.new("Combo spell order"))
local comboSpellOrderList = {
	comboSpellOrder.addItem(MenuStringList.new("1st", {"Q", "W", "E"}, 1)),
	comboSpellOrder.addItem(MenuStringList.new("2ed", {"Q", "W", "E"}, 2)),
	comboSpellOrder.addItem(MenuStringList.new("3rd", {"Q", "W", "E"}, 3)),
}

local ultMenu = submenu.addItem(SubMenu.new("ult settings"))
local ultHumanized = ultMenu.addItem(MenuBool.new("ult humanized", true))
local semiUltMode = ultMenu.addItem(MenuBool.new("[semi auto] ult mode(always ON)", false))
local semiUltModeKey = ultMenu.addItem(MenuKeyBind.new("[semi auto] ult mode Key(ON/OFF temporally)", 17))
local ultSearchRange = ultMenu.addItem(MenuSlider.new("[semi auto] ult search range(default 800)", 800, 0, 1500, 100))
local ultMode = ultMenu.addItem(MenuStringList.new("ult mode", {"auto", "manual"}, 1))
local ultDelay = ultMenu.addItem(MenuSlider.new("[auto/semi auto] ult delay(default 800)", 800, 0, 2000, 100))
local ultKey = ultMenu.addItem(MenuKeyBind.new("[manual] ult Key", string.byte("T")))

local semiAuto = false
local semiAutoDelay = 0

local isCastingQ = false
local qTime = 0
local qRangeMin = GetCastRange(myHero, _Q)
local qRangeMax = 1500
local function castQ(target0)
	local target = target0 or GetTarget(qRangeMax, DAMAGE_MAGIC)
	if not target then return end
	if IsInDistance(target, qRangeMax) and CanUseSpell(myHero,_Q) == READY then	
		local qRange = qRangeMin + (GetGameTimer() - qTime) * 500
		if qRange > qRangeMax then	qRange = qRangeMax end

		-- start castQ
		if not isCastingQ then
      CastSkillShot(_Q,GetMousePos())
      return
    end

    -- release castQ
    if IsInDistance(target, qRange) then 
    	-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
    	local pred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),math.huge,500,qRange,200,false,true)
    	if pred.HitChance == 1 then 
    		CastSkillShot2(_Q,pred.PredPos)
    		-- PrintChat("qRange "..qRange)
    	end
		end
	end
end

local function castW(target0)
	local target = target0 or GetTarget(GetCastRange(myHero, _W), DAMAGE_MAGIC)
	if not target then return end
	if IsInDistance(target, GetCastRange(myHero,_W)) and CanUseSpell(myHero,_W) == READY then	
		-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
		local pred = GetPredictionForPlayer(GetOrigin(target),target,GetMoveSpeed(target),math.huge,500,GetCastRange(myHero,_W),150,false,true)
		if pred.HitChance == 1 then
			CastSkillShot(_W,pred.PredPos)
		end
	end
end

local function castE(target0)	
	local target = target0 or GetTarget(GetCastRange(myHero, _E), DAMAGE_MAGIC)
	if not target then return end
	if IsInDistance(target, GetCastRange(myHero,_E)) and CanUseSpell(myHero,_E) == READY then
		-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
		local pred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target),1600,250,GetCastRange(myHero,_E),70,true,true)
		-- DrawDebugText("cast E: "..pred.HitChance,20,0,135,0xff00ff00)
		if pred.HitChance == 1 then
			CastSkillShot(_E,pred.PredPos)
		end
	end
end

local rTarget
local rDelay
local rChangeTargetDelay
local rRange = 0
local isCastingR = false
local function castR( target )
	-- save r range because r range change to 25000 when casting
	if not isCastingR then
		rRange = GetCastRange(myHero,_R)
		rTarget = nil
		rDelay = nil
		rChangeTargetDelay = nil
		return 
	end

	-- get target or change target when target is dead
	if not rTarget or IsDead(rTarget) or not ( GetOrigin(rTarget) and IsInDistance(rTarget, rRange) ) then 
		local old = rTarget
		rTarget = GetTarget(rRange, DAMAGE_MAGIC)
		
		if old and rTarget then
			local range = GetDistance(old, rTarget)
			-- PrintChat("ChangeTargetrange "..range)
			-- delay range / 2 ms
			rChangeTargetDelay = GetTickCount() + range / 2
		end
	end

	-- target not found
	if not rTarget then return end

	if (semiAuto or semiUltMode.getValue()) and GetDistance(GetMousePos(), GetOrigin(rTarget)) > ultSearchRange.getValue() then 
		rTarget = nil
		rDelay = nil
		rChangeTargetDelay = nil
		return 
	end

	local danger = IsInDistance(target, 700)
	local ultModeType = ultMode.getValue()
	if ultModeType == 1 and ultHumanized.getValue() and not danger then
		-- if rDelay then PrintChat("rDelay "..rDelay- GetTickCount()) end
		-- if rChangeTargetDelay then PrintChat("rChangeTargetDelay "..rChangeTargetDelay- GetTickCount()) end
		if rDelay and rDelay > GetTickCount() then return end
		if rChangeTargetDelay and rChangeTargetDelay > GetTickCount() then return end
	elseif ultModeType == 2 and not ultKey.getValue() then return
	end

	if ValidTarget(rTarget, rRange) then
		-- CastStartPosVec,EnemyChampionPtr,EnemyMoveSpeed,YourSkillshotSpeed,SkillShotDelay,SkillShotRange,SkillShotWidth,MinionCollisionCheck,AddHitBox;
		local pred = GetPredictionForPlayer(GetOrigin(myHero),rTarget,GetMoveSpeed(rTarget),math.huge,600,rRange,170,false,true);
	 	if pred.HitChance == 1 then
			CastSkillShot(_R,pred.PredPos.x,pred.PredPos.y,pred.PredPos.z)
			rDelay = GetTickCount() + ultDelay.getValue()
			-- PrintChat(rRange.."  "..GetObjectName(rTarget))
		end
	end
end

local killableInfoText = ""
local function killableInfo()
	-- skip when R in cd
	-- if CanUseSpell(myHero,_R) ~= READY then return end

	-- skip when not learn R yet
	if GetCastLevel(myHero,_R) == 0 then return end

	killableInfoText = ""
	local rDmg = 135 + GetCastLevel(myHero,_R) * 55 + GetBonusAP(myHero) * 0.43
	rDmg = rDmg * 3
	for nID, enemy in pairs(GetEnemyHeroes()) do
		if IsObjectAlive(enemy) and IsVisible(enemy) then
			realdmg = CalcDamage(myHero, enemy, 0, rDmg)
			hp = GetCurrentHP(enemy)
			if realdmg > hp then
				killableInfoText = killableInfoText..GetObjectName(enemy).."  killable by 3 R\n"
			end
			-- killableInfoText = killableInfoText..GetObjectName(enemy).."    HP:"..hp.."  dmg: "..realdmg.." "..killable.."\n"
		end
  end
end

OnDraw(function(myHero)
	DrawDebugText("Q range "..GetCastRange(myHero,_Q),20,200,30,0xff00ff00)
	DrawDebugText("R range "..GetCastRange(myHero,_R),20,0,30,0xff00ff00)

	if semiAuto then
		DrawText("semi-auto R mode : ON", 40,600,200,0xffffff00)
	end

  DrawText(killableInfoText,40,500,0,0xffff0000) 

  -- draw semi auto search circle
	if isCastingR and (semiUltMode.getValue() or semiAuto) then
		local mousePos = GetMousePos()
		DrawCircle(mousePos.x,mousePos.y,mousePos.z,ultSearchRange.getValue(),0,0,0xff0000ff)
	end
end)

local castSpellList = {
	castQ, castW, castE
}
OnTick(function(myHero)	
	killableInfo()

	-- TODO: rework this toggle feature with new api(hope we have)
	if semiUltModeKey.getValue() and semiAutoDelay < GetTickCount() then
		semiAuto = not semiAuto
		semiAutoDelay = GetTickCount() + 500
	end	

	if comboKey.getValue() then
		castSpellList[comboSpellOrderList[1].getValue()]()
		castSpellList[comboSpellOrderList[2].getValue()]()
		castSpellList[comboSpellOrderList[3].getValue()]()
	end

	local target = GetCurrentTarget()
	if ValidTarget(target) then	
		castR(target)
	end
end)

require 'Interrupter'
addInterrupterCallback(function(target, spellType, spell)
	castE(target)
end)

local qBuffName = "XerathArcanopulseChargeUp"
local rBuffName = "XerathLocusOfPower2"
OnUpdateBuff(function(object,buffProc)
	if object == myHero then
		local buffName = buffProc.Name
		if buffName == qBuffName then
			isCastingQ = true
			qTime = buffProc.StartTime
		elseif buffName == rBuffName then
			isCastingR = true
		end
	end
end)

OnRemoveBuff(function(object,buffProc)
	if object == myHero then
		local buffName = buffProc.Name
		if buffName == qBuffName then
			isCastingQ = false
		elseif buffName == rBuffName then
			isCastingR = false
		end
	end
end)

PrintChat("simple xerath loaded")