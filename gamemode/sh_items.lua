-- Items
-- Bleh

local items = {}

function GM:GetItem(item_id)
	return items[item_id] and items[item_id] or false
end

-- local functions
local function LoadItems()
	local folder = string.Replace(GM.Folder, 'gamemodes/', '')
	local fs, ds = file.Find(folder .. '/gamemode/items/*.lua', 'LUA')
	
	for _, f in pairs(fs) do
		if SERVER then
			AddCSLuaFile(folder .. '/gamemode/items/' .. f)
		end
		
		ITEM = {}
		include(folder .. '/gamemode/items/' .. f)
		
		local item_id = string.Replace(f, '.lua', '')
		
		ITEM.ID = item_id
		
		items[item_id] = ITEM
	end
end

LoadItems()