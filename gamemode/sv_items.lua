-- Items
-- Bleh

local worlditems = {}

function GM:SpawnItemInWorld(item_id, pos)
	local ent = ents.Create('es_item')
	local entindex = ent:EntIndex()
	
	ent:SetItem(item_id)
	
	ent:SetPos(pos)
	ent:Spawn()
	
	net.Start('Lounge_Spawn_Item')
		net.WriteInt(entindex, 32)
		net.WriteString(item_id)
	net.Broadcast()
	
	worlditems[entindex] = ent
end

function GM:RemoveItemFromWorld(entindex)
	worlditems[entindex] = nil
end

util.AddNetworkString('Lounge_Spawn_Item')