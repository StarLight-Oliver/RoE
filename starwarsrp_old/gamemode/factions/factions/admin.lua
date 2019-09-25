local fac = {}


local facc = {}



local PERMS = {
	[1]	= {"Spectate", "Warn", "Gag", "Mute", "Strip Admin"},
	[2]	= {"Kick", "Rankup For Admins", "Event Character", "Rename", "Bring Out of RP", "Spawn NPC", "Talk to Player"},
	[3]	= {"Map Change", "Ban", "admin_kick", "Event Entities", "Char ID Modify", "NPC Modify",  "admin_gag", "admin_mute", },
	[4]	= {"BanID", "admin_name", "admin_kick", "admin_strip", "unban", "admin_warn", "admin_bringoutofrp"},
	[5]	= {"admin_ban", "Rankup"},
	[6]	= {},
	[7]	= {},
} 

local oldtbl = {}
local counter = 1
function GetCommands()
	local tbl = {"Map Change", "Event Entities","NPC Modify"} 
	for x = 1, counter do
		tbl = table.Add(tbl, PERMS[x])
	end
	counter = counter + 1
	return  tbl
end
fac.Name = "Staff"
fac.Color = Color(169,169,169)
fac.Desc = "staff"
fac.BasePay = 0
fac.Tag = "[Staff]"
fac.Hide = true
fac.RankID = {}
fac.Ranks = {
	[1] = {
		Name = "T-Mod",
		numbers = false,
		Model = "models/player/starlight/cultist_pm/cultist_pm.mdl",
		Health = 100,
		Armor = 20,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 0,
		Commands = GetCommands(),
		Spawn = function(ply) ply:GodEnable()
		end,
	},
	[2] = { -- Mod
		Name = "Orange",
		numbers = false,
		Model = "models/player/starlight/cultist_pm/cultist_pm.mdl",
		Health = 100,
		Armor = 20,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 4,
		Commands = GetCommands(),
		Spawn = function(ply) ply:GodEnable()
			
		
		end,
	},
	[3] = { -- Admin
		Name = "Green",
		numbers = false,
		Model = "models/player/starlight/cultist_pm/cultist_pm.mdl",
		Health = 100,
		Armor = 20,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 5,
		Commands = GetCommands(),
		Spawn = function(ply) ply:GodEnable()
		
		end,
	},
	[4] = { -- Super Admin
		Name = "Purple",
		numbers = false,
		Model = "models/player/starlight/cultist_pm/cultist_pm.mdl",
		Health = 100,
		Armor = 20,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 5,
		Commands = GetCommands(),
		Spawn = function(ply) ply:GodEnable()
		
		end,
	},
	[5] = {
		Name = "Red", -- Man
		numbers = false,
		Model = "models/player/starlight/cultist_pm/cultist_pm.mdl",
		Health = 100,
		Armor = 20,
		Pay = 1,
		Speed = 2,
		Weapons = {"","",""},
		Permission = 5,
		Commands = GetCommands(),
		Spawn = function(ply) ply:GodEnable()
		
		end,
	},
	[6] = {
		Name = "Blue", -- CD
		numbers = false,
		Model = "models/player/starlight/cultist_pm/cultist_pm.mdl",
		Health = 100,
		Armor = 20,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission =  5,
		Commands =GetCommands(),
		Spawn = function(ply) ply:GodEnable()
		
		end,
	},
	[7] = { -- F and CF
		Name = "Pink",
		numbers = false,
		Model = "models/player/starlight/cultist_pm/cultist_pm.mdl",
		Health = 100,
		Armor = 20,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 5,
		Commands = GetCommands(),
		Spawn = function(ply) ply:GodEnable()
		
		end,
	},
}
RegisterFaction(fac)