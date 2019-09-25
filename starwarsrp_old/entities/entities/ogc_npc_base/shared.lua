ENT.Base 			= "base_nextbot"
ENT.Name			= "Normal"

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"Level")
	self:NetworkVar("Int",1,"HealthCap")
end
local be = Material("starcolor")
if (CLIENT) then
	function ENT:Initialize()
	end
	
	function ENT:Draw()
		--if (self:GetPos():Distance(LocalPlayer():GetPos()) > 1000) then return end
		self:DrawModel()
		--render.SetMaterial(be)
		--render.DrawSphere( self:GetPos(), 256, 30, 30, Color( 255, 0, 0, 100 ) )
		local ent = self
		local ahAngle = ent:GetAngles()
		local AhEyes = LocalPlayer():EyeAngles()
		
		ahAngle:RotateAroundAxis(ahAngle:Forward(), 90)
		ahAngle:RotateAroundAxis(ahAngle:Right(), -90)		
		cam.Start3D2D(ent:GetPos()+ent:GetRight()*20+ent:GetUp() * 80, Angle(0, AhEyes.y-90, 90), 0.175)
			draw.SimpleText("Level: " .. self:GetLevel(), "ButtonFont", 5, -50, color)
		cam.End3D2D()
	end
end

