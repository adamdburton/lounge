-- Clientside Items

local clientsideitems = {}

function GM:ClientsideItemsPostPlayerDraw(ply)
	if clientsideitems[ply:UniqueID()] then
		for item_id, mdl in pairs(clientsideitems[ply:UniqueID()]) do
			local ITEM = GAMEMODE:GetItem(item_id)
			
			if not ITEM.Attachment and not ITEM.Bone then clientsideitems[ply:UniqueID()][item_id] = nil continue end
			
			local pos = Vector()
			local ang = Angle()

			if ITEM.Attachment then
				local attach_id = ply:LookupAttachment(ITEM.Attachment)
				if not attach_id then return end

				local attach = ply:GetAttachment(attach_id)

				if not attach then return end

				pos = attach.Pos
				ang = attach.Ang
			else
				local bone_id = ply:LookupBone(ITEM.Bone)
				if not bone_id then return end

				pos, ang = ply:GetBonePosition(bone_id)
			end

			model, pos, ang = ITEM:ModifyClientsideModel(ply, model, pos, ang)

			model:SetPos(pos)
			model:SetAngles(ang)

			model:SetRenderOrigin(pos)
			model:SetRenderAngles(ang)
			model:SetupBones()
			model:DrawModel()
			model:SetRenderOrigin()
			model:SetRenderAngles()
		end
	end
end

-- player functions
local Player = FindMetaTable('Player')

function Player:AddClientsideItem(item_id)
	local item = GAMEMODE:GetItem(item_id)
	if not item then return false end
	
	if not clientsideitems[self:UniqueID()] then
		clientsideitems[self:UniqueID()] = {}
	end
	
	if clientsideitems[self:UniqueID()][item_id] then return false end -- only one of each type
	
	local mdl = ClientsideModel(item.Model, RENDERGROUP_OPAQUE)
	mdl:SetNoDraw(true)
	
	clientsideitems[self:UniqueID()][item_id] = mdl
end

function Player:RemoveClientsideItem(item_id)
	if not clientsideitems[self:UniqueID()] then return end
	if not clientsideitems[self:UniqueID()][item_id] then return end
	
	clientsideitems[self:UniqueID()][item_id] = nil
end