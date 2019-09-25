
local fac = {}
fac.Name = "501st Legion"
fac.Color = Color(0,0,255)
fac.Desc = "501st legion"
fac.BasePay = 10
fac.Tag = "501st"
fac.RankID = {}
fac.Ranks = {
	[1] = {
		Name = "PVT",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_trp/501_trp.mdl",
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
		Name = "PFC",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_trp/501_trp.mdl",
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
		Name = "SPC",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_trp/501_trp.mdl",
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
		Name = "CPL",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_sgt/501_sgt.mdl",
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
		Name = "SGT",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_d1/501_d1.mdl",
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
		Name = "SSG",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_d2/501_d2.mdl",
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
		Name = "SFC",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_d3/501_d3.mdl",
		Health = 160,
		Armor = 50,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
		
		end,
	},
	[8] = {
		Name = "MSG",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_d4/501_d4.mdl",
		Health = 170,
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
		Name = "1SG",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_d5/501_d5.mdl",
		Health = 180,
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
		Name = "SGM",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_d6/501_d6.mdl",
		Health = 190,
		Armor = 65,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
		
		end,
	},
	[11] = {
		Name = "2LT",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_lt/501_lt.mdl",
		Health = 200,
		Armor = 70,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Start Simulation"},
		Spawn = function(ply)
		
		end,
	},
	[12] = {
		Name = "1LT",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_lt/501_lt.mdl",
		Health = 225,
		Armor = 75,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Start Simulation"},
		Spawn = function(ply)
		
		end,
	},
	[13] = {
		Name = "CPT",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_cpt/501_cpt.mdl",
		Health = 250,
		Armor = 80,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
		
		end,
	},
	[14] = {
		Name = "MAJ",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_maj/501_maj.mdl",
		Health = 275,
		Armor = 85,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
		
		end,
	},
	[15] = {
		Name = "LTC",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_maj/501_maj.mdl",
		Health = 300,
		Armor = 90,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
		
		end,
	},
	[16] = {
		Name = "COL",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_col/501_col.mdl",
		Health = 325,
		Armor = 95,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
		
		end,
	},
	[17] = {
		Name = "CMD",
		numbers = true,
		Model = "models/reizer_cgi_p2/501_col/501_col.mdl",
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
		Model = "models/reizer_cgi_p2/501_rex/501_rex.mdl",
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
}
RegisterFaction(fac)