
if (SERVER) then

	SWEP.Weight				= 5
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false

end

if ( CLIENT ) then

	SWEP.DrawAmmo			= true
	SWEP.DrawCrosshair		= false
	SWEP.ViewModelFOV		= 82
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.PrintName			= "DC-15S"			
	SWEP.Author				= "StarLight"
	SWEP.ViewModelFOV      	= 50
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	--killicon.Add( "weapon_752_dc15s", "HUD/killicons/DC15S", Color( 255, 80, 0, 255 ) )
end

SWEP.Author			= "StarLight"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Category = "OGC CW"
SWEP.HoldType				= "ar2"
SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false


SWEP.Primary.Delay = 1
SWEP.Primary.Recoil			= 0.5
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Spread			= 0.0125
SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= 400
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "ar2"

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(-4.06, -9.219, 1.395)
SWEP.IronSightsAng = Vector(-0.454, 0.7, 0.5)

SWEP.Primary.Cone = 0.5


SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ViewModel				= "models/weapons/v_DC15S.mdl"
SWEP.WorldModel				= "models/weapons/w_DC15S.mdl"
local FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg")

function SWEP:BulletShoot()
	if self:Clip1() <= 0 then self:Reload()	return end 
	if ( !self:CanPrimaryAttack() ) then return end
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
				
	self.Weapon:EmitSound( WEAPONS[self:GetMainType()][self:GetSubType()].FireSound )

	self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone )
			
	self:TakePrimaryAmmo( 1 )
			
	if ( self.Owner:IsNPC() ) then return end

	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.1,0.1) *self.Primary.Recoil, 0 ) )
				
	if ( (game.SinglePlayer() && SERVER) || CLIENT ) then
		self.Weapon:SetNetworkedFloat( "LastShootTime", CurTime() )
	end
end

function SWEP:GunLoadOut()
	self.Primary.Damage = WEAPONS[self:GetMainType()][self:GetSubType()].Damage
	self.Primary.Recoil = WEAPONS[self:GetMainType()][self:GetSubType()].Recoil
	self.Primary.NumShots = WEAPONS[self:GetMainType()][self:GetSubType()].NumShots
	self.Primary.Cone = WEAPONS[self:GetMainType()][self:GetSubType()].Cone
	self.Primary.Delay = WEAPONS[self:GetMainType()][self:GetSubType()].Delay
end

function SWEP:SetupDataTables()

	self:NetworkVar( "String", 0, "MainType" )
	self:NetworkVar( "String", 1, "SubType" )
	self:NetworkVar( "String", 1, "WorldModel" )
	
	self:NetworkVar("Bool", 0, "Stripped")
	
	if SERVER then
		self:SetStripped(false)
		self:SetMainType("Primary")
		self:SetSubType("DC-15S")
	end

end

--[[---------------------------------------------------------
---------------------------------------------------------]]
function SWEP:Initialize()

	if ( SERVER ) then
		self:SetNPCMinBurst( 30 )
		self:SetNPCMaxBurst( 30 )
		self:SetNPCFireRate( 0.01 )
	end
	
	self:SetWeaponHoldType( self.HoldType )
	self.Weapon:SetNetworkedBool( "Ironsights", false ) 
	WEAPONS[self:GetMainType()][self:GetSubType()].LoadOut(self)
	self:SetHoldType(WEAPONS[self:GetMainType()][self:GetSubType()].holdtypes[1])
end

function SWEP:SetNewWeapon(main, sub, id)
	self:SetMainType(main)
	self:SetSubType(sub)
	self:SetHoldType(WEAPONS[self:GetMainType()][self:GetSubType()].holdtypes[1])
	self.weaponid = id	
end


function SWEP:PrimaryAttack()
	if self:GetHoldType() == "passive" then return end
	if self:GetHoldType() == "normal" then return end
	WEAPONS[self:GetMainType()][self:GetSubType()].Primary(self)
end

function SWEP:CanPrimaryAttack()
	if self.Weapon:GetNextPrimaryFire() > CurTime() then
		return false
	else
		return true
	end
end

SWEP.NextSecondaryAttack = 0
function SWEP:SecondaryAttack()
	if self:GetHoldType() == "passive" then return end
	if self:GetHoldType() == "normal" then return end
	WEAPONS[self:GetMainType()][self:GetSubType()].Secondary(self)	
end

function SWEP:CanSecondaryAttack()
	if ( self.NextSecondaryAttack > CurTime() ) then return false end
	return true
end

function SWEP:CSShootBullet( dmg, recoil, numbul, cone )
	if self.Owner:IsNPC() then
		local targ = self.Owner:GetEnemy()
		self.Owner:PointAtEntity( targ)
	end
	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01
	if SERVER then
		local ent = ents.Create("star_bullet")
		ent:SetPos(self.Owner:GetPos() + Vector(0,0,45)	)
		ent:SetAngles(self.Owner:GetAngles() + Angle(math.Rand(-cone, cone),math.Rand(-cone, cone) , 0))
		ent.Damage	= dmg
		ent:SetModel("models/props_c17/chair02a.mdl")
		ent:Spawn()
		ent:Activate()
		ent:SetOwner(self.Owner)
		ent:SetBulletColor( WEAPONS[self:GetMainType()][self:GetSubType()].Color || Vector(5,255,5) )
		ent:SetStartPos(self.Owner:GetPos() + Vector(0,0,45))
		ent:SetDamageAmount(10)
		ent:SetVelocity(ent:GetAngles():Forward() * 5000)
		local phys = ent:GetPhysicsObject()
		if ( !IsValid( phys ) ) then ent:Remove() return end

		local velocity = ent:GetAngles():Forward()
		velocity = velocity * 100000
		velocity = velocity
		phys:ApplyForceCenter( velocity )
	end
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if ( self.Owner:IsNPC() ) then return end
	
	if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles( eyeang )
	
	end

end

hook.Add("ShouldCollide", "ogc_swep_collide", function(ent1, ent2)
	if ent1:GetClass() == "star_bullet" and ent2:IsPlayer() then
		if ent2 == ent1.Owner then
			return false
		end
	elseif ent2:GetClass() == "star_bullet" and ent1:IsPlayer() then
		if ent1 == ent2.Owner then
			return false
		end
	end
	return true
end)

hook.Add("EntityTakeDamage", "ogc_swep_ent_dmg", function(target, dmg)
	if dmg:GetAttacker():GetClass() == "star_bullet" then
		if dmg:GetDamageType() == DMG_CRUSH then
			return true
		end
	end
end)

function SWEP:Think()
	if self:GetStripped() then
		self:SetHoldType("normal")
		return
	end
	if WEAPONS[self:GetMainType()][self:GetSubType()].wmodel != self.WorldModel then
		local wep = WEAPONS[self:GetMainType()][self:GetSubType()]
		self.WorldModel = WEAPONS[self:GetMainType()][self:GetSubType()].wmodel
		WEAPONS[self:GetMainType()][self:GetSubType()].LoadOut(self)
	end
	
end

function SWEP:Reload()
	if self:GetStripped() then return	end
	if (self.reloadtime || 0 ) > CurTime() then return end
	local auto = false
	if self.Primary.Automatic then auto = true  self.Primary.Automatic = false end
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:DefaultReload(ACT_RELOAD )
	self.reloadtime = CurTime() + 3
	if auto then
		self.Primary.Automatic = true
	end
end


local IRONSIGHT_TIME = 0.25

--[[---------------------------------------------------------
   Name: GetViewModelPosition
   Desc: Allows you to re-position the view model
---------------------------------------------------------]]
function SWEP:GetViewModelPosition( pos, ang )

	if ( !self.IronSightsPos ) then return pos, ang end

	local bIron = self.Weapon:GetNetworkedBool( "Ironsights" )
	
	if ( bIron != self.bLastIron ) then
	
		self.bLastIron = bIron 
		self.fIronTime = CurTime()
		
		if ( bIron ) then 
			self.SwayScale 	= 0.3
			self.BobScale 	= 0.1
		else 
			self.SwayScale 	= 1.0
			self.BobScale 	= 1.0
		end
	
	end
	
	local fIronTime = self.fIronTime or 0

	if ( !bIron && fIronTime < CurTime() - IRONSIGHT_TIME ) then 
		return pos, ang 
	end
	
	local Mul = 1.0
	
	if ( fIronTime > CurTime() - IRONSIGHT_TIME ) then
	
		Mul = math.Clamp( (CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1 )
		
		if (!bIron) then Mul = 1 - Mul end
	
	end

	local Offset	= self.IronSightsPos
	
	if ( self.IronSightsAng ) then
	
		ang = ang * 1
		ang:RotateAroundAxis( ang:Right(), 		self.IronSightsAng.x * Mul )
		ang:RotateAroundAxis( ang:Up(), 		self.IronSightsAng.y * Mul )
		ang:RotateAroundAxis( ang:Forward(), 	self.IronSightsAng.z * Mul )
	
	
	end
	
	local Right 	= ang:Right()
	local Up 		= ang:Up()
	local Forward 	= ang:Forward()
	
	

	pos = pos + Offset.x * Right * Mul
	pos = pos + Offset.y * Forward * Mul
	pos = pos + Offset.z * Up * Mul

	return pos, ang
	
end

--[[---------------------------------------------------------
	SetIronsights
---------------------------------------------------------]]
function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )

end



/*---------------------------------------------------------
	DrawHUD
	
	Just a rough mock up showing how to draw your own crosshair.
	
---------------------------------------------------------*/

function SWEP:DrawHUD()
	self.PrintName = WEAPONS[self:GetMainType()][self:GetSubType()].name
	self.Author			= ""
	self.Contact		= ""
	self.Purpose		= ""
	self.Instructions	= ""
	self.WorldModel = WEAPONS[self:GetMainType()][self:GetSubType()].wmodel
end

function SWEP:DrawWorldModel()
	self.WorldModel = WEAPONS[self:GetMainType()][self:GetSubType()].wmodel
	if self:GetStripped() then
	local pos = self.Owner:GetPos()
	render.SetMaterial(Material("starcolor"))
	local height = 75
	if self.Owner:Crouching() then height = 60 end
	--render.DrawQuadEasy( pos + Vector( 0, 30, height/2 ), Vector( 0, 1, 0 ), 60, height, Color( 0, 0, 255, 100 + (math.Rand(0,155)) ), 0 )
	--render.DrawQuadEasy( pos + Vector( 0, -30, height/2 ), Vector( 0, 1, 0 ), 60, height, Color( 0, 0, 255, 100 + (math.Rand(0,155)) ), 0 )
	--render.DrawQuadEasy( pos + Vector( 30, 0, height/2 ), Vector( 1, 0, 0 ), 60, height, Color( 0, 0, 255, 100 + (math.Rand(0,155)) ), 0 )
	--render.DrawQuadEasy( pos + Vector( -30, 0, height/2 ), Vector( 1, 0, 0 ), 60, height, Color( 0, 0, 255, 100 + (math.Rand(0,155)) ), 0 )
	--render.DrawQuadEasy( pos + Vector( 0, 0, height ), Vector( 0, 0, 1 ), 60, 60, Color( 0, 0, 255, 100 + (math.Rand(0,155)) ), 0 )
	--render.DrawQuadEasy( pos + Vector( 0, 0, 0 ), Vector( 0, 0, 1 ), 60, 60, Color( 0, 0, 255, 100 + (math.Rand(0,155)) ), 0 )
	render.DrawSphere( pos + Vector(0,0, height/2), 40, 20, 20, Color( 0, 0, 255, 100))
	return end
	
	if WEAPONS[self:GetMainType()][self:GetSubType()].DrawModel then
		WEAPONS[self:GetMainType()][self:GetSubType()].DrawModel(self)
		return
	end
	
	
	self:DrawModel()
end


/*---------------------------------------------------------
	onRestore
	Loaded a saved game (or changelevel)
---------------------------------------------------------*/
function SWEP:OnRestore()

	self.NextSecondaryAttack = 0
	self:SetIronsights( false )
	
end

function SWEP:DoImpactEffect( tr, dmgtype )
	if( tr.HitSky ) then return true; end
	
	util.Decal( "fadingscorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
	
	if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then

		local effect = EffectData();
		effect:SetOrigin( tr.HitPos );
		effect:SetNormal( tr.HitNormal );

		util.Effect( "effect_sw_impact", effect );

		local effect = EffectData();
		effect:SetOrigin( tr.HitPos );
		effect:SetStart( tr.StartPos );
		effect:SetDamageType( dmgtype );

		util.Effect( "RagdollImpact", effect );
	end

    return true;
end
