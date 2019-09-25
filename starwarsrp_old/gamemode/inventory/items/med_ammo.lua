RegisterITEMS( {
    name = "Medical Supplies", -- name of the item
    model = "models/riddickstuff/bactagrenade/bactanade.mdl", -- the model of it - From riddick's bacta thing
	weapon = nil,
    modifications = nil,
    crafting = {
        ["Scrap Metal"] = 25,
    }, -- what is the cost for crafting it
    price = {
        sell = 100, -- base value for selling it
        buy = 200, -- base value for buying it 
    },
    drop = 2, -- chance of it droping from a player
    use = function(ply)
		ply:SetHealth(math.Clamp(ply:Health() + 30, 0, ply:GetMaxHealth()) )
		return true
	end, -- can it be used
})

RegisterITEMS( {
    name = "Ammunition Kit", -- name of the item
    model = "models/starwars/items/energy_cell.mdl", -- the model of it - From https://steamcommunity.com/sharedfiles/filedetails/?id=290145812
    modifications = nil,
	weapon = nil,
    crafting = {
        ["Scrap Metal"] = 10,
    }, -- what is the cost for crafting it
    price = {
        sell = 100, -- base value for selling it
        buy = 200, -- base value for buying it 
    },
    drop = 2, -- chance of it droping from a player
    use = function(ply)
		ply:GiveAmmo(400, "AR2", false)
		return true
	end, -- can it be used
})


RegisterITEMS( {
    name = "Sniper Mod", -- name of the item
    model = "models/riddickstuff/bactagrenade/bactanade.mdl", -- the model of it - From riddick's bacta thing
    weapon = nil,
    modifications = nil,
    drop = 2, -- chance of it droping from a player
    use = function(ply)
        ply:SetHealth(math.Clamp(ply:Health() + 30, 0, ply:GetMaxHealth()) )
        return true
    end, -- can it be used
})

RegisterITEMS( {
    name = "Anti Armor Mod", -- name of the item
    model = "models/riddickstuff/bactagrenade/bactanade.mdl", -- the model of it - From riddick's bacta thing
    weapon = nil,
    modifications = nil,
    drop = 2, -- chance of it droping from a player
    use = function(ply)
        ply:SetHealth(math.Clamp(ply:Health() + 30, 0, ply:GetMaxHealth()) )
        return true
    end, -- can it be used
})


RegisterITEMS( {
    name = "Med Kit", -- name of the item
    weapon = {"Melee", "Med Kit"},
    model = "models/weapons/w_medkit.mdl", -- Base Gmod
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
    name = "Med Kit",
    wmodel = "models/weapons/w_medkit.mdl",
    FireSound = Sound ("HealthKit.Touch"),
    Automatic = false,
    RPM = 20,
    Recoil = 0.5,
    Cone = 0.5,
    NumShots = 1,
    Damage = 5,
    Color = Vector(0,0,255),
    Delay = 15,
    holdtypes = {"pistol", "normal"},
    LoadOut = function(self)
    end,
    Primary = function(self)
        
    if (self.MEDCOOL || 0 ) < CurTime() then
      local ent = self.Owner:GetEyeTrace().Entity
      if ent:IsPlayer() and ent:GetPos():Distance(self.Owner:GetPos()) < 70 then
        ent:SetHealth(math.Clamp(ent:Health() + 10, 0, ent:GetMaxHealth() ) )
        self.MEDCOOL = CurTime() + 1
        self:EmitSound(WEAPONS[self:GetMainType()][self:GetSubType()].FireSound)
      end
    end
   
    end,
    Secondary = function(self)
        
    end,
}
RegisterWeapons(tbl, "Melee")