local tbl = {}

tbl.name = "The Player you are looking at needs ammo"
tbl.args = false
tbl.panel = false
tbl.cmd = "!thammo"
tbl.svfunction = function(ply)
	local ent = ply:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsPlayer() then
		net_SendEmote(ent, EMOTE_AMMO, ply)
	end
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)