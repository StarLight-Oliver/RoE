local tbl = {}

tbl.name = "The Player you are looking at needs health"
tbl.args = false
tbl.panel = false
tbl.cmd = "!thmedic"
tbl.svfunction = function(ply)
	local ent = ply:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsPlayer() then
		net_SendEmote(ent, EMOTE_HEALTH, ply)
	end
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)