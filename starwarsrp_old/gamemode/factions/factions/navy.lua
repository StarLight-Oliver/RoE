
local fac = {}
fac.Name = "Republic Navy"
fac.Color = Color(47,79,79)
fac.Desc = "Make sure the ship is flown correctly"
fac.BasePay = 20
fac.Tag = false
fac.RankID = {}
fac.Ranks = {
	[1] = {
		Name = "Junior Crewman",
		numbers = false,
		Model = "models/player/clone/ifnbnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Defcon Decrease", "Defcon Increase"},
		Spawn = function(ply)
			ply:SetBodyGroups("003")
		end,
	},	
	[2] = {
		Name = "Crewman",
		numbers = false,
		Model = "models/player/clone/ifnbnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Defcon Decrease", "Defcon Increase"},
		Spawn = function(ply)
			ply:SetBodyGroups("003")
		end,
	},
	[3] = {
		Name = "Able Crewman",
		numbers = false,
		Model = "models/player/clone/ifnbnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Defcon Decrease", "Defcon Increase"},
		Spawn = function(ply)
			ply:SetBodyGroups("003")
		end,
	},
	[4] = {
		Name = "Leading Crewman",
		numbers = false,
		Model = "models/player/clone/ifnbnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Defcon Decrease", "Defcon Increase"},
		Spawn = function(ply)
			ply:SetBodyGroups("003")
		end,
	},
	[5] = {
		Name = "Chief",
		numbers = false,
		Model = "models/player/clone/ifnbnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Defcon Decrease", "Defcon Increase"},
		Spawn = function(ply)
			
		end,
	},
	[6] = {
		Name = "Master Chief",
		numbers = false,
		Model = "models/player/clone/ifnbnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Defcon Decrease", "Defcon Increase"},
		Spawn = function(ply)
			
		end,
	},
	[7] = {
		Name = "Midshipman",
		numbers = false,
		Model = "models/player/clone/ifnbnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Defcon Decrease", "Defcon Increase"},
		Spawn = function(ply)
			
		end,
	},
	[8] = {
		Name = "Ensign",
		numbers = false,
		Model = "models/player/clone/ifngnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Invite To Faction", "Defcon Decrease", "Defcon Increase", "Start Simulation"},
		Spawn = function(ply)
			ply:SetBodyGroups("003")
		end,
	},
	[9] = {
		Name = "Acting Sub-Lieutenant",
		numbers = false,
		Model = "models/player/clone/ifngnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Start Simulation", "Defcon Decrease", "Defcon Increase"},
		Spawn = function(ply)
			ply:SetBodyGroups("003")
		end,
	},
	[10] = {
		Name = "Sub Lieutenant",
		numbers = false,
		Model = "models/player/clone/ifngnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Start Simulation", "Defcon Decrease", "Defcon Increase"},
		Spawn = function(ply)
			ply:SetBodyGroups("003")
		end,
	},
	[11] = {
		Name = "Lieutenant",
		numbers = false,
		Model = "models/player/clone/ifngnaval.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Start Simulation", "Defcon Decrease", "Defcon Increase"},
		Spawn = function(ply)
		
		end,
	},
	[12] = {
		Name = "Captain",
		numbers = false,
		Model = "models/player/bridgestaff/cgibridgestaff.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation", "Defcon Decrease", "Defcon Increase", "Toggle Global Voice"},
		Spawn = function(ply)
			
		end,
	},
	[13] = {
		Name = "LT Commander",
		numbers = false,
		Model = "models/player/bridgestaff/cgibridgestaff.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation", "Defcon Decrease", "Defcon Increase", "Toggle Global Voice"},
		Spawn = function(ply)
			
		end,
	},
	[14] = {
		Name = "Commander",
		numbers = false,
		Model = "models/player/bridgestaff/cgibridgestaff.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation", "Defcon Decrease", "Defcon Increase", "Toggle Global Voice"},
		Spawn = function(ply)
			
		end,
	},
	[15] = {
		Name = "Commodore",
		numbers = false,
		Model = "models/player/bridgestaff/cgibridgestaff.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation", "Defcon Decrease", "Defcon Increase", "Toggle Global Voice"},
		Spawn = function(ply)
			
		end,
	},
	[16] = {
		Name = "Rear Admiral",
		numbers = false,
		Model = "models/player/bridgestaff/cgibridgestaff.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation", "Defcon Decrease", "Defcon Increase", "Toggle Global Voice"},
		Spawn = function(ply)
			
		end,
	},
	[17] = {
		Name = "Vice Admiral",
		numbers = false,
		Model = "models/player/bridgestaff/cgibridgestaff.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation", "Defcon Decrease", "Defcon Increase", "Toggle Global Voice"},
		Spawn = function(ply)
		
		end,
	},
	[18] = {
		Name = "Admiral",
		numbers = false,
		Model = "models/player/wullf/wullf.mdl",
		Health = 100,
		Armor = 10,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation", "Defcon Decrease", "Defcon Increase", "Toggle Global Voice"},
		Spawn = function(ply)
		
		end,
	},
}
RegisterFaction(fac)