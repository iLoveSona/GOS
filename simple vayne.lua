local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Vayne" then return end

require 'MapPositionGOS'
require 'Interrupter'
d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local GetDistance = d.GetDistance
local GetTarget = d.GetTarget

local submenu = menu.addItem(SubMenu.new("simple vayne"))
local key = submenu.addItem(MenuKeyBind.new("auto stun key", string.byte(" ")))
local autoStun = submenu.addItem(MenuBool.new("auto stun when possible", true))
local combo = submenu.addItem(MenuKeyBind.new("combo key", string.byte(" ")))

local eRange = GetCastRange(myHero,_E)

-- modify from IAC vayne
local function AutoEiAC(target)
	if ValidTarget(target,eRange) and CanUseSpell(myHero,_E) == READY then
		local pos = GetPredictionForPlayer(GetOrigin(myHero),target,GetMoveSpeed(target), 2000, 250, 1000, 1, false, true).PredPos
		local vPos = Vector(pos)
		for length = 0, 450, GetHitBox(target) do
	    local tPos = vPos + Vector(vPos - Vector(myHero)):normalized() * length
	    if MapPosition:inWall(tPos) then
	      CastTargetSpell(target, _E)
	      break
	    end
	  end
	end
end

addInterrupterCallback(function(target, spellType, spell)
	-- PrintChat(spell.name.." "..GetObjectName(target))
	if IsInDistance(target, GetCastRange(myHero,_E)) and CanUseSpell(myHero,_E) == READY then
		if spellType == CHANELLING_SPELLS or (spellType == GAPCLOSER_SPELLS and GetDistance(spell.startPos) > GetDistance(spell.endPos)) then
			CastTargetSpell(target, _E)
		end
	end
end)

OnTick(function(myHero)
	if key.getValue() or autoStun.getValue() then
		AutoEiAC(GetTarget(eRange, DAMAGE_PHYSICAL))
	end

	-- if shouldReset then
	-- 	if CanUseSpell(myHero,_Q) == READY then
	-- 		CastSkillShot(_Q, GetMousePos())			
	-- 		shouldReset = false
 --   	end
	-- end
end)

require('simple orbwalk')
addResetAASpell(function()
	if CanUseSpell(myHero,_Q) == READY then
		CastSkillShot(_Q, GetMousePos())
		return true
	else
		return false
  end
end)

OnProcessSpellComplete(function(unit, spell)    
  -- if unit == myHero and spell.name == "VayneTumble" then
		-- resetAA()
  -- end
end)

OnProcessSpell(function(unit, spell)
	if unit == myHero and spell.name == "VayneTumble" then
		resetAA()
  end
end)

PrintChat("simple vayne loaded")