-- Coins
-- Uses properties

-- player functions
local Player = FindMetaTable('Player')

function Player:GetCoins()
	return self:GetProperty('coins', 0)
end

function Player:SetCoins(num)
	self:SetProperty('coins', num, true, true)
end

function Player:GiveCoins(num)
	self:SetProperty('coins', self:GetCoins() + num, true, true)
end

function Player:TakeCoins(num)
	self:SetProperty('coins', self:GetCoins() - num, true, true)
end

function Player:HasCoins(num)
	return self:GetCoins() >= num
end