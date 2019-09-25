include("shared.lua")

function ENT:Think()
end

function ENT:Draw()

	if LocalPlayer():GetPos():Distance(self:GetPos()) < 3036 then
		self:DrawModel()
	end
	
	local trace = LocalPlayer():GetEyeTrace()
	if trace.Entity and IsValid(trace.Entity) and trace.Entity == self then
		local angle = LocalPlayer():EyeAngles()
		angle:RotateAroundAxis(angle:Forward(), 90)
		angle:RotateAroundAxis(angle:Right(), 90)		
		--angle.r = angle.r - 180
		cam.Start3D2D( trace.HitPos + angle:Up() *50, angle, 0.05 )
			surface.SetDrawColor( 255, 255, 255, 255 )
			local c = -100
			local tbl = ITEMS[self:GetItemType()]
			draw.SimpleText("Name: " .. tbl.name, "item_text", 25,c+ 15, color)
		cam.End3D2D()
	end
end