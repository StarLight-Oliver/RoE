
local fac = {}
fac.Name = "Starfighter Corps"
fac.Color = Color(169,169,169)
fac.Desc = "Pilots of the Republic"
fac.BasePay = 10
fac.Tag = "Pilot"
fac.RankID = {}
fac.Ranks = {
	[1] = {
		Name = "Airman Basic",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot/clone_pilot.mdl",
		Health = 100,
		Armor = 20,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 1,
		Commands = {},
		Spawn = function(ply)
		
		end,
	},
	[2] = {
		Name = "Airman",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot/clone_pilot.mdl",
		Health = 110,
		Armor = 25,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 1,
		Commands = {},
		Spawn = function(ply)
		
		end,
	},
	[3] = {
		Name = "Leading Airman",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot/clone_pilot.mdl",
		Health = 120,
		Armor = 30,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 1,
		Commands = {},
		Spawn = function(ply)
		
		end,
	},
	[4] = {
		Name = "FCPL",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot/clone_pilot.mdl",
		Health = 130,
		Armor = 35,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 1,
		Commands = {},
		Spawn = function(ply)
		
		end,
	},
	[5] = {
		Name = "FSGT",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot_sgt/clone_pilot_sgt.mdl",
		Health = 140,
		Armor = 40,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 1,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
		
		end,
	},
	[6] = {
		Name = "Flight Chief",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot_sgt/clone_pilot_sgt.mdl",
		Health = 150,
		Armor = 45,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
		
		end,
	},
	[7] = {
		Name = "Officer Cadet",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot_sgt/clone_pilot_sgt.mdl",
		Health = 160,
		Armor = 50,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {},
		Spawn = function(ply)
		
		end,
	},
	[8] = {
		Name = "WO",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot_sgt/clone_pilot_sgt.mdl",
		Health = 180,
		Armor = 55,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
		
		end,
	},
	[9] = {
		Name = "CWO",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot_sgt/clone_pilot_sgt.mdl",
		Health = 190,
		Armor = 60,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
		
		end,
	},
	[10] = {
		Name = "Flight Officer",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot_lt/clone_pilot_lt.mdl",
		Health = 200,
		Armor = 70,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
		
		end,
	},
	[11] = {
		Name = "Flight Lieutenant",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot_lt/clone_pilot_lt.mdl",
		Health = 225,
		Armor = 100,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Start Simulation"},
		Spawn = function(ply)
		
		end,
	},
	[12] = {
		Name = "Flight Captain",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot_cpt/clone_pilot_cpt.mdl",
		Health = 275,
		Armor = 85,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Start Simulation"},
		Spawn = function(ply)
		
		end,
	},
	[13] = {
		Name = "Squadron Leader",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot2/clone_pilot2.mdl",
		Health = 350,
		Armor = 100,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
		
		end,
		},
	[14] = {
		Name = "Wing Commander",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot2/clone_pilot2.mdl",
		Health = 400,
		Armor = 100,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
		
		end,
		},
/*	[15] = {
		Name = "Group Captain",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot_cpt/clone_pilot_cpt.mdl",
		Health = 300,
		Armor = 90,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
		
		end,
		},
	[16] = {
		Name = "Command Leader",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_pilot_cpt/clone_pilot_cpt.mdl",
		Health = 400,
		Armor = 100,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
		
		end,
		},
	[17] = {
		Name = "Air Commodore",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_cmd/clone_cmd.mdl",
		Health = 350,
		Armor = 100,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
		
		end,
		},
	[18] = {
		Name = "BCMD",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_cmd/clone_cmd.mdl",
		Health = 400,
		Armor = 100,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
		
		end,
	},*/
}
RegisterFaction(fac)