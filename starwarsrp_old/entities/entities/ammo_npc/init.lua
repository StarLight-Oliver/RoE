AddCSLuaFile("cl_init.lua") 
AddCSLuaFile("shared.lua")

include("shared.lua") 

function ENT:Initialize( ) 
	
	self:SetModel( "models/reizer_cgi_p2/clone_jet/clone_jet.mdl" )
	self:SetHullType( HULL_HUMAN ) 
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
		
		local mon = caller:GetMoney()
		local val = 10
		if val < tonumber(mon) then
			local ply = caller
			ply:SLChatMessage({Color(160,194,32), "[Store] ", color_white, "You have bought 100 ammo"})
		    ply:TakeMoney(val)
		    ply:GiveAmmo(100, "AR2", false)
		end

	end

end