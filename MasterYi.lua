-- modify from Logge's YI
local myHero=GetMyHero()
if GetObjectName(myHero) ~= "MasterYi" then return end

local d = require 'DLib'
local ValidTarget = d.ValidTarget

local myTeam = GetTeam(myHero)
local delayTime=0
local qRange = GetCastRange(myHero,_Q)*1.5

Q_ON = {
["Aatrox"]		= {0,_R},
["Ahri"]		= {0,_E},
["Akali"]		= {0,_Q},
["Alistar"]		= {0,_Q,0,_W},
["Amumu"]		= {0,_R},
["Anivia"]		= {0,_E},
--["Annie"]		= {0,_R},
["Ashe"]		= {0,_R},
["Azir"]		= {0,_R},
["Blitzcrank"]		= {0,_Q},
["Brand"]		= {0,_R},
["Caitlyn"]		= {0,_E,0,_R},
["Cassiopeia"]		= {0,_R},
["Darius"]		= {0,_R},
["Draven"]		= {0,_R},
["Elise"]		= {0,_E},
["Ezreal"]		= {0,_E},
["Fizz"]		= {0,_R},
--[Fiora"]		= {0,_W},
["Garen"]		= {0,_R},
["Gragas"]		= {0,_E,0,_R},
["Graves"]		= {0,_R},
["Hecarim"]		= {0,_R},
["JarvanIV"]		= {0,_R},
["Jinx"]		= {0,_R},
["Kassadin"]		= {0,_R},
["Katarina"]		= {0,_Q},
["KhaZix"]		= {0,_E},
["LeeSin"]		= {0,_R},
["Lissandra"]		= {0,_R},
["Lulu"]		= {0,_W},
["Lucian"]		= {0,_E},
["Lux"]			= {0,_Q},
["Malphite"]		= {0,_R},
["Malzahar"]		= {0,_R},
["Morgana"]		= {0,_Q,0,_R},
["Nautilus"]		= {0,_R},
["Orianna"]		= {0,_R},
["Pantheon"]		= {0,_W},
["Quinn"]		= {0,_Q,0,_E},
["Rammus"]		= {0,_E},
["RekSai"]		= {0,_E},
--["Renekton"]		= {0,_W},
["Rumble"]		= {0,_R},
["Ryze"]		= {0,_W},
["Sejuani"]		= {0,_R},
["Shaco"]		= {0,_Q},
["Shen"]		= {0,_E},
["Singed"]		= {0,_E},
["Skarner"]		= {0,_R},
["Sona"]		= {0,_R},
["Syndra"]		= {20,_R},
["Talon"]		= {0,_R},
["Taric"]		= {0,_E},
["Teemo"]		= {0,_Q},
["Thresh"]		= {0,_E},
["Tryndamere"]		= {0,_E},
["TwistedFate"]		= {0,"goldcardpreattack"},		--special 
["Urgot"]		= {0,_R},
["Varus"]		= {0,_R},
["Vayne"]		= {0,_E},
["Veigar"]		= {0,_R},
["Vi"]			= {0,_R},
["Vladimir"]		= {0,_R},
["Warwick"]		= {0,_R},
["Xerath"]		= {0,_E},
["Trundle"]		= {0,_R},
["Tristana"]		= {0,_W,0,_R},
["Yasuo"]		= {0,"yasuoq3",0,"yasuoq3w"},		--special
["Zyra"]		= {0,_E},

["Riven"]		= {0,"rivenizunablade"},
["Rengar"]		= {0,"RengarBasicAttack",0,"RengarBasicAttack2"},
["Jax"]		= {1050,_E}

--Plz rework me \|/
--["Nocturne"]		= {0,_R},
--["Karthus"]		= {3000,_R},
--["Zed"]		= {0,_R},


}

OnProcessSpell(function(unit, spellProc)
	local spellList = Q_ON[GetObjectName(unit)]
	if not spellList or GetTeam(unit) == myTeam or GetObjectType(unit) ~= Obj_AI_Hero then return end
--		PrintChat(GetObjectType(unit)..":"..spellProc.name)						--DEBUG
	
	for n,slot in pairs(spellList) do
		if n%2==1 then
			delayTime=slot
		elseif n>1 then
			--print("Looking for "..GetCastName(unit,slot))			--DEBUG
			local name = spellProc.name
			if name == slot or name == GetCastName(unit, slot)  then
				PrintChat("Q'd on "..spellProc.name.." with "..delayTime.."ms delay")
				delay(function()
					--PrintChat("USED Q")
					if CanUseSpell(myHero, _Q) == READY and ValidTarget(unit, qRange) then CastTargetSpell(unit, _Q) end
				end, delayTime)
				delayTime=0
			end
		end
	end
end)

PrintChat("Yi Loaded - Enjoy your game - Logge")
