if GetObjectName(GetMyHero()) ~= "Kayle" then return end

local d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget

OnLoop(function(myHero)
	local target = GetCurrentTarget()
	if KeyIsDown(32) and ValidTarget(target) then
		-- Kayle' E range 525
		if IsInDistance(target, 525) and CanUseSpell(myHero, _E) == READY then
			CastSpell(_E)
		end
		if IsInDistance(target, GetCastRange(myHero,_Q)) and CanUseSpell(myHero, _Q) == READY then	
			CastTargetSpell(target, _Q) 
		end
		if Smite and IsInDistance(target, GetCastRange(myHero,Smite)) and CanUseSpell(myHero, Smite) then
			CastTargetSpell(target, Smite)
		end
	end
end)

PrintChat("simple kayle script loaded")