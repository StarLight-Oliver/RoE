local tbl = {}

tbl.name = "[SEC] Strip Weapon and Comms"
tbl.args = false
tbl.panel = false
tbl.cmd = "!stripac"
tbl.svfunction = function(ply)
	local ent = ply:GetEyeTrace().Entity

	if IsValid(ent) and ent:IsVehicle() then
		print("YEAH")
		for index, pl in pairs(ents.FindInSphere(ent:GetPos(), 100)) do
			if pl:IsPlayer() and pl:InVehicle() then
				pl:ExitVehicle()
				ent = pl
			end
		end
	end


	if IsValid(ent) and ent:IsPlayer() and !ent:GetActiveWeapon():GetStripped() then
		if !ent.StripTable then ent.StripTable = {} end
		ent.StripTable[ply] = CurTime() + 5
		local count = 0 
		for ply, time in pairs(ent.StripTable) do
			if count >= STRIPREQUIRE then break end
			if time > CurTime() then
				count = count + 1
			else
				ent.StripTable[ply] = nil
			end
		end
		if SIMULATIONACTIVE then
        	SIMULATIONTABLE[ent] = nil
        	Check_SimTable()
   		 end
		ent:GetActiveWeapon():SetStripped(true)
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