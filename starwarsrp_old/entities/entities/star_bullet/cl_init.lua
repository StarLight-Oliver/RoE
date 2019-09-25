
/*
	local endDistance = self.Speed * self.StartTime
	local startDistance = endDistance - self.Length
	startDistance = math.max(0, startDistance)
	endDistance = math.max(0, endDistance)
	local startPos = self.StartPos + self.Normal * startDistance
	local endPos = self.StartPos + self.Normal * endDistance
	render.SetMaterial(MaterialFront)
	render.DrawSprite(endPos, 8, 8, color_white)
	render.SetMaterial(MaterialMain)
	render.DrawBeam(startPos, endPos, 10, 0, 1, color_white)
*/
include('shared.lua')



local MaterialMain 			= Material("effects/sw_laser_main")
local MaterialFront 		= Material("effects/sw_laser_front")

function ENT:Draw()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local endPos = pos + ang:Forward() * self.scale
	local startPos = pos - ang:Forward() * self.scale
	local col = self:GetBulletColor()
	col = Color(col.x, col.y, col.z, 255)
	render.SetMaterial(MaterialFront)
	render.DrawSprite(endPos, 8, 8,col)
	render.SetMaterial(MaterialMain)
	render.DrawBeam(startPos, endPos, 10, 0.1, 1, col)
	render.SetMaterial(MaterialMain)
	local startPos = pos - ang:Forward() * (self.scale - 2)
	local endPos = pos + ang:Forward() * (self.scale - 0.5)
	render.DrawBeam(startPos, endPos, 5, 0.1, 1, Color(255,255,255))
end