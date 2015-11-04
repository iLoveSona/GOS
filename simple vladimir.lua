local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Vladimir" then return end

local d = require 'DLib'
local ValidTarget = d.ValidTarget
local GetTarget = d.GetTarget
local GetPosForAoeSpell = d.GetPosForAoeSpell

local submenu = menu.addItem(SubMenu.new("simple vladimir"))
local combo = submenu.addItem(MenuKeyBind.new("combo key", string.byte(" ")))
local ultNumber = submenu.addItem(MenuSlider.new("ult when", 3, 1, 5, 1))

local eSubmenu = submenu.addItem(SubMenu.new("E stack manager"))
local showStackExpireTime = eSubmenu.addItem(MenuBool.new("show stack expire time", true))
local autoStackKeyToggle = eSubmenu.addItem(MenuKeyBind.new("stack key(toggle)", 17))
local autoStackKeyPress = eSubmenu.addItem(MenuKeyBind.new("stack key(press)", string.byte(" ")))

require 'antiCC'
addAntiCCCallback(function()
	if CanUseSpell(myHero,_W) == READY then
		CastSpell(_W)
	end
end)

local function castE()
	if CanUseSpell(myHero, _E) == READY then
		CastSpell(_E)
	end
end

local stackExpireTime = nil
local autoStackKeyDelay = - math.huge
local autoStackMode = false
local qRange = GetCastRange(myHero, _Q)
local rRange = GetCastRange(myHero, _R)
OnTick(function(myHero)

	-- TODO: rework this toggle feature with new api(hope we have)
	if autoStackKeyToggle.getValue() and autoStackKeyDelay < GetTickCount() then
		autoStackMode = not autoStackMode
		autoStackKeyDelay = GetTickCount() + 500
	end	

	-- auto Q
	local target = GetTarget(qRange, DAMAGE_MAGIC)
	if target and CanUseSpell(myHero, _Q) == READY then	
		CastTargetSpell(target, _Q)
	end

	-- auto keep e stack
	if (autoStackMode or autoStackKeyPress.getValue()) and stackExpireTime then
		local time = stackExpireTime - GetGameTimer()
		if time < 0.2 then
			castE()
		end
	end

	if combo.getValue() then

		-- Vladimir' E range 600
		if ValidTarget(GetCurrentTarget(), 600) then
			castE()
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

OnDraw(function(myHero)
	if showStackExpireTime.getValue() and stackExpireTime then
		local time = stackExpireTime - GetGameTimer()
		if time > 0 then
			DrawText("E stack expire in : "..string.format("%.1f",time).."s", 40,600,200,0xffff0000)
		end
	end

	if autoStackMode or autoStackKeyPress.getValue() then
		DrawText("auto stack mode : ON", 40,600,250,0xffffff00)
	end
end)

local eBuffName = "vladimirtidesofbloodcost"
OnUpdateBuff(function(object,buffProc)
	if object == myHero and buffProc.Name == eBuffName then
		stackExpireTime = buffProc.ExpireTime
	end
end)

OnRemoveBuff(function(object,buffProc)
	if object == myHero and buffProc.Name == eBuffName then
		stackExpireTime = nil
	end
end)

PrintChat("simple vladimir script loaded")