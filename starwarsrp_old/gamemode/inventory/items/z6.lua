RegisterITEMS( {
    name = "Z6 Rotary Blaster", -- name of the item
    weapon = {"Primary", "Z6 Rotary Blaster"},
    model = "models/weapons/w_z6_rotary_blaster.mdl", -- TFA
    modifications = nil,
    crafting = {
        ["Scrap Metal"] = 100,
		["Scrap Ingot"] = 40,
		["Wiring Kit"] = 10,
    }, -- what is the cost for crafting it
    price = {
        sell = 300, -- base value for selling it
        buy = 45000, -- base value for buying it 
    },
    drop = nil, -- chance of it droping from a player
    use = nil, -- can it be used
})

local tbl = {
	name = "Z6 Rotary Blaster",
	wmodel = "models/weapons/tfa_sw_z6_rotary_blaster.mdl", -- models/weapons/tfa_sw_z6_rotary_blaster.mdl 
	vmodel = "models/weapons/v_DC15S.mdl", 
	FireSound = Sound("weapons/z6_rotary/repeat-1.wav"),
	Automatic = false,
	RPM = 20,
	Recoil = 0.2,
	Cone = 1,
	NumShots = 1,
	Damage = 15,
	Color = Vector(0,0,255),
	Delay = 0.001,
	holdtypes = {"physgun", "passive"},
	SpawnAbles = {
		[1] = {
			Name = "Scrap Metal",
			Spawn = function(ply)
				local ent = ents.Create("base_sl_gun")
				ent:SetPos(ply:GetEyeTrace().HitPos+ Vector(0,0, 20))
				ent:SetAngles(ply:GetAngles())
				
				ent:SetTurretType(GetTurret("Basic Turret"))

				ent:Spawn()
				ent:Activate()
				
			end
		},
		[2] = {
			Name = "Scrap Ingot",
			Spawn = function(ply)
				MsgC("Here\n")
				local ent = ents.Create("base_sl_turret")
				ent:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0, 100))
				ent:SetAngles(ply:GetAngles())
				ent:Spawn()
				ent:Activate()
				print(ent)
			end
		},
		[3] = {
			Name = "Death",

		},
	},

	LoadOut = function(self)
		self:GunLoadOut()
		if self.weaponid then
			local tbl = GetItemByID(self.weaponid)[1]
			if !tbl then return end
			for x = 1, 9 do
				if tbl["mod" .. numtoword[x]] != "NULL" then
					local ba = tbl["mod" .. numtoword[x]]
					local mod = ITEMS[tbl.type].modifications
					if mod[ba]["damage"] then
						self.Primary.Damage = self.Primary.Damage + mod[ba]["damage"]
						self.bulletcol = Vector(50,50,50)
					end
				end
			
			end
	    end
	    
	end,
	Primary = function(self)
		if !self.z6 then
			self:EmitSound(Sound("weapons/z6_rotary/z6_startspin.wav"))
		end
		self.z6 = true
		timer.Create("z6_cooldown" .. self.Owner:EntIndex(), 0.2 , 1, function()
			self.z6 = false
			self:EmitSound(Sound("weapons/z6_rotary/z6_stopspin.wav"))
		end)
		timer.Simple(0.5, function()
		    if !IsValid(self) or !IsValid(self.Owner) then return end
			if self.Owner:IsNPC() then
			if self.z6 then
					self:BulletShoot()
				end
				return
			end
			if self.Owner:Alive() then
				if self.z6 then
				    if CLIENT then return end
					self:BulletShoot()
				end
			end
		end)
	end,
	Secondary = function(self)
		if ( !self.IronSightsPos ) then return end
		bIronsights = !self.Weapon:GetNetworkedBool( "Ironsights", false )		
		self:SetIronsights( bIronsights )		
		self.NextSecondaryAttack = CurTime() + 0.3
	end,
}
RegisterWeapons(tbl, "Primary")