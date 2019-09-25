
local fac = {}
fac.Name = "Delta Squad"
fac.Color = Color(139,69,19)
fac.Desc = "Delta Squad"
fac.BasePay = 15
fac.Tag = "RC"
fac.RankID = {}
fac.Ranks = {
	[1] = {
		Name = "1140",
		numbers = false,
		Model = "models/reizer_cgi_p2/rc_fixer_dirty/rc_fixer_dirty.mdl",
		Health = 150,
		Armor = 150,
		Pay = 1,
		Speed = 1.4,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {""},
		Spawn = function(ply)
			
		end,
	},
	[2] = {
		Name = "1262",
		numbers = false,
		Model = "models/reizer_cgi_p2/rc_scorch_dirty/rc_scorch_dirty.mdl",
		Health = 150,
		Armor = 150,
		Pay = 1,
		Speed = 1.4,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {""},
		Spawn = function(ply)
			
		end,
	},
	
	[3] = {
		Name = "1207",
		numbers = false,
		Model = "models/reizer_cgi_p2/rc_sev_dirty/rc_sev_dirty.mdl",
		Health = 150,
		Armor = 150,
		Pay = 1,
		Speed = 1.4,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {""},
		Spawn = function(ply)
			
		end,
	},
	
	[4] = {
		Name = "1138",
		numbers = false,
		Model = "models/reizer_cgi_p2/rc_boss_dirty/rc_boss_dirty.mdl",
		Health = 200,
		Armor = 150,
		Pay = 1,
		Speed = 1.4,
		Weapons = {"","",""},
		Permission = 4,
		Commands = {"Invite To Faction", "Rankup", "Remove from Faction", "Start Simulation"},
		Spawn = function(ply)
			
		end,
	},

}
RegisterFaction(fac)