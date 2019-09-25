local tbl = {}

tbl.name = "Enemy Spotted"
tbl.args = false
tbl.panel = false
tbl.cmd = "!enemy"
tbl.svfunction = function(ply)
	local pos = ply:GetEyeTrace().HitPos
	local ent = ents.Create("ogc_scout")
	ent:SetPos(pos - Vector(0,0,90))
	ent:SetModel("models/hunter/blocks/cube2x2x2.mdl")
	ent:Spawn()
	ent:Activate()
	timer.Simple(10, function()
		ent:Remove()
	end)
	
	timer.Simple(0.1, function()
		if IsValid(ent) then
			net_SendEmote(ent, EMOTE_ENEMY, ply)
		end
	end)
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)