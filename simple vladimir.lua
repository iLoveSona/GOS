local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Vladimir" then return end

local d = require 'DLib'
local ValidTarget = d.ValidTarget
local GetTarget = d.GetTarget
local GetPosForAoeSpell = d.GetPosForAoeSpell

local submenu = menu.addItem(SubMenu.new("simple vladimir"))
local combo = submenu.addItem(MenuKeyBind.new("combo key", string.byte(" ")))
local ultNumber = submenu.addItem(MenuSlider.new("ult when", 3, 1, 5, 1))

require 'antiCC'
addAntiCCCallback(function()
	if CanUseSpell(myHero,_W) == READY then
		CastSpell(_W)
	end
end)

local qRange = GetCastRange(myHero, _Q)
local rRange = GetCastRange(myHero, _R)
OnTick(function(myHero)

	-- auto Q
	local target = GetTarget(qRange, DAMAGE_MAGIC)
	if target and CanUseSpell(myHero, _Q) == READY then	
		CastTargetSpell(target, _Q)
	end

	if combo.getValue() then

		-- Vladimir' E range 600
		if CanUseSpell(myHero, _E) == READY and ValidTarget(GetCurrentTarget(), 600) then
			CastSpell(_E)			
		end
		
		if CanUseSpell(myHero, _R) == READY then
			local result = GetPosForAoeSpell(GetOrigin(myHero), rRange, 375)
			-- PrintChat(result.count)
			-- DrawCircle(result, 375,3,255,0xffff0000)
			if result.count >= ultNumber.getValue() then
				CastSkillShot(_R,result.x,result.y,result.z)
			end
		end

	end
	
end)

PrintChat("simple vladimir script loaded")