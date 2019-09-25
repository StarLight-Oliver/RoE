
if SERVER then
	util.AddNetworkString("rankup_player_sendinfo")
	util.AddNetworkString("request_join_faction")
	util.AddNetworkString("request_invite_faction")
	net.Receive("rankup_player_sendinfo", function(len, ply)
		if ply.ExpectingRankuprequest then -- Someone is trying to force a rankup
			local rank = net.ReadString()
			local ent = net.ReadEntity()
			local fac = ply.Char.faction
			if ent.Char.faction != fac then return end
			if FACTIONS[fac].RankID[rank] then
				if FACTIONS[fac].RankID[ent.Char.rank] >= FACTIONS[fac].RankID[ply.Char.rank] then return end
				if FACTIONS[fac].RankID[rank] < FACTIONS[fac].RankID[ply.Char.rank] then
					local id = ent.Char.id
					ply:ChatPrint("Updating his rank")
					ent:ChatPrint("Your rank is being updated")
					log(ply, ply:Name() .. " has updated " .. ent:Name() .. " rank to " .. rank)
					UpdateCharacter(id,"rank", rank)
					ply.ExpectingRankuprequest = false
				end
			end
		end
	end)
	
	net.Receive("request_join_faction", function(len, ply)
		local fac = net.ReadString()
		if (FACTIONINVITES[fac][ply.Char.id] || 0 ) > CurTime() then
			local rank =  FACTIONS[fac].Ranks[1].Name
			local id = ply.Char.id
			UpdateCharacter(id,"faction", fac)
			UpdateCharacter(id,"rank", rank)
			ply:KillSilent()
			ply:Respawn()
		end
	end)
	
	net.Receive("request_invite_faction", function(len, ply)
		if ply.expectinginvite then
			ply.expectinginvite = false
			local ent = net.ReadEntity()
			if ent.Char then
				local fac = ply.Char.faction
				ent:SLChatMessage({Color(100,200,200), "[Factions] ", color_white, ply:Name(), " has invited you to join " .. fac .. ", You have 30 seconds till the invite ends" })
				FACTIONINVITES[fac][ent.Char.id] = CurTime() + 30
			end
		end
	end)
	
	
else

	function net_com_rankup(ent, rank)
		net.Start("rankup_player_sendinfo")
			net.WriteString(rank)
			net.WriteEntity(ent)
		net.SendToServer()
	end

	function net_request_fac_join(fac)
		net.Start("request_join_faction")
			net.WriteString(fac)
		net.SendToServer()
	
	end
	
	function net_request_fac_invite(ent)
		net.Start("request_invite_faction")
			net.WriteEntity(ent)
		net.SendToServer()
	end
end
