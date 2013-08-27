ITEM.Name = 'Backpack'
ITEM.Cost = 0

ITEM.Model = 'models/props_c17/SuitCase_Passenger_Physics.mdl'
ITEM.Bone = 'ValveBiped.Bip01_Spine2'

ITEM.Buyable = false
ITEM.Sellable = false
ITEM.Droppable = false
ITEM.Pickupable = false
ITEM.Equippable = false
ITEM.Holsterable = false

ITEM.ShowInBackpack = false

function ITEM:ModifyClientsideModel(ply, model, pos, ang)
	model:SetModelScale(0.8, 0)
	pos = pos + (ang:Right() * 5) + (ang:Up() * 6) + (ang:Forward() * 2)
	
	return model, pos, ang
end