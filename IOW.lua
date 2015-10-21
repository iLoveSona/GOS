require('Inspired2')
local IOWversion = 1.98
local myHeroName = GetObjectName(GetMyHero())

class "InspiredsOrbWalker"

function InspiredsOrbWalker:__init()
  self.lastAttack = 0
  self.lastCooldown = 0
  self.attacksEnabled = true
  self.movementEnabled = true
  self.altAttacks = Set { "caitlynheadshotmissile", "frostarrow", "garenslash2", "kennenmegaproc", "lucianpassiveattack", "masteryidoublestrike", "quinnwenhanced", "renektonexecute", "renektonsuperexecute", "rengarnewpassivebuffdash", "trundleq", "xenzhaothrust", "xenzhaothrust2", "xenzhaothrust3" }
  self.resetAttacks = Set { "dariusnoxiantacticsonh", "fioraflurry", "garenq", "hecarimrapidslash", "jaxempowertwo", "jaycehypercharge", "leonashieldofdaybreak", "luciane", "lucianq", "monkeykingdoubleattack", "mordekaisermaceofspades", "nasusq", "nautiluspiercinggaze", "netherblade", "parley", "poppydevastatingblow", "powerfist", "renektonpreexecute", "rengarq", "shyvanadoubleattack", "sivirw", "takedown", "talonnoxiandiplomacy", "trundletrollsmash", "vaynetumble", "vie", "volibearq", "xenzhaocombotarget", "yorickspectral", "reksaiq", "riventricleave", "itemtitanichydracleave", "itemtiamatcleave" }
  self.rangeCircle = GoS:Circle(GoS.White)
  self.tick = 0
  self:MakeMenu()
  OnLoop(function() self:Loop() end)
  OnProcessSpell(function(x,y) self:ProcessSpell(x,y) end)
  OnProcessWaypoint(function(x,y) self:ProcessWaypoint(x,y) end)
  return self
end

function Set(list)
  local set = {}
  for _, l in ipairs(list) do 
    set[l] = true 
  end
  return set
end

function msg(x)
  Msg(x, "InspiredsOrbWalker")
end

function InspiredsOrbWalker:MakeMenu()
  self.Config = Menu("Inspired'sOrbWalker", "IOW")
  self.Config:SubMenu("h", "Hotkeys")
  self.Config.h:Key("Combo", "Combo", 32)
  self.Config.h:Key("Harass", "Harass", string.byte("C"))
  self.Config.h:Key("LastHit", "LastHit", string.byte("X"))
  self.Config.h:Key("LaneClear", "LaneClear", string.byte("V"))
  self.Config:Slider("cad", "Cancel Adjustment", 0, -100, 100, 1)
  self.Config:List("lcm", "Lane Clear method", myHeroName == "Vayne" and 2 or 1, {"Focus Highest", "Stick to 1"})
  self.Config:Boolean("items", "Use Items", true)
  GoS:DelayAction(function()
    if GetRange(myHero) < 450 then
      self.Config:Boolean("sticky", "Stick to Target", true)
    end
    self.rangeCircle.Attach(myHero, GetRange(myHero)+GetHitBox(myHero))
    self.Config:Boolean("drawcircle", "Autoattack Circle", false)
    self.Config:Info("space", "")
    self.Config:Info("version", "Version: v"..IOWversion)
    self.loaded = true
    msg("Loaded!")
  end, 1000)
end

function InspiredsOrbWalker:Mode()
  if self.Config.h.Combo:Value() then
    return "Combo"
  elseif self.Config.h.Harass:Value() then
    return "Harass"
  elseif self.Config.h.LastHit:Value() then
    return "LastHit"
  elseif self.Config.h.LaneClear:Value() then
    return "LaneClear"
  else
    return ""
  end
end

function InspiredsOrbWalker:Loop()
  if not self.loaded or self.tick > GetTickCount() then return end
  self.tick = GetTickCount() + 60
  self.rangeCircle.Draw(self.Config.drawcircle:Value())
  self.myRange = GetRange(myHero)+GetHitBox(myHero)+(self.Target and GetHitBox(self.Target) or GetHitBox(myHero))
  self.Target = self:GetTarget()
  self:Orb(self:GetTarget())
end

function InspiredsOrbWalker:GetTarget()
  if self.Config.h.Combo:Value() then
    return GoS:GetTarget(self.myRange, DAMAGE_PHYSICAL)
  elseif self.Config.h.Harass:Value() then
    for i=1, minionManager.maxObjects do
      local minion = minionManager.objects[i]
      if minion and IsObjectAlive(minion) and GetTeam(minion) ~= GetTeam(myHero) and GoS:IsInDistance(minion, self.myRange) then
        local health = GoS:PredictHealth(minion, 1000*GoS:GetDistance(minion)/GoS:GetProjectileSpeed(myHero) + GetWindUp(myHero)*1000)
        if health < self:GetDmg(minion) and health > 0 then
          return minion
        end
      end
    end
    return GoS:ValidTarget(self.Target, self.myRange) and self.Target or GoS:GetTarget(self.myRange, DAMAGE_PHYSICAL)
  elseif self.Config.h.LaneClear:Value() then
    local highestMinion, highestHealth = nil, 0
    for i=1, minionManager.maxObjects do
      local minion = minionManager.objects[i]
      if minion and IsObjectAlive(minion) and GetTeam(minion) ~= GetTeam(myHero) and GoS:IsInDistance(minion, self.myRange) then
        local health = GoS:PredictHealth(minion, 1000*GoS:GetDistance(minion)/GoS:GetProjectileSpeed(myHero) + GetWindUp(myHero)*1000)
        local health2 = GoS:PredictHealth(minion, 2000*GoS:GetDistance(minion)/GoS:GetProjectileSpeed(myHero) + GetWindUp(myHero)*2000)
        if not highestMinion then highestMinion = minion highestHealth = health end
        if health > 0 then
          local dmg = self:GetDmg(minion) 
          if (health2 < 0 or health2 < dmg*2) and health > dmg and health ~= GetCurrentHP(minion) then
            return nil
          end
          if health < dmg then
            return minion
          elseif self.Config.lcm:Value() == 1 and health > highestHealth then
            highestHealth = health 
            highestMinion = minion
          elseif self.Config.lcm:Value() == 2 then
            if GoS:ValidTarget(self.Target) and GetObjectType(self.Target) ~= Obj_AI_Hero then
              return self.Target
            elseif health > highestHealth then
              highestHealth = health 
              highestMinion = minion
            end
          end
        end
      end
    end
    return highestMinion
  elseif self.Config.h.LastHit:Value() then
    for i=1, minionManager.maxObjects do
      local minion = minionManager.objects[i]
      if minion and IsObjectAlive(minion) and GetTeam(minion) ~= GetTeam(myHero) and GoS:IsInDistance(minion, self.myRange) then
        local health = GoS:PredictHealth(minion, 1000*GoS:GetDistance(minion)/GoS:GetProjectileSpeed(myHero) + GetWindUp(myHero)*1000)
        if health < self:GetDmg(minion) and health > 0 then
          return minion
        end
      end
    end
  end
end

function InspiredsOrbWalker:GetDmg(to) -- thanks to Sir Deftsu for this :3
  local addmg = 0
  local apdmg = 0
  local truedmg = 0
  if myHeroName == "Aatrox" then
  addmg = addmg + (GotBuff(myHero, "aatroxwpower") > 0 and 35*GetCastLevel(myHero,_W)+25 or 0)
  elseif myHeroName == "Ashe" then
  addmg = addmg + (GotBuff(myHero, "asheqattack") > 0 and (GetBonusDmg(myHero)+GetBaseDamage(myHero))*(.05*GetCastLevel(myHero,_Q)+.1) or 0)
  elseif myHeroName == "Blitzcrank" then
  addmg = addmg + (GotBuff(myHero, "PowerFist") > 0 and GetBonusDmg(myHero)+GetBaseDamage(myHero) or 0)
  elseif myHeroName == "Caitlyn" then
  addmg = addmg + (GotBuff(myHero, "caitlynheadshot") > 0 and 1.5*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Chogath" then
  apdmg = apdmg + (GotBuff(myHero, "VorpalSpikes") > 0 and 15*GetCastLevel(myHero,_E)+5+.3*GetBonusAP(myHero) or 0)
  elseif myHeroName == "Corki" then
  truedmg = truedmg + (GotBuff(myHero, "rapidreload") > 0 and .1*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Darius" then
  addmg = addmg + (GotBuff(myHero, "DariusNoxianTacticsONH") > 0 and .4*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Diana" then
  apdmg = apdmg + (GotBuff(myHero, "dianaarcready") > 0 and math.max(5*GetLevel(myHero)+15,10*GetLevel(myHero)-10,15*GetLevel(myHero)-60,20*GetLevel(myHero)-125,25*GetLevel(myHero)-200)+.8*GetBonusAP(myHero) or 0)
  elseif myHeroName == "Draven" then
  addmg = addmg + (GotBuff(myHero, "dravenspinning") > 0 and (.1*GetCastLevel(myHero,_Q)+.35)*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Ekko" then
  apdmg = apdmg + (GotBuff(myHero, "ekkoeattackbuff") > 0 and 30*GetCastLevel(myHero,_E)+20+.2*GetBonusAP(myHero) or 0)
  elseif myHeroName == "Fizz" then
  apdmg = apdmg + (GotBuff(myHero, "FizzSeastonePassive") > 0 and 5*GetCastLevel(myHero,_W)+5+.3*GetBonusAP(myHero) or 0)
  elseif myHeroName == "Garen" then
  addmg = addmg + (GotBuff(myHero, "GarenQ") > 0 and 25*GetCastLevel(myHero,_Q)+5+.4*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Gragas" then
  apdmg = apdmg + (GotBuff(myHero, "gragaswattackbuff") > 0 and 30*GetCastLevel(myHero,_W)-10+.3*GetBonusAP(myHero)+(.01*GetCastLevel(myHero,_W)+.07)*GetMaxHP(minion) or 0)
  elseif myHeroName == "Irelia" then
  truedmg = truedmg + (GotBuff(myHero, "ireliahitenstylecharged") > 0 and 25*GetCastLevel(myHero,_Q)+5+.4*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Jax" then
  apdmg = apdmg + (GotBuff(myHero, "JaxEmpowerTwo") > 0 and 35*GetCastLevel(myHero,_W)+5+.6*GetBonusAP(myHero) or 0)
  elseif myHeroName == "Jayce" then
  apdmg = apdmg + (GotBuff(myHero, "jaycepassivemeleeatack") > 0 and 40*GetCastLevel(myHero,_R)-20+.4*GetBonusAP(myHero) or 0)
  elseif myHeroName == "Jinx" then
  addmg = addmg + (GotBuff(myHero, "JinxQ") > 0 and .1*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Kassadin" then
  apdmg = apdmg + (GotBuff(myHero, "netherbladebuff") > 0 and 20+.1*GetBonusAP(myHero) or 0) + (GotBuff(myHero, "NetherBlade") > 0 and 25*GetCastLevel(myHero,_W)+15+.6*GetBonusAP(myHero) or 0)
  elseif myHeroName == "Kayle" then
  apdmg = apdmg + (GotBuff(myHero, "kaylerighteousfurybuff") > 0 and 5*GetCastLevel(myHero,_E)+5+.15*GetBonusAP(myHero) or 0) + (GotBuff(myHero, "JudicatorRighteousFury") > 0 and 5*GetCastLevel(myHero,_E)+5+.15*GetBonusAP(myHero) or 0)
  elseif myHeroName == "Leona" then
  apdmg = apdmg + (GotBuff(myHero, "LeonaShieldOfDaybreak") > 0 and 30*GetCastLevel(myHero,_Q)+10+.3*GetBonusAP(myHero) or 0)
  elseif myHeroName == "MasterYi" then
  addmg = addmg + (GotBuff(myHero, "doublestrike") > 0 and .5*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Nocturne" then
  addmg = addmg + (GotBuff(myHero, "nocturneumrablades") > 0 and .2*(GetBonusdmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Orianna" then
  apdmg = apdmg + (GotBuff(myHero, "orianaspellsword") > 0 and 8*math.floor((GetLevel(myHero)+2)/3)+2+0.15*GetBonusAP(myHero) or 0)
  elseif myHeroName == "RekSai" then
  addmg = addmg + (GotBuff(myHero, "RekSaiQ") > 0 and 10*GetCastLevel(myHero,_Q)+5+.2*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Rengar" then
  addmg = addmg + (GotBuff(myHero, "rengarqbase") > 0 and math.max(30*GetCastLevel(myHero,_Q)+(.05*GetCastLevel(myHero,_Q)-.05)*(GetBonusDmg(myHero)+GetBaseDamage(myHero))) or 0) + (GotBuff(myHero, "rengarqemp") > 0 and math.min(15*GetLevel(myHero)+15,10*GetLevel(myHero)+60)+.5*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Shyvana" then
  addmg = addmg + (GotBuff(myHero, "ShyvanaDoubleAttack") > 0 and (.05*GetCastLevel(myHero,_Q)+.75)*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0)
  elseif myHeroName == "Talon" then
  addmg = addmg + (GotBuff(myHero, "talonnoxiandiplomacybuff") > 0 and 30*GetCastLevel(myHero,_Q)+.3*(GetBonusDmg(myHero)) or 0)
  elseif myHeroName == "Trundle" then
  addmg = addmg + (GotBuff(myHero, "TrundleTrollSmash") > 0 and 20*GetCastLevel(myHero,_Q)+((0.05*GetCastLevel(myHero,_Q)+0.095)*(GetBonusDmg(myHero)+GetBaseDamage(myHero))) or 0)
  elseif myHeroName == "Varus" then
  apdmg = apdmg + (GotBuff(myHero, "VarusW") > 0 and (4*GetCastLevel(myHero,_W)+6+.25*GetBonusAP(myHero)) or 0) 
  elseif myHeroName == "Vayne" then
  addmg = addmg + (GotBuff(myHero, "vaynetumblebonus") > 0 and (.05*GetCastLevel(myHero,_Q)+.25)*(GetBonusDmg(myHero)+GetBaseDamage(myHero)) or 0) 
  truedmg = truedmg + (GotBuff(to, "vaynesilvereddebuff") > 1 and 10*GetCastLevel(myHero,_W)+10+((1*GetCastLevel(myHero,_W)+3)*GetMaxHP(to)/100) or 0)
  elseif myHeroName == "Vi" then
  addmg = addmg + (GotBuff(myHero, "ViE") > 0 and 15*GetCastLevel(myHero,_E)-10+.15*(GetBonusDmg(myHero)+GetBaseDamage(myHero))+.7*GetBonusAP(myHero) or 0) 
  elseif myHeroName == "Volibear" then
  addmg = addmg + (GotBuff(myHero, "VolibearQ") > 0 and 30*GetCastLevel(myHero,_Q) or 0)
  end
  return truedmg + GoS:CalcDamage(myHero, to, GetBonusDmg(myHero)+GetBaseDamage(myHero)+addmg, apdmg) * 0.95
end

function InspiredsOrbWalker:Orb(target)
  if self:DoAttack() and GoS:ValidTarget(target) and self:TimeToAttack() then
    AttackUnit(target)
  elseif self:DoWalk() and self:TimeToMove() then
    MoveToXYZ(GetMousePos())
  end
end

function InspiredsOrbWalker:TimeToMove()
  return (self.lastAttack + GetWindUp(myHero)*1000 + self.Config.cad:Value() < GetTickCount() - GetLatency()/2) or (myHeroName == "Kalista")
end

function InspiredsOrbWalker:TimeToAttack()
  return self.lastAttack + 1000/self:GetFullAttackSpeed() < GetTickCount() + GetLatency()/2 + 70
end

function InspiredsOrbWalker:DoAttack()
  return (self.Config.h.Combo:Value() or self.Config.h.Harass:Value() or self.Config.h.LaneClear:Value() or self.Config.h.LastHit:Value()) and self.attacksEnabled
end

function InspiredsOrbWalker:DoWalk()
  return (self.Config.h.Combo:Value() or self.Config.h.Harass:Value() or self.Config.h.LaneClear:Value() or self.Config.h.LastHit:Value()) and self.movementEnabled
end

function InspiredsOrbWalker:GetFullAttackSpeed()
  return GetAttackSpeed(myHero)*GetBaseAttackSpeed(myHero)
end

function InspiredsOrbWalker:ProcessSpell(unit, spell)
  if unit and unit == myHero and spell and spell.name then
    if spell.name:lower():find("attack") or self.altAttacks[spell.name:lower()] then
      self.lastAttack = GetTickCount() - GetLatency()/2
      GoS:DelayAction(function() 
        if self.Config.items:Value() and (self.Config.h.Combo:Value() or self.Config.h.Harass:Value()) then
          GoS:CastOffensiveItems(self.Target) 
        end
      end, GetWindUp(myHero)*1000)
    end
    if self.resetAttacks[spell.name:lower()] then
      -- self.lastAttack = GetTickCount() + spell.windUpTime * 1000 + 70 + GetLatency() - 1000/self:GetFullAttackSpeed()
      self.lastAttack = 0
    end
  end
end

function InspiredsOrbWalker:ProcessWaypoint(Object,way)
  if Object == myHero and not self:TimeToMove() and way.index > 2 then
    self.lastAttack = 0
  end
end

function InspiredsOrbWalker:EnableAutoAttacks()
  self.attacksEnabled = true
end

function InspiredsOrbWalker:DisableAutoAttacks()
  self.attacksEnabled = false
end

function InspiredsOrbWalker:EnableMovement()
  self.movementEnabled = true
end

function InspiredsOrbWalker:DisableMovement()
  self.movementEnabled = false
end

function InspiredsOrbWalker:EnableOrbwalking()
  self.attacksEnabled = true
  self.movementEnabled = true
end

function InspiredsOrbWalker:DisableOrbwalking()
  self.attacksEnabled = false
  self.movementEnabled = false
end

_G.IOW = InspiredsOrbWalker()
