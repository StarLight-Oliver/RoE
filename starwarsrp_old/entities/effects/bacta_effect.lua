local count = 200
local range = 100

EFFECT.Mat = Material("star/effects/blue_shockwave")

EFFECT.Mats = {
[2] = true,
[3] = true,
[4] = true,
[5] = true,
}

function EFFECT:Init( data )
	self.pos = data:GetOrigin()
	self.DieTime = CurTime() + 5

	local emitter = ParticleEmitter(self.pos)

	for x = 1, count do
		local part = emitter:Add("particle/particle_glow_0" .. math.random(2, 5), self.pos)
			part:SetDieTime(math.random(3, 5) )
			part:SetStartAlpha(math.random(200,255) )
			part:SetEndAlpha(0)
			part:SetBounce(1)
			part:SetCollide(true)
			part:SetColor(math.random(30, 60), math.random(30, 60), math.random(200, 255))
			part:SetStartSize(math.random(5, 15))
			part:SetEndSize(math.random(50, 100) )
			part:SetVelocity(VectorRand() * math.random(1, range/2))
	end
	emitter:Finish()
end

function EFFECT:Think()
	return self.DieTime > CurTime()
end

function EFFECT:Render()
	render.SetMaterial(self.Mat)
	render.DrawQuadEasy(self.pos, Vector(0,0,1), range*4, range*4, color_white)
end
