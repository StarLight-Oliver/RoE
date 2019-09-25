

local tbl = {}

tbl.name = "Salute"
tbl.args = false
tbl.panel = false
tbl.cmd = "!salute"
tbl.svfunction = function(ply)
	ply:SetActAnim(ACT_GMOD_TAUNT_SALUTE)
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)


local tbl = {}

tbl.name = "Sit"
tbl.args = false
tbl.panel = false
tbl.cmd = "!sit"
tbl.svfunction = function(ply)
	ply:SetSitting(!ply.Sitting)
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)