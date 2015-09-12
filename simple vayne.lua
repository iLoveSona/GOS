local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Vayne" then return end

require 'MapPositionGOS'
require 'Interrupter'
d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget

-- modify from IAC vayne
local function AutoEiAC()
	local target = GetCurrentTarget()
	if ValidTarget(target,GetCastRange(myHero,_E)) and IsInDistance(target, GetCastRange(myHero,_E)) and CanUseSpell(myHero,_E) == READY then
		for _=0,450,GetHitBox(target) do
			local Pred = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target), 2000, 250, 1000, 1, false, true)
	    local tPos = Vector(Pred.PredPos)+Vector(Vector(Pred.PredPos)-Vector(myHero)):normalized()*_
	    if MapPosition:inWall(tPos) then
	      CastTargetSpell(target, _E)
	      break
	    end
	  end
	end
end

addInterrupterCallback(function(target, spellType, spell)
	if IsInDistance(target, GetCastRange(myHero,_E)) and CanUseSpell(myHero,_E) == READY then
		CastTargetSpell(target, _E)
	end
end)

OnLoop(function(myHero)
	AutoEiAC()
end)

PrintChat("simple vayne loaded")