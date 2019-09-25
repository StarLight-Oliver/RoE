include("shared.lua")

function ENT:Think()
end

function ENT:Draw()
	if self:GetTarget() == LocalPlayer() then
		self:DrawModel()	
		local pos = self:GetPos()
		render.DrawSprite( pos, 16, 16, white )
	end
end