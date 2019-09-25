local tbl = {}

tbl.name = "Spawn Droid Ship"
tbl.args = false
tbl.panel = false
tbl.cmd = "!spawndroidship"
tbl.svfunction = function(ply)
	local ent = ents.Create("lunasflightschool_vulturedroid")
		ent:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0,100))
		ent.Own = ply
		ent:Spawn()
		ent:Activate()
		ent:SetAI(false)
		ent:SetAITEAM(1)
		ent:SetHP(650)
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)