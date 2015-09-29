if GetObjectName(GetMyHero()) ~= "Katarina" then return end

local d = require("DLib")
-- require("Inspired")
require("IAC")
require("simple ward jump")

myIAC = IAC()

local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local CalcDamage = d.CalcDamage
local GetTarget = d.GetTarget
local GetEnemyHeroes = d.GetEnemyHeroes
local GetDistance = d.GetDistance

local wardRange = 600
OnLoop(function(myHero)
	local target = GetCurrentTarget()

	-- KillableInfo(target)
	DrawKillInfo()

	checkR()

	if ValidTarget(target) then
		-- kill steal
		-- TODO
		-- killSteal(target)

		-- combo
		if KeyIsDown(string.byte(" ")) then
			castQ(target)
			castE(target)
			castW(target)
			castR(target)
		end

		-- auto harass
		castQ(target)
		castW(target)

	end

end)

function checkR()
	if GotBuff(myHero,"katarinarsound") > 0 then
		myIAC:SetOrb(false)
	else 
		myIAC:SetOrb(true) 
	end
end

function castQ( target )
	if IsInDistance(target, GetCastRange(myHero,_Q)) and CanUseSpell(myHero, _Q) == READY then	
		CastTargetSpell(target, _Q) 
	end
end

function castW( target )
	if IsInDistance(target, GetCastRange(myHero,_W)) and CanUseSpell(myHero, _W) == READY then	
		CastSpell(_W)
	end
end

function castE( target )
	if IsInDistance(target, GetCastRange(myHero,_E)) and CanUseSpell(myHero, _E) == READY then	
		CastTargetSpell(target, _E) 
	end
end

function castR( target )
	if IsInDistance(target, GetCastRange(myHero,_R)) and CanUseSpell(myHero, _R) == READY then	
		myIAC:SetOrb(false)
		CastSpell(_R)
	end
end

function killSteal( target )
	local range = GetDistance(target)
	if range <= (GetCastRange(myHero,_Q)+wardRange) and CanUseSpell(myHero, _Q) == READY then
		if range > GetCastRange(myHero,_Q) then
			wardJump(GetOrigin(target))
		end
		castQ(target)
	end
end

function DrawKillInfo()
	for _, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) then
			local pos = WorldToScreen(1, GetOrigin(enemy))
			local enemyText, color =  GetDrawText(enemy)
			if enemyText and pos.flag then
				DrawText(enemyText, 15, pos.x, pos.y, color)
			end
		end
	end
end

function GetDrawText(target)
	local hp  = GetCurrentHP(target)
  local AP = GetBonusAP(myHero)
  local bonusAD = GetBonusDmg(myHero)
  local totalAD = bonusAD+GetBaseDamage(myHero)
	local DmgTable = { 
		Q = CalcDamage(myHero, target, 0, 35+25*GetCastLevel(myHero,_Q)+0.45*AP),
		Q2 = CalcDamage(myHero, target, 0, 0+15*GetCastLevel(myHero,_Q)+0.15*AP),
		W = CalcDamage(myHero, target, 0, 5+35*GetCastLevel(myHero,_W)+0.25*AP+0.6*bonusAD), 
		E = CalcDamage(myHero, target, 0, 10+30*GetCastLevel(myHero,_E)+0.25*AP), 
		R = CalcDamage(myHero, target, 0, 15+20*GetCastLevel(myHero,_R)+0.25*AP+0.375*GetBonusDmg(myHero))
	}
	local ExtraDmg = 0
	if Ignite and CanUseSpell(GetMyHero(), Ignite) == READY then
		ExtraDmg = ExtraDmg + (20*GetLevel(myHero)+50)
	end
	if DmgTable.Q > hp then
		killSteal(target)
		return 'Q', ARGB(255, 139, 0, 0)
	elseif DmgTable.W > hp then
		return 'W', ARGB(255, 139, 0, 0)
	elseif DmgTable.E > hp then
		return 'E', ARGB(255, 139, 0, 0)
	elseif DmgTable.Q + DmgTable.W > hp then
		return 'W + Q', ARGB(255, 139, 0, 0)
	elseif DmgTable.E + DmgTable.W > hp then
		return 'E + W', ARGB(255, 139, 0, 0)
	elseif DmgTable.Q + DmgTable.W + DmgTable.E > hp then
		return 'Q + W + E', ARGB(255, 255, 0, 0)
	elseif DmgTable.Q + DmgTable.Q2 + DmgTable.W + DmgTable.E > hp then
		return '(Q + Passive) + W +E', ARGB(255, 255, 0, 0)
	elseif ExtraDmg > 0 and ExtraDmg + DmgTable.Q + DmgTable.Q2 + DmgTable.W + DmgTable.E > hp then
		return '(Q + Passive) + W + E + Ignite', ARGB(255, 255, 0, 0)
	elseif CanUseSpell(myHero, _R) ~= ONCOOLDOWN and DmgTable.Q + DmgTable.W + DmgTable.E + (DmgTable.R *10) > hp then
		return 'Q + W + E + Ult ('.. string.format('%4.1f', ((hp -  DmgTable.Q - DmgTable.W - DmgTable.E) / DmgTable.R)/4) .. ' Secs)', ARGB(255, 255, 69, 0)
	else
		return 'Cant Kill Yet', ARGB(255, 0, 255, 0)
	end
end

function KillableInfo( target )
	if ValidTarget(target) then
		local dmg = 0
    local hp  = GetCurrentHP(target)
    local AP = GetBonusAP(myHero)
    local TotalDmg = GetBonusDmg(myHero)+GetBaseDamage(myHero)
    local targetPos = GetOrigin(target)
    local drawPos = WorldToScreen(1,targetPos.x,targetPos.y,targetPos.z)
    if CanUseSpell(myHero, _Q) == READY then
      dmg = dmg + CalcDamage(myHero, target, 0, 35+25*GetCastLevel(myHero,_Q)+0.45*AP) * 1.25
    end
    if CanUseSpell(myHero, _W) == READY then
      dmg = dmg + CalcDamage(myHero, target, 0, 5+35*GetCastLevel(myHero,_W)+0.25*AP+0.6*TotalDmg)
    end
    if CanUseSpell(myHero, _E) == READY then
      dmg = dmg + CalcDamage(myHero, target, 0, 10+30*GetCastLevel(myHero,_E)+0.25*AP)
    end
    if CanUseSpell(myHero, _R) ~= ONCOOLDOWN and GetCastLevel(myHero,_R) > 0 then
      dmg = dmg + CalcDamage(myHero, target, 0, 30+10*GetCastLevel(myHero,_R)+0.2*AP+0.3*GetBonusDmg(myHero)) * 10
    end
    if dmg > hp then
      DrawText("Killable",20,drawPos.x,drawPos.y,0xffffffff)
      DrawDmgOverHpBar(target,hp,0,hp,0xffffffff)
    else
      DrawText(math.floor(100 * dmg / hp).."%",20,drawPos.x,drawPos.y,0xffffffff)
      DrawDmgOverHpBar(target,hp,0,dmg,0xffffffff)
    end
  end
end

PrintChat("simple katarina script loaded")
