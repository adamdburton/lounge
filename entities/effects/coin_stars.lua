function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local emitter = ParticleEmitter(pos)
	
	local particle = emitter:Add('sprites/lounge/star', pos)
	
	local vel = (VectorRand() * 50)
	vel.z = math.random(50, 100)
	particle:SetVelocity(vel)
	particle:SetDieTime(1.0)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(0)
	particle:SetStartSize(16)
	particle:SetEndSize(0)
	particle:SetGravity(Vector(0, 0, -300))
	particle:SetColor(255, 200, 30)
	
	emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end

