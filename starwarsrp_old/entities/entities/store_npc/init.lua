AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua")

include("shared.lua") 

function ENT:Initialize( ) 
	
	self:SetModel( "models/starwars/syphadias/props/sw_tor/bioware_ea/props/vendor/vendor_weapon_stall_wo_flag.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	
	self:SetMaxYawSpeed( 90 ) 
end

function ENT:OnTakeDamage()
	return false 
end 

function ENT:AcceptInput( name, activator, caller )	

	if name == "Use" and caller:IsPlayer() then
		
		caller:ConCommand("store_panel")

	end

end