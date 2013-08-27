-- Inventory
-- Uses properties

-- player functions
local Player = FindMetaTable('Player')

-- buying/selling

function Player:BuyItem(item_id, qty)
	local item = GAMEMODE:GetItem(item_id)
	if not item then return false end
	
	if not self:HasCoins(item.Price * qty) then return false end
	
	self:TakeCoins(item.Price * qty)
	self:GiveItem(item_id, qty)
end

function Player:SellItem(item_id, qty)
	local item = GAMEMODE:GetItem(item_id)
	if not item then return false end
	
	if not self:HasItemQuantity(item_id, qty) then return false end
	
	local price = GAMEMODE:CalculateSellPrice(item.Price)
	self:GiveCoins(price * qty)
	self:TakeItem(item_id, qty)
end

-- get/give/take

function Player:GetItems()
	return self:GetProperty('items', {})
end

function Player:GetItemQuantity(item_id)
	if not self:HasItem(item_id) then return 0 end
	
	local items = self:GetItems()
	return items[item_id].Quantity
end

function Player:GiveItem(item_id, qty)
	local items = self:GetItems()
	
	if not items[item_id] then
		items[item_id] = {
			Quantity = 0,
			Equipped = false,
			Modifiers = {}
		}
	end
	
	items[item_id].Quantity = items[item_id].Quantity + qty
	
	self:UpdateItems(items)
end

function Player:TakeItem(item_id, qty)
	if not self:HasItem(item_id) then return false end
	
	local items = self:GetItems()
	
	if items[item_id].Quantity - qty < 0 then
		return false
	elseif items[item_id].Quantity - qty == 0 then
		items[item_id] = nil
	else
		items[item_id].Quantity = items[item_id].Quantity - qty
	end
	
	self:UpdateItems(items)
end

-- has checking

function Player:HasItem(item_id)
	local items = self:GetItems()
	return items[item_id] and true or false
end

function Player:HasItemQuantity(item_id, qty)
	if not self:HasItem() then return false end
	
	local items = self:GetItems()
	return items[item_id].Quantity >= qty
end

function Player:HasItemEquipped(item_id)
	if not self:HasItem() then return false end
	
	local items = self:GetItems()
	return items[item_id].Equipped
end

-- equipping/holstering

function Player:EquipItem(item_id)
	if not self:HasItem(item_id) then return false end
	if self:HasItemEquipped(item_id) then return false end
	
	local items = self:GetItems()
	items[item_id].Equipped = true
	
	GAMEMODE:GetItem(item_id):OnEquip(self)
	
	self:UpdateItems(items)
end

function Player:HolsterItem(item_id)
	if not self:HasItem(item_id) then return false end
	if not self:HasItemEquipped(item_id) then return false end
	
	local items = self:GetItems()
	items[item_id].Equipped = false
	
	GAMEMODE:GetItem(item_id):OnHolster(self)
	
	self:UpdateItems(items)
end

-- dropping

function Player:DropItem(item_id, qty)
	if not self:HasItem(item_id) then return false end
	
	if self:HasItemEquipped(item_id) and self:GetItemQuantity(item_id) == 1 then
		self:HolsterItem(item_id)
	end
	
	self:TakeItem(item_id)
	
	GAMEMODE:SpawnItemInWorld(item_id, self:GetPos() + (self:Forward() * 100))
end

-- sending

function Player:UpdateItems(items)
	self:SetProperty('items', items, true, false)
end