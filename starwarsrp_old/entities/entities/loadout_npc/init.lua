AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua")

include("shared.lua") 

function ENT:Initialize( ) 
	
	self:SetModel( "models/reizer_cgi_p2/clone_jet/clone_jet.mdl" )
	self:SetHullType( HULL_HUMAN )  -- ??
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	
	self:SetMaxYawSpeed( 90 ) 
end

function ENT:Think()

	local anim = "idle_all_01"
	self:ResetSequence(anim)
	local sequence = self:LookupSequence( anim)
	self:SetSequence( sequence )

end

function ENT:OnTakeDamage()
	return false 
end 

function ENT:AcceptInput( name, activator, caller )	

	if name == "Use" and caller:IsPlayer() then
	    local ply = caller
		local fac = FACTIONS[ply.Char.faction]
		local stats = fac.Ranks[fac.RankID[ply.Char.rank]]
		ply:SetMaxHealth(stats.Health)
		
	end

end