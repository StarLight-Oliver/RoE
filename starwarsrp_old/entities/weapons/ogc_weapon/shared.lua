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

SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"

SWEP.IronSightsPos = Vector(-4.06, -9.219, 1.395)
SWEP.IronSightsAng = Vector(-0.454, 0.7, 0.5)

SWEP.Primary.Cone = 0.5


SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ViewModel				= "models/weapons/c_medkit.mdl"
SWEP.WorldModel				= "models/weapons/w_DC15S.mdl"
local FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg")

function SWEP:BulletShoot(stun)
	if self:Clip1() <= 0 then self:Reload()	return end 
	if ( !self:CanPrimaryAttack() ) then return end
	self.Weapon:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
				
	self.Weapon:EmitSound( WEAPONS[self:GetMainType()][self:GetSubType()].FireSound )
    self.Owner:LagCompensation(true)
	    self:CSShootBullet( self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self.Primary.Cone, stun )
	self.Owner:LagCompensation(false)		
	self:TakePrimaryAmmo( 1 )
			
	if ( self.Owner:IsNPC() ) then return end

	self.Owner:ViewPunch( Angle( math.Rand(-0.2,-0.1) * self.Primary.Recoil, math.Rand(-0.01,0.01) *self.Primary.Recoil, 0 ) )
				
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
	self.bulletcol = WEAPONS[self:GetMainType()][self:GetSubType()].Color
end

function SWEP:SetupDataTables()

	self:NetworkVar( "String", 0, "MainType" )
	self:NetworkVar( "String", 1, "SubType" )
	self:NetworkVar( "String", 2, "WorldModel" )
	
	self:NetworkVar("Bool", 0, "Stripped")
	self:NetworkVar("Vector", 0, "SpecialPos")
	
	if SERVER then
		self:SetStripped(false)
		self:SetWorldModel("models/weapons/w_dc15sa.mdl")
		self:SetMainType("Fists")
		self:SetSubType("Fists")
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
	self:SetNoDraw(false)
	self:SetMainType(main)
	self:SetSubType(sub)
	self:SetHoldType(WEAPONS[self:GetMainType()][self:GetSubType()].holdtypes[1])
	self.weaponid = id	
	
	self:SetWorldModel(WEAPONS[self:GetMainType()][self:GetSubType()].wmodel)
	--self:SetWorldModel( WEAPONS[self:GetMainType()][self:GetSubType()].wmodel
	WEAPONS[self:GetMainType()][self:GetSubType()].LoadOut(self)
	timer.Simple(0.1, function()
	if id then
		net.Start("loadout_swep")
			net.WriteEntity(self)
			net.WriteString(id || "")
			net.WriteTable(GetItemByID(id)[1])
		net.Send(self.Owner)
	end

	self.WorldModel = self:GetWorldModel()


	end)
	self.Weapon:SetNetworkedBool( "Ironsights", false )
end

if CLIENT then

	local IDTBL = {}

	function GetItemByID(id)
		return { IDTBL[id]}
	end

	net.Receive("loadout_swep", function()
		self = net.ReadEntity()
		self.weaponid = net.ReadString()
		IDTBL[self.weaponid] = net.ReadTable()

		WEAPONS[self:GetMainType()][self:GetSubType()].LoadOut(self)
	end)
else
	util.AddNetworkString("loadout_swep")
end


function SWEP:PrimaryAttack()
	if self:GetHoldType() == "passive" then return end
	if self:GetHoldType() == "normal" then return end
	if IsValid(self.Owner.CurrentShip) then return end
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
	if !self:CanSecondaryAttack() then return end
	if self:GetHoldType() == "passive" then return end
	if self:GetHoldType() == "normal" then return end
	if IsValid(self.Owner.CurrentShip) then return end
	WEAPONS[self:GetMainType()][self:GetSubType()].Secondary(self)	
end

function SWEP:CanSecondaryAttack()
	if ( self.NextSecondaryAttack > CurTime() ) then return false end
	return true
end

function SWEP:CSShootBullet( dmg, recoil, numbul, cone, stun )
    
	numbul 	= numbul 	or 1
	cone 	= cone 		or 0.01
	if stun then
	    if SERVER then
		    local str = "star_bullet"
		    if stun then str = "star_bullet_stun" end
	
		    if self.Weapon:GetNetworkedBool( "Ironsights", false ) then
		    	cone = cone / 2
		    end
	
		    local ent = ents.Create(str)
		    local vect,ang = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
		    local pos = vect		
		
		    ent:SetPos(pos)

		    ent:SetAngles(self.Owner:EyeAngles() + Angle(math.Rand(-cone, cone),math.Rand(-cone, cone) , 0))
	    	ent.Damage	= dmg
		    ent:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	    	ent:SetCustomCollisionCheck( true )
	    	ent:Spawn()
		    ent:Activate()
	    	ent:SetOwner(self.Owner)
	    	ent:SetBulletColor( self.bulletcol || Vector(5,255,5) )
	    	ent:SetStartPos(pos)
	    	ent:SetDamageAmount(self.Primary.Damage ||10)
	    	ent:SetVelocity(ent:GetAngles():Forward() * 5000)
	    	ent.vel = 100000
	    	local phys = ent:GetPhysicsObject()
	    	if ( !IsValid( phys ) ) then ent:Remove() return end

		    local velocity = ent:GetAngles():Forward()
		    velocity = velocity * 100000
		    velocity = velocity
		    phys:ApplyForceCenter( velocity )
    	end
else
         if self.Weapon:GetNetworkedBool( "Ironsights", false ) then
		    	cone = cone / 2
		    end
    
    	local bullet = {}
    	bullet.Num 	= num
	    bullet.Src 	= self.Owner:GetShootPos()
	    bullet.Dir 	= self.Owner:GetAimVector()
	    bullet.Spread 	= Vector( cone/16, cone/16, 0 )
	    bullet.Tracer	= 1
	    bullet.TracerName = "msw_laser"
    	bullet.Force	= 1
	    bullet.Damage	= self.Primary.Damage ||10

	    self.Owner:FireBullets( bullet )

	    self:ShootEffects()
    end

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	if ( self.Owner:IsNPC() ) then return end
	
	if ( (game.SinglePlayer() && SERVER) || ( !game.SinglePlayer() && CLIENT && IsFirstTimePredicted() ) ) then
	
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - (recoil/2)
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
if (self.Drag and (!self.Owner:KeyDown(IN_ATTACK2) or !IsValid(self.Drag.Entity))) then
		self.Drag = nil
	end
	if self:GetStripped() then
		self:SetHoldType("normal")
		return
	end	
end

function SWEP:Reload()
	if self:GetStripped() then return	end
	if self.Owner:KeyDown( IN_USE ) and (self.holtypechange || 0) < CurTime() then
		local hold = self:GetHoldType()
		local types = WEAPONS[self:GetMainType()][self:GetSubType()].holdtypes
		local index = 0
		for x,y in pairs(types) do
			if y  == hold then
				index = x
			end
		end
		if index == #types then
			index = 0
		end
		index = index + 1
		self:SetHoldType(types[index])
		self.holtypechange = CurTime() + 0.5
		self.reloadtime = CurTime() + 0.6
		return
	end
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
	SetIronsights
---------------------------------------------------------]]
function SWEP:SetIronsights( b )

	self.Weapon:SetNetworkedBool( "Ironsights", b )
	self.NextSecondaryAttack = CurTime() + 10
end



/*---------------------------------------------------------
	DrawHUD
	
	Just a rough mock up showing how to draw your own crosshair.
	
---------------------------------------------------------*/

local x,y = ScrW()/2,ScrH()/2

	local ColWhite = Color(255,255,255)
	local Col = Color(255,255,255)
	local Colt = Color(255,255,255,100)


function SWEP:DrawHUD()
	self.PrintName = WEAPONS[self:GetMainType()][self:GetSubType()].name
	self.Author			= ""
	self.Contact		= ""
	self.Purpose		= ""
	self.Instructions	= ""

	local tbl = WEAPONS[self:GetMainType()][self:GetSubType()]
		
	if self:GetMainType() == "Primary" or self:GetMainType() == "Secondary" then

		if !self.bulletcol then return end
		local prim = self.Primary
		draw.SimpleText(tbl.name,"Trebuchet24",  90, ScrH()/2 - 90, Color(self.bulletcol.x,self.bulletcol.y, self.bulletcol.z))

		draw.SimpleText("Accuracy: " .. (prim.Cone * 100), "Trebuchet18",  100, ScrH()/2 - 65)
		draw.SimpleText("Recoil: " .. (prim.Recoil * 10), "Trebuchet18",  100, ScrH()/2 - 50)
		draw.SimpleText("Damage: " .. prim.Damage, "Trebuchet18",  100, ScrH()/2 - 35)
		draw.SimpleText("Delay: " .. (prim.Delay * 1), "Trebuchet18",  100, ScrH()/2 - 20)


	else
		draw.SimpleText(tbl.name,"Trebuchet24",  90, ScrH()/2 - 90, Color(200,200,200))


	end
 
 local Pos = self.Owner:GetShootPos()
		local Aim = self.Owner:GetAimVector()
		
		local Tr = util.TraceLine({
			start = Pos,
			endpos = Pos+Aim*64,
			filter = player.GetAll(),
		})
		
		local HitEnt = Tr.Entity
		
		if (IsValid(HitEnt) and HitEnt:GetMoveType() == MOVETYPE_VPHYSICS and !self.Drag and !HitEnt:IsVehicle()) then
			self.Time = math.min(1,self.Time || 0+2*FrameTime())
		else
			self.Time = math.max(0,self.Time || 0-2*FrameTime())
		end
		
		if (self.Time > 0) then	
			Col.a = ColWhite.a*self.Time
			
			//DrawText("Drag","SRP_Font32",x,y,Col,1)
		end
		
		if (self.Drag and IsValid(self.Drag.Entity)) then
			local Pos2 		= Pos + Aim*100*self.Drag.Fraction
			local OffPos 	= self.Drag.Entity:LocalToWorld(self.Drag.OffPos)
			local Dif 		= Pos2-OffPos
			
			local A = OffPos:ToScreen()
			local B = Pos2:ToScreen()
			
			
			surface.DrawRect(A.x-2,A.y-2,4,4,ColWhite)
			surface.DrawRect(B.x-2,B.y-2,4,4,ColWhite)
			
			surface.DrawLine(A.x,A.y,B.x,B.y,Colt)
		end
end

function SWEP:DrawWorldModel()

	self.WorldModel = self:GetWorldModel() || WEAPONS[self:GetMainType()][self:GetSubType()].wmodel
	

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



function SWEP:DoImpactEffect( tr, dmgtype )
	if( tr.HitSky ) then return true; end
	
	util.Decal( "fadingscorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal );
	
	if( game.SinglePlayer() or SERVER or not self:IsCarriedByLocalPlayer() or IsFirstTimePredicted() ) then

	--	util.Effect( "effect_sw_impact", effect );

		local effect = EffectData();
		effect:SetOrigin( tr.HitPos );
		effect:SetStart( tr.StartPos );
		effect:SetDamageType( dmgtype );

		util.Effect( "RagdollImpact", effect );
	end

    if SERVER then
        	if tr.HitEntity then

		if tr.HitEntity:GetClass() == "shooting_range" then

			data.HitEntity:GetTarget().score = data.HitEntity:GetTarget().score + math.Clamp(50- data.HitPos:Distance(data.HitEntity:GetPos()), 1, 50 )
			data.HitEntity:GetTarget():EmitSound(soundhit)
			return
		end

		if tr.HitEntity.ID then
			tr.HitEntity.Healt = math.Clamp(tr.HitEntity.Healt - 1, 0, 100)
		end
    end  
    end


    return true;
end