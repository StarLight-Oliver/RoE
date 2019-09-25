local tbl = {}

tbl.name = "Defcon Increase"
tbl.args = false
tbl.panel = false
tbl.cmd = "!defconinc"
tbl.svfunction = function(ply)
	SetDefcon(math.Clamp(defconget() - 1, 1, 5))
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)