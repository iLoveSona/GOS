if GetObjectName(GetMyHero()) ~= "Vladimir" then return end

local d = require 'DLib'
local IsInDistance = d.IsInDistance
local ValidTarget = d.ValidTarget
local GetDistance = d.GetDistance
local GetEnemyHeroes = d.GetEnemyHeroes

require 'antiCC'
addAntiCCCallback(function()
	if CanUseSpell(myHero,_W) == READY then
		CastSpell(_W)
	end
end)

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

		if KeyIsDown(32) then
			local result = GetPosForAoeSpell(GetOrigin(myHero), GetCastRange(myHero,_R), 375)
			if result.count >= 3 then
				-- PrintChat(result.count)
				-- DrawCircle(result, 375,3,255,0xffff0000)
				if CanUseSpell(myHero, _R) == READY then
					CastSkillShot(_R,result.x,result.y,result.z)
				end
			end
		end
	end
end)

function GetPosForAoeSpell(startPos, castRange, spellRadius)
	local list = GetEnemyHeroes()
	local range = castRange + spellRadius
	
	local tempList = {}
	for key,enemy in pairs(list) do
		if ValidTarget(enemy) and GetDistance(startPos, GetOrigin(enemy)) < range then
			tempList[key] = list[key]
		end
	end
	return GetMEC(spellRadius, tempList)
end

function ExcludeFurthest(point, listOfEntities)
	local removalId

	for id,entity in pairs(listOfEntities) do
		if not removalId or GetDistance(point, entity) > GetDistance(point, listOfEntities[removalId]) then
			removalId = id
		end
	end

	listOfEntities[removalId] = nil

	return listOfEntities
end

-- minimum enclosing circle(MEC)
function GetMEC(aoe_radius, listOfEntities)
	local average = {x=0, y=0, z=0, count = 0}

	for _,entity in pairs(listOfEntities) do
		local ori = GetOrigin(entity)
		average.x = average.x + ori.x
		average.y = average.y + ori.y
		average.z = average.z + ori.z
		average.count = average.count + 1
	end

	-- list is empty
	if average.count == 0 then return average end

  average.x = average.x / average.count
  average.y = average.y / average.count
  average.z = average.z / average.count

  local targetsInRange = 0
  for _,entity in pairs(listOfEntities) do
    if GetDistance(average, entity) <= aoe_radius then
      targetsInRange = targetsInRange + 1
    end
  end

  if targetsInRange == average.count then
    return average
  else
    return GetMEC(aoe_radius, ExcludeFurthest(average, listOfEntities))
  end
end

PrintChat("simple vladimir script loaded")