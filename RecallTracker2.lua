local version = 1
require ("DLib")

up=Updater.new("DrakeSharp/GOS/master/RecallTracker2.lua", "RecallTracker2", version)
if up.newVersion() then 
	up.update() end

local subm=menu.addItem(SubMenu.new("Recall tracker"))
local barWidth=subm.addItem(MenuSlider.new("Bar width",250, 1, 1000, 1))
local rowHeight=subm.addItem(MenuSlider.new("Row Height",18, 18, 30, 1))
local onlyEnemies=subm.addItem(MenuBool.new("Track enemies only", true))
local onlyFOW=subm.addItem(MenuBool.new("Track recalls started in FOW only", true))
local keytomove=subm.addItem(MenuKeyBind.new("Hold to move bars", 90))
local side=subm.addItem(MenuStringList.new("Bars on the side", {"Right", "Left", "Nowhere"}))

local recalling = {}
if c.config.recallkrystiantracker==nil then c.config.recallkrystiantracker={} end
if c.config.recallkrystiantracker.x==nil then c.config.recallkrystiantracker.x=5 end
if c.config.recallkrystiantracker.y==nil then c.config.recallkrystiantracker.y=500 end
local show = false
local drag = false
local dragpos = Vector2.new()
local rect=Rectangle.new(c.config.recallkrystiantracker.x, c.config.recallkrystiantracker.y, 168,rowHeight.getValue())

registerInputListener(function(key, pressed)

	if key==(keytomove.getValue(true)) then
		show=pressed
		if not pressed then
			drag = false
			c.config.recallkrystiantracker.x=rect.x
			c.config.recallkrystiantracker.y=rect.y
			c.save()
			recalling["TEST"] = nil
		else
			local rec = {}
			rec.hero = GetMyHero()
			rec.info = {isStart=true, isFinish=false, totalTime=90000}
			rec.starttime = GetTickCount()
			rec.killtime = nil
			rec.result = nil
			recalling["TEST"] = rec
		end
	end
	
	if not show then return end
	
	if key==1 and not pressed then
		drag=false
	end
	if key==1 and rect.contains(mousePos()) and pressed then
			drag=true
			dragpos=Vector2.new(mousePos())
			drag = true
	end
end)

OnDraw(function()
	if show then
		if drag then
			tempVec=mousePos().sub(dragpos)
				dragpos=mousePos()
				rect.y=rect.y+tempVec.y
				rect.x=rect.x+tempVec.x
		end
		FillRect(rect.x,rect.y, 168,rowHeight.getValue(),0xA0000000)
		DrawText("Drag this", 14, rect.x+50, rect.y, 0xFFFF0000)
	end
	
	local i = 1
	for hero, recallObj in pairs(recalling) do
		local percent=math.floor(GetCurrentHP(recallObj.hero)/GetMaxHP(recallObj.hero)*100)
		local color=percentToRGB(percent)
		local leftTime = recallObj.starttime - GetTickCount() + recallObj.info.totalTime
		
		if leftTime<0 then leftTime = 0 end
		FillRect(rect.x,rect.y+rowHeight.getValue()*i-2,168,rowHeight.getValue(),0x90000000)
		if i>1 then FillRect(rect.x,rect.y+rowHeight.getValue()*i-2,168,1,0xC0000000) end
		
		DrawText(string.format("%s (%d%%)", hero, percent), 14, rect.x+2, rect.y + rowHeight.getValue()*i+(rowHeight.getValue()-18)/2, color)
		
		if recallObj.info.isStart then
			DrawText(string.format("%.1fs", leftTime/1000), 14, rect.x+115, rect.y+rowHeight.getValue()*i+(rowHeight.getValue()-18)/2, color)
			local leng=round(barWidth.getValue()*leftTime/recallObj.info.totalTime)
			if side.getValue()==1 then
				FillRect(rect.x+169,rect.y+rowHeight.getValue()*i+(rowHeight.getValue()-18)/2, leng,14,0x90000000)
			elseif side.getValue()==2 then
				FillRect(rect.x-1-leng,rect.y+rowHeight.getValue()*i+(rowHeight.getValue()-18)/2, leng,14,0x90000000)
			end
		else
			if recallObj.killtime == nil then
				if recallObj.info.isFinish and not recallObj.info.isStart then
					recallObj.result = "finished"
					recallObj.killtime =  GetTickCount()+2000
				elseif not recallObj.info.isFinish then
					recallObj.result = "cancelled"
					recallObj.killtime =  GetTickCount()+2000
				end
				
			end
			DrawText(recallObj.result, 14, rect.x+115, rect.y+rowHeight.getValue()*i+(rowHeight.getValue()-18)/2, color)
		end
		
		if recallObj.killtime~=nil and GetTickCount() > recallObj.killtime then
			recalling[hero] = nil
		end
		
		i=i+1
	end
end)

OnProcessRecall(function(Object,recallProc)
	if onlyEnemies.getValue() and GetTeam(GetMyHero())==GetTeam(Object) then return end
	if onlyFOW.getValue() and recalling[GetObjectName(Object)] == nil  and IsVisible(Object) then return end
	
	local rec = {}
	rec.hero = Object
	rec.info = recallProc
	rec.starttime = GetTickCount()
	rec.killtime = nil
	rec.result = nil
	recalling[GetObjectName(Object)] = rec

end)
notification("Recall tracker 2 by Krystian loaded.", 3000)
