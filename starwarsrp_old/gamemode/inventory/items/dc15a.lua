RegisterITEMS( {
	name = "DC-15A", -- name of the item
	weapon = {"Primary", "DC-15A"}, -- is it a weapon
	model = "models/weapons/w_dc15a_neue.mdl", -- the model of it
	modifications = {
		["Damage Mod"] = {damage = 15,}
	},
	crafting = {
		["Scrap Metal"] = 400,
	}, -- what is the cost for crafting it
	price = {
		sell = 1000, -- base value for selling it
		buy = 2000, -- base value for buying it 
	},
	drop = nil, -- chance of it droping from a player
	use = nil, -- can it be used
})

local tbl = {
	name = "DC-15A",
	wmodel = "models/weapons/w_dc15a_neue.mdl",
	vmodel = "models/weapons/v_DC15S.mdl", 
	FireSound = Sound ("weapons/dc15a/dc15a_fire.ogg"),
	Automatic = false,
	RPM = 343,
	Recoil = 0.7,
	Cone = 0.5,
	NumShots = 1,
	Damage = 50,
	Color = Vector(0,0,255),
	Delay = 275/1000,
	holdtypes = {"ar2", "passive"},
	LoadOut = function(self)
		self:GunLoadOut()
		if self.weaponid then
			local tbl = GetItemByID(self.weaponid)[1]
			
			for x = 1, 9 do
				if tbl["mod" .. numtoword[x]] != "NULL" then
					local ba = tbl["mod" .. numtoword[x]]
					local mod = ITEMS[tbl.type].modifications
					if mod[ba]["damage"] then
						self.Primary.Damage = self.Primary.Damage + mod[ba]["damage"]
						self.bulletcol = Vector(0,0,0)
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