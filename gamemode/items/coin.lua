ITEM.Name = 'Coin'
ITEM.Model = 'models/coins/ammopack_small.mdl'

ITEM.Buyable = false

function ITEM:OnTouch(ply)
	if SERVER then
		ply:GiveCoins(1)
		self:Remove()
		sound.Play('lounge/coin.wav', self:GetPos())
	end
end

function ITEM:Draw()
	if CLIENT then
		self:SetRenderAngles(Angle(0, CurTime() * 100, 0))
		self:DrawModel()
	end
end

function ITEM:Think()
	if SERVER then
		local effect = EffectData()
		effect:SetOrigin(self:GetPos() + Vector(0, 0, 10))
			
		util.Effect("coin_stars", effect)
		
		local nearplayer = false
		
		for _, ply in pairs(player.GetAll()) do
			local dist = ply:GetPos():Distance(self:GetPos())
			if dist <= 200 then
				nearplayer = true
				
				local vel = ply:GetPos() - self:GetPos()
				self:GetPhysicsObject():SetVelocity(vel)
			end
		end
		
		if not nearplayer then
			self:GetPhysicsObject():SetVelocity(Vector(0, 0, 0))
		end
	end
	
	if CLIENT then
		self.DL = DynamicLight(self:EntIndex())
		self.DL.Pos = self:GetPos() + Vector(0, 0, 10)
		self.DL.r = 255
		self.DL.g = 200
		self.DL.b = 30
		self.DL.Brightness = 3
		self.DL.Decay = 256
		self.DL.Size = 128
		self.DL.DieTime = CurTime() + 1
	end
end