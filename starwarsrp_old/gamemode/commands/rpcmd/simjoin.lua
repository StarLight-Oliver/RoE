local tbl = {}

tbl.name = "Join Simulation"
tbl.args = false
tbl.panel = false
tbl.cmd = "!joinsim"
tbl.svfunction = function(ply)
	SIMULATIONTABLE[ply] = true
	SLChatMessage({Color(137,71,190 ), "[Sim System] ", color_white, "Player " .. ply:Name() .. " has joined the simulation!"})
	if SIMULATIONACTIVE then
		for index, ent in pairs(ents.GetAll()) do
			if ent:IsNPC() then
				if ent.siment then
					ent:AddEntityRelationship( ply, D_HT, 99 )
				end
			end
		end
	end
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)