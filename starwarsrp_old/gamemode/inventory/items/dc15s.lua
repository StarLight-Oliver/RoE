RegisterITEMS( {
	name = "DC-15S", -- name of the item
	weapon = {"Primary", "DC-15S"}, -- is it a weapon
	model = "models/weapons/w_DC15S.mdl", -- the model of it
	modifications = {
		["Scrap Metal"] = {damage = 10,}
	},
	crafting = {
		["Scrap Metal"] = 4,
	}, -- what is the cost for crafting it
	price = {
		sell = 10, -- base value for selling it
		buy = 20, -- base value for buying it 
	},
	drop = nil, -- chance of it droping from a player
	use = nil, -- can it be used 
})

local tbl = {
	name = "DC-15S",
	wmodel = "models/weapons/w_DC15S.mdl",
	vmodel = "models/weapons/v_DC15S.mdl", 
	FireSound = Sound ("weapons/dc15s/DC15S_fire.ogg"),
	Automatic = false,
	RPM = 240,
	Recoil = 0.5,
	Cone = 	0.3025,--150/100,
	NumShots = 1,
	Damage = 20,
	Color = Vector(0,0,255),
	Delay = 0.38,
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