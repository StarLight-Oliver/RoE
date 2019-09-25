local tbl = {}

tbl.name = "Defcon Decrease"
tbl.args = false
tbl.panel = false
tbl.cmd = "!defcondec"
tbl.svfunction = function(ply)
	SetDefcon(math.Clamp(defconget() + 1, 1, 5))
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)