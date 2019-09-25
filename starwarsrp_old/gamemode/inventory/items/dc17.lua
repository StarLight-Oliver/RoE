
RegisterITEMS( {
    name = "DC-17 Rifle", -- name of the item
    weapon = {"Primary", "DC-17 Rifle"},
    model = "models/weapons/w_dc17m_br.mdl", -- TFA i think
    modifications = { 
		["Sniper Mod"] = { 
			model = "models/weapons/w_dc17m_sn.mdl", 
			damage = 290, 
			cone = 0, 
			delay = 1.8, 
			recoil = 8,
		},
		["Anti-Armor Mod"] = {model = "models/weapons/w_dc17m_at.mdl"},
	},
    crafting = {
        ["Scrap Metal"] = 1600,
    }, -- what is the cost for crafting it
    price = {
        sell = 5000, -- base value for selling it
        buy = 10000, -- base value for buying it 
    },
    drop = nil, -- chance of it droping from a player
    use = nil, -- can it be used
})

local tbl = {
	name = "DC-17 Rifle",
	wmodel = "models/weapons/w_dc17m_br.mdl",
	vmodel = "models/weapons/v_DC15S.mdl", 
	FireSound = Sound ("weapons/dc17m_br/dc17m_br_fire.ogg"),
	Automatic = false,
	RPM = 20,
	Recoil = 0.7,
	Cone = 0.5,
	NumShots = 1,
	Damage = 50,
	Color = Vector(0,0,255),
	Delay = 200/1000,
	holdtypes = {"ar2", "passive"},
	LoadOut = function(self)
		self:GunLoadOut()

		if self.weaponid then
			local tbl = GetItemByID(self.weaponid)[1]
			
			for x = 1, 9 do
				if tbl["mod" .. numtoword[x]] != "NULL" then
					local ba = tbl["mod" .. numtoword[x]]
					local mod = ITEMS[tbl.type].modifications
					if mod[ba] then
						if mod[ba]["damage"] then
							self.Primary.Damage = self.Primary.Damage + mod[ba]["damage"]
							self.bulletcol = Vector(0,0,0)
						end
						if mod[ba]["cone"] then
							self.Primary.Cone = self.Primary.Cone * mod[ba]["cone"]
							self.bulletcol = Vector(0,200,0)
						end

						if mod[ba]["delay"] then

							self.Primary.Delay= self.Primary.Delay +mod[ba]["delay"]
						end

						if mod[ba]["recoil"] then

							self.Primary.Recoil= self.Primary.Recoil +mod[ba]["recoil"]
						end

						if mod[ba]["model"] then
						--	self:SetWorldModel(mod[ba]["model"])
							if CLIENT then return end
								self:SetWorldModel(mod[ba]["model"])
						end
					end
				end
			
			end
		end
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
}
RegisterWeapons(tbl, "Primary")















RegisterITEMS( {
    name = "DC-17", -- name of the item
    weapon = {"Secondary", "DC-17"},
    model = "models/weapons/w_dc17.mdl", -- TFA i think
    modifications = nil,
    crafting = {
        ["Scrap Metal"] = 800,
    }, -- what is the cost for crafting it
    price = {
        sell = 100, -- base value for selling it
        buy = 2000, -- base value for buying it 
    },
    drop = nil, -- chance of it droping from a player
    use = nil, -- can it be used
})


local tbl = {
	name = "DC-17",
	wmodel = "models/weapons/w_dc17.mdl",
	vmodel = "models/weapons/v_DC15S.mdl", 
	FireSound = Sound("weapons/dc17/dc17_fire.ogg"),
	Automatic = false,
	RPM = 20,
	Recoil = 0.2,
	Cone = 0.5,
	NumShots = 1,
	Damage = 8,
	Color = Vector(0,0,255),
	Delay = 0.7,
	holdtypes = {"pistol", "passive"},
	LoadOut = function(self)
		self:GunLoadOut()
		/*if self.weaponid then
			local tbl = GetItemByID(self.weaponid)[1]
			for x = 1, 9 do
				if tbl["mod" .. numtoword[x]] != "NULL" then
					local ba = tbl["mod" .. numtoword[x]]
					local mod = ITEMS[tbl.type].modifications
					if mod[ba]["damage"] then
						self.Primary.Damage = self.Primary.Damage + mod[ba]["damage"]
					end
				end
			
			end
		end*/
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
}
RegisterWeapons(tbl, "Secondary")





