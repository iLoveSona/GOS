local myHero = GetMyHero()
local name = GetObjectName(myHero)
require('DLib')

local submenu = menu.addItem(SubMenu.new("simple skin hack for "..name))
local index = submenu.addItem(MenuSlider.new("skin index", 0, 0, 15, 1))

-- put here will reslove some skin problem
-- HeroSkinChanger(myHero,index.getValue())

OnTick(function(myHero)
	HeroSkinChanger(myHero,index.getValue())
end)

PrintChat("simple skin hack for "..name.." loaded")