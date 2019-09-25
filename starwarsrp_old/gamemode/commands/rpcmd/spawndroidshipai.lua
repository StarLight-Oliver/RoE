local tbl = {}

tbl.name = "Spawn Droid Ship with AI"
tbl.args = false
tbl.panel = false
tbl.cmd = "!spawndroidshipai"
tbl.svfunction = function(ply)
	local ent = ents.Create("lunasflightschool_vulturedroid")
		ent:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0,100))
		ent.Own = ply
		ent:Spawn()
		ent:Activate()
		ent:SetAI(true)
		ent:SetAITEAM(1)
		ent:SetHP(650)
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)