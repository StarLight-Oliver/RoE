local tbl = {}

tbl.name = "Start Simulation"
tbl.args = false
tbl.panel = false
tbl.cmd = "!startsim"
tbl.svfunction = function(ply)
	if SIMULATIONACTIVE then return end
	SIMULATIONTABLE[ply] = true
	SLChatMessage({Color(137,71,190 ), "[Sim System] ", color_white, "Player " .. ply:Name() .. " has started the simulation"})
	SIM_WAVE()
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)