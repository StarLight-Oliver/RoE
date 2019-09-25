AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/hunter/blocks/cube2x2x2.mdl" )
	self:DrawShadow(false)

	self.Entity:SetMoveType( MOVETYPE_NONE )

	
	self:SetCollisionGroup( COLLISION_GROUP_NONE )	

end



function ENT:OnTakeDamage(dmginfo)
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

