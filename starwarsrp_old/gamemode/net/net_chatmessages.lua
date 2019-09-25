Chat_ENUMS = {
	[1] = function(ply, str)
		-- body
	end,
	[2] = "ooc",
	[3] = "looc",
	[4] = "faction",
}




if SERVER then
	util.AddNetworkString("ChatMessage")
    util.AddNetworkString("ChatMessageSound")

	function plymeta:SLChatMessage(tbl)
		net.Start("ChatMessage")
			net.WriteTable(tbl)
		net.Send(self)
	end
	
	function plymeta:SLChatMessageSound(tbl, sound)
	    net.Start("ChatMessageSound")
	        net.WriteTable(tbl)
	        net.WriteString(sound)
	    net.Send(self)
	end
	
	function SLChatMessageSound(tbl, sound)
		net.Start("ChatMessageSound")
			net.WriteTable(tbl)
			net.WriteString(sound)
		net.Broadcast()
	end
	
	function SLChatMessage(tbl)
		net.Start("ChatMessage")
			net.WriteTable(tbl)
		net.Broadcast()
	end


	local BadLetter = {
		['"'] = true,

		}

	function CleanUp(txt, ply)
		if BadLetter[string.sub(txt, 1, 1)] then
			txt = string.sub(txt, 2)
		end

		if BadLetter[string.sub(txt, #txt)] then
			txt = string.sub(txt, 1, #txt-1)
			
		end
		if string.sub(txt, 1, 1) == "/" or string.sub(txt, 1 ,1) == "!" then
			hook.Run( "PlayerSay", ply, txt )
			return false
		end
		txt = string.Replace(txt, "/59", ";")

	return txt 
end

	concommand.Add("comms", function(ply, cmd, args, str)
		str = CleanUp(str, ply) if !str then return end

		local inter = 1- INNERCOMMS:GetComms()
		if inter < 0.1 then inter = 0 end
		log(ply,"[Comms] " .. str)
		if (ply.muteged || 0) > CurTime() then return end
		local number = math.ceil(#str * inter)
		if number != 0 then
			for x = 1, number do
				local num = math.Rand(1, #str)
				str = string.SetChar(str, num, "*")
			end
		end
		local name = ply:Name()
		local number = math.ceil(#name * inter)
		if number != 0 then
			for x = 1, number do
				local num = math.Rand(1, #name)
				name = string.SetChar(name, num, "*")
			end
		end
		
		local tbl = {Color(200,200,0), "[Comms] ", color_white, name, ": " .. str}
		for x,y in pairs(player.GetAll()) do
			if y == ply then
				y:SLChatMessage({Color(200,200,0), "[Comms] ", color_white, ply:Name(), ": " ..str})
			elseif y.Char then
				if inter == 1 then continue end
				y:SLChatMessage(tbl)
			end
		end
	end)
	
	concommand.Add("ooc", function(ply, cmd, args, str)
		str = CleanUp(str, ply) if !str then return end
		log(ply,"[OOC] " .. str)
		if (ply.muteged || 0) > CurTime() then return end
		local name =  ply:Name()
		local tbl = {Color(255,255,255), "[OOC] ", name, ": " .. str}
		SLChatMessage(tbl)
	end)
	
	concommand.Add("looc", function(ply, cmd, args, str)
		str = CleanUp(str, ply) if !str then return end
		log(ply,"[LOOC] " .. str)
		if (ply.muteged || 0) > CurTime() then return end
		local name =  ply:Name()
		local tbl = {Color(200,200,200), "[LOOC] ", name, ": ", color_white, str}
		for x,y in pairs(ents.FindInSphere(ply:GetPos(), 2048)) do
			if y:IsPlayer()then
				y:SLChatMessage(tbl)
			end
		end
	end)
	
	concommand.Add("faction", function(ply, cmd, args, str)
		str = CleanUp(str, ply) if !str then return end
		local inter = 1- INNERCOMMS:GetComms()
		log(ply,"[Faction] " .. str)
		if (ply.muteged || 0) > CurTime() then return end
		local name =  ply:Name()
		local fac = ply.Char.faction
		local tbl = {FACTIONS[fac].Color, "[Faction] ", color_white, name, ": ", str}
		ply:SLChatMessage(tbl)
		
		local number = math.ceil(#str * inter)
		if number != 0 then
			for x = 1, number do
				local num = math.Rand(1, #str)
				str = string.SetChar(str, num, "*")
			end
		end
		local name = ply:Name()
		local number = math.ceil(#name * inter)
		if number != 0 then
			for x = 1, number do
				local num = math.Rand(1, #name)
				name = string.SetChar(name, num, "*")
			end
		end
		
		local tbl = {FACTIONS[fac].Color, "[Faction] ", color_white, name, ": " .. str}
		
		
		for x,y in pairs(player.GetAll()) do
			if y == ply then continue end
			if y.Char then
				if fac == y.Char.faction then
					y:SLChatMessage(tbl)
				end
			end
		end
	end)
	
	
	-- self.Char.faction
else

	net.Receive("ChatMessage", function(len,pl)
		if pl then return end
		local tbl = net.ReadTable()
		chat.AddText(unpack(tbl))
	end)

    net.Receive("ChatMessageSound", function(len,pl)
		if pl then return end
		local tbl = net.ReadTable()
		local sound = net.ReadString()
		chat.AddText(unpack(tbl))
		surface.PlaySound(sound)
	end)
end