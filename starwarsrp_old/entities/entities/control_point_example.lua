AddCSLuaFile()
ENT.Base = "control_point"
ENT.PrintName = "Control Point Example"
ENT.Author = "Anthony Fuller + Star Light"
ENT.Category = "OGC | Events"
ENT.Spawnable = true
ENT.Contact = "An admin."


function ENT:Think()

	self:SetProgress( math.abs(math.sin((CurTime()/4) ) ) )
	if self:GetMaxProgress() != 1 then
		self:SetMaxProgress(1)
	end
end
