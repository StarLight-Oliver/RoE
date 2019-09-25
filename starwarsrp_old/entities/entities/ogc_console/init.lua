AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/kingpommes/venator/corner_console.mdl" )
	self:DrawShadow(true)
	--self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/citadel_hub_ambience1.mp3" )
	--self.BuildingSound:Play()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType( SIMPLE_USE )
	
	self:SetCollisionGroup( COLLISION_GROUP_NONE )	

end

util.AddNetworkString("ogbuntu_open")

function ENT:Use( ply )
--	if ply.Char.faction == "AHHH"then
	ply.InConsole = true
	ply:ChatPrint("fuck")
	net.Start("ogbuntu_open")
		net.WriteString(" ")
	net.Send(ply)
--	end
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

