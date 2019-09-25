local notargetfunc = function(ply)
    ply:SetNoTarget(true)
end


local fac = {}
fac.Name = "CIS"
fac.Color = Color(169,169,169)
fac.Desc = "Roger Roger"
fac.BasePay = 10
fac.Tag = ""
fac.Hide = true
fac.RankID = {}
fac.Ranks = {
	[1] = {
		Name = "Battle Droid",
		numbers = false,
		Model = "models/tfa/comm/gg/pm_sw_droid_b1.mdl",
		Health = 1000,
		Armor = 50,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Spawn Droid Ship with AI", "Spawn Droid Ship"},
		Spawn = function(ply)
		ply:lfsSetAITeam(1)
		end,
	},
	[2] = {
		Name = "Battle Droid Commander",
		numbers = false,
		Model = "models/tfa/comm/gg/pm_sw_droid_commander.mdl",
		Health = 1500,
		Armor = 50,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Spawn Droid Ship with AI", "Spawn Droid Ship"},
		Spawn = function(ply)
		ply:lfsSetAITeam(1)
		end,
	},
	[3] = {
		Name = "Battle Droid Commando",
		numbers = false,
		Model = "models/tfa/comm/gg/pm_sw_droid_commando.mdl",
		Health = 3000,
		Armor = 50,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 3,
		Commands = {"Spawn Droid Ship with AI", "Spawn Droid Ship"},
		Spawn = function(ply)
		ply:lfsSetAITeam(1)
		end,
	},
	[4] = {
		Name = "Tactial Droid",
		numbers = false,
		Model = "models/tfa/comm/gg/pm_sw_droid_tactical.mdl",
		Health = 1200,
		Armor = 50,
		Pay = 1,
		Speed = 1,
		Weapons = {"","",""},
		Permission = 5,
		Commands = {"Spawn Droid Ship with AI", "Spawn Droid Ship"},
		Spawn = function(ply)
		ply:lfsSetAITeam(1)
		end,
	},
}
RegisterFaction(fac)