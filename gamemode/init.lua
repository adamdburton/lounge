-- clientside includes
AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('sh_items.lua')
AddCSLuaFile('cl_items.lua')
AddCSLuaFile('cl_properties.lua')
AddCSLuaFile('cl_coins.lua')
AddCSLuaFile('cl_inventory.lua')
AddCSLuaFile('cl_clientsideitems.lua')

-- serverside includes
include('shared.lua')
include('sv_mysql.lua')
include('sh_items.lua')
include('sv_items.lua')
include('sv_properties.lua')
include('sv_coins.lua')
include('sv_inventory.lua')
include('sv_clientsideitems.lua')

-- derive the base gamemode
DeriveGamemode('base')

function GM:Think()
	self.BaseClass:Think()
	
	-- related think functions
	self:MySQLThink()
end

function GM:Initialize()
	self.BaseClass:Initialize()
	
	-- related initialize functions
	self:PropertiesInitialize()
end

function GM:PlayerInitialSpawn(ply)
	self.BaseClass:PlayerInitialSpawn(ply)
	
	-- related playerinitialspawn functions
	self:PropertiesPlayerInitialSpawn(ply)
end