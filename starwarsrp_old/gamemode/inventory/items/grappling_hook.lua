RegisterITEMS( {
	name = "Grappling Hook", -- name of the item
	weapon = {"Melee", "Grappling Hook"}, -- is it a weapon
	model = "models/weapons/w_toolgun.mdl", -- the model of it
	modifications = nil,
	crafting = {
		["Scrap Metal"] = 160,
	}, -- what is the cost for crafting it
/*	price = {
		sell = 10, -- base value for selling it
		buy = 45000, -- base value for buying it 
	},*/
	prive = nil,
	drop = nil, -- chance of it droping from a player
	use = nil, -- can it be used
})

local tbl = {
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
				self.Primary.Automatic = true
				self.Secondary.Automatic = true
				self.Primary.Delay = WEAPONS[self:GetMainType()][self:GetSubType()].Delay
			end,
			Primary = function(self)
				if SERVER then
					if self.Owner:OnGround() then return end
					if self:GetSpecialPos() != Vector(0,0,0) then
						self.Owner:SetLocalVelocity(Vector(0,0,0))
						self.Owner:SetVelocity( (self:GetSpecialPos() - self:GetPos() ):GetNormal() * 512)
					else
						if IsValid(self.Owner:GetEyeTrace().Entity) and	self.Owner:GetEyeTrace().Entity:IsPlayer() then return end
						if self.Owner:GetEyeTrace().HitPos:Distance(self.Owner:GetPos()) < 2024 then 
						    self:SetSpecialPos(self.Owner:GetEyeTrace().HitPos)
						end
					end
					timer.Create("Grapple" .. self.Owner:EntIndex(), 0.1, 1, function()
						self:SetSpecialPos(Vector(0,0,0))
					end)
				end
			end,
			Secondary = function(self)
				if SERVER then
					if self.Owner:OnGround() then return end
					
					if self.Owner:Armor() < 2 then return end
					
					if self:GetSpecialPos() != Vector(0,0,0) then
						if (self.grapplysec || 0) < CurTime() then
							self.grapplysec = CurTime() + 0.5
							self.Owner:SetVelocity( (self:GetSpecialPos() - self:GetPos() ):GetNormal() * 512)
							self.Owner:SetArmor(self.Owner:Armor() - 1)
							local ent = self.Owner
							ent.regenval = 5
							timer.Create("armorregen" .. ent:EntIndex(), ent.regenval, 1, function()
								ArmorRegen(ent)
							end)
							
							
						end
						
					else
						if IsValid(self.Owner:GetEyeTrace().Entity) and	self.Owner:GetEyeTrace().Entity:IsPlayer() then return end
						if self.Owner:GetEyeTrace().HitPos:Distance(self.Owner:GetPos()) < 3024 then 
						    self:SetSpecialPos(self.Owner:GetEyeTrace().HitPos)
						end
					end
					timer.Create("Grapple" .. self.Owner:EntIndex(), 0.1, 1, function()
						self:SetSpecialPos(Vector(0,0,0))
					end)
				end
			end,
			DrawModel = function(self)
			
				local pos = self:GetPos() + Vector(0,0, 45)
			
				local obj = self:LookupAttachment("muzzle")
				local posang = self:GetAttachment( obj )
				if !posang then
					self:DrawModel()
				return end
				local pos = posang.Pos
			
			
				if self:GetSpecialPos() != Vector(0,0,0) then
					render.SetMaterial(Material("cable/cable2"))
					render.DrawBeam( self:GetSpecialPos(), pos, 2, 0, 1, Color(255,255,255) )
				end
				
				self:DrawModel()

			end,
		}






RegisterWeapons(tbl, "Melee")