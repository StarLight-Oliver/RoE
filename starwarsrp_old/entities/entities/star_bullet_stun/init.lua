AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
local bo,ao = Vector(-1,-1,-1),Vector(1,1,1)
function ENT:Initialize()
	self:DrawShadow(false)
	self:SetModel("models/props_c17/chair02a.mdl")	
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:PhysicsInitBox(bo,ao)
		local phys = self:GetPhysicsObject()
	if phys then
		phys:Wake()
		phys:EnableGravity( false )
	end
	self:SetCustomCollisionCheck( true )
	self:CollisionRulesChanged()
	self.Entity:SetVelocity(self.Entity:GetAngles():Forward() * 5000)
end

function ENT:PhysicsCollide( data, phys )
	util.Decal( "fadingscorch", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal );

	local effect = EffectData()
	effect:SetOrigin(data.HitPos  )
	effect:SetStart( self:GetStartPos() )
	effect:SetDamageType( DMG_BULLET )

	util.Effect( "RagdollImpact", effect )
	self:Remove()
	
	if data.HitEntity then
		local d = DamageInfo()
		d:SetDamage( self:GetDamageAmount() )
		d:SetAttacker( self.Owner || self )
		d:SetDamageType( DMG_BULLET )
		if data.HitEntity.ID then
			data.HitEntity.Healt = math.Clamp(data.HitEntity.Healt - 1, 0, 100)
		else
			data.HitEntity:TakeDamageInfo( d )
			if data.HitEntity:IsPlayer() then
				data.HitEntity:Freeze(true)
				timer.Create("stun_effect" .. data.HitEntity:EntIndex(), 10,  1, function()
					data.HitEntity:Freeze(false)
				end)
			end
		end
	end
	
	
	
end


function ENT:Think()
	if !IsValid(self.Owner) then
		self:Remove()
	end
	if !self.vel then
		self.vel = 100
	end
	self.livetime = (self.livetime || 0) + 1
	if self.livetime > 1320 then self:Remove() end
	
	local phys = self:GetPhysicsObject()
		if ( !IsValid( phys ) ) then self:Remove() return end

		local velocity = self:GetAngles():Forward()
		velocity = velocity * self.vel
		velocity = velocity
		phys:ApplyForceCenter( velocity )
end