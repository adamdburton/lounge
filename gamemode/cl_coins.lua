-- Coins
-- Uses properties

-- player functions
local Player = FindMetaTable('Player')

function Player:GetCoins()
	return self:GetProperty('coins', 0)
end

function Player:HasCoins(num)
	return self:GetCoins() >= num
end