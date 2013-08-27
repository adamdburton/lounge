-- Player and gamemode properties
-- Uses MySQL

local properties = {}
local player_properties = {}

function GM:GetProperty(prop, default)
	if not properties[prop] then return default end
	
	return properties[prop]
end

-- player functions
local Player = FindMetaTable('Player')

function Player:GetProperty(prop, default)
	if not player_properties[self:UniqueID()] then MsgN('here1') return default end
	if not player_properties[self:UniqueID()][prop] then MsgN('here2') return default end
	
	return player_properties[self:UniqueID()][prop]
end

-- net hooks
net.Receive('Lounge_Property', function(length)
	local prop = net.ReadString()
	local type = net.ReadString()
	
	local value
	
	if type == 'table' then
		value = net.ReadTable()
	elseif type == 'string' then
		value = net.ReadString()
	elseif type == 'number' then
		value = net.ReadInt(32)
	end
	
	properties[prop] = value
end)

net.Receive('Lounge_Player_Property', function(length)
	local unique_id = net.ReadString()
	local prop = net.ReadString()
	local type = net.ReadString()
	
	local value
	
	if type == 'table' then
		value = net.ReadTable()
	elseif type == 'string' then
		value = net.ReadString()
	elseif type == 'number' then
		value = net.ReadInt(32)
	end
	
	if not player_properties[unique_id] then
		player_properties[unique_id] = {}
	end
	
	player_properties[unique_id][prop] = value
end)

net.Receive('Lounge_Properties', function(length)
	local recv_properties = net.ReadTable()
	local recv_player_properties = net.ReadTable()
	
	for key, value in pairs(recv_properties) do
		properties[key] = value
	end
	
	for unique_id, props in pairs(recv_player_properties) do
		if not player_properties[unique_id] then
			player_properties[unique_id] = {}
		end
		
		for key, value in pairs(props) do
			player_properties[unique_id][key] = value
		end
	end
end)