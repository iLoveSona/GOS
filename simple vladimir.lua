if GetObjectName(GetMyHero()) ~= "Vladimir" then return end

local d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget

OnLoop(function(myHero)
	local target = GetCurrentTarget()
	
	if ValidTarget(target) then
		if CanUseSpell(myHero, _Q) == READY and IsInDistance(target, GetCastRange(myHero,_Q)) then	
			CastTargetSpell(target, _Q)
		end

		-- Vladimir' E range 600
		if KeyIsDown(32) and CanUseSpell(myHero, _E) == READY and IsInDistance(target, 600) then
			CastSpell(_E)
		end		
	end
end)

PrintChat("simple vladimir script loaded")