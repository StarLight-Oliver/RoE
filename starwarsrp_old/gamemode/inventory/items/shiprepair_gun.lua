RegisterITEMS( {
	name = "Ship Repair Gun", -- name of the item
	weapon = {"Melee", "Ship Repair Gun"}, -- is it a weapon
	model = "models/props/starwars/weapons/fusion_cutter.mdl", -- the model of it
	modifications = nil,
	crafting = {
		["Scrap Metal"] = 40,
	}, -- what is the cost for crafting it
/*	price = {
		sell = 10, -- base value for selling it
		buy = 4000, -- base value for buying it 
	},*/
	price = nil,
	drop = nil, -- chance of it droping from a player
	use = nil, -- can it be used
})

local tbl = {
			name = "Ship Repair Gun",
			wmodel = "models/props/starwars/weapons/fusion_cutter.mdl",
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
						if ent.LFS then
							self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
								self.sound = CreateSound(self.Owner, "ambient/fire/fire_small_loop1.wav")
								self.sound:Play()
							if (self.sound2 || 0) < CurTime() then
								self.sound2 = CurTime() + 0.5
								ent:SetHP(math.Clamp(ent:GetHP() + 10, 0, ent.MaxHealth) )
							end
							local pos = self.Owner:GetEyeTrace().HitPos
							local fx = EffectData()
								fx:SetOrigin( pos )
							util.Effect( "Sparks", fx, true)							
							timer.Create("sparks" .. self.Owner:EntIndex(), 0.3, 1, function()
								self.sound:Stop()
								self.sound = nil
								self.sound2 = nil
							end)
						end
					end
				end
			end,
			Secondary = function(self)
				if CLIENT then return end
				if IsValid(self.Owner:GetEyeTrace().Entity) then
					local ent = self.Owner:GetEyeTrace().Entity
					if ent:GetPos():Distance(self.Owner:GetPos()) < 200 then
       			 		--self.Owner:ChatPrint(ent.Base .. "    ") -- Might be needed later
						if ent.LFS then
							self.Weapon:SetNextSecondaryFire( CurTime() + 2 )
							self.Owner:SLChatMessage({Color(100,100,100),"[Engineering] ", color_white, "This ship has " .. ent:GetHP() .. " Health"})
						end
					end
				end
			end,
			DrawModel = function(self)
				
				if !self.grapplehook then
					self.grapplehook = ClientsideModel("models/props/starwars/weapons/fusion_cutter.mdl")
					self.grapplehook:SetAngles(self.Owner:GetAngles())
					self.grapplehook:SetPos(self:GetPos() - Vector(0,0,45) )
					self.grapplehook:DrawShadow(true)
					self.grapplehook:SetNoDraw(true)
				end
				self.grapplehook:DrawModel()
				local obj = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
					local pos, ang = self.Owner:GetBonePosition( obj )
					self.grapplehook:SetPos(pos + ang:Forward() * 2.5 + ang:Up() * 5 + ang:Right() * 1.5)
					ang:RotateAroundAxis( ang:Right(), 180 )
					ang:RotateAroundAxis( ang:Up(), 180 )
					self.grapplehook:SetAngles(ang)
			end,
			}






RegisterWeapons(tbl, "Melee")