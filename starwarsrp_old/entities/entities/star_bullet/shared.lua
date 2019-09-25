ENT.Type 		= "anim"
ENT.Base = "base_anim"
ENT.PrintName	= "Bullet"
ENT.Author		= "StarLight"
ENT.Contact		= ""
ENT.Category = "OGC"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false

ENT.scale = 10

function ENT:SetupDataTables()
	self:NetworkVar( "Vector", 0, "BulletColor" )
	self:NetworkVar( "Vector", 1, "StartPos")
	self:NetworkVar( "Float", 0, "DamageAmount")
end

