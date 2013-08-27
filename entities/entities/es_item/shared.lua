ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = ""
ENT.Author = ""
ENT.Contact = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetItem(item_id)
	local item = GAMEMODE:GetItem(item_id)
	
	if item.Model then
		self:SetModel(item.Model)
	end
	
	for k, v in pairs(item) do
		if type(v) == 'function' then
			self[k] = v
		end
	end
	
	self.Item = item
end