
RegisterITEMS( {
	name = "Barrier", -- name of the item
	weapon = {"Melee", "Barrier"}, -- is it a weapon
	model = "models/lt_c/sci_fi/box_crate.mdl", -- the model of it
	crafting = {
		["Scrap Metal"] = 5,
		["Scrap Ingot"] = 10, 
	}, -- what is the cost for crafting it
	price = {
		sell = 100, -- base value for selling it
		buy = 2500, -- base value for buying it 
	},
	drop = nil, -- chance of it droping from a player
	use = nil,
})



local tbl = {
	name = "Barrier",
	wmodel = "models/props_c17/concrete_barrier001a.mdl",
	vmodel = "", 
	FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg"),
	Automatic = false,
	RPM = 20,
	Recoil = 0.5,
	Cone = 0.5,
	NumShots = 1,
	Damage = 10,
	Color = Vector(0,0,255),
	Delay = 0.1,
	holdtypes = {"duel"},
	LoadOut = function(self)
		if !self.barrierammo then
			self.barrierammo = 10
		end
	end,
	Primary = function(self)
			if CLIENT then return end
			
			if !self.barrierammo then
				self.barrierammo = 10
			end
			
			if self.barrierammo <= 0 then return end
			if (self.asdasd || 0 ) > CurTime() then return end
			self.asdasd = CurTime() + 1
			self.barrierammo = self.barrierammo - 1 
			local ent = ents.Create("prop_physics")
			ent:SetModel("models/props_c17/concrete_barrier001a.mdl")
			local ang = self.Owner:GetAngles()
			ent:SetPos( self.Owner:GetPos() +  Angle(0, ang.y, 0):Forward() * 40 + Vector(0,0,1) )
			ent:SetAngles( Angle(0, ang.y, 0))
			ent.owner = self.Owner
			ent.deployable = true
			ent:Spawn()
			ent:SetMoveType(MOVETYPE_NONE)
	end,
	Secondary = function(self)
		local ent = self.Owner:GetEyeTrace().Entity
		if IsValid(ent) and ent:GetPos():Distance(self.Owner:GetPos()) < 256 then
			if ent.deployable then
				ent:Remove()
				self.barrierammo = math.Clamp(self.barrierammo + 1, 1, 10) 
			end
		end
	end,
	
	DrawModel = function(self)
		if !self.fakeweapon then
			self.fakeweapon = ClientsideModel("models/props_junk/wood_crate001a.mdl")
			self.fakeweapon:SetModelScale(0.5)
			if !self.Owner:Crouching() then
				self.fakeweapon:SetPos(self:GetPos() - Vector(0,0,40) + self.Owner:GetAngles():Right() * 10)
			else
				self.fakeweapon:SetPos(self:GetPos() - Vector(0,0,70) + self.Owner:GetAngles():Right() * 1)
			end
			self.fakeweapon:SetAngles(self.Owner:GetAngles())
			self.fakeweapon:FollowBone(self.Owner,self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))
			self.fakeweapon:DrawShadow(true)
			self.fakeweapon:SetNoDraw(true)
		end
		self.fakeweapon:DrawModel()
		if (self.fakeweaponrest || 0 < CurTime()) then
			if !self.Owner:Crouching() then
				self.fakeweapon:SetPos(self:GetPos() - Vector(0,0,40) + self.Owner:GetAngles():Right() * 10)
			end
			self.fakeweaponrest = CurTime() + 5
		end
	end,
}
RegisterWeapons(tbl, "Melee")
