-- Player and gamemode properties
-- Uses MySQL

local properties = {}
local player_properties = {}

-- hook functions
function GM:PropertiesInitialize()
	self:MySQLQuery('SELECT * FROM `properties`', {}, function(data)
		for _, row in pairs(data) do
			properties[row.key] = {
				Value = row.value,
				Shared = row.shared
			}
		end
	end)
	
	self:MySQLQuery('SELECT * FROM `player_properties`', {}, function(data)
		for _, row in pairs(data) do
			if not player_properties[row.unique_id] then
				player_properties[row.unique_id] = {}
			end
			
			player_properties[row.unique_id][row.key] = {
				Value = row.value,
				Shared = row.shared == 1 and true or false,
				Public = row.public == 1 and true or false
			}
		end
	end)
end

function GM:PropertiesPlayerInitialSpawn(ply)
	local send_properties = {}
	local send_player_properties = {}
	
	for key, prop in pairs(properties) do
		if prop.Shared then
			send_properties[key] = prop.Value
		end
	end
	
	for unique_id, props in pairs(player_properties) do
		for key, prop in pairs(props) do
			if prop.Shared and (ply:UniqueID() == unique_id or prop.Public) then
				if not send_player_properties[unique_id] then
					send_player_properties[unique_id] = {}
				end
				
				send_player_properties[unique_id][key] = prop.Value
			end
		end
	end
	
	net.Start('Lounge_Properties')
		net.WriteTable(send_properties)
		net.WriteTable(send_player_properties)
	net.Send(ply)
end

-- property functions
function GM:GetProperty(prop, default)
	if not properties[prop] then return default end
	
	return properties[prop].Value
end

function GM:SetProperty(prop, value, shared)
	if not shared then shared = false end
	
	self:MySQLQuery('DELETE FROM `properties` WHERE `key` = ?', { prop })
	self:MySQLQuery('INSERT INTO `properties` (`key`, `value`, `shared`) VALUES (?, ?, ?)', { prop, value, shared and 1 or 0 })
	
	properties[prop] = {
		Value = value,
		Shared = shared
	}
	
	-- send if required
	if shared then
		net.Start('Lounge_Property')
			
			net.WriteString(prop)
			net.WriteString(type(value))
			
			if type(value) == 'table' then
				net.WriteTable(value)
			elseif type(value) == 'string' then
				net.WriteString(value)
			elseif type(value) == 'number' then
				net.WriteInt(value, 32)
			end
			
		net.Broadcast()
	end
end

-- player functions
local Player = FindMetaTable('Player')

function Player:SetProperty(prop, value, shared, public)
	if not shared then shared = false end
	if not public then public = false end
	
	GAMEMODE:MySQLQuery('DELETE FROM `player_properties` WHERE `unique_id` = ? AND `key` = ?', { self:UniqueID(), prop })
	GAMEMODE:MySQLQuery('INSERT INTO `player_properties` (`unique_id`, `key`, `value`, `shared`, `public`) VALUES (?, ?, ?, ?, ?)', { self:UniqueID(), prop, value, shared and 1 or 0, public and 1 or 0 })
	
	if not player_properties[self:UniqueID()] then
		player_properties[self:UniqueID()] = {}
	end
	
	player_properties[self:UniqueID()][prop] = {
		Value = value,
		Shared = shared,
		Public = public
	}
	
	-- send if required
	if shared then
		net.Start('Lounge_Player_Property')
			
			net.WriteString(tostring(self:UniqueID()))
			net.WriteString(prop)
			net.WriteString(type(value))
			
			if type(value) == 'table' then
				net.WriteTable(value)
			elseif type(value) == 'string' then
				net.WriteString(value)
			elseif type(value) == 'number' then
				net.WriteInt(value, 32)
			end
			
		if public then
			net.Broadcast()
		else
			net.Send(self)
		end
	end
end

function Player:GetProperty(prop, default)
	if not player_properties[self:UniqueID()] then return default end
	if not player_properties[self:UniqueID()][prop] then return default end
	
	return player_properties[self:UniqueID()][prop].Value
end

-- networked strings
util.AddNetworkString('Lounge_Properties') 
util.AddNetworkString('Lounge_Property') 
util.AddNetworkString('Lounge_Player_Property') 