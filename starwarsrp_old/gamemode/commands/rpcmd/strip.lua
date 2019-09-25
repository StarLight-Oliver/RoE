local tbl = {}

STRIPREQUIRE = 4

tbl.name = "Strip Weapon and Comms"
tbl.args = false
tbl.panel = false
tbl.cmd = "!stripen"
tbl.svfunction = function(ply)
	local ent = ply:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsPlayer() and !ent:GetActiveWeapon():GetStripped() then
		if !ent.StripTable then ent.StripTable = {} end
		ent.StripTable[ply] = CurTime() + 5
		local count = 0 
		for ply, time in pairs(ent.StripTable) do
			--if count >= STRIPREQUIRE then break end
			if time > CurTime() then
				count = count + 1
			else
				ent.StripTable[ply] = nil
			end
		end
		if count >= STRIPREQUIRE then
			ent:GetActiveWeapon():SetStripped(true)
		end
	elseif IsValid(ent) and ent:IsPlayer() then
		if ent.StripTable[ply] then
			if ent.StripTable[ply] > CurTime() then return end
		end
		ent:GetActiveWeapon():SetStripped(false)
	end
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)