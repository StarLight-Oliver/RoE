ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Control Point"
ENT.Author = "Anthony Fuller + Star Light"
ENT.Category = "OGC | Events"
ENT.Spawnable = true
ENT.Contact = "An admin."

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "MaxProgress")
	self:NetworkVar( "Float", 1, "Increment")
	self:NetworkVar( "Float", 2, "Delay")
	self:NetworkVar("Float", 3, "Progress")
	if SERVER then
		self:SetMaxProgress(100)
		self:SetProgress(0)
		self:SetDelay(10)
		self:SetIncrement(10)
	end
end 
