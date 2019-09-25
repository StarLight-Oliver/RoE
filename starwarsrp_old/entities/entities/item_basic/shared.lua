ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "item"
ENT.Author = "StarLight"

function ENT:SetupDataTables()
	self:NetworkVar("String",0,"ItemType")
end