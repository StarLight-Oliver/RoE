ITEMS = ITEMS || {}
DROPITEMS = DROPITEMS || {}
CRAFTING = CRAFTING || {}
BUYITEMS = BUYITEMS || {}
local SwingSound = Sound( "WeaponFrag.Throw" )
local HitSound = Sound( "Flesh.ImpactHard" )
local damageattack = function(self)
	local hitdistance = 48
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * hitdistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * hitdistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( tr.Hit && !( game.SinglePlayer() && CLIENT ) ) then
		self:EmitSound( HitSound )
	end

	local hit = false

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( math.random( 8, 12 ) )
		dmginfo:SetDamageForce( self.Owner:GetRight() * -4912 + self.Owner:GetForward() * 9989 )
		tr.Entity:TakeDamageInfo( dmginfo )
		hit = true

	end

end




WEAPONS =  { ["Primary"] = {}, ["Secondary"] = {}, ["Melee"] = {}, ["Fists"] = {
	["Fists"] = {
			name = "Fists",
			wmodel = "models/weapons/c_arms.mdl",
			FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg"),
			Automatic = true,
			RPM = 20,
			Recoil = 0.5,
			Cone = 0.5,
			NumShots = 1,
			Damage = 0,
			Delay = 0.1,
			holdtypes = {"fist", "normal"},
			LoadOut = function(self)

			end,
			Primary = function(self)
				self.Owner:SetAnimation( PLAYER_ATTACK1 )
				self:EmitSound( SwingSound )
				self:SetNextPrimaryFire( CurTime() + 0.9 )
				if CLIENT then return end
				timer.Simple(0.2, function()
					 damageattack(self)
				end)
			end,
			Secondary = function(self)
				self.Secondary.Automatic = true
			  	local Pos = self.Owner:GetShootPos()
	local Aim = self.Owner:GetAimVector()

	local Tr = util.TraceLine({
		start = Pos,
		endpos = Pos+Aim*64,
		filter = player.GetAll(),
	})

	local HitEnt = Tr.Entity

	if (self.Drag) then
		HitEnt = self.Drag.Entity
	else
		if (!IsValid(HitEnt) or HitEnt:GetMoveType() != MOVETYPE_VPHYSICS or HitEnt:IsVehicle()) then return end

		if (!self.Drag) then
			self.Drag = {
				OffPos = HitEnt:WorldToLocal(Tr.HitPos),
				Entity = HitEnt,
				Fraction = Tr.Fraction,
			}
		end
	end

	if (CLIENT or !IsValid(HitEnt)) then return end

	local Phys = HitEnt:GetPhysicsObject()

	if (IsValid(Phys)) then
		local Pos2 		= Pos + Aim*64*self.Drag.Fraction
		local OffPos 	= HitEnt:LocalToWorld(self.Drag.OffPos)
		local Dif 		= Pos2-OffPos
		local Nom 		= (Dif:GetNormal()*math.min(1,Dif:Length()/100)*500-Phys:GetVelocity())*Phys:GetMass()

		Phys:ApplyForceOffset(Nom,OffPos)
		Phys:AddAngleVelocity(-Phys:GetAngleVelocity()/4)
	end
			end,
			DrawModel = function(self)

			end,
		},}}
function RegisterITEMS(tbl)
	if ITEMS[tbl.name] then
		if OGCCW.Dev then
			MsgC(Color(255,0,0) , tbl.name .." is an already defined item\n" )
		end
		--return
	end
	ITEMS[tbl.name] = tbl
	if tbl.drop then
		for x = 1, tbl.drop do
			DROPITEMS[x] = tbl.name
		end
	end
	if tbl.crafting then
		CRAFTING[tbl.name] = tbl.crafting
	end

	if tbl.price then
		BUYITEMS[tbl.name] = tbl.price
	end
end

function RegisterWeapons(tbl, type)
	if WEAPONS[type][tbl.name] then
		if OGCCW.Dev then
			MsgC(Color(255,0,0) , tbl.name .." is an already defined weapon\n" )
		end
	--	return
	end
	WEAPONS[type][tbl.name] = tbl
end

local Folder  		= GM.Folder:gsub("gamemodes/","").."/gamemode/inventory/items"

local Class   		= file.Find(Folder.."/*.lua","LUA")

for k,v in pairs(Class) do
	if SERVER then AddCSLuaFile(Folder.."/"..v) end
	include(Folder.."/"..v)
end
/*
WEAPONS = {
	["Primary"] = {
		["DC-15S"] = {
			name = "DC-15S",
			wmodel = "models/weapons/w_DC15S.mdl",
			vmodel = "models/weapons/v_DC15S.mdl",
			FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg"),
			Automatic = false,
			RPM = 20,
			Recoil = 0.5,
			Cone = 0.5,
			NumShots = 1,
			Damage = 50,
			Color = Vector(0,0,255),
			Delay = 0.1,
			holdtypes = {"ar2", "passive"},
			LoadOut = function(self)
				self:GunLoadOut()
			end,
			Primary = function(self)
				self:BulletShoot()
			end,
			Secondary = function(self)
				if ( !self.IronSightsPos ) then return end
				bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )

				self:SetIronsights( bIronsights )

				self.NextSecondaryAttack = CurTime() + 0.3
			end,
		},

	},
	["Melee"] = {
		["repair_gun"] = {
			name = "Repair Gun",
			wmodel = "models/weapons/w_toolgun.mdl",
			FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg"),
			Automatic = true,
			RPM = 20,
			Recoil = 0.5,
			Cone = 0.5,
			NumShots = 1,
			Damage = 0,
			Delay = 0.1,
			holdtypes = {"pistol", "normal"},
			LoadOut = function(self)
				self.Primary.Delay = WEAPONS[self:GetMainType()][self:GetSubType()].Delay
			end,
			Primary = function(self)
				if CLIENT then return end
				if IsValid(self.Owner:GetEyeTrace().Entity) then
					local ent = self.Owner:GetEyeTrace().Entity
					if ent:GetPos():Distance(self.Owner:GetPos()) < 200 then
						if ent.Engineering then
							self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
								self.sound = CreateSound(self.Owner, "ambient/fire/fire_small_loop2.wav")
								self.sound:Play()
							if (self.sound2 || 0) < CurTime() then
								self.sound2 = CurTime() + 0.5
								ent:OnRepair(20)
							end
							local pos = self.Owner:GetEyeTrace().HitPos
							local fx = EffectData()
								fx:SetOrigin( pos )
							util.Effect( "Sparks", fx, true )

							timer.Create("sparks" .. self.Owner:EntIndex(), 0.3, 1, function()
								self.sound:Stop()
								self.sound = nil
								self.sound2 = nil
							end)
						end
					end
				end
			end,
		},

		["grappling_hook"] = {
			name = "Grappling Hook",
			wmodel = "models/weapons/w_toolgun.mdl",
			FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg"),
			Automatic = true,
			RPM = 20,
			Recoil = 0.5,
			Cone = 0.5,
			NumShots = 1,
			Damage = 0,
			Delay = 0.1,
			holdtypes = {"pistol", "normal"},
			LoadOut = function(self)
				self.Primary.Delay = WEAPONS[self:GetMainType()][self:GetSubType()].Delay
			end,
			Primary = function(self)
				if self.Owner:OnGround() then return end
				if self.poshit then
					self.Owner:SetLocalVelocity(Vector(0,0,0))
					self.Owner:SetVelocity( (self.poshit - self:GetPos() ):GetNormal() * 512)
				else
					if IsValid(self.Owner:GetEyeTrace().Entity) and	self.Owner:GetEyeTrace().Entity:IsPlayer() then return end
					self.poshit = self.Owner:GetEyeTrace().HitPos
				end
				timer.Create("Grapple" .. self.Owner:EntIndex(), 0.1, 1, function()
					self.poshit = nil
				end)
			end,
		}
	},
	["Fists"] = {
		["Fists"] = {
			name = "Fists",
			wmodel = "models/weapons/w_toolgun.mdl",
			FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg"),
			Automatic = true,
			RPM = 20,
			Recoil = 0.5,
			Cone = 0.5,
			NumShots = 1,
			Damage = 0,
			Delay = 0.1,
			holdtypes = {"pistol", "normal"},
			LoadOut = function(self)

			end,
			Primary = function(self)

			end,
		},
	},
}

/*

{
			name = "Repair Gun",
			wmodel = "models/weapons/w_toolgun.mdl",
			FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg"),
			Automatic = true,
			RPM = 20,
			Recoil = 0.5,
			Cone = 0.5,
			NumShots = 1,
			Damage = 0,
			Delay = 0.1,
			holdtypes = {"pistol", "normal"},
			LoadOut = function(self)
				self.Primary.Delay = WEAPONS[self:GetMainType()][self:GetSubType()].Delay
			end,
			Primary = function(self)
				if CLIENT then return end
				if IsValid(self.Owner:GetEyeTrace().Entity) then
					local ent = self.Owner:GetEyeTrace().Entity
					if ent:GetPos():Distance(self.Owner:GetPos()) < 200 then
						if ent.Engineering then
							self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
								self.sound = CreateSound(self.Owner, "ambient/fire/fire_small_loop2.wav")
								self.sound:Play()
							if (self.sound2 || 0) < CurTime() then
								self.sound2 = CurTime() + 0.5
								ent:OnRepair(20)
							end
							local pos = self.Owner:GetEyeTrace().HitPos
							local fx = EffectData()
								fx:SetOrigin( pos )
							util.Effect( "Sparks", fx, true )

							timer.Create("sparks" .. self.Owner:EntIndex(), 0.3, 1, function()
								self.sound:Stop()
								self.sound = nil
								self.sound2 = nil
							end)
						end
					end
				end
			end,
		},


*/
