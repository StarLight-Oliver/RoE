local HardLaser = Material( "ogc/lightsaber/blade_glow" )
local HardLaserInner = Material( "ogc/lightsaber/blade_inner" )

local HardLaserTrail = Material( "lightsaber/hard_light_trail" )
local HardLaserTrailInner = Material( "lightsaber/hard_light_trail_inner" )

local HardLaserTrailEnd = Material( "lightsaber/hard_light_trail_end" )
local HardLaserTrailEndInner = Material( "lightsaber/hard_light_trail_end_inner" )

local HardLaserTrailEnd = Material( "lightsaber/hard_light_trail" )
local HardLaserTrailEndInner = Material( "lightsaber/hard_light_trail_inner" )

local gOldPositions = {}
local gTrailLength = 2
local lastTime = 0.5

local colors = {
	White = color_white,
	Red = Color(255,0,0),
	Blue = Color(0,0,255),
	Green = Color(0,255,0),
	Yellow = Color(255,255, 0),
	Cyan = Color(0,255,255),
	Purple = Color(128,0,128),
	Pink = Color(255,20,147),
	Orange = Color(255,69,0)
}

function rb655_LS_DoDamage( tr, wep )
	local ent = tr.Entity
	if ( !IsValid( ent ) or ( ent:Health() <= 0 && ent:GetClass() != "prop_ragdoll" )) then return end

	local dmginfo = DamageInfo()
	dmginfo:SetDamageForce( tr.HitNormal * -13.37 )

	
	dmginfo:SetDamage(wep.Damage || 25)

	if ( ( !ent:IsPlayer() or !wep:IsWeapon() ) ) then
		-- This causes the damage to apply force the the target, which we do not want
		-- For now, only apply it to the SENT
		dmginfo:SetInflictor( wep )
	end

	if ( ent:GetClass() == "npc_zombie" or ent:GetClass() == "npc_fastzombie" ) then
		dmginfo:SetDamageType( bit.bor( DMG_SLASH, DMG_CRUSH ) )
		dmginfo:SetDamageForce( tr.HitNormal * 0 )
		dmginfo:SetDamage( math.max( dmginfo:GetDamage(), 30 ) ) -- Make Zombies get cut in half
	end

	if ( !IsValid( wep.Owner ) ) then
		dmginfo:SetAttacker( wep )
	else
		dmginfo:SetAttacker( wep.Owner )
	end

	if ent:IsNPC() then
	dmginfo:SetDamage(100)
	end
	
	ent:TakeDamageInfo( dmginfo )
end



function GetSaberPosAng(self,  num, side )
	num = num || 1


	if ( IsValid( self.Owner ) ) then
		local bone = self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" )
		
		local attachment = self:LookupAttachment( "blade" .. num )
		if ( side ) then
			attachment = self:LookupAttachment( "quillon" .. num )
		end

		if ( !bone && SERVER ) then
			
		end

		if ( attachment && attachment > 0 ) then
			local PosAng = self:GetAttachment( attachment )

			if ( !bone && SERVER ) then
				PosAng.Pos = PosAng.Pos + Vector( 0, 0, 36 )
				if ( SERVER && IsValid( self.Owner ) && self.Owner:Crouching() ) then PosAng.Pos = PosAng.Pos - Vector( 0, 0, 18 ) end
				PosAng.Ang.p = 0
			end

			return PosAng.Pos, PosAng.Ang:Forward()
		end

		if ( bone ) then
			local pos, ang = self.Owner:GetBonePosition( bone )
			if ( pos == self.Owner:GetPos() ) then
				local matrix = self.Owner:GetBoneMatrix( bone )
				if ( matrix ) then
					pos = matrix:GetTranslation()
					ang = matrix:GetAngles()
				else
					
				end
			end

			ang:RotateAroundAxis( ang:Forward(), 180 )
			ang:RotateAroundAxis( ang:Up(), 30 )
			ang:RotateAroundAxis( ang:Forward(), -5.7 )
			ang:RotateAroundAxis( ang:Right(), 92 )

			pos = pos + ang:Up() * -3.3 + ang:Right() * 0.8 + ang:Forward() * 5.6

			return pos, ang:Forward()
		end

		
	else
		
	end

	local defAng = self:GetAngles()
	defAng.p = 0

	local defPos = self:GetPos() + defAng:Right() * 0.6 - defAng:Up() * 0.2 + defAng:Forward() * 0.8
	if ( SERVER ) then defPos = defPos + Vector( 0, 0, 36 ) end
	if ( SERVER && IsValid( self.Owner ) && self.Owner:Crouching() ) then defPos = defPos - Vector( 0, 0, 18 ) end

	return defPos, -defAng:Forward()
end


function DamageTrace(self, blade)
    if !IsValid(self) then return end
	local isTrace1Hit = false
	local pos, ang = GetSaberPosAng(self, blade)
	local trace = util.TraceLine( {
		start = pos,
		endpos = pos + ang * 42,
		filter = { self, self.Owner },
		mins = Vector( -1, -1, -1 ) * 2,
		maxs = Vector( 1, 1, 1 ) * 2
	} )
	local traceBack = util.TraceLine( {
		start = pos + ang * 42,
		endpos = pos,
		filter = { self, self.Owner },
		mins = Vector( -1, -1, -1 ) * 2,
		maxs = Vector( 1, 1, 1 ) * 2
	} )
	// uncomment the mins and maxs will make a box happen, This "LORD TYLER" is how you do it not with your complicated function
	
	--if ( SERVER ) then debugoverlay.Line( trace.StartPos, trace.HitPos, .1, Color( 255, 0, 0 ), false ) end

	-- When the blade is outside of the world
	if ( trace.HitSky or ( trace.StartSolid && trace.HitWorld ) ) then trace.Hit = false end
	if ( traceBack.HitSky or ( traceBack.StartSolid && traceBack.HitWorld ) ) then traceBack.Hit = false end

	isTrace1Hit = trace.Hit or traceBack.Hit

	-- Don't deal the damage twice to the same entity
	if ( traceBack.Entity == trace.Entity && IsValid( trace.Entity ) ) then traceBack.Hit = false end

	if ( trace.Hit ) then rb655_LS_DoDamage( trace, self ) end
	if ( traceBack.Hit ) then rb655_LS_DoDamage( traceBack, self ) end

	return isTrace1Hit
end

function rb655_DrawHit( pos, dir )
	local effectdata = EffectData()
	effectdata:SetOrigin( pos )
	effectdata:SetNormal( dir )
	util.Effect( "StunstickImpact", effectdata, true, true )
end


function OGC_RenderBlade( pos, dir, len, maxlen, width, color, eid, underwater, unstable )
	-- render.DrawLine( pos + dir * len*-5, pos + dir * len*10, color, true )
	local rain = false
	if color == "Rainbow" then rain = true end
	local color = colors[color]
	if !color then color = colors["Red"] end
	if rain then 
		color = table.Random(colors)
	end 
	if ( underwater ) then
		local ed = EffectData()
		ed:SetOrigin( pos )
		ed:SetNormal( dir )
		ed:SetRadius( len )
		util.Effect( "rb655_saber_underwater", ed )
	end

	local inner_color = color_white
	if ( black_inner ) then inner_color = color_white end
	render.SetMaterial( HardLaser )
	--unstable = false
	if unstable then
		local stable = 10000
		local le = len
		for x = 1, len do
				render.DrawBeam( pos, pos + dir * (le / x), width * (1 + (CurTime() % 0.4)), stable, 0, color )
		end
		render.SetMaterial( HardLaserInner )
		render.DrawBeam( pos, pos + dir * (len), width * (0.8 - (CurTime() % 0.4)), 1, 0.01, inner_color )
	else
		local le = len + 10
		for x = 1, len do
			render.DrawBeam( pos, pos + dir * (le / x), width * 1.4 - (x / (len / 2)), 1, 0, color )
		end
		render.SetMaterial( HardLaserInner )
		render.DrawBeam( pos, pos + dir * (len), width * 1, 1, 0.01, inner_color )
	end
	local SaberLight = DynamicLight( eid )
	if ( SaberLight ) then
		SaberLight.Pos = pos + dir * ( len / 2 )
		SaberLight.r = color.r
		SaberLight.g = color.g
		SaberLight.b = color.b
		SaberLight.Brightness = 0.6
		SaberLight.Size = 176 * ( len / maxlen )
		SaberLight.Decay = 0
		SaberLight.DieTime = CurTime() + 0.1
	end
end


RegisterITEMS( {
	name = "Inquisitor Saber", -- name of the item
	weapon = {"Melee", "Inquisitor Saber"}, -- is it a weapon
	model = "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl", -- the model of it
	modifications = nil,
	--[[crafting = {
		["Scrap Metal"] = 4000,
	}, -- what is the cost for crafting it]]--
	--[[price = {
		sell = 10, -- base value for selling it
		buy = 40000, -- base value for buying it 
	},]]--
	price = nil,
	drop = nil, -- chance of it droping from a player
	use = nil, -- can it be used
})

local tbl = {
			name = "Inquisitor Saber",
			wmodel = "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl",
			FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg"),
			Automatic = true,
			RPM = 20,
			Recoil = 0.5,
			Cone = 0.5,
			NumShots = 1,
			Damage = 25,
			Delay = 0.1,
			holdtypes = {"knife", "normal"},
			LoadOut = function(self)
				self.Damage =  WEAPONS[self:GetMainType()][self:GetSubType()].Damage
				self.Primary.Automatic = true
				self.Secondary.Automatic = true
				self.Primary.Delay = WEAPONS[self:GetMainType()][self:GetSubType()].Delay
			end,
			Primary = function(self)
				if SERVER then
					if !self:CanSecondaryAttack() then return end
					self.NextSecondaryAttack = CurTime() + 1
					
					local str = nil
					
					
					if self.Owner:KeyDown(IN_MOVELEFT) then
						local lefttbl = {"wos_phalanx_b_left_t1", "wos_phalanx_b_left_t2", "wos_phalanx_b_left_t3"}
						str = table.Random(lefttbl)
					elseif self.Owner:KeyDown(IN_MOVERIGHT) then
						-- right
						local lefttbl = {"wos_phalanx_b_right_t1", "wos_phalanx_b_right_t2", "wos_phalanx_b_right_t3"}
						str = table.Random(lefttbl)
					else
						local fronttbl = {"wos_phalanx_b_s3_t1", "wos_phalanx_b_s3_t2", "wos_phalanx_b_s3_t3"}
						str = table.Random(fronttbl)
					end				
					self.Owner:SetAnim(str) -- wos_phalanx_b_left_t1, wos_phalanx_b_right_t1, wos_phalanx_b_s3_t1, 
					for x = 1, 100 do
						timer.Simple(x/10, function()
							local hit = DamageTrace(self,1)
							
							local hit2 = DamageTrace(self,2)
						end)
					end
				end 
			end,
			Secondary = function(self)
				if !self:CanSecondaryAttack() then return end
				if SERVER then
					
					self.NextSecondaryAttack = CurTime() + 10
					self:GetOwner():DrawWorldModel(false)

					local ent = ents.Create("ent_lightsaber_inquis")
					ent:SetModel("models/star/venator/inqusitor_saber.mdl")
					ent:Spawn()
					ent:SetBladeLength(42)
					ent:SetMaxLength(42)
					ent:SetCrystalColor("Red")
					ent:SetPos(self.Owner:GetPos())
					ent:SetOwner(self.Owner)
					ent:OnEnabled()

				end
			end,
			DrawModel = function(self)
				self:DrawModel()
				if self:GetHoldType() == "knife" then
					local pos, dir = GetSaberPosAng(self, 1)
					OGC_RenderBlade( pos, dir, 42, 42, 2, "Red", self:EntIndex() + 512,self.Owner:WaterLevel() > 2, false )
					local pos, dir = GetSaberPosAng(self, 2)
					OGC_RenderBlade( pos, dir, 42, 42, 2, "Red", self:EntIndex() + 512*2,self.Owner:WaterLevel() > 2, false )
				end
			end,
		}

		
		/*
if ( self:LookupAttachment( "blade2" ) > 0 ) then
		local pos, dir = self:GetSaberPosAng( 2 )
		rb655_RenderBlade( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clrs, self:GetDarkInner(), self:EntIndex() + 655, self:GetOwner():WaterLevel() > 2, false, "F1")
	end


*/
		
		
RegisterWeapons(tbl, "Melee")



RegisterITEMS( {
	name = "Jedi Saber", -- name of the item
	weapon = {"Melee", "Jedi Saber"}, -- is it a weapon
	model = "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl", -- the model of it
	modifications = nil,
	--[[crafting = {
		["Scrap Metal"] = 4000,
	}, -- what is the cost for crafting it]]--
	--[[price = {
		sell = 10, -- base value for selling it
		buy = 40000, -- base value for buying it 
	},]]--
	price = nil,
	drop = nil, -- chance of it droping from a player
	use = nil, -- can it be used
})

local tbl = {
			name = "Jedi Saber",
			wmodel = "models/sgg/starwars/weapons/w_common_jedi_saber_hilt.mdl",
			FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg"),
			Automatic = true,
			RPM = 20,
			Recoil = 0.5,
			Cone = 0.5,
			NumShots = 1,
			Damage = 25,
			Delay = 0.1,
			holdtypes = {"knife", "normal"},
			LoadOut = function(self)
				self.Damage =  WEAPONS[self:GetMainType()][self:GetSubType()].Damage
				self.Primary.Automatic = true
				self.Secondary.Automatic = true
				self.Primary.Delay = WEAPONS[self:GetMainType()][self:GetSubType()].Delay
			end,
			Primary = function(self)
				if SERVER then
					if !self:CanSecondaryAttack() then return end
					self.NextSecondaryAttack = CurTime() + 1
					
					local str = nil
					
					
					if self.Owner:KeyDown(IN_MOVELEFT) then
						local lefttbl = {"wos_phalanx_b_left_t1", "wos_phalanx_b_left_t2", "wos_phalanx_b_left_t3"}
						str = table.Random(lefttbl)
					elseif self.Owner:KeyDown(IN_MOVERIGHT) then
						-- right
						local lefttbl = {"wos_phalanx_b_right_t1", "wos_phalanx_b_right_t2", "wos_phalanx_b_right_t3"}
						str = table.Random(lefttbl)
					else
						local fronttbl = {"wos_phalanx_b_s3_t1", "wos_phalanx_b_s3_t2", "wos_phalanx_b_s3_t3"}
						str = table.Random(fronttbl)
					end				
					self.Owner:SetAnim(str) -- wos_phalanx_b_left_t1, wos_phalanx_b_right_t1, wos_phalanx_b_s3_t1, 
					for x = 1, 100 do
						timer.Simple(x/10, function()
							local hit = DamageTrace(self,1)
							
							local hit2 = DamageTrace(self,2)
						end)
					end
				end 
			end,
			Secondary = function(self)
				if !self:CanSecondaryAttack() then return end
				if SERVER then
					--if self.Owner:Armor() < 2 then return end
					--self.NextSecondaryAttack = CurTime() + 0.1
					self:GetOwner():DrawWorldModel(true)

					--self.Owner:SetArmor(self.Owner:Armor() - 0.000001)
					local ent = self.Owner
					ent.regenval = 5
					self.Owner.entitytbl = self.Owner.entitytbl || {}
					for index, ent in pairs(ents.FindInSphere(self.Owner:GetPos(),  512)) do
						if ent:GetClass() == "star_bulle%" and ent:GetMoveType() != MOVETYPE_NONE then
								ent:SetMoveType(MOVETYPE_NONE)
								self.Owner.entitytbl[ent:EntIndex()] = ent
						end
					end


					timer.Create("Unfreeze guns" .. ent:EntIndex(), 1, 1, function()
						for index, ent in pairs(self.Owner.entitytbl) do
							if IsValid(ent) then
								ent:SetLocalVelocity(Vector(0,0,0))
								--ent:Remove()
								local en = ents.Create(ent:GetClass())
								en:SetAngles(ent:GetAngles())
								en.Damage	= ent.Damage
								en:SetModel(ent:GetModel())
								en:SetCustomCollisionCheck( true )
								
								
								local owner = ent:GetOwner()
								local col = ent:GetBulletColor()
								local pos = ent:GetPos()
								local dmg = ent:GetDamageAmount()
								local vel = ent:GetAngles():Forward()
								ent:Remove()
								
								en:Spawn()
								en:Activate()
								en:SetOwner(owner)
								en:SetBulletColor(col )
								en:SetStartPos(pos)			
								en:SetDamageAmount(dmg)
								en:SetVelocity(vel * 5000)

								ent.vel = 100000
								local phys = en:GetPhysicsObject()
								ent:Remove()
								if ( !IsValid( phys ) ) then en:Remove() return end
						
								local velocity = en:GetAngles():Forward()
								velocity = velocity * 100000
								velocity = velocity
								phys:ApplyForceCenter( velocity )
							end
						end
						self.Owner.entitytbl = nil
					end)
					timer.Create("armorregen" .. ent:EntIndex(), ent.regenval, 1, function()
						ArmorRegen(ent)
					end)

				end
			end,
			DrawModel = function(self)
				self:DrawModel()
				if self:GetHoldType() == "knife" then
					local pos, dir = GetSaberPosAng(self, 1)
					OGC_RenderBlade( pos, dir, 42, 42, 2, "Blue", self:EntIndex() + 512,self.Owner:WaterLevel() > 2, false )
					local pos, dir = GetSaberPosAng(self, 2)
					OGC_RenderBlade( pos, dir, 42, 42, 2, "Blue", self:EntIndex() + 512*2,self.Owner:WaterLevel() > 2, false )
				end
			end,
		}

		
		/*
if ( self:LookupAttachment( "blade2" ) > 0 ) then
		local pos, dir = self:GetSaberPosAng( 2 )
		rb655_RenderBlade( pos, dir, self:GetBladeLength(), self:GetMaxLength(), self:GetBladeWidth(), clrs, self:GetDarkInner(), self:EntIndex() + 655, self:GetOwner():WaterLevel() > 2, false, "F1")
	end


*/
		
		
RegisterWeapons(tbl, "Melee")