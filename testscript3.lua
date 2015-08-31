local version = 6
require ("DLib")

closeConsole()

local UP=Updater.new("iLoveSona/GOS/master/testscript3.lua", "testscript3", version)
if UP.newVersion() then UP.update() end
if gVersion()<2 then notification("Redownload GOSUtility", 10000) end

local ssl=menu.addItem(SubMenu.new("Simple Script Loader"))
local loaded=ssl.addItem(SubMenu.new("Loaded scripts"))
local all=ssl.addItem(SubMenu.new("All scripts"))
ssl.addItem(MenuSeparator.new("Don't forget about F6-F6"))
ssl.addItem(MenuSeparator.new("to load/unload selected scripts"))

for i, script in ipairs(listScripts()) do
	if all.addItem(MenuBool.new(script)).getValue() then
		local result, error = prequire(script)
		if result then
			loaded.addItem(MenuSeparator.new(script))
		else
			--notification(script..":\n Failed to load", 5000)
			print(error)
		end
	end
end