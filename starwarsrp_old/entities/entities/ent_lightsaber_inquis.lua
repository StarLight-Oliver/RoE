
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Inquisitor Saber"
ENT.Category = "Robotboy655's Entities"

ENT.Editable = true
ENT.Spawnable = true

ENT.RenderGroup = RENDERGROUP_BOTH

-- --------------------------------------------------------- Initialization --------------------------------------------------------- --

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "BladeLength" )
	self:NetworkVar( "Float", 1, "BladeWidth", { KeyName = "BladeWidth", Edit = { type = "Float", category = "Blade", min = 2, max = 4, order = 1 } } )
	self:NetworkVar( "Float", 2, "MaxLength", { KeyName = "MaxLength", Edit = { type = "Float", category = "Blade", min = 32, max = 64, order = 2 } } )

	self:NetworkVar( "Bool", 0, "Enabled" )
	self:NetworkVar( "Bool", 1, "Stable", { KeyName = "DarkInner", Edit = { type = "Boolean", category = "Blade", order = 3 } } )

	self:NetworkVar( "String", 0, "CrystalColor")

	if ( SERVER ) then
		self:SetBladeLength( 42 )
		self:SetBladeWidth( 2 )
		self:SetMaxLength( 42 )

		self:SetStable( true )
		self:SetEnabled( false )
		self:SetCrystalColor("Red")
		self:NetworkVarNotify( "Enabled", self.OnEnabledOrDisabldd )
	end
end

function ENT:Initialize()
	self.dietime = CurTime() + 10
	if ( SERVER ) then
		self:PhysicsInit( SOLID_NONE )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_NONE )

		self.LoopSound ="lightsaber/saber_loop" .. math.random( 1, 8 ) .. ".wav"
		self.SwingSound =  "lightsaber/saber_swing" .. math.random( 1, 2 ) .. ".wav"
		self.OnSound = "lightsaber/saber_on" .. math.random( 1, 2 ) .. ".wav"
		self.OffSound = "lightsaber/saber_off" .. math.random( 1, 2 ) .. ".wav"

		--self:OnEnabled()
	else
		self:SetRenderBounds( Vector( -self:GetBladeLength(), -128, -128 ), Vector( self:GetBladeLength(), 128, 128 ) )

		language.Add( self.ClassName, self.PrintName )
	end
end

-- --------------------------------------------------------- Enable / Disable --------------------------------------------------------- --

function ENT:OnEnabled()
	if ( CLIENT ) then return end
	if ( self:WaterLevel() > 2) then return end

	self:EmitSound( self.OnSound )

	self.SoundLoop = CreateSound( self, Sound( self.LoopSound ) )
	if ( self.SoundLoop ) then self.SoundLoop:Play() end

	self.SoundSwing = CreateSound( self, Sound( self.SwingSound ) )
	if ( self.SoundSwing ) then self.SoundSwing:Play() self.SoundSwing:ChangeVolume( 0, 0 ) end

	self.SoundHit = CreateSound( self, Sound( "lightsaber/saber_hit.wav" ) )
	if ( self.SoundHit ) then self.SoundHit:Play() self.SoundHit:ChangeVolume( 0, 0 ) end
end

function ENT:OnDisabled( bRemove )
	if ( CLIENT ) then
		return
	end

	self:EmitSound( self.OffSound )

	if ( self.SoundLoop ) then self.SoundLoop:Stop() self.SoundLoop = nil end
	if ( self.SoundSwing ) then self.SoundSwing:Stop() self.SoundSwing = nil end
	if ( self.SoundHit ) then self.SoundHit:Stop() self.SoundHit = nil end
end

function ENT:OnEnabledOrDisabldd( name, old, new )

	if ( old == new ) then return end

	if ( new ) then
		self:OnEnabled()
	else
		self:OnDisabled()
	end
end

function ENT:OnRemove()
	self:OnDisabled( true )
end

-- --------------------------------------------------------- Misc --------------------------------------------------------- --

function ENT:GetSaberPosAng( num, side )
	num = num || 1

	local attachment = self:LookupAttachment( "blade" .. num )
	if ( side ) then
		attachment = self:LookupAttachment( "quillon" .. num )
	end

	if ( attachment > 0 ) then
		local PosAng = self:GetAttachment( attachment )

		return PosAng.Pos, PosAng.Ang:Forward()
	end

	return self:LocalToWorld( Vector( 1, -0.58, -0.25 ) ), -self:GetAngles():Forward()

end
local HardLaserTrail = Material( "lightsaber/hard_light_trail" )
local HardLaserTrailInner = Material( "lightsaber/hard_light_trail_inner" )

function ENT:Draw()

	--render.SetColorModulation( 1, 1, 1 )
	self:DrawModel()
	if ( halo.RenderedEntity && IsValid( halo.RenderedEntity() ) && halo.RenderedEntity() == self ) then return end
	local pos = self:GetPos()
	local pos, dir = self:GetSaberPosAng(1)
	OGC_RenderBlade( pos, dir, 42, 42, 2, self:GetCrystalColor(), self:EntIndex() + 512,self.Owner:WaterLevel() > 2, !self:GetStable() )
	local pos, dir = self:GetSaberPosAng(2)
	OGC_RenderBlade( pos, dir, 42, 42, 2, self:GetCrystalColor(), self:EntIndex() + 512*2,self.Owner:WaterLevel() > 2, !self:GetStable() )
end

function ENT:OnTakeDamage( dmginfo )

	-- React physically when shot/getting blown
	self:TakePhysicsDamage( dmginfo )

end

function ENT:Think()
	if self:GetOwner():GetActiveWeapon():GetWorldModel() != "models/star/venator/inqusitor_saber.mdl" then
		if SERVER then
			self:Remove()
		end
	end
	if SERVER then
		self:SetSequence(self:LookupSequence("spin"))
		self:SetCycle( (CurTime() * 2 ) % 360)
	else
		self:SetSequence(self:LookupSequence("spin"))
		self:SetCycle( (CurTime() * 4 ) % 360)
	end

	if ( !self:GetEnabled() && self:GetBladeLength() != 0 ) then
		self:SetBladeLength( math.Approach( self:GetBladeLength(), 0, 2 ) )
	elseif ( self:GetEnabled() && self:GetBladeLength() != self:GetMaxLength() ) then
		self:SetBladeLength( math.Approach( self:GetBladeLength(), self:GetMaxLength(), 8 ) )
	end

	if self.dietime < CurTime() then
		if SERVER then
		self:Remove()
		self:GetOwner():DrawWorldModel(true)
		end
	end

	self:SetEnabled(true)
	local attachment = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand")
	if ( attachment > 0 ) then
		local pos, ang = self:GetBonePosition(attachment)
		local matrix = self.Owner:GetBoneMatrix( attachment)
		if ( matrix ) then
				pos = matrix:GetTranslation()
				ang = matrix:GetAngles()
		end
		
		ang:RotateAroundAxis( ang:Forward(), 180 )
		ang:RotateAroundAxis( ang:Up(), 30 )
		ang:RotateAroundAxis( ang:Forward(), -5.7 )
		ang:RotateAroundAxis( ang:Right(), 92 )

		--pos = pos + ang:Up() * -3.3 + ang:Right() * 0.8 + ang:Forward() * 5.6
		
		
		
		self:SetPos(pos)
		self:SetAngles(ang)
	end
	
	if ( self:GetBladeLength() <= 0 ) then
		if ( self.SoundSwing ) then self.SoundSwing:ChangeVolume( 0, 0 ) end
		if ( self.SoundLoop ) then self.SoundLoop:ChangeVolume( 0, 0 ) end
		if ( self.SoundHit ) then self.SoundHit:ChangeVolume( 0, 0 ) end
		return
	end
	if CLIENT then return end
	local pos, ang = self:GetSaberPosAng()
	local hit = self:BladeThink( pos, ang )
	if ( self:LookupAttachment( "blade2" ) > 0 ) then
		local pos2, ang2 = self:GetSaberPosAng( 2 )
		local hit_2 = self:BladeThink( pos2, ang2 )
		hit = hit || hit_2
	end

	if ( self.SoundHit ) then
		if ( hit ) then self.SoundHit:ChangeVolume( math.Rand( 0.1, 0.5 ), 0 ) else self.SoundHit:ChangeVolume( 0, 0 ) end
	end

	if ( self.SoundSwing ) then
		local ang = self:GetAngles()
		if ( self.LastAng != ang ) then
			self.LastAng = self.LastAng || ang
			self.SoundSwing:ChangeVolume( 1, 0 )
			--self.SoundSwing:ChangeVolume( math.Rand( 0, 1 ), 0 ) -- For some reason if I spam always 1, the sound doesn't loop
			--self.SoundSwing:ChangeVolume( math.min( pos:Distance( self.LastPos ) / 16, 1 ), 0 )
		end
		self.LastAng = ang
	end

	if ( self.SoundLoop ) then
		local pos = pos + ang * self:GetBladeLength()
		if ( self.LastPos != pos ) then
			self.LastPos = self.LastPos || pos
			self.SoundLoop:ChangeVolume( 0.1 + math.Clamp( pos:Distance( self.LastPos ) / 32, 0, 0.2 ), 0 )
			--self.SoundLoop:ChangeVolume( 0.1 + math.Clamp( pos:Distance( self.LastPos ) / 32, 0, 0.2 ), 0 )
			--self.SoundLoop:ChangeVolume( 1 - math.min( pos:Distance( self.LastPos ) / 16, 1 ), 0 )
			--self.SoundLoop:ChangeVolume( self:GetBladeLength() / self:GetMaxLength(), 0 )
		end
		self.LastPos = pos
	end
	
	
	
	
	self:NextThink( CurTime() )
	return true
end

function ENT:BladeThink( startpos, dir )
	local trace = util.TraceHull( {
		start = startpos,
		endpos = startpos + dir * self:GetBladeLength(),
		filter = {self, self.Owner},
		--[[mins = Vector( -1, -1, -1 ) * self:GetBladeWidth() / 2,
		maxs = Vector( 1, 1, 1 ) * self:GetBladeWidth() / 2]]
	} )

	if ( trace.Hit ) then
		rb655_LS_DoDamage( trace, self )
	end

	return trace.Hit
end

function ENT:Use( activator, caller, useType, value )
	if ( !IsValid( activator ) || !activator:KeyPressed( IN_USE ) ) then return end
	if ( self:WaterLevel() > 2 && !self:GetWorksUnderwater() ) then return end

	--[[if ( self:GetEnabled() ) then
		self:EmitSound( self.OffSound )
	else
		self:EmitSound( self.OnSound )
	end]]

	self:SetEnabled( !self:GetEnabled() )
end

function ENT:SpawnFunction( ply, tr )
	if ( !tr.Hit || !ply:CheckLimit( "ent_lightsabers" ) ) then return end

	local ent = ents.Create( ClassName )
	ent:SetPos( tr.HitPos + tr.HitNormal * 2 )

	local ang = ply:EyeAngles()
	ang.p = 0
	ang:RotateAroundAxis( ang:Right(), 180 )
	ent:SetAngles( ang )

	-- Sync values from the tool
	ent:SetMaxLength( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladel", 42 ), 32, 64 ) )
	ent:SetCrystalColor( Vector( ply:GetInfo( "rb655_lightsaber_red" ), ply:GetInfo( "rb655_lightsaber_green" ), ply:GetInfo( "rb655_lightsaber_blue" ) ) / 255 )
	ent:SetDarkInner( ply:GetInfo( "rb655_lightsaber_dark" ) == "1" )
	ent:SetModel( ply:GetInfo( "rb655_lightsaber_model" ) )
	ent:SetBladeWidth( math.Clamp( ply:GetInfoNum( "rb655_lightsaber_bladew", 2 ), 2, 4 ) )

	ent.LoopSound = ply:GetInfo( "rb655_lightsaber_humsound" )
	ent.SwingSound = ply:GetInfo( "rb655_lightsaber_swingsound" )
	ent.OnSound = ply:GetInfo( "rb655_lightsaber_onsound" )
	ent.OffSound = ply:GetInfo( "rb655_lightsaber_offsound" )

	ent:Spawn()
	ent:Activate()

	ent.Owner = ply
	ent.Color = ent:GetColor()

	local phys = ent:GetPhysicsObject()
	if ( IsValid( phys ) ) then phys:Wake() end

	if ( IsValid( ply ) ) then
		ply:AddCount( "ent_lightsabers", ent )
		ply:AddCleanup( "ent_lightsabers", ent )
	end

	return ent
end
