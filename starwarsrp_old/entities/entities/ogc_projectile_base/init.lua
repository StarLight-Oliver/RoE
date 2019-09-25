
AddCSLuaFile( "shared.lua" )

include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( self.Model || "models/starwars/syphadias/props/sw_tor/bioware_ea/items/harvesting/slicing/slicing_footlocker_dial.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType( SIMPLE_USE )

	self:PhysWake()

	local phys = self:GetPhysicsObject()
	phys:SetMass(100)

	self.CD = CurTime()+1
end

function ENT:Think()
	self:OnTick()

	if (!self.CD or self.CD < CurTime()) then
		self:OnExplode()
		self:Remove()
	end

	return CurTime()+0.1
end

function ENT:SetTimer(timer)
	self.CD = CurTime()+timer
end


//Overridables
function ENT:OnExplode()
end

function ENT:OnTick()
end
