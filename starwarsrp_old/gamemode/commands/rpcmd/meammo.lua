local tbl = {}

tbl.name = "I need Ammo"
tbl.args = false
tbl.panel = false
tbl.cmd = "!ammo"
tbl.svfunction = function(ply)
	net_SendEmote(ply, EMOTE_AMMO)
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)