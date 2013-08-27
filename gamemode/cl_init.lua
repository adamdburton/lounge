-- clientside includes
include('shared.lua')
include('sh_items.lua')
include('cl_items.lua')
include('cl_properties.lua')
include('cl_coins.lua')
include('cl_inventory.lua')
include('cl_clientsideitems.lua')

function GM:PostPlayerDraw(ply)
	self.BaseClass:PostPlayerDraw(ply)
	
	-- related postplayerdraw functions
	self:ClientsideItemsPostPlayerDraw(ply)
end

function GM:Think()
	self.BaseClass:Think()
	
	-- related think functions
	self:ItemsThink()
end