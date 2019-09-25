ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Item Chest"
ENT.Author = "Anthony Fuller"
ENT.Category = "OGC | Events"
ENT.Spawnable = true
ENT.Contact = "An admin."

function ENT:SetupDataTables()
	self:NetworkVar( "String", 1, "BoxSize")
	self:NetworkVar( "String", 2, "EntityClass")
end
