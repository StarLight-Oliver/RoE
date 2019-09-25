AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
local bo,ao = Vector(-1,-1,-1),Vector(1,1,1)
function ENT:Initialize()
	self:SetCustomCollisionCheck( true )
	self:DrawShadow(false)
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")	
	self:SetSolid( SOLID_NONE )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid( SOLID_VPHYSICS )
	self:PhysicsInitBox(bo,ao)
		local phys = self:GetPhysicsObject()
	if phys then
		phys:Wake()
		phys:EnableGravity( false )
	end
	
	--self:CollisionRulesChanged()
	self:SetVelocity(self:GetAngles():Forward() * 5000)
end
local soundhit = Sound("needhealth.mp3")
function ENT:PhysicsCollide( data, phys )
	util.Decal( "fadingscorch", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal );
	local effect = EffectData();
	effect:SetOrigin( data.HitPos)
	effect:SetNormal( data.HitNormal )

	--util.Effect( "effect_sw_impact", effect )

	local effect = EffectData()
	effect:SetOrigin(data.HitPos  )
	effect:SetStart( self:GetStartPos() )
	effect:SetDamageType( DMG_BULLET )

	util.Effect( "RagdollImpact", effect )
	self:Remove()
	
	if data.HitEntity then

		if data.HitEntity:GetClass() == "shooting_range" then

			data.HitEntity:GetTarget().score = data.HitEntity:GetTarget().score + math.Clamp(50- data.HitPos:Distance(data.HitEntity:GetPos()), 1, 50 )
			data.HitEntity:GetTarget():EmitSound(soundhit)
			return
		end

		local d = DamageInfo()
		d:SetDamage( self:GetDamageAmount() )
		d:SetAttacker( self.Owner || self )
		d:SetDamageType( DMG_BULLET )
		if data.HitEntity.ID then
			data.HitEntity.Healt = math.Clamp(data.HitEntity.Healt - 1, 0, 100)
		else
			data.HitEntity:TakeDamageInfo( d )
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
	if (self.NextForce || 0 ) < CurTime()	then
	local phys = self:GetPhysicsObject()
		if ( !IsValid( phys ) ) then self:Remove() return end

		local velocity = self:GetAngles():Forward()
		velocity = velocity * self.vel
		velocity = velocity
		phys:ApplyForceCenter( velocity )
		self.NextForce = CurTime()
	end
end