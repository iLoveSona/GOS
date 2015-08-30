require('Inspired')
require('DLib')

DelayAction(function ()
	for _, imenu in pairs(menuTable) do
		local submenu = menu.addItem(SubMenu.new(imenu.name))
		for _,subImenu in pairs(imenu) do
			if subImenu.type == SCRIPT_PARAM_ONOFF then
				local ggeasy = submenu.addItem(MenuBool.new(subImenu.t, subImenu.value))
				OnLoop(function(myHero) subImenu.value = ggeasy.getValue() end)
			elseif subImenu.type == SCRIPT_PARAM_KEYDOWN then
				local ggeasy = submenu.addItem(MenuKeyBind.new(subImenu.t, subImenu.key))
				OnLoop(function(myHero) subImenu.key = ggeasy.getValue(true) end)
			elseif subImenu.type == SCRIPT_PARAM_INFO then
				submenu.addItem(MenuSeparator.new(subImenu.t))
			end
		end
	end
	_G.DrawMenu = function ( ... )	end
end, 1000)
