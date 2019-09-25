
PARTYUPGRADES = {
	
	[1] = {
		Name = "Health",
		Color = Color(255,1,1),
		Icon = {
			Mat = Material("doctor/upgrades/health.png"),
			Color = Color(200,200,200),
		},
		Price = function(lvl)
			return (lvl+3)^4
		end,
		Hooks = {
			OnPlayerSpawn = function(ply, lvl )
				ply:SetHealth( ply:Health() + lvl * 5)
				ply:SetMaxHealth( ply:Health() + lvl * 5)
			end
		},
	},
	[2] = {
		Name = "Shield",
		Color = Color(1,1,255),
		Icon = {
			Mat = Material("doctor/upgrades/shield.png"),
			Color = Color(200,200,200),
		},
		Price = function(lvl)
			return (lvl+3)^4
		end,
		Hooks = {
			OnPlayerSpawn = function(ply, lvl )
				ply:SetArmour( (ply.MaxArmor || 0 ) + lvl * 3)
			end
		},

	},
	[3] = {
		Name = "Damage", -- Do Later
		Color = Color(1,255,1),
		Icon = {
			Mat = Material("doctor/upgrades/damage.png"),
			Color = Color(150,150,150),
		},
		Price = function(lvl)
			return (lvl+3)^4
		end,
		Hooks = {
			OnPlayerSpawn = function(ply, lvl )
				ply:SetHealth( ply:Health() + lvl * 2)
				ply:SetMaxHealth( ply:Health() + lvl * 2)
			end
		},

	},
	[4] = {
		Name = "Party Size",
		Color = Color(25,255, 255),
		Icon = {
			Mat = Material("fives/upgrades/partyup.png"),
			Color = Color(255,255,255),
		},
		Price = function(lvl)
			return (lvl+10)^6
		end,
		Hooks = {
			GetPartySize= function(ply, lvl)
				ply.Size = ply.Size + 2*(lvl)
			end
		},

	}

}

function PartyUpgradeSys(ply,id, hook)
	local grades = GetUpgrades(id)
	for index, tbl in pairs(PARTYUPGRADES) do
		if tbl.Hooks[hook] then
			local grade  = 0
			for k,v in pairs(grades) do
				if v.type == tonumber(k) then
					grade = tonumber(v.up)
					break
				end
			end
			tbl.Hooks[hook](ply, id, grade)
		end
	end
end









if SERVER then
	util.AddNetworkString("party_invite")
	util.AddNetworkString("party_send_members")
	util.AddNetworkString("party_wipe")
	util.AddNetworkString("party_rankup")
	util.AddNetworkString("party_make_owner")
	util.AddNetworkString("party_leave")
	util.AddNetworkString("party_kick")
	util.AddNetworkString("party_toinvite")
	util.AddNetworkString("party_create")
	util.AddNetworkString("party_upgrades")


	net.Receive("party_upgrades", function(len, ply)
		local upgrade = net.ReadDouble()
		local id = ply:GetParty()[1].partyid
		local grades = GetUpgrades(id)
		if PARTYUPGRADES[upgrade] then
			local grade  = 0
			for k,v in pairs(grades) do
				if tonumber(v.type) == upgrade then
					grade = tonumber(v.up)
					break
				end
			end
			grade = grade + 1


			local price = PARTYUPGRADES[upgrade].Price(grade)
			if ply:GetMoney() < price then return end -- not enough moneyz
			ply:SetMoney(ply:GetMoney() - price)

			SetUpgrade(id, upgrade, grade)

			for index, pl in pairs(player.GetAll()) do
				if pl:GetParty() and pl:GetParty()[1].partyid == id then
					net_SendParty(pl)
				end
			end
		end
	end)

	
	function net_SendParty(ply)
		local val = ply:GetParty()
		if val then
			local members = GetPartyMembers(val[1].partyid)
			local grades  = GetUpgrades(val[1].partyid)
			net.Start("party_wipe")
				net.WriteTable(GetPartyFromID(val[1].partyid))
			net.Send(ply)
			for index, tbl in pairs(members) do
				timer.Simple(index/100, function()
					net.Start("party_send_members")
						net.WriteTable(tbl)
						net.WriteTable(GetCharNameFromID(tbl.id))
					net.Send(ply)
				end)
			end



			for index, tbl in pairs(grades) do
				timer.Simple(index/100, function()
					net.Start("party_upgrades")
						net.WriteTable(tbl)
					net.Send(ply)
				end)
			end


		else
			net.Start("party_wipe")
				net.WriteTable({})
			net.Send(ply)
		end
	end
	
	net.Receive("party_leave", function(len, ply)
		ply.leave = (ply.leave || 0 ) + 1
		if ply.leave >= 2 then
			ply.leave = 0
			local val = ply:GetParty()[1]
			if val.rank == "3" then
				ply:SLChatMessage({Color(21,125,100 ), "[Party-System] ", color_white, "You must make someone else the Owner before you leave"})
				return
			end
			sql.Query( "REMOVE FROM partymember WHERE id = " .. ply.Char.id ) 
			ply:SLChatMessage({Color(21,125,100 ), "[Party-System] ", color_white, "You have left your current party"})
		else
			ply:SLChatMessage({Color(21,125,100 ), "[Party-System] ", color_white, "Click leave again to confirm that you want to leave!"})
		end
	end)
	
	
	net.Receive("party_create", function(len , ply)
		local name = net.ReadString()
		local tag = ""
		for x = 1, 3 do
			local val = math.random(1, #name)
			tag = tag .. name[val]
		end
		tag = string.upper(tag)
		if ply:GetParty() then
			local val = ply:GetParty()[1]
			if val.rank == "3" then
				ply:SLChatMessage({Color(21,125,100 ), "[Party-System] ", color_white, "You must make someone else the Owner before you create a new Party"})
				return
			end
		end
		if ply:GetMoney() < 10000 then
			ply:SLChatMessage({Color(21,125,100 ), "[Party-System] ", color_white, "You must have 10000 credits to be able to create a new Party"})
			return 
		end
		
		local val = CreateParty(name, ply ,tag)
		if val then
			ply:TakeMoney(10000)
			net_SendParty(ply)
		end
	end)
	
	
	net.Receive("party_rankup", function(len, ply)
		local bool = net.ReadBool()
		local str = net.ReadString()
		local val = ply:GetParty()[1]
		local partid = val.partyid
		local members = GetPartyMembers(val.partyid)
		local mem = nil
		for index, tbl in pairs(members) do
			if tbl.id == str then
				mem = tbl
			end
		end
		if !mem then return end
		if tonumber(val.rank) > tonumber(mem.rank) then
			if bool then
				sql.Query( "UPDATE partymember SET rank = ".. 2 .." WHERE id = " .. mem.id)
			else
				sql.Query( "UPDATE partymember SET rank = ".. 1 .." WHERE id = " .. mem.id)
			end
		end
		for index, pl in pairs(player.GetAll()) do
			if pl.Char then
				if pl:GetParty()[1].partyid == val then
					net_SendParty(pl)
				end
			end
		end
	end)
	
	
	
	net.Receive("party_kick", function(len, ply)
		local str = net.ReadString()
		local val = ply:GetParty()[1]
		local partid = val.partyid
		local members = GetPartyMembers(val.partyid)
		local mem = nil
		for index, tbl in pairs(members) do
			if tbl.id == str then
				mem = tbl
			end
		end
		
		if !mem then return end
		if tonumber(val.rank) > tonumber(mem.rank) then
			sql.Query("DELETE FROM partymember WHERE id = " .. mem.id ) 
		end
		for index, pl in pairs(player.GetAll()) do
			if pl.Char then
				net_SendParty(pl)
			end
		end
	end)
	
	net.Receive("party_make_owner", function(len, ply)
		local str = net.ReadString()
		local val = ply:GetParty()[1]
		
		if  (ply.oldmem || "" ) != str then
			ply.partyowncount = 0
		end
		
		ply.partyowncount = (ply.partyowncount || 0 ) + 1
		
		
		if ply.partyowncount < 2 then
			ply.oldmem = str
			ply:SLChatMessage({Color(21,125,100 ), "[Party-System] ", color_white, "To Confirm that you want to make this person the owner of this party, click their name again"})
			return
		end
		
		ply.partyowncount = 0
		
		local partid = val.partyid
		local members = GetPartyMembers(val.partyid)
		local mem = nil
		for index, tbl in pairs(members) do
			if tbl.id == str then
				mem = tbl
			end
		end
		if !mem then return end
		if val.rank == "3" then
			sql.Query( "UPDATE partymember SET rank = ".. 3 .." WHERE id = " .. mem.id)
			sql.Query( "UPDATE partymember SET rank = ".. 2 .." WHERE id = " .. val.id)
		end
		for index, pl in pairs(player.GetAll()) do
			if pl.Char then
				if pl:GetParty()[1].partyid == val then
					net_SendParty(pl)
				end
			end
		end
		
	end)
	
	function net_inviteparty(id,ply, name)
		if !ply.invites then ply.invites = {} end
		ply.invites[id] = CurTime() + 30
		ply:SLChatMessage({Color(21,125,100 ), "[Party-System] ", color_white, "You have been invited to " .. name})
			
		net.Start("party_invite")
			net.WriteDouble(id)
			net.WriteString(name)
		net.Send(ply)
	end
	
	net.Receive("party_toinvite", function(len, ply)
		local ent = net.ReadEntity()
		if ent == ply then return end
		if !ent.Char then return end
		if ent:IsPlayer() then 
			local val = ply:GetParty()[1]
			if val.rank != "1" then
				local part = GetPartyFromID(val.partyid)
				local name = part.name
				local id = part.partyid
				net_inviteparty(id,ent, name)
			end
		end
	end)
	
	
	net.Receive("party_invite", function(len, ply)
		local id = net.ReadString()
		if ply.invites[id] then
			if ply.invites[id] > CurTime() then
				PartyJoin(ply, id)
				
				for index, pl in pairs(player.GetAll()) do
					if pl.Char then
						if pl:GetParty()[1].partyid == id then
							net_SendParty(pl)
						end
					end
				end
				
				
			end
		end
	end)
else

	invite = {}

	net.Receive("party_wipe", function(len,pl)
		local tbl = net.ReadTable()
		if tbl != {} then
			party_table = tbl
		else
			party_table = nil
		end
		party = {}
		party_stat = nil
		party_up = {}
	end)
	

	net.Receive("party_upgrades", function()
		party_up[ #party_up + 1] = net.ReadTable()
	end)

	net.Receive("party_send_members", function(len,pl)
		party[#party + 1] = net.ReadTable()
		local tbl = net.ReadTable()
		
		local stat = party[#party]
		if stat.id == LocalPlayer().Char.id then
			party_stat = stat
		end
		
		
		local name = ""
		local fac = FACTIONS[tbl.faction]
		
		if fac.Ranks[fac.RankID[tbl.rank]].numbers then 
			name =	fac.Tag .. " " .. tbl.rank .. " " .. tbl.numbers .. " " .. tbl.name
		elseif fac.Tag then
			name =	fac.Tag .. " " .. tbl.rank .. " " .. tbl.name
		else
			name = tbl.rank .. " " .. tbl.name
		end
		
		
		
		
		party[#party]["Name"] = name
	end)
	
	net.Receive("party_invite", function(len,pl)
		local id = net.ReadDouble()
		lastinvite = CurTime() + 30
		local name = net.ReadString()
		invite[id] ={name, CurTime() + 30}
	end)
	
	function net_joinparty(id)
		net.Start("party_invite")
			net.WriteString(id)
		net.SendToServer()
	end
	
	function net_inviteparty(id)
		net.Start("party_toinvite")
			net.WriteEntity(id)
		net.SendToServer()
	end
	
	function net_part_kick(info)
		net.Start("party_kick")
			net.WriteString(info.id)
		net.SendToServer()
	end
	
	function net_part_rankdown(info)
		net.Start("party_rankup")
			net.WriteBool(false)
			net.WriteString(info.id)
		net.SendToServer()
	end
	
	function net_part_rankup(info)
		net.Start("party_rankup")
			net.WriteBool(true)
			net.WriteString(info.id)
		net.SendToServer()
	end
	
	function net_part_makeowner(info)
		net.Start("party_make_owner")
			net.WriteString(info.id)
		net.SendToServer()
	end
	
	function net_leave_party()
		net.Start("party_leave")
		net.SendToServer()
	end
	
	function net_make_party(name)
		net.Start("party_create")
			net.WriteString(name)
		net.SendToServer()
	end	
end

