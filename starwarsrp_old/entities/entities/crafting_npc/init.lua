AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua")

include("shared.lua") 

function ENT:Initialize( ) 
	
	self:SetModel( "models/starwars/syphadias/props/sw_tor/bioware_ea/props/city/city_market_stand_01.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
end

function ENT:OnTakeDamage()
	return false 
end 

function ENT:AcceptInput( name, activator, caller )	

	if name == "Use" and caller:IsPlayer() then
		
		caller:ConCommand("crafting_panel")

	end

end