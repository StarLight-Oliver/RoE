--models/bf2017/w_scoutblaster.mdl

RegisterITEMS( {
    name = "Stun Gun", -- name of the item
    weapon = {"Secondary", "Stun Gun"},
    model = "models/bf2017/w_scoutblaster.mdl", -- TFA
    modifications = nil,
    crafting = {
        ["Scrap Metal"] = 7500,
    }, -- what is the cost for crafting it
    price = {
        sell = 150, -- base value for selling it
        buy = 45000, -- base value for buying it 
    },
    drop = nil, -- chance of it droping from a player
    use = nil, -- can it be used
})


local tbl = {
	name = "Stun Gun",
	wmodel = "models/bf2017/w_scoutblaster.mdl",
	vmodel = "models/weapons/v_DC15S.mdl", 
	FireSound = Sound ("weapons/dc15a/dc15a_supressed_by_st.ogg"),
	Automatic = false,
	RPM = 20,
	Recoil = 0.5,
	Cone = 0.5,
	NumShots = 1,
	Damage = 0,
	Color = Vector(0,0,255),
	Delay = 8,
	holdtypes = {"pistol", "normal"},
	LoadOut = function(self)
		self:GunLoadOut()
	end,
	Primary = function(self)
		self:BulletShoot(true)
	end,
	Secondary = function(self)
		if ( !self.IronSightsPos ) then return end
		bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )		
		self:SetIronsights( bIronsights )		
		self.NextSecondaryAttack = CurTime() + 0.3
	end,
}
RegisterWeapons(tbl, "Secondary")
