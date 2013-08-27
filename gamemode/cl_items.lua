-- Items
-- Bleh

local items = {}

function GM:ItemsThink()
	for k, v in pairs(items) do
		local ent = Entity(v.EntIndex)
		
		if IsValid(ent) then
			ent:SetItem(v.ItemID)
			
			items[k] = nil
		end
	end
end

-- net hooks
net.Receive('Lounge_Spawn_Item', function(length)
	local entindex = net.ReadInt(32)
	local item_id = net.ReadString()
	
	table.insert(items, entindex, {
		EntIndex = entindex,
		ItemID = item_id
	})
end)