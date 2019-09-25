local tbl = {}

tbl.name = "Toggle View"
tbl.args = false
tbl.panel = false
tbl.cmd = "!p"
tbl.svfunction = function(ply)
	net_SendPToggle(ply)
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)