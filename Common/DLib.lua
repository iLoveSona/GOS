local version = 23

local require2 = _G.require

libTable = {
	-- ["DLib"] = "iLoveSona/GOS/master/Common/DLib.lua",
	["simple ward jump"] = "iLoveSona/GOS/master/simple%20ward%20jump.lua",
	["simple auto level spell"] = "iLoveSona/GOS/master/simple%20auto%20level%20spell.lua",
	["Interrupter"] = "iLoveSona/GOS/master/Common/Interrupter.lua",
	["Inspired"] = "Inspired-gos/scripts/master/Common/Inspired.lua",
	["IOW"] = "Inspired-gos/scripts/master/Common/IOW.lua",
	-- ["IAC"] = "Inspired-gos/scripts/master/Common/IAC.lua",
	["MapPosition"] = "Maxxxel/GOS/master/Common/Utility/MapPosition.lua",
	["MapPositionGOS"] = "Maxxxel/GOS/master/Common/Utility/MapPositionGOS.lua",
	["MapPosition_bushes_1"] = "Maxxxel/GOS/master/Common/Utility/MapPosition_bushes_1.lua",
	["MapPosition_walls_1_1"] = "Maxxxel/GOS/master/Common/Utility/MapPosition_walls_1_1.lua",
	["2DGeometry"] = "Maxxxel/GOS/master/Common/Utility/2DGeometry.lua",
	["IsFacing"] = "Maxxxel/GOS/master/Common/Utility/IsFacing.lua"
}

-- better handle require error
function require( m, hideErr )
	local hideErr = hideErr or false
	local PrintChat = _G.PrintChat
	if hideErr then PrintChat = function ( ... ) end end
	ok, err = pcall(require2, m)
	if not ok then
		local url = libTable[m]
			if  url then 
			print(err)
			PrintChat("<font color=\"#00CCFF\"><b>LOAD \""..m..".lua\" FAIL, auto fix mode: try redownload the script, plz waiting...</b></font>")
			saveScript("Common\\"..m, webRequest("github", url.."?rand="..math.random(1,10000)))
			PrintChat("<font color=\"#00CCFF\"><b> auto fix mode: \""..m..".lua\" updated, press F6-F6 to reload.</b></font>")
		-- detect noob require a webpage error
		elseif string.find(err, "unexpected symbol near '<'") then PrintChat("<font color=\"#FF1919\"><b>LOAD \""..m..".lua\" SCRIPT ERROR: make sure you download the script code instead webpage</b></font>")
		else
			PrintChat(err)
		end
		return nil, err
	end
	return err
end

function prequire(m, hideErr) 
  -- local ok, err = pcall(require, m) 
  -- if not ok then return nil, err end
  -- return err
  return require(m, hideErr)
end

function requireDL(script, address, retry)
  local retry = retry or 0
  local status, module = pcall(require, script)
  
  if not status and retry<4 then
	retry=retry+1
    response=webRequest("github", address.."?rand="..math.random(1,10000))
    if response~=nil then
      saveScript("Common\\"..script, response) end
    requireDL(script, address, retry)
  else
    if retry==4 then
      MessageBox(0,"Unable to download library "..script,"Error!",0) end

  end
  if retry>0 then
	s, module = pcall(require, script) end
  return module
end

function codeToString(code)
	if code >=48 and code<=90 then
		return string.char(code)
	elseif code==1 then
		return "mouseLeft"
	elseif code==2 then
		return "mouseRight"
	elseif code==4 then
		return "mouseMiddle"
	elseif code==5 then
		return "mouseX1"
	elseif code==6 then
		return "mouseX2"
	elseif code==6 then
		return "mouseMiddle"
	elseif code==13 then
		return "enter"
	elseif code==16 then
		return "shift"
	elseif code==8 then
		return "backspace"
	elseif code==9 then
		return "tab"
	elseif code==13 then
		return "enter"
	elseif code==16 then
		return "shift"
	elseif code==17 then
		return "ctrl"
	elseif code==18 then
		return "alt"
	elseif code==19 then
		return "pause"
	elseif code==20 then
		return "caps lock"
	elseif code==27 then
		return "escape"
	elseif code==32 then
		return "spacebar"
	elseif code==33 then
		return "pgUp"
	elseif code==34 then
		return "pgDn"
	elseif code==35 then
		return "end"
	elseif code==36 then
		return "home"
	elseif code==37 then
		return "left"
	elseif code==38 then
		return "up"
	elseif code==39 then
		return "right"
	elseif code==40 then
		return "down"
	elseif code==44 then
		return "printSc"
	elseif code==45 then
		return "insert"
	elseif code==46 then
		return "del"
	elseif code==47 then
		return "help"
	elseif code==91 then
		return "lWindow"
	elseif code==92 then
		return "rWindow"
	elseif code==93 then
		return "select"
	elseif code==96 then
		return "Num 0"
	elseif code==97 then
		return "Num 1"
	elseif code==98 then
		return "Num 2"
	elseif code==99 then
		return "Num 3"
	elseif code==100 then
		return "Num 4"
	elseif code==101 then
		return "Num 5"
	elseif code==102 then
		return "Num 6"
	elseif code==103 then
		return "Num 7"
	elseif code==104 then
		return "Num 8"
	elseif code==105 then
		return "Num 9"
	elseif code==106 then
		return "Num *"
	elseif code==107 then
		return "Num +"
	elseif code==109 then
		return "Num -"
	elseif code==111 then
		return "Num /"
	elseif code==112 then
		return "F1"
	elseif code==113 then
		return "F2"
	elseif code==114 then
		return "F3"
	elseif code==115 then
		return "F4"
	elseif code==116 then
		return "F5"
	elseif code==117 then
		return "F6"
	elseif code==118 then
		return "F7"
	elseif code==119 then
		return "F8"
	elseif code==120 then
		return "F9"
	elseif code==121 then
		return "F10"
	elseif code==122 then
		return "F11"
	elseif code==123 then
		return "F12"
	else return tostring(code) end
end

function getTextWidth(text, offset)
	local ret=offset or 0
	for c in text:gmatch"." do
		if c==" " then ret=ret+4
		elseif tonumber(c)~=nil then ret=ret+6
		elseif c==string.upper(c) then ret=ret+8
		elseif c==string.lower(c) then ret=ret+7
		else ret=ret+5 end
	end
	return ret
end

function getLongestString(textList)
	local mx=0
	for i, str in ipairs(textList) do
		local l=getTextWidth(str)
		if l>mx then
			mx=l
		end
	end
	return mx
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function roundStep(num, step)
	return round(num/step)*step
end

function stripchars(str, chrs)
  return str:gsub("["..chrs.."]", ''):gsub("%[%]", "")
end
function stripchars2(str, chrs)
  return str:gsub("%[%]")
end

function calcRounding(num)
	num=num+0.00000000000001
	local t=1
	local places=t
	while true do
		if num >= t then return places-1 end
		places=places + 1
		t=t/10
	end
end

function percentToRGB(percent) 
	local r, g
    if percent == 100 then
        percent = 99 end
		
    if percent < 50 then
        r = math.floor(255 * (percent / 50))
        g = 255
    else
        r = 255
        g = math.floor(255 * ((50 - percent % 50) / 50))
    end
	
    return 0x90000000+g*0xFFFF+r*0xFF
end


--REGION notifications---------------------------------------------------------
--{
Notification={}
local notifications={}
local notificationsActive=false

function Notification.new(message, duration, drawcolor, textcolor, animationscale, fontsize, y)
	local this = {}
	this.message = message
	this.duration = duration or 2000
	this.drawcolor=drawcolor or 0x70000000
	this.textcolor=textcolor or 0xFF71D450
	this.animationscale=animationscale or 1
	this.x=-1000
	this.y=y
	this.toremove=false
	this.creationTime=GetTickCount()+300*animationscale
	this.fontsize = fontsize or 14
	
	function this.updateX(tickcount)
		if tickcount>this.creationTime and tickcount<this.creationTime+this.duration  then this.x=7 return end
		if(tickcount>this.creationTime+this.duration) then
			local z=(tickcount-(this.creationTime+this.duration))/animationscale
			this.x=math.ceil(7+0.0018*z*z - 1.23*z)
				if tickcount>this.creationTime+this.duration+300*animationscale then this.toremove=true end
			return
		end
		local z=(this.creationTime-tickcount)/animationscale
		this.x=math.ceil(7+0.0018*z*z - 1.23*z)
	end
		
	function this.onLoop(tickcount)
		this.updateX(tickcount)
		FillRect(this.x, this.y, 0.4 * #this.message * this.fontsize, 1.5 * this.fontsize, this.drawcolor) 
		DrawText(this.message,this.fontsize,this.x+3, this.y+5, this.textcolor)
	end
	return this
end

function notification(message, duration, animationscale, fontsize, textcolor, drawcolor)
	if message==nil then PrintChat("Notification: message not set, ignored.") end
	drawcolor=drawcolor or 0x70000000
	textcolor=textcolor or 0xFF71D450
	animationscale=animationscale or 1
	for slot = 0, 15, 1 do
		if notifications[slot]==nil then
			notifications[slot]=Notification.new(message, duration, drawcolor, textcolor, animationscale, fontsize, slot*60+5)
			notificationsActive=true
			return
		end
	end
end

function notificationsOnLoop(tickcount)
	if not notificationsActive then return end
	for k, value in pairs(notifications) do
		value.onLoop(tickcount)
		if value.toremove==true then notifications[k]=nil end
	end
	if next(notifications) == nil then
		notificationsActive=false
	end
end

--ENDREGION notifications------------------------------------------------------}

--REGION delay-----------------------------------------------------------------
--{
local delayed={}
local delayedActive=false

function delay(func, t)
	if(t==nil) then PrintChat("Delay: time not set") return end
	delayedActive=true
	table.insert(delayed, {t+GetTickCount(), func})
end
	
function delayedOnLoop(tickcount)
	if not delayedActive then return end
	for i, item in pairs(delayed) do
		if item[1] <= tickcount then
			item[2]()
			delayed[i] = nil
		end
	end
	if next(delayed) == nil then
		delayedActive=false
	end
end

--ENDREGION delay--------------------------------------------------------------}

--REGION Menu------------------------------------------------------------------
--{
local ITEMHEIGHT=30
local ITEMWIDTH=100
local TEXTYOFFSET=-7
local TOGGLEWIDTH=30
local MENUTEXTCOLOR=0xFFFFFFFF
local MENUBGCOLOR=0xC8000000
local MENUBGACTIVE=4285098345
local MENUBORDERCOLOR=0xFF000000


MainMenu={}
function MainMenu.new()
	local this = {}
	if c.config.menu==nil then
		c.config.menu={}
	end
	this.conf=c.config.menu
	if c.config.menuX==nil then
		c.config.menuX=300
	end
	if c.config.menuY==nil then
		c.config.menuY=300
	end
	
	this.children = {}
	
	this.pos=Vector2.new(c.config.menuX, c.config.menuY)
	this.setpos=Vector2.new(c.config.menuX, c.config.menuY)
	this.width = width or ITEMWIDTH
	this.fullHeight= 0
	this.active=false
	
	function this.inputProcessor(key, pressed)
		if key == 160 then 
			if pressed then
				this.show()
			else
				this.hide()
			end
		end
		if not this.active then return end
		local mousevec=mousePos()
		for num, item in ipairs(this.children) do
			item.processInput(key, pressed, mousevec)
		end
		
	end
	
	this.proc=registerInputListener(this.inputProcessor)
	
	function this.show()
		this.active=true
		for num, item in ipairs(this.children) do
			item.show()
		end
	end
	
	function this.hide()
		this.active=false
		for num, item in pairs(this.children) do
			item.hide()
			this.conf[item.name]=item.getValue(true)
		end
		c.config.menuX=this.pos.x
		c.config.menuY=this.pos.y
		c.save()
	end
	function this.addItem(MenuItem)
		local free=1
		for num, item in ipairs(this.children) do
			free=free+1
		end
		MenuItem.name=stripchars(MenuItem.name, "\n\a\b\f\r\t\v\"%[%]" )
		this.expandMain(MenuItem.textlengthAdd+getTextWidth(MenuItem.name, 0))
		MenuItem.setPosition(this.pos)
		MenuItem.setWidthInternal(this.width)
		MenuItem.parent=this
		MenuItem.mainMenu=this
		this.children[free]=MenuItem
		this.calculateY()
		if this.conf[MenuItem.name]~=nil then
			MenuItem.setValue(this.conf[MenuItem.name])
		end
		return MenuItem
	end
	

	
	function this.deactivateAll()
		for num, item in ipairs(this.children) do
			item.active=false
		end
	end
	
	function this.setMenuPosition(pos)
		this.setpos=Vector2.new(pos)
	end
	
	function this.calculateY()
	local yOffset=0
		for i, item in ipairs(this.children) do
			item.setYoffset(yOffset)
			yOffset=yOffset+(item.rectangle.height or 0)
		end
		this.fullHeight=yOffset
		return MenuItem
	end
	
	function this.expandMain(newWidth)
		if newWidth>this.width then
			this.width=newWidth
			for i, item in ipairs(this.children) do
				item.setWidthInternal(newWidth)
			end
		end
	end
	
	function this.onLoop()
		if not this.active then return end
		if not this.pos.equals(this.setpos) then
			this.pos=this.setpos
			for num, item in ipairs(this.children) do
				item.setPosition(this.setpos)
			end
		end
		for i, item in pairs(this.children) do
			item.onLoop()
		end
		FillRect(this.pos.x,this.pos.y,1,this.fullHeight+2, MENUBORDERCOLOR)
		FillRect(this.pos.x+this.width,this.pos.y,1,this.fullHeight+2, MENUBORDERCOLOR)
		FillRect(this.pos.x,this.pos.y+this.fullHeight,this.width,2, MENUBORDERCOLOR)
	end
	
	return this
end

SubMenu={}
function SubMenu.new(name)
	--item fields
	local this = {}
	this.conf = {}
	this.name = name or "Unnamed"
	this.parent=parent
	this.mainMenu=nil
	this.textY=0
	this.pos=Vector2.new()
	this.rectangle = Rectangle.new(0, 0, ITEMWIDTH, ITEMHEIGHT)
	this.active=false
	--drag specific fields
	this.allowDrag=true
	this.dragPos=Vector2.new()
	this.dragging=false
	this.dragUnlocked=false
	
	--submenu specific fields
	this.fullHeight = 0
	this.yOffset=0
	this.childWidth= ITEMWIDTH
	this.children = {}
	
	this.textlengthAdd=55
	
	function this.getValue()
		for num, item in pairs(this.children) do
			this.conf[item.name]=item.getValue(true)
		end
		return this.conf
	end
	
	function this.setValue(val)
		this.conf=val
	end
	
	function this.processInput(key, pressed, mouseVector)
	
		if key==1 and not pressed then
			this.dragging=false
		end
		if key==1 and this.rectangle.contains(mouseVector) and pressed then
				this.dragging=true
				this.dragUnlocked=false
				this.dragPos=Vector2.new(mouseVector)
				this.parent.deactivateAll()
				this.deactivateAll()
				this.active=true
		end

		if not this.active then return end
		for num, item in ipairs(this.children) do
			item.processInput(key, pressed, mouseVector)
		end
	end
	
	function this.show()
		for num, item in ipairs(this.children) do
			item.show()
		end
	end
	
	function this.hide()
		this.dragging=false
		for num, item in ipairs(this.children) do
			item.hide()
		end
	end
	
	function this.addItem(MenuItem)
		local free=1
		for num, item in ipairs(this.children) do
			free=free+1
		end 
		MenuItem.name=stripchars(MenuItem.name, "\n\a\b\f\r\t\v\"%[%]" )
		MenuItem.parent=this
		MenuItem.mainMenu=this.mainMenu
		this.expandChild(MenuItem.textlengthAdd+getTextWidth(MenuItem.name, 0))
		MenuItem.setWidthInternal(this.childWidth)
		MenuItem.setPosition(Vector2.new(this.pos.x+this.rectangle.width, this.pos.y+this.yOffset))
		this.children[free]=MenuItem
		this.calculateY()
		if this.conf[MenuItem.name]~=nil then
			MenuItem.setValue(this.conf[MenuItem.name])
		end
		return MenuItem
	end
	
	function this.setYoffset(newoff)
		this.yOffset=newoff
		this.rectangle.y=this.yOffset+this.pos.y
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setPosition(v)
		this.pos=v
		this.rectangle.x=v.x
		this.rectangle.y=this.yOffset+this.pos.y
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
		this.setChildPos(Vector2.new(this.pos.x+this.rectangle.width, this.pos.y+this.yOffset))
	end
	
	function this.setWidth(newWidth)
		if this.parent.setChildWidth~=nil then 
			this.parent.setChildWidth(newWidth) 
		else
			this.parent.expandMain(newWidth)
		end
	end
	
	function this.expand(newWidth)
		if this.parent.expandChild~=nil then 
			this.parent.expandChild(newWidth) 
		else
			this.parent.expandMain(newWidth)
		end
	end
	
	function this.expandChild(newWidth)
		if newWidth>this.childWidth then
			this.childWidth=newWidth
			for i, item in ipairs(this.children) do
				item.setWidthInternal(newWidth)
			end
		end
	end
	
	function this.setWidthInternal(newWidth)
		this.rectangle.width=newWidth
		this.setChildPos(Vector2.new(this.pos.x+this.rectangle.width, this.pos.y+this.yOffset))
	end
	
	function this.setHeight(newHeight)
		this.rectangle.height=newHeight
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
		this.setChildPos(Vector2.new(this.pos.x+this.rectangle.width, this.rectangle.y))
		this.parent.calculateY()
	end
	
	function this.setChildWidth(newWidth)
		this.childWidth=(newWidth)
		this.setChildPos(Vector2.new(this.pos.x+this.rectangle.width, this.rectangle.y))
		for i, item in ipairs(this.children) do
			item.setWidthInternal(newWidth)
		end
	end
	
	function this.setChildPos(v)
		for num, item in ipairs(this.children) do
			item.setPosition(v)
		end
	end
	
	function this.deactivateAll()
		for num, item in ipairs(this.children) do
			item.active=false
		end
	end
	
	function this.calculateY()
	local yOffset=0
		for i, item in ipairs(this.children) do
			item.setYoffset(yOffset)
			yOffset=yOffset+(item.rectangle.height or 0)
		end
		this.fullHeight=yOffset
		return MenuItem
	end
	
	function this.onLoop()
	
		if this.active then
			if this.dragging then
				tempVec=mousePos().sub(this.dragPos)
				if this.dragUnlocked then
					this.dragPos=mousePos()
					this.mainMenu.setMenuPosition(tempVec.add(this.mainMenu.pos))
				elseif not this.dragUnlocked and tempVec.len2()>100 then
					this.dragUnlocked=true
					this.dragPos=mousePos()
				end
			end
			this.rectangle.draw(MENUBGACTIVE)
		else
			this.rectangle.draw(MENUBGCOLOR)
		end
		DrawText(">", 16, this.pos.x+this.rectangle.width-15, this.textY, MENUTEXTCOLOR)
		DrawText(this.name, 15, this.pos.x+5, this.textY, MENUTEXTCOLOR)
		FillRect(this.rectangle.x,this.rectangle.y,this.rectangle.width,2,MENUBORDERCOLOR)
		
		if not this.active then return end

		
		if next(this.children) == nil then return end
		
		for i, item in pairs(this.children) do
			item.onLoop()
		end
		FillRect(this.pos.x+this.rectangle.width,this.rectangle.y,1,this.fullHeight+2, MENUBORDERCOLOR)
		FillRect(this.pos.x+this.rectangle.width+this.childWidth,this.rectangle.y,1,this.fullHeight+2, MENUBORDERCOLOR)
		FillRect(this.pos.x+this.rectangle.width,this.rectangle.y+this.fullHeight,this.childWidth,2, MENUBORDERCOLOR)

	end
	
	return this
end

MenuSeparator={}
function MenuSeparator.new(name)
	--item fields
	local this = {}
	this.name = name or "Unnamed"
	this.parent=parent
	this.mainMenu=nil
	this.textY=0
	this.yOffset=0
	this.pos=Vector2.new()
	this.rectangle = Rectangle.new(0, 0, ITEMWIDTH, ITEMHEIGHT)
	this.textlengthAdd=20
	
	this.allowDrag=true
	this.dragPos=Vector2.new()
	this.dragging=false
	this.dragUnlocked=false
	
	function this.processInput(key, pressed, mouseVector)
		if key==1 and not pressed then
			this.dragging=false
		end
		if key==1 and this.rectangle.contains(mouseVector) and pressed then
				this.dragging=true
				this.dragUnlocked=false
				this.dragPos=Vector2.new(mouseVector)
				this.active=true
		end
	end

	function this.getValue()
		return this.name
	end
	function this.setValue(val)
		
	end
	
	function this.expand(newWidth)
		this.parent.expandChild(newWidth)
	end
	
	function this.setYoffset(newoff)
		this.yOffset=newoff
		this.rectangle.y=this.pos.y+this.yOffset
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setPosition(v)
		this.rectangle.x=v.x
		this.pos=v
		this.rectangle.y=this.pos.y+this.yOffset
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setWidth(newWidth)
		if this.parent.setChildWidth~=nil then 
			this.parent.setChildWidth(newWidth) 
		else
			this.parent.expandMain(newWidth)
		end
	end
	
	function this.setWidthInternal(newWidth)
		this.rectangle.width=newWidth
	end
	
	function this.setHeight(newHeight)
		this.rectangle.height=newHeight
		this.textY=this.rectangle.y+this.height/2+TEXTYOFFSET
		this.parent.calculateY()
	end

	function this.onLoop()
		if this.active then
			if this.dragging then
				tempVec=mousePos().sub(this.dragPos)
				if this.dragUnlocked then
					this.dragPos=mousePos()
					this.mainMenu.setMenuPosition(tempVec.add(this.mainMenu.pos))
				elseif not this.dragUnlocked and tempVec.len2()>100 then
					this.dragUnlocked=true
					this.dragPos=mousePos()
				end
			end
		end
	
	
	
		this.rectangle.draw(MENUBGCOLOR)
		DrawText(this.name, 15, this.pos.x+5, this.textY, MENUTEXTCOLOR)
		FillRect(this.rectangle.x,this.rectangle.y,this.rectangle.width,2,MENUBORDERCOLOR)
	end
	
	function this.show()
	end
	
	function this.hide()
		this.dragging=false
	end
	
	return this
end

MenuKeyBind={}
function MenuKeyBind.new(name, keycode)
	--item fields
	local this = {}
	this.name = name or "Unnamed"
	this.keycode = keycode or 0
	this.parent=parent
	this.mainMenu=nil
	this.textY=0
	this.yOffset=0
	this.pos=Vector2.new()
	this.rectangle = Rectangle.new(0, 0, ITEMWIDTH, ITEMHEIGHT)
	this.activeRectangle = Rectangle.new(0, 0, TOGGLEWIDTH, ITEMHEIGHT)
	this.waitingForKey=false
	this.keycodeString=codeToString(this.keycode)
	this.textlengthAdd=90
	
	function this.processInput(key, pressed, mouseVector)
		if this.waitingForKey and pressed and (key~=1 or this.rectangle.contains(mouseVector)) then
			this.keycode = key
			this.keycodeString=codeToString(this.keycode)
			this.waitingForKey=false
		end
		if key==1 and pressed then
			if this.rectangle.contains(mouseVector) then
				this.waitingForKey=true
				this.keycodeString="..."
			else
				this.waitingForKey=false
				this.keycodeString=codeToString(this.keycode)
			end
		end
	end

	function this.getValue(a)
		if a==nil then return KeyIsDown(this.keycode) end
		return this.keycode
	end
	
	function this.setValue(va)
		if type(va)~="number" then return end
		this.keycode = math.abs(round(va))
		this.keycodeString=codeToString(this.keycode)
	end
	
	function this.setWidth(newWidth)
		if this.parent.setChildWidth~=nil then 
			this.parent.setChildWidth(newWidth) 
		else
			this.parent.expandMain(newWidth)
		end
	end
	
	function this.setYoffset(newoff)
		this.yOffset=newoff
		this.rectangle.y=this.pos.y+this.yOffset
		this.activeRectangle.y=this.rectangle.y
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setPosition(v)
		this.rectangle.x=v.x
		this.activeRectangle.x=this.rectangle.x+this.rectangle.width-TOGGLEWIDTH
		this.pos=v
		this.rectangle.y=this.pos.y+this.yOffset
		this.activeRectangle.y=this.rectangle.y
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setWidth(newWidth)
		if this.parent.expand~=nil then this.parent.expand(newWidth) end
		if this.parent.setChildWidth~=nil then this.parent.setChildWidth(newWidth) end
	end
	
	function this.setWidthInternal(newWidth)
		this.rectangle.width=newWidth
		this.activeRectangle.x=this.rectangle.x+newWidth-TOGGLEWIDTH
	end
	
	function this.setHeight(newHeight)
		this.rectangle.height=newHeight
		this.activeRectangle.height=this.rectangle.height
		this.textY=this.rectangle.y+this.height/2+TEXTYOFFSET
		this.parent.calculateY()
	end

	function this.onLoop()
		this.rectangle.draw(MENUBGCOLOR)
		if this.getValue() then
			this.activeRectangle.draw(0xFF008000)
			DrawText("On", 15, this.pos.x+this.rectangle.width-24, this.textY, MENUTEXTCOLOR)
		else
			this.activeRectangle.draw(0xFFFF0000)
			DrawText("Off", 15, this.pos.x+this.rectangle.width-24, this.textY, MENUTEXTCOLOR)
		end
		FillRect(this.activeRectangle.x-2,this.activeRectangle.y,1,this.activeRectangle.height,MENUBORDERCOLOR)
		DrawText(string.format("%s (%s)",this.name, this.keycodeString), 15, this.pos.x+5, this.textY, MENUTEXTCOLOR)
		FillRect(this.rectangle.x,this.rectangle.y,this.rectangle.width,2,MENUBORDERCOLOR)
	end
	
	function this.show()
	end
	
	function this.hide()
		if this.waitingForKey then
			this.waitingForKey=false
			this.keycodeString=tostring(this.keycode)
		end
	end
	return this
end

MenuBool={}
function MenuBool.new(name, active)
	--item fields
	local this = {}
	this.name = name or "Unnamed"
	this.valueActive=active or false
	this.parent=parent
	this.mainMenu=nil
	this.textY=0
	this.yOffset=0
	this.pos=Vector2.new()
	this.rectangle = Rectangle.new(0, 0, ITEMWIDTH, ITEMHEIGHT)
	this.activeRectangle = Rectangle.new(0, 0, TOGGLEWIDTH, ITEMHEIGHT)
	this.textlengthAdd=60

	this.allowDrag=true
	this.dragPos=Vector2.new()
	this.dragging=false
	this.dragUnlocked=false
	
	function this.processInput(key, pressed, mouseVector)
		if key==1 and pressed and this.activeRectangle.contains(mouseVector) then
			this.valueActive = not this.valueActive
		end
		if key==1 and not pressed then
			this.dragging=false
		end
		if key==1 and this.rectangle.contains(mouseVector) and pressed then
				this.dragging=true
				this.dragUnlocked=false
				this.dragPos=Vector2.new(mouseVector)
				this.active=true
		end
	end

	function this.getValue()
		return this.valueActive
	end
	
	function this.setValue(va)
		if type(va)~="boolean" then return end
		this.valueActive=va
	end
	
	function this.expand(newWidth)
		this.parent.expandChild(newWidth)
	end
	
	function this.setYoffset(newoff)
		this.yOffset=newoff
		this.rectangle.y=this.pos.y+this.yOffset
		this.activeRectangle.y=this.rectangle.y
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setPosition(v)
		this.rectangle.x=v.x
		this.activeRectangle.x=this.rectangle.x+this.rectangle.width-TOGGLEWIDTH
		this.pos=v
		this.rectangle.y=this.pos.y+this.yOffset
		this.activeRectangle.y=this.rectangle.y
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setWidth(newWidth)
		if this.parent.setChildWidth~=nil then 
			this.parent.setChildWidth(newWidth) 
		else
			this.parent.expandMain(newWidth)
		end
	end
	
	function this.setWidthInternal(newWidth)
		this.rectangle.width=newWidth
		this.activeRectangle.x=this.rectangle.x+newWidth-TOGGLEWIDTH
	end
	
	function this.setHeight(newHeight)
		this.rectangle.height=newHeight
		this.activeRectangle.height=this.rectangle.height
		this.textY=this.rectangle.y+this.height/2+TEXTYOFFSET
		this.parent.calculateY()
	end

	function this.onLoop()
		if this.active then
			if this.dragging then
				tempVec=mousePos().sub(this.dragPos)
				if this.dragUnlocked then
					this.dragPos=mousePos()
					this.mainMenu.setMenuPosition(tempVec.add(this.mainMenu.pos))
				elseif not this.dragUnlocked and tempVec.len2()>100 then
					this.dragUnlocked=true
					this.dragPos=mousePos()
				end
			end
		end
		
		this.rectangle.draw(MENUBGCOLOR)
		if this.valueActive then
			this.activeRectangle.draw(0xFF008000)
			DrawText("On", 15, this.pos.x+this.rectangle.width-25, this.textY, MENUTEXTCOLOR)
		else
			this.activeRectangle.draw(0xFFFF0000)
			DrawText("Off", 15, this.pos.x+this.rectangle.width-25, this.textY, MENUTEXTCOLOR)
		end
		FillRect(this.activeRectangle.x-2,this.activeRectangle.y,1,this.activeRectangle.height,MENUBORDERCOLOR)
		DrawText(this.name, 15, this.pos.x+5, this.textY, MENUTEXTCOLOR)
		FillRect(this.rectangle.x,this.rectangle.y,this.rectangle.width,2,MENUBORDERCOLOR)
	end
	function this.show()
	end
	
	function this.hide()

	end
	return this
end

MenuStringList={}
function MenuStringList.new(name, stringlist, index)
	--item fields
	local this = {}
	this.name = name or "Unnamed"
	this.stringlist=stringlist or {"Empty"}
	this.selectedIndex=index or 1
	this.parent=parent
	this.mainMenu=nil
	this.textY=0
	this.yOffset=0
	this.pos=Vector2.new()
	this.rectangle = Rectangle.new(0, 0, ITEMWIDTH, ITEMHEIGHT)
	this.leftRectangle = Rectangle.new(0, 0, TOGGLEWIDTH, ITEMHEIGHT)
	this.rightRectangle = Rectangle.new(0, 0, TOGGLEWIDTH, ITEMHEIGHT)
	this.textlengthAdd=80+getLongestString(this.stringlist)
	this.isShow = false

	
	function this.processInput(key, pressed, mouseVector)
		if isShow and key==1 and pressed then
			if this.leftRectangle.contains(mouseVector) then
				if this.selectedIndex==1 then 
					this.selectedIndex=table.getn(this.stringlist)
				else
					this.selectedIndex=this.selectedIndex-1
				end
			elseif this.rightRectangle.contains(mouseVector) then
				if this.selectedIndex==table.getn(this.stringlist) then 
					this.selectedIndex=1
				else
					this.selectedIndex=this.selectedIndex+1
				end
			end
		end
	end

	function this.getValue()
		return this.selectedIndex
	end
	
	function this.setValue(va)
		this.selectedIndex=(math.abs(round(va-1))%table.getn(this.stringlist))+1
	end
	
	function this.expand(newWidth)
		this.parent.expandChild(newWidth)
	end
	
	function this.setYoffset(newoff)
		this.yOffset=newoff
		this.rectangle.y=this.pos.y+this.yOffset
		this.leftRectangle.y=this.rectangle.y
		this.rightRectangle.y=this.rectangle.y
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setPosition(v)
		this.rectangle.x=v.x
		this.leftRectangle.x=this.rectangle.x+this.rectangle.width-TOGGLEWIDTH*2-2
		this.rightRectangle.x=this.rectangle.x+this.rectangle.width-TOGGLEWIDTH
		this.pos=v
		this.rectangle.y=this.pos.y+this.yOffset
		this.leftRectangle.y=this.rectangle.y
		this.rightRectangle.y=this.rectangle.y
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setWidth(newWidth)
		if this.parent.setChildWidth~=nil then 
			this.parent.setChildWidth(newWidth) 
		else
			this.parent.expandMain(newWidth)
		end
	end
	
	function this.setWidthInternal(newWidth)
		this.rectangle.width=newWidth
		this.leftRectangle.x=this.rectangle.x+newWidth-TOGGLEWIDTH*2-2
		this.rightRectangle.x=this.rectangle.x+newWidth-TOGGLEWIDTH
	end
	
	function this.setHeight(newHeight)
		this.rectangle.height=newHeight
		
		this.leftRectangle.height=this.rectangle.height
		this.rightRectangle.height=this.rectangle.height
		
		this.textY=this.rectangle.y+this.height/2+TEXTYOFFSET
		this.parent.calculateY()
	end

	function this.onLoop()
		this.rectangle.draw(MENUBGCOLOR)
		
		this.leftRectangle.draw(4278190335)
		this.rightRectangle.draw(4278190335)
		FillRect(this.leftRectangle.x-2,this.leftRectangle.y,1,this.leftRectangle.height,MENUBORDERCOLOR)
		FillRect(this.rightRectangle.x-2,this.rightRectangle.y,1,this.rightRectangle.height,MENUBORDERCOLOR)
		DrawText(">", 15, this.rightRectangle.x+10, this.textY, MENUTEXTCOLOR)
		DrawText("<", 15, this.leftRectangle.x+10, this.textY, MENUTEXTCOLOR)
		DrawText(this.name, 15, this.pos.x+5, this.textY, MENUTEXTCOLOR)
		DrawText(this.stringlist[this.selectedIndex], 15, this.leftRectangle.x-getTextWidth(this.stringlist[this.selectedIndex], 5), this.textY, MENUTEXTCOLOR)
		FillRect(this.rectangle.x,this.rectangle.y,this.rectangle.width,2,MENUBORDERCOLOR)
	end
	function this.show()
		isShow = true
	end
	
	function this.hide()
		isShow = false
	end
	return this
end

MenuSlider={}
function MenuSlider.new(name, value, mi, ma, step)
	--item fields
	local this = {}
	this.name = name or "Unnamed"
	this.min = mi or 0
	this.max = ma or 10
	
	if value==nil or value<mi then
		this.value=mi
	else
		this.value=value
	end
	
	this.step = step or 1
	this.sliderActive = false
	this.places=calcRounding(this.step)
	this.parent=parent
	this.mainMenu=nil
	this.textY=0
	this.yOffset=0
	this.pos=Vector2.new()
	this.rectangle = Rectangle.new(0, 0, ITEMWIDTH, ITEMHEIGHT)
	this.sliderRectangle = Rectangle.new(0, 0, 	2, ITEMHEIGHT)
	this.textlengthAdd=20+getTextWidth(string.format("%."..this.places.."f", this.max))
	
	function this.processInput(key, pressed, mouseVector)
		if key~=1 then return end
		if pressed and this.rectangle.contains(mouseVector) then
			this.sliderActive = true
			return
		end
		this.sliderActive=false
	end

	function this.getValue()
		return this.value
	end
	
	function this.setValue(va)
		if type(va)~="number" then return end
		va=va or 0
		local val = roundStep(va, this.step)
		if val<this.min then val=this.min end
		if val>this.max then val=this.max end
		this.value=val
		this.updateSlider()
	end
	
	function this.expand(newWidth)
		this.parent.expandChild(newWidth)
	end
	
	function this.updateSlider()
		this.sliderRectangle.x=2+this.rectangle.x+(this.rectangle.width-5)*(this.value-this.min)/(this.max-this.min)
		this.sliderRectangle.y=this.rectangle.y
	end
	
	function this.setYoffset(newoff)
		this.yOffset=newoff
		this.rectangle.y=this.pos.y+this.yOffset
		this.sliderRectangle.y=this.rectangle.y
		this.updateSlider()
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setPosition(v)
		this.rectangle.x=v.x
		this.pos=v
		this.rectangle.y=this.pos.y+this.yOffset
		this.sliderRectangle.y=this.rectangle.y
		this.updateSlider()
		this.textY=this.rectangle.y+this.rectangle.height/2+TEXTYOFFSET
	end
	
	function this.setWidth(newWidth)
		if this.parent.setChildWidth~=nil then 
			this.parent.setChildWidth(newWidth) 
		else
			this.parent.expandMain(newWidth)
		end
	end
	
	function this.setWidthInternal(newWidth)
		this.rectangle.width=newWidth
		this.updateSlider()
	end
	
	function this.setHeight(newHeight)
		this.rectangle.height=newHeight
		this.sliderRectangle.height=this.rectangle.height
		this.updateSlider()
		
		this.textY=this.rectangle.y+this.height/2+TEXTYOFFSET
		this.parent.calculateY()
	end

	function this.onLoop()
		if this.sliderActive then
			local val = roundStep(mousePos().sub(this.rectangle).x/this.rectangle.width*(this.max-this.min)+this.min, this.step)
			if val<this.min then val=this.min end
			if val>this.max then val=this.max end
			this.value=val
			this.updateSlider()
		end
		this.rectangle.draw(MENUBGCOLOR)
		this.sliderRectangle.draw(0xFFFFFF00)
		DrawText(this.name, 15, this.pos.x+5, this.textY, MENUTEXTCOLOR)
		local textval=string.format("%."..this.places.."f", this.value)
		DrawText(textval, 15, this.pos.x+this.rectangle.width-getTextWidth(textval, 10), this.textY, MENUTEXTCOLOR)
		
		FillRect(this.rectangle.x,this.rectangle.y,this.rectangle.width,2,MENUBORDERCOLOR)
	end
	
	function this.show()
	end
	
	function this.hide()
	this.sliderActive=false
	end
	return this
end
--ENDREGION Menu---------------------------------------------------------------}

--REGION GOSUTILITY------------------------------------------------------------
--{
local GOSUactive=false

function extensionsActive()
	return GOSUActive
end

function listScripts()
	local ret={} 
	for k, v in pairs(g.listScripts()) do 
		table.insert(ret, v)
	end 
	return ret 
end
	
function print(text)
	return g.print(text) end

function printn(text)
	return g.printn(text) end

function closeConsole()
	return g.closeConsole() end
	
function saveScript(name, script)
	g.saveScript(name, script) end
	
function webRequest(server, address)
	local result=g.request(server, address)
	if result=="" or result=="Not found" then return nil end
	return result end
	
function mousePos()
	local pos
	if g then 
		pos=g.mousePos() 
		return Vector2.new(pos[1], pos[2])
	else
		pos=GetMousePos()
		pos=WorldToScreen(1, pos.x, pos.y, pos.z)
		return Vector2.new(pos)
	end
end

function getResolution()
	local res = g.resolution()
	return Vector2.new(res[1], res[2])
end

function gVersion()
	return g.version()
end

function lolVersion()
	return g.getLolVersion()
end
--ENDREGION GOSUTILITY---------------------------------------------------------}

--REGION key and mouse events--------------------------------------------------
--{
local keys={}
local subscribers={}
local inputEventsActive=false
for i=1, 255, 1 do
	keys[i]=false
end

function pollKeysOnLoop()
	if not inputEventsActive then return end
	for i=1, 255, 1 do
		if i~=117 and i~=118 then 
			local state=KeyIsDown(i)
			if keys[i]~=state then
				broadcastEvent(i, state)
			end
		keys[i]=state
		end
	end
end

function broadcastEvent(keyCode, pressed)
	for i, subs in ipairs(subscribers) do
		subs(keyCode, pressed)
	end
end

function registerInputListener(listener)
	if type(listener)=="function" then
		inputEventsActive=true
		subscribers[table.getn(subscribers)+1]=listener
		return table.getn(subscribers)
	else
		PrintChat("Script tried to register non function as an event listener!")
	end
end

function unregisterInputListener(num)
	subscribers[num]=nil
	if next(subscribers) == nil then inputEventsActive=false end
end

--ENDREGION key and mouse events-----------------------------------------------}

--REGION Geometry--------------------------------------------------------------
--{
Vector2={}

function Vector2.new(x, y)
	local this = {}
	if type(x)=="table" then 
		this.x=x.x or 0
		this.y=x.y or 0
	else
		this.x=x or 0
		this.y=y or 0
	end
	
	function this.cpy()
		return Vector2.new(this)
	end
		
	function this.len()
		return math.sqrt(this.x * this.x + this.y * this.y)
	end
		
	function this.len2()
		return this.x * this.x + this.y * this.y
	end
		
	function this.set(x, y)
		if type(x)=="table" then 
			this.x=x.x
			this.y=x.y
		else
			this.x=x
			this.y=y
		end
		return this
	end
		
	function this.sub(x, y)
		if type(x)=="table" then 
			this.x=this.x-x.x
			this.y=this.y-x.y
		else
			this.x=this.x-x
			this.y=this.y-y
		end
		return this
	end
			
	function this.add(x, y)
		if type(x)=="table" then 
			this.x=this.x+x.x
			this.y=this.y+x.y
		else
			this.x=this.x+x
			this.y=this.y+y
		end
		return this
	end
		
	function this.nor(x, y)
		l = this.len()
		if l ~= 0 then
			this.x =x/l
			this.y =y/l
		end
		return this
	end
	
	function this.dot(x, y)
		if type(x)=="table" then 
			return this.x * x.x + this.y * x.y
		else
			return this.x * x + this.y * y
		end
	end

	function this.scl(scalar)
		this.x=this.x*scalar
		this.y=this.y*scalar
		return this
	end

	function this.scl2(x, y)
		if type(x)=="table" then 
			this.x=this.x*x.x
			this.y=this.y*x.y
		else
			this.x=this.x*x
			this.y=this.y*y
		end
		return this
	end
	
	function this.dst(x, y)
	local x_d, y_d
		if type(x)=="table" then
			x_d = x.x-this.x
			y_d = x.y-this.y
		else
			x_d = x-this.x
			y_d = y-this.y
		end
		return math.sqrt(x_d * x_d + y_d * y_d)
	end
	
	function this.limit(limit)
		return this.limit2(limit * limit)
	end
	
	function this.limit2(limit2)
		local len2=this.len2()
		if len2 > limit2 then
			return this.scl(math.sqrt(limit2 / len2)) end
		return this
	end
	
	function this.clamp (mi, ma)
		local len2 = this.len2()
		if (len2 == 0) then
			return this end
		local max2 = ma * ma
		if (len2 > max2) then
			return this.scl(math.sqrt(max2 / len2)) end
		local min2 = mi * mi
		if (len2 < min2) then
			return this.scl(math.sqrt(min2 / len2)) end
		return this
	end
	
	function this.setLength (l)
		return this.setLength2( l * l )
	end

	function this.setLength2 (len2)
		local oldLen2 = len2()
		if oldLen2 == 0 or oldLen2 == len2 then
			return this
		else
			return this.scl(math.sqrt( len2 / oldLen2 ))
		end
	end
	
	function this.toString()
		return "[" .. this.x .. ":" .. this.y .. "]"
	end
	
	function this.crs(x, y)
		if type(x)=="table" then 
			return this.x * x.y - this.y * x.x
		else
			return this.x * y - this.y * x
		end
	end
	
	function this.angle (reference)
		if reference==nil then
			local angle = math.atan2(this.y, this.x) * radiansToDegrees
			if angle < 0 then angle=angle+360 end
			return angle
		else
			return math.atan2(this.crs(reference), this.dot(reference)) *radiansToDegrees
		end
	end
	
	function this.angleRad (reference)
		if reference==nil then
			return math.atan2(this.y, this.x)
		else
			return math.atan2(this.crs(reference), this.dot(reference))
		end
	end

	function this.setAngle (degrees)
		return this.setAngleRad(degrees * degreesToRadians)
	end
	
	function this.setAngleRad (radians)
		this.set(this.len(), 0)
		this.rotateRad(radians)
		return this
	end
	
	function this.rotate (degrees)
		return rotateRad(degrees * degreesToRadians)
	end
	
	function this.rotateRad (radians)
		local co = math.cos(radians)
		local si = math.sin(radians)

		local newX = this.x * co - this.y * si
		local newY = this.x * si + this.y * co

		this.x = newX
		this.y = newY

		return this
	end
	
	function this.rotate90 (dir)
		local x = this.x
		if (dir >= 0) then
			this.x = -this.y
			this.y = x
		else
			this.x = this.y
			this.y = -x
		end
		return this
	end
	
	function this.lerp (target, alpha)
		local invAlpha = 1 - alpha
		this.x = (this.x * invAlpha) + (target.x * alpha)
		this.y = (this.y * invAlpha) + (target.y * alpha)
		return this
	end
	
	function this.equals (obj) 
		if this == obj then return true end
		if obj == nil or obj.x~=this.x or obj.y~=this.y then return false end
		return true
	end
	
	function this.epsilonEquals (other, epsilon)
		if other == nil then return false end
		if math.abs(other.x - this.x) > epsilon then return false end
		if math.abs(other.y - this.y) > epsilon then return false end
		return true
	end
	
	function this.isUnit (margin)
		local margin=margin or 0.000000001
		return math.abs(this.len2() - 1) < margin
	end
	
	function this.isZero (margin)
		local margin=margin or 0.000000001
		return math.abs(this.len2()) < margin
	end
	
	function this.isOnLine (other, epsilon)
		local epsilon=epsilon or 0.000001
		return isZero(this.x * other.y - this.y * other.x, epsilon)
	end
	
	function this.isCollinear (other, epsilon)
		local epsilon=epsilon or 0.000001
		return this.isOnLine(other, epsilon) and this.dot(other) > 0
	end
	
	function this.isCollinearOpposite (other, epsilon)
		local epsilon=epsilon or 0.000001
		return this.isOnLine(other, epsilon) and this.dot(other) < 0
	end
	
	function this.isPerpendicular (other, epsilon)
		local epsilon=epsilon or 0.000001
		return isZero(this.dot(other), epsilon)
	end
	
	function this.hasSameDirection (other)
		return dot(other) > 0
	end
	
	function this.hasOppositeDirection (other)
		return dot(other) < 0
	end
	
	function this.setZero (other)
		this.x = 0
		this.y = 0
		return this
	end
	
	return this
end

Rectangle={}

function Rectangle.new(x, y, width, height)
	local this = {}
	
	if type(x)=="table" then
		this.x = x.x
		this.y = x.y
		this.width = x.width
		this.height = x.height
	else
		this.x = x or 0
		this.y = y or 0
		this.width = width or 0
		this.height = height or 0
	end

	function this.set(x, y, width, height)
		if type(x)=="table" then
			this.x = x.x
			this.y = x.y
			this.width = x.width
			this.height = x.height
		else
			this.x = x or 0
			this.y = y or 0
			this.width = width or 0
			this.height = height or 0
		end
		return this
	end
		
	function this.setPosition(x, y)
		if type(x)=="table" then
			this.x = x.x
			this.y = x.y
		else
			this.x = x or 0
			this.y = y or 0
		end
		return this
	end
		
	function this.setSize(width, height)
		if type(x)=="table" then
			this.width = x.width
			this.height = x.height
		else
			this.width = width or 0
			this.height = height or 0
		end
		return this
	end
		
	function this.contains(x, y)
		if type(x)=="table" then
			if width == nil then
				local xmin = x.x
				local xmax = xmin + x.width
				local ymin = x.y
				local ymax = ymin + x.height

				return ((xmin > this.x and xmin < this.x + width) and (xmax > this.x and xmax < this.x + width))
					and ((ymin > this.y and ymin < this.y + height) and (ymax > this.y and ymax < this.y + height))
			else
				return this.x <= x.x and this.x + this.width >= x.x and this.y <= x.y and this.y + this.height >= x.y
			end
		else
			return this.x <= x and this.x + this.width >= x and this.y <= y and this.y + this.height >= y
		end
	end
		
	function overlaps(r)
		return this.x < r.x + r.width and this.x + this.width > r.x and y < r.y + r.height and this.y + this.height > r.y
	end

	function this.merge(x, y)
		if type(x)=="table" then 
			if x.x==nil then --Vector2 array
				local minX = this.x
				local maxX = this.x + this.width
				local minY = this.y
				local maxY = this.y + this.height
				for i, v in ipairs(x) do
					minX = math.min(minX, v.x)
					maxX = math.max(maxX, v.x)
					minY = math.min(minY, v.y)
					maxY = math.max(maxY, v.y)
				end
				this.x = minX
				this.width = maxX - minX
				this.y = minY
				this.height = maxY - minY
			elseif x.width==nil then --Vector2
				return merge(x.x, x.y)
			else --Rectangle
				local minX = math.min(this.x, rect.x)
				local maxX = math.max(this.x + this.width, rect.x + rect.width)
				this.x = minX;
				this.width = maxX - minX
				local minY = math.min(this.y, rect.y)
				local maxY = math.max(this.y + this.height, rect.y + rect.height)
				this.y = minY
				this.height = maxY - minY
			end
		else --2 numbers
			local minX = math.min(this.x, x)
			local maxX = math.max(this.x + width, x)
			this.x = minX
			this.width = maxX - minX

			local minY = math.min(this.y, y)
			local maxY = math.max(this.y + this.height, y)
			this.y = minY
			this.height = maxY - minY
		end
		return this
	end
		
	function this.getAspectRatio()
		if this.height == 0 then
			return math.huge
		else
			return this.width / this.height
		end
	end
	
	function this.setCenter(x, y)
		if type(x)=="table" then 
			this.setPosition(x.x - this.width / 2, x.y - this.height / 2)
		else
			this.setPosition(x - this.width / 2, y - this.height / 2)
		end
		return this
	end

	function this.area()
		return this.width*this.height
	end

	function this.perimeter()
		return 2 * (this.width + this.height)
	end
	
	function this.toString()
		return this.x .. "," .. this.y .. "," .. this.width .. "," .. this.height
	end
	
	function this.equals (obj) 
		if this == obj then return true end
		if obj == nil or obj.x~=this.x or obj.y~=this.y or obj.width~=this.width or obj.height~=this.height then return false end
		return true
	end
	
	function this.draw (color) 
		FillRect(this.x,this.y,this.width, this.height, color or 0x90000000) 
	end

	return this
end

DCircle={}

function DCircle.new(x, y, radius)
	local this = {}
	
	if type(x)=="table" then
		if type(y)=="table" then--center and edge
			this.x = center.x
			this.y = center.y
			this.radius = Vector2.new(x.x - y.x, x.y - y.y).len()
		else
			this.x = x.x
			this.y = x.y
			this.radius = x.radius
		end
	else
		this.x = x or 0
		this.y = y or 0
		this.radius = radius or 0
	end

	function this.set(x, y, radius)
		if type(x)=="table" then
			if type(y)=="table" then--center and edge
				this.x = center.x
				this.y = center.y
				this.radius = Vector2.new(x.x - y.x, x.y - y.y).len()
			else
				this.x = x.x
				this.y = x.y
				this.radius = x.radius
			end
		else
			this.x = x or 0
			this.y = y or 0
			this.radius = radius or 0
		end
		return this
	end
		
	function this.setPosition(x, y)
		if type(x)=="table" then
			this.x = x.x
			this.y = x.y
		else
			this.x = x or 0
			this.y = y or 0
		end
		return this
	end
		
	function this.contains(x, y)
		if type(x)=="table" then
			if x.radius==nil then
				local dx = this.x - x.x
				local dy = this.y - x.y
				return dx * dx + dy * dy <= this.radius * this.radius
			else
				local radiusDiff = radius - x.radius
				if radiusDiff < 0 then return false end
				local dx = this.x - x.x
				local dy = this.y - x.y
				local dst = dx * dx + dy * dy
				local radiusSum = this.radius + x.radius
				return (not(radiusDiff * radiusDiff < dst) and (dst < radiusSum * radiusSum))
			end
		else
			local x = this.x - x
			local y = this.y - y
			return x * x + y * y <= this.radius * this.radius
		end
	end
		
	function this.overlaps(c)
		local dx = this.x - c.x
		local dy = this.y - c.y
		local distance = dx * dx + dy * dy
		local radiusSum = this.radius + c.radius
		return distance < radiusSum * radiusSum
	end

	function this.area()
		return this.radius * this.radius * math.pi
	end

	function this.circumference()
		return 2 * this.radius * math.pi
	end
	
	function this.toString()
		return this.x .. "," .. this.y .. "," .. this.radius;
	end
	
	function this.equals (obj) 
		if this == obj then return true end
		if obj == nil or obj.x~=this.x or obj.y~=this.y or obj.radius~=this.radius then return false end
		return true
	end
	
	function this.draw (color) 
		FillRect(this.x,this.y,this.width, this.height, color or 0x90000000) 
	end

	return this
end

radiansToDegrees=180/math.pi
degreesToRadians = math.pi / 180

function isZero(value, epsilon)
	local tolerance=tolerance or 0.000001
	return math.abs(value) <= tolerance
end
	
	
--ENDREGION Geometry---------------------------------------------------------------}

--REGION Config, serializer--------------------------------------------------------------
--{
Config={}
function Config.new()
	this={}
	this.name="Config"
	this.newline="\n"
	this.config={}
	function this.load()
		local c=prequire(this.name, true)
		if c~=nil and type(c)=="table" then
			this.config=c
		end
	end
	function this.save()
		if not g then return end
		local index=1
		local buf = {[[local c={}]]}
		index=index+1
		buf[index]=this.serializeTable(this.config, "c")
		index=index+1
		buf[index]=[[return c]]
		index=index+1
		buf[index]=this.newline
		index=index+1
		saveScript("Common\\"..this.name, table.concat( buf ))
	end
	
	function this.serializeTable(tab, prefix)
		local index=1
		local buf = {}
		buf[index]=this.newline
		index=index+1
		for key, value in pairs(tab) do
			if type(key)=="number" then
				buf[index]=prefix.."["..key.."]="
			else
				buf[index]=prefix..'["'..stripchars(key, "\n\a\b\f\r\t\v\"%[%]" )..'"]='
			end
			index=index+1
			
			local valtype=type(value)
			if valtype=="number" then
				buf[index]=value
				index=index+1
			elseif valtype=="table" then
				buf[index]="{}"
				index=index+1
				if type(key)=="number" then
					buf[index]=this.serializeTable(value, prefix.."["..key.."]")
				else
					buf[index]=this.serializeTable(value, prefix..'["'..stripchars(key, "\n\a\b\f\r\t\v\"%[%]" )..'"]')
				end
				index=index+1
			elseif valtype=="string" then
				buf[index]="[["..stripchars(value, "\n\a\b\f\r\t\v\"%[%]" ).."]]"
				index=index+1
			elseif valtype=="boolean" then
				buf[index]=tostring(value)
				index=index+1
			else
				buf[index]="type not supported :("
				index=index+1
			end
			buf[index]=this.newline
			index=index+1
		end
		return table.concat( buf )
	end

return this
end
--ENDREGION Config, serializer-----------------------------------------------------------}

--REGION Updater--------------------------------------------------------------
--{
Updater={}
function Updater.new(address, name, version)
	local this = {}
	this.address=address
	this.version=version
	this.name=name
	
	function this.newVersion()
		if not updaterActive.getValue() or not g then return false end
		this.response=webRequest("github", this.address.."?rand="..math.random(1,10000))
		if this.response==nil then return false end
		this.remoteVersion = string.match(this.response, "local version = %d+")
		if this.remoteVersion==nil then 
			this.response=nil
			return false 
		end
		this.remoteVersion = tonumber(string.match(this.remoteVersion, "%d+"))
	return this.remoteVersion>this.version
	end
	
	function this.update()
		if this.response==nil then end
		saveScript(this.name, this.response)
		delay(function() notification(this.name.." updated.\n F6-F6 to reload.", 5000) end, 5000)
	end
	return this
end

--ENDREGION Updater-----------------------------------------------------------}



package.cpath=string.gsub(package.path, ".lua", ".dll")

c=Config.new()
c.load()

menu=MainMenu.new()
updaterActive=menu.addItem(MenuBool.new("Updater active", true))

g=prequire("GOSUtility")
if g then
	local UP=Updater.new("iLoveSona/GOS/master/Common/DLib.lua", "Common\\DLib", version)
	if UP.newVersion() then UP.update() end
	if gVersion()<6 then 
		notification("plz Redownload GOSUtility", 10000) 
	else
		local versionCode = lolVersion()
		if versionCode then	
			PrintChat("lol version : "..versionCode) 
			closeConsole()
		else 
			PrintChat("lol version : not found") 
		end
	end	
else
	PrintChat("GOSUtility.dll not found. Functions using GOSUtility won't work.")
end

OnLoop(function()
	local tickcount=GetTickCount()
	pollKeysOnLoop()
	delayedOnLoop(tickcount)
	notificationsOnLoop(tickcount)
	menu.onLoop()
end)

PrintChat("[DLib] : loaded")

--Inspired lib----------------------------------------------------------------
-- copy paste some useful api coz too lazy to require two lib....
function VectorType(v)
    v = GetOrigin(v) or v
    return v and v.x and type(v.x) == "number" and ((v.y and type(v.y) == "number") or (v.z and type(v.z) == "number"))
end

class 'Vector'

function Vector:__init(a, b, c)
    if a == nil then
        self.x, self.y, self.z = 0.0, 0.0, 0.0
    elseif b == nil then
        a = GetOrigin(a) or a
        assert(VectorType(a), "Vector: wrong argument types (expected nil or <Vector> or 2 <number> or 3 <number>)")
        self.x, self.y, self.z = a.x, a.y, a.z
    else
        assert(type(a) == "number" and (type(b) == "number" or type(c) == "number"), "Vector: wrong argument types (<Vector> or 2 <number> or 3 <number>)")
        self.x = a
        if b and type(b) == "number" then self.y = b end
        if c and type(c) == "number" then self.z = c end
    end
end

function Vector:__type()
    return "Vector"
end

function Vector:__add(v)
    assert(VectorType(v) and VectorType(self), "add: wrong argument types (<Vector> expected)")
    return Vector(self.x + v.x, (v.y and self.y) and self.y + v.y, (v.z and self.z) and self.z + v.z)
end

function Vector:__sub(v)
    assert(VectorType(v) and VectorType(self), "Sub: wrong argument types (<Vector> expected)")
    return Vector(self.x - v.x, (v.y and self.y) and self.y - v.y, (v.z and self.z) and self.z - v.z)
end

function Vector.__mul(a, b)
    if type(a) == "number" and VectorType(b) then
        return Vector({ x = b.x * a, y = b.y and b.y * a, z = b.z and b.z * a })
    elseif type(b) == "number" and VectorType(a) then
        return Vector({ x = a.x * b, y = a.y and a.y * b, z = a.z and a.z * b })
    else
        assert(VectorType(a) and VectorType(b), "Mul: wrong argument types (<Vector> or <number> expected)")
        return a:dotP(b)
    end
end

function Vector.__div(a, b)
    if type(a) == "number" and VectorType(b) then
        return Vector({ x = a / b.x, y = b.y and a / b.y, z = b.z and a / b.z })
    else
        assert(VectorType(a) and type(b) == "number", "Div: wrong argument types (<number> expected)")
        return Vector({ x = a.x / b, y = a.y and a.y / b, z = a.z and a.z / b })
    end
end

function Vector.__lt(a, b)
    assert(VectorType(a) and VectorType(b), "__lt: wrong argument types (<Vector> expected)")
    return a:len() < b:len()
end

function Vector.__le(a, b)
    assert(VectorType(a) and VectorType(b), "__le: wrong argument types (<Vector> expected)")
    return a:len() <= b:len()
end

function Vector:__eq(v)
    assert(VectorType(v), "__eq: wrong argument types (<Vector> expected)")
    return self.x == v.x and self.y == v.y and self.z == v.z
end

function Vector:__unm()
    return Vector(-self.x, self.y and -self.y, self.z and -self.z)
end

function Vector:__vector(v)
    assert(VectorType(v), "__vector: wrong argument types (<Vector> expected)")
    return self:crossP(v)
end

function Vector:__tostring()
    if self.y and self.z then
        return "(" .. tostring(self.x) .. "," .. tostring(self.y) .. "," .. tostring(self.z) .. ")"
    else
        return "(" .. tostring(self.x) .. "," .. self.y and tostring(self.y) or tostring(self.z) .. ")"
    end
end

function Vector:clone()
    return Vector(self)
end

function Vector:unpack()
    return self.x, self.y, self.z
end

function Vector:len2(v)
    assert(v == nil or VectorType(v), "dist: wrong argument types (<Vector> expected)")
    local v = v and Vector(v) or self
    return self.x * v.x + (self.y and self.y * v.y or 0) + (self.z and self.z * v.z or 0)
end

function Vector:len()
    return math.sqrt(self:len2())
end

function Vector:dist(v)
    assert(VectorType(v), "dist: wrong argument types (<Vector> expected)")
    local a = self - v
    return a:len()
end

function Vector:normalize()
    local a = self:len()
    self.x = self.x / a
    if self.y then self.y = self.y / a end
    if self.z then self.z = self.z / a end
end

function Vector:normalized()
    local a = self:clone()
    a:normalize()
    return a
end

function Vector:center(v)
    assert(VectorType(v), "center: wrong argument types (<Vector> expected)")
    return Vector((self + v) / 2)
end

function Vector:crossP(other)
    assert(self.y and self.z and other.y and other.z, "crossP: wrong argument types (3 Dimensional <Vector> expected)")
    return Vector({
        x = other.z * self.y - other.y * self.z,
        y = other.x * self.z - other.z * self.x,
        z = other.y * self.x - other.x * self.y
    })
end

function Vector:dotP(other)
    assert(VectorType(other), "dotP: wrong argument types (<Vector> expected)")
    return self.x * other.x + (self.y and (self.y * other.y) or 0) + (self.z and (self.z * other.z) or 0)
end

function Vector:projectOn(v)
    assert(VectorType(v), "projectOn: invalid argument: cannot project Vector on " .. type(v))
    if type(v) ~= "Vector" then v = Vector(v) end
    local s = self:len2(v) / v:len2()
    return Vector(v * s)
end

function Vector:mirrorOn(v)
    assert(VectorType(v), "mirrorOn: invalid argument: cannot mirror Vector on " .. type(v))
    return self:projectOn(v) * 2
end

function Vector:sin(v)
    assert(VectorType(v), "sin: wrong argument types (<Vector> expected)")
    if type(v) ~= "Vector" then v = Vector(v) end
    local a = self:__vector(v)
    return math.sqrt(a:len2() / (self:len2() * v:len2()))
end

function Vector:cos(v)
    assert(VectorType(v), "cos: wrong argument types (<Vector> expected)")
    if type(v) ~= "Vector" then v = Vector(v) end
    return self:len2(v) / math.sqrt(self:len2() * v:len2())
end

function Vector:angle(v)
    assert(VectorType(v), "angle: wrong argument types (<Vector> expected)")
    return math.acos(self:cos(v))
end

function Vector:affineArea(v)
    assert(VectorType(v), "affineArea: wrong argument types (<Vector> expected)")
    if type(v) ~= "Vector" then v = Vector(v) end
    local a = self:__vector(v)
    return math.sqrt(a:len2())
end

function Vector:triangleArea(v)
    assert(VectorType(v), "triangleArea: wrong argument types (<Vector> expected)")
    return self:affineArea(v) / 2
end

function Vector:rotateXaxis(phi)
    assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    local c, s = math.cos(phi), math.sin(phi)
    self.y, self.z = self.y * c - self.z * s, self.z * c + self.y * s
end

function Vector:rotateYaxis(phi)
    assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    local c, s = math.cos(phi), math.sin(phi)
    self.x, self.z = self.x * c + self.z * s, self.z * c - self.x * s
end

function Vector:rotateZaxis(phi)
    assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    local c, s = math.cos(phi), math.sin(phi)
    self.x, self.y = self.x * c - self.z * s, self.y * c + self.x * s
end

function Vector:rotate(phiX, phiY, phiZ)
    assert(type(phiX) == "number" and type(phiY) == "number" and type(phiZ) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    if phiX ~= 0 then self:rotateXaxis(phiX) end
    if phiY ~= 0 then self:rotateYaxis(phiY) end
    if phiZ ~= 0 then self:rotateZaxis(phiZ) end
end

function Vector:rotated(phiX, phiY, phiZ)
    assert(type(phiX) == "number" and type(phiY) == "number" and type(phiZ) == "number", "Rotated: wrong argument types (expected <number> for phi)")
    local a = self:clone()
    a:rotate(phiX, phiY, phiZ)
    return a
end

-- not yet full 3D functions
function Vector:polar()
    if math.close(self.x, 0) then
        if (self.z or self.y) > 0 then return 90
        elseif (self.z or self.y) < 0 then return 270
        else return 0
        end
    else
        local theta = math.deg(math.atan((self.z or self.y) / self.x))
        if self.x < 0 then theta = theta + 180 end
        if theta < 0 then theta = theta + 360 end
        return theta
    end
end

function Vector:angleBetween(v1, v2)
    assert(VectorType(v1) and VectorType(v2), "angleBetween: wrong argument types (2 <Vector> expected)")
    local p1, p2 = (-self + v1), (-self + v2)
    local theta = p1:polar() - p2:polar()
    if theta < 0 then theta = theta + 360 end
    if theta > 180 then theta = 360 - theta end
    return theta
end

function Vector:compare(v)
    assert(VectorType(v), "compare: wrong argument types (<Vector> expected)")
    local ret = self.x - v.x
    if ret == 0 then ret = self.z - v.z end
    return ret
end

function Vector:perpendicular()
    return Vector(-self.z, self.y, self.x)
end

function Vector:perpendicular2()
    return Vector(self.z, self.y, -self.x)
end


local myHero = GetMyHero()
local myTeam = GetTeam(myHero)
local summonerNameOne = GetCastName(myHero,SUMMONER_1)
local summonerNameTwo = GetCastName(myHero,SUMMONER_2)
_G.Ignite = (summonerNameOne:lower():find("summonerdot") and SUMMONER_1 or (summonerNameTwo:lower():find("summonerdot") and SUMMONER_2 or nil))
_G.Smite = (summonerNameOne:lower():find("summonersmite") and SUMMONER_1 or (summonerNameTwo:lower():find("summonersmite") and SUMMONER_2 or nil))
_G.Exhaust = (summonerNameOne:lower():find("summonerexhaust") and SUMMONER_1 or (summonerNameTwo:lower():find("summonerexhaust") and SUMMONER_2 or nil))

local ilib = {}
function ilib.IsInDistance(p1,r)
    return ilib.GetDistanceSqr(GetOrigin(p1)) < r*r
end

function ilib.GetDistance(p1,p2)
  p1 = GetOrigin(p1) or p1
  p2 = GetOrigin(p2) or p2 or GetOrigin(myHero)
  return math.sqrt(ilib.GetDistanceSqr(p1,p2))
end

function ilib.GetDistanceSqr(p1,p2)
    p2 = p2 or GetOrigin(myHero)
    local dx = p1.x - p2.x
    local dz = (p1.z or p1.y) - (p2.z or p2.y)
    return dx*dx + dz*dz
end

function ilib.ValidTarget(unit, range)
    range = range or 25000
    if not unit or not GetOrigin(unit) or not IsTargetable(unit) or IsImmune(unit, myHero) or IsDead(unit) or not IsVisible(unit) or GetTeam(unit) == myTeam or not ilib.IsInDistance(unit, range) then return false end
    return true
end

function ilib.CalcDamage(source, target, addmg, apdmg)
    local ADDmg = addmg or 0
    local APDmg = apdmg or 0
    local ArmorPen = GetObjectType(source) == Obj_AI_Minion and 0 or math.floor(GetArmorPenFlat(source))
    local ArmorPenPercent = GetObjectType(source) == Obj_AI_Minion and 1 or math.floor(GetArmorPenPercent(source)*100)/100
    local Armor = GetArmor(target)*ArmorPenPercent-ArmorPen
    local ArmorPercent = (GetObjectType(source) == Obj_AI_Minion and Armor < 0) and 0 or Armor > 0 and math.floor(Armor*100/(100+Armor))/100 or math.ceil(Armor*100/(100-Armor))/100
    local MagicPen = math.floor(GetMagicPenFlat(source))
    local MagicPenPercent = math.floor(GetMagicPenPercent(source)*100)/100
    local MagicArmor = GetMagicResist(target)*MagicPenPercent-MagicPen
    local MagicArmorPercent = MagicArmor > 0 and math.floor(MagicArmor*100/(100+MagicArmor))/100 or math.ceil(MagicArmor*100/(100-MagicArmor))/100
    return (GotBuff(source,"exhausted")  > 0 and 0.4 or 1) * math.floor(ADDmg*(1-ArmorPercent))+math.floor(APDmg*(1-MagicArmorPercent))
end

-- only hero
local objManager = {
	uncheck = {},
	enemyHeroes = {},
	allyHeroes = {},
}

-- you need use callback by initCallback when you want use this api in load time
function ilib.GetEnemyHeroes()
	return objManager.enemyHeroes
end

function ilib.GetAllyHeroes()
	return objManager.allyHeroes
end

DAMAGE_MAGIC, DAMAGE_PHYSICAL = 1, 2
function ilib.GetTarget(range, damageType)
	damageType = damageType or 2
	local target, steps = nil, 10000
	for _, k in pairs(ilib.GetEnemyHeroes()) do
		local step = GetCurrentHP(k) / ilib.CalcDamage(GetMyHero(), k, DAMAGE_PHYSICAL == damageType and 100 or 0, DAMAGE_MAGIC == damageType and 100 or 0)
		if k and ilib.ValidTarget(k, range+GetHitBox(k)) and step < steps then
			target = k
			steps = step
		end
	end
	return target
end

local callback = nil
function ilib.initCallback(callback0)
	callback = callback0
end

function ilib.init()
	-- local done = false
	-- OnLoop(function()
		-- for _,object in pairs(objManager.uncheck) do
		-- 	local objType = GetObjectType(object)
		-- 	local objTeam = GetTeam(object)

		-- 	if objType == Obj_AI_Hero and objTeam ~= myTeam then
		-- 		objManager.enemyHeroes[object] = object
		-- 		objManager.uncheck[object] = nil
		-- 	end
		-- end
	-- 	done = true
	-- end)

	-- OnCreateObj(function(object)
	-- 	local objType = GetObjectType(object)
	-- 	local objTeam = GetTeam(object)
	-- 	objManager.uncheck[object] = object
	-- end)

	-- OnDeleteObj(function(object)
	-- 	local objType = GetObjectType(object)
	-- 	local objTeam = GetTeam(object)
	-- 	objManager.enemyHeroes[object] = nil
	-- end)

	local initHeroCounter = 0
	local print = print
	OnObjectLoop(function(object,myHero)
		if initHeroCounter >= 9 then return end
		-- if done then return end

		if GetObjectType(object) == Obj_AI_Hero then
			local slot = GetNetworkID(object)
			
			-- if objManager.allyHeroes[slot] or objManager.enemyHeroes[slot] then return end

			if GetTeam(object) == GetTeam(myHero) then
				objManager.allyHeroes[slot] = object
				-- print(initHeroCounter.." allyHeroes : "..GetObjectName(object))
			else
				objManager.enemyHeroes[slot] = object
				-- print(initHeroCounter.." enemyHeroes : "..GetObjectName(object))
			end
			initHeroCounter = initHeroCounter + 1
			-- print(initHeroCounter)
			if initHeroCounter >= 9 and callback then callback(true) end
		end
	end)
end

ilib.init()
return ilib
--------------------------------------------------------------------------------