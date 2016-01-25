local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Tryndamere" then return end

local d = require 'DLib'

local submenu = menu.addItem(SubMenu.new("simple tryndamere"))
local showBuffExpireTime = submenu.addItem(MenuBool.new("show ult expire time", true))
local autoQ = submenu.addItem(MenuBool.new("auto Q after ult gone", true))

local function castQ()
	if CanUseSpell(myHero, _Q) == READY then
		CastSpell(_Q)
	end
end

local stackExpireTime = nil
local autoStackKeyDelay = - math.huge
OnTick(function(myHero)

	-- auto Q when ult gone
	if autoQ.getValue() and stackExpireTime then
		local time = stackExpireTime - GetGameTimer()
		if time < 0.2 then
			castQ()
		end
	end
	
end)

OnDraw(function(myHero)
	if showBuffExpireTime.getValue() and stackExpireTime then
		local time = stackExpireTime - GetGameTimer()
		if time > 0 then
			DrawText("ult gone in : "..string.format("%.1f",time).."s", 40,600,200,0xffff0000)
		end
	end
end)

local buffName = "UndyingRage"
OnUpdateBuff(function(object,buffProc)
	if object == myHero and buffProc.Name == buffName then
		stackExpireTime = buffProc.ExpireTime
	end
end)

OnRemoveBuff(function(object,buffProc)
	if object == myHero and buffProc.Name == buffName then
		stackExpireTime = nil
	end
end)

PrintChat("simple tryndamere script loaded")