RegisterITEMS( {
	name = "E-5", -- name of the item
	weapon = {"Primary", "E-5"}, -- is it a weapon
	model = "models/weapons/w_e5.mdl", -- the model of it
	modifications = nil,
	crafting = nil,
	price = {
		sell = 10000000, -- base value for selling it
		buy = 20000000, -- base value for buying it 
	},
	drop = nil, -- chance of it droping from a player
	use = nil, -- can it be used
})

local tbl = {
	name = "E-5",
	wmodel = "models/weapons/w_e5.mdl",
	vmodel = "models/weapons/v_DC15S.mdl", 
	FireSound = Sound ("weapons/e5/e5_fire.ogg"),
	Automatic = false,
	RPM = 20,
	Recoil = 0.5,
	Cone = 0.3025,
	NumShots = 1,
	Damage = 55,
	Color = Vector(255,0,0),
	Delay = 0.25,
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
}
RegisterWeapons(tbl, "Primary")