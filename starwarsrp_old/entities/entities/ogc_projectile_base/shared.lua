
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= ""
ENT.Author			= "Star"
ENT.Purpose			= "Stuff"

function ENT:SetupDataTables()
end


function ENT:Draw()
	self:DrawModel()
end

function ENT:PhysicsCollide( data, phys )
	if ( data.Speed > 50 ) then self:EmitSound( Sound( "Flashbang.Bounce" ) ) end
end
