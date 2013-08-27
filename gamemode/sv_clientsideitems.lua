-- Clientside Models

-- player functions
local Player = FindMetaTable('Player')

function Player:AddClientsideItem(item_id)
	if not GAMEMODE:ItemExists(item_id) then return false end
end