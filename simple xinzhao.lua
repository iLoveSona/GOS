-- use q for AA reset
-- auto W when atk enemy
-- auto E when out of AA range
-- auto R when X enemy in range
local myHero = GetMyHero()
if GetObjectName(myHero) ~= "XinZhao" then return end

d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local GetDistance = d.GetDistance
local GetTarget = d.GetTarget
local GetEnemyHeroes = d.GetEnemyHeroes

local submenu = menu.addItem(SubMenu.new("simple xin zhao"))
local ultNumber = submenu.addItem(MenuSlider.new("ult when", 3, 1, 5, 1))
local combo = submenu.addItem(MenuKeyBind.new("combo key", string.byte(" ")))

local eRange = GetCastRange(myHero,_E)
local rRange = 187.5

local activeERange = GetRange(myHero) + GetHitBox(myHero) + 100
local function castE()
	local target = GetTarget(eRange, DAMAGE_PHYSICAL)
	if target and CanUseSpell(myHero, _E) == READY and GetDistance(target) > activeERange then
		CastTargetSpell(target, _E)
	end
end

local function castW()
	if CanUseSpell(myHero,_W) == READY then
		CastSpell(_W)
  end
end

local function castR()
	if CanUseSpell(myHero,_R) == READY then
		CastSpell(_R)
  end
end

OnTick(function(myHero)
	if not combo.getValue() then return end

	castE()

	-- check how many enemy in R range
	local counter = 0
	for _,enemy in pairs(GetEnemyHeroes()) do		
		if ValidTarget(enemy, rRange) then counter = counter + 1 end
	end
	if counter >= ultNumber.getValue() then castR() end

end)

require('simple orbwalk')
addResetAASpell(function()
	if CanUseSpell(myHero,_Q) == READY then
		CastSpell(_Q)
		return true
	else
		return false
  end
end)

OnProcessSpellComplete(function(unit, spell)
	if unit == myHero and spell.name == "XenZhaoComboTarget" then
		resetAA()
  end
end)

OnProcessSpellAttack(function(unit, spell)
	if unit == myHero and combo.getValue() then
		castW()
	end
end)

PrintChat("simple XinZhao loaded")