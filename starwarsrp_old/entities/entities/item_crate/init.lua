AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	if self:GetBoxSize() == "Small" then
		self:SetModel( "models/kingpommes/emperors_tower/imp_crates/imp_crate_single_closed_static.mdl" )
	else
		self:SetModel( "models/kingpommes/emperors_tower/imp_crates/imp_crate_double_closed_static.mdl" )
	end

	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:EnableGravity(true) phys:Wake() end
end

function ENT:Think()

	if self.opened then return end

	if self:GetBoxSize() == "Small" then
		self:SetModel( "models/kingpommes/emperors_tower/imp_crates/imp_crate_single_closed_static.mdl" )
	else
		self:SetModel( "models/kingpommes/emperors_tower/imp_crates/imp_crate_double_closed_static.mdl" )
	end

end

function ENT:Use(activator, caller)
	if not IsValid(caller) or not caller:IsPlayer() then
		return
	end
	if self.opened then return end
	if self:GetBoxSize() == "Small" then

		self:SetModel( "models/kingpommes/emperors_tower/imp_crates/imp_crate_single_base_static.mdl" )
		self.opened = true
		local item = ents.Create("item_basic")
		item:SetPos( self:GetPos()  + self:LocalToWorld(Vector(0,0,10)))
		item:SetItem({type = self:GetEntityClass()})
		item:Spawn()

	else

		self:SetModel( "models/kingpommes/emperors_tower/imp_crates/imp_crate_double_base_phys.mdl" )
		self.opened = true
		local item = ents.Create("item_basic")
		item:SetPos( self:GetPos()  + self:LocalToWorld(Vector(0,0,10)))
		item:SetItem({type = self:GetEntityClass()})
		item:Spawn()

	end

end
