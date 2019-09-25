
local fac = {}
fac.Name = "Jedi"
fac.Color = Color(0,0,139)
fac.Desc = "Masters of the Force"
fac.BasePay = 30
fac.Tag = "Jedi"
fac.RankID = {}
fac.Ranks = {
	[1] = {
		Name = "Initiate",
		numbers = false,
		Model = "models/animus/casualjediv2/v2_casualjedi_07.mdl",
		Health = 1000,
		Armor = 20,
		Pay = 1,
		Speed = 1.5,
		Weapons = {"","","weapon_lightsaber"},
		Permission = 5,
		Commands = {""},
		Spawn = function(ply)
			
		end,
	},
  	[2] = {
		Name = "Padawan",
		numbers = false,
		Model = "models/animus/padawanv2/v2_padawan_02.mdl",
		Health = 1500,
		Armor = 20,
		Pay = 1,
		Speed = 1.6,
		Weapons = {"","","weapon_lightsaber"},
		Permission = 5,
		Commands = {""},
		Spawn = function(ply)
			
		end,
	},
  	[3] = {
		Name = "Knight",
		numbers = false,
		Model = "models/grealms/characters/jedibattlelord/jedibattlelord_04.mdl",
		Health = 2000,
		Armor = 20,
		Pay = 1,
		Speed = 1.6,
		Weapons = {"","","weapon_lightsaber"},
		Permission = 5,
		Commands = {"Start Simulation"},
		Spawn = function(ply)
			
		end,
	},
  	[4] = {
		Name = "Master",
		numbers = false,
		Model = "models/animus/jedirobesv2/v2_jedirobes_06.mdl",
		Health = 2500,
		Armor = 20,
		Pay = 1,
		Speed = 1.7,
		Weapons = {"","","weapon_lightsaber"},
		Permission = 5,
		Commands = {"Start Simulation"},
		Spawn = function(ply)
			
		end,
	},
  	
}
RegisterFaction(fac)