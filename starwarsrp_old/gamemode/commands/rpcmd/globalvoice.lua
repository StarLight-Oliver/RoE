local tbl = {}

tbl.name = "Toggle Global Voice"
tbl.args = false
tbl.panel = false
tbl.cmd = "!gvoice"
tbl.svfunction = function(ply)
	ply.broadcastingvoice = !ply.broadcastingvoice
end
tbl.clfunction = function(ply)
	ply.broadcastingvoice = !ply.broadcastingvoice
end
RegisterRPCommands(tbl)

hook.Add("PlayerDeath", "globalvoice", function(ply)
	ply.broadcastingvoice = false
end)

hook.Add("PlayerSilentDeath", "globalvoice", function(ply)
	ply.broadcastingvoice = false
end)
