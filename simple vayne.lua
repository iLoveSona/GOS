local myHero = GetMyHero()
if GetObjectName(myHero) ~= "Vayne" then return end

require 'MapPositionGOS'
require 'Interrupter'
d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local GetDistance = d.GetDistance

local submenu = menu.addItem(SubMenu.new("simple vayne"))
local key = submenu.addItem(MenuKeyBind.new("auto stun key", string.byte(" ")))
local autoStun = submenu.addItem(MenuBool.new("auto stun when possible", true))
local combo = submenu.addItem(MenuKeyBind.new("combo key", string.byte(" ")))

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
	-- PrintChat(spell.name.." "..GetObjectName(target))
	if IsInDistance(target, GetCastRange(myHero,_E)) and CanUseSpell(myHero,_E) == READY then
		if spellType == CHANELLING_SPELLS or (spellType == GAPCLOSER_SPELLS and GetDistance(spell.startPos) > GetDistance(spell.endPos)) then
			CastTargetSpell(target, _E)
		end
	end
end)

OnTick(function(myHero)
	if key.getValue() or autoStun.getValue() then
		AutoEiAC()
	end
end)

require('simple orbwalk')
OnProcessSpellComplete(function(unit, spell)    
  if unit == myHero and spell.name:lower():find("attack") and combo.getValue() then
   	if CanUseSpell(myHero,_Q) == READY then
			CastSkillShot(_Q, GetMousePos())			
   	end
  end
end)

OnProcessSpell(function(unit, spell)
	if unit == myHero and spell.name == "VayneTumble" then
		resetAA()
  end
end)

PrintChat("simple vayne loaded")