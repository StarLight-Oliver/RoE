
local fac = {}
fac.Name = "Medical Brigade"
fac.Color = Color(0,0,255)
fac.Desc = "The Best Medics of the Clone Army"
fac.BasePay = 10
fac.Tag = "MED"
fac.RankID = {}
fac.Ranks = {
	[1] = {
		Name = "PVT",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
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
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
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
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
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
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
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
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 140,
		Armor = 40,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 1,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
			ply:SetBodyGroups("0001000")
		end,
	},
	[6] = {
		Name = "SSG",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 150,
		Armor = 45,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
			ply:SetBodyGroups("0001000")
		end,
	},
	[7] = {
		Name = "SFC",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 160,
		Armor = 50,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
			ply:SetBodyGroups("0001000")
		end,
	},
	[8] = {
		Name = "MSG",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 170,
		Armor = 55,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
			ply:SetBodyGroups("0001000")
		end,
	},
	[9] = {
		Name = "1SG",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 180,
		Armor = 60,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
			ply:SetBodyGroups("0001000")
		end,
	},
	[10] = {
		Name = "SGM",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 190,
		Armor = 65,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 2,
		Commands = {"Invite to Faction"},
		Spawn = function(ply)
			ply:SetBodyGroups("0001000")
		end,
	},
	[11] = {
		Name = "2LT",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 200,
		Armor = 70,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Start Simulation"},
		Spawn = function(ply)
			ply:SetBodyGroups("0011000")
		end,
	},
	[12] = {
		Name = "1LT",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 225,
		Armor = 75,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Start Simulation"},
		Spawn = function(ply)
			ply:SetBodyGroups("0011000")
		end,
	},
	[13] = {
		Name = "CPT",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 250,
		Armor = 80,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
			ply:SetBodyGroups("0111000")
		end,
		},
	[14] = {
		Name = "MAJ",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 275,
		Armor = 85,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
			ply:SetBodyGroups("0111000")
		end,
		},
	[15] = {
		Name = "LTC",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 300,
		Armor = 90,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
			ply:SetBodyGroups("0111000")
		end,
		},
	[16] = {
		Name = "COL",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 325,
		Armor = 95,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
			ply:SetBodyGroups("0111000")
		end,
		},
	[17] = {
		Name = "CMD",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 350,
		Armor = 100,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
			ply:SetBodyGroups("1111000")
		end,
		},
	[18] = {
		Name = "BCMD",
		numbers = true,
		Model = "models/reizer_cgi_p2/clone_med/clone_med.mdl",
		Health = 400,
		Armor = 100,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
			ply:SetBodyGroups("1111000")
		end,
	},
}
RegisterFaction(fac)