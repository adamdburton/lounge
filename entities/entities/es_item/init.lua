AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
 
include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/error.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	
	if phys:IsValid() then
		phys:Wake()
	end
end

function ENT:StartTouch(ent)
	if not ent:IsPlayer() then return end
	
	self:OnTouch(ent)
end

function ENT:OnTouch(ply)
	ply:GiveItem(self.Item.ID)
	self:Remove()
end