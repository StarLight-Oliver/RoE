local tbl = {}

tbl.name = "I need Health"
tbl.args = false
tbl.panel = false
tbl.cmd = "!medic"
tbl.svfunction = function(ply)
	net_SendEmote(ply, EMOTE_HEALTH)
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)