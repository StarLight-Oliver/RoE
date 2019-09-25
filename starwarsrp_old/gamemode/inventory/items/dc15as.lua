RegisterITEMS( {
    name = "DC-15a Sidearm", -- name of the item
    weapon = {"Secondary", "DC-15a Sidearm"},
    model = "models/weapons/w_dc15sa.mdl", -- TFA
    modifications = nil,
    crafting = {
        ["Scrap Metal"] = 750,
    }, -- what is the cost for crafting it
    price = {
        sell = 150, -- base value for selling it
        buy = 2500, -- base value for buying it 
    },
    drop = nil, -- chance of it droping from a player
    use = nil, -- can it be used
})


local tbl = {
	name = "DC-15a Sidearm",
	wmodel = "models/weapons/w_dc15sa.mdl",
	vmodel = "models/weapons/v_DC15S.mdl", 
	FireSound = Sound ("weapons/dc15sa/dc15sa_fire.ogg"),
	Automatic = false,
	RPM = 20,
	Recoil = 0.5,
	Cone = 0.4,
	NumShots = 1,
	Damage = 8,
	Color = Vector(0,0,255),
	Delay = 0.6,
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
