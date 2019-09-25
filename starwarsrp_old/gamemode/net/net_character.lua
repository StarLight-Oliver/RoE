OGCCW.CHAR = {}

if SERVER then
	util.AddNetworkString("Char_GetCharacters")
	util.AddNetworkString("Char_Create")
	util.AddNetworkString("Char_Loadout")
	util.AddNetworkString("Char_Delete")
	util.AddNetworkString("Char_Wipe")
	
	net.Receive("Char_GetCharacters", function(len,pl)
		net_CharGet(pl)
	end)
	
	function net_CharGet(ply)
		local char = ply:GetCharacters()
		ply.character = char
		net.Start("Char_Wipe")
		net.Send(ply)
		for x,y in pairs(ply.character) do
			timer.Simple(x/10, function()
				net.Start("Char_GetCharacters")
					net.WriteTable(y)
					net.WriteEntity(ply)
				net.Send(ply)
			end)
		end
	end
	
	net.Receive("Char_Loadout", function(len,pl)
		local num = net.ReadDouble()
		net_ChatLoadout(pl, num)
	end)
	
	net.Receive("Char_Create", function(len,pl)
		local str = net.ReadString()
		if !str then return end
		if type(str) != "string" then return end
		CreateCharacter(str,pl)
		pl.character = pl:GetCharacters()
	end)
	concommand.Add("create_staff_character", function(ply)
		print("Hi")
		timer.Simple(0.2, function()
			RequestStaffTable()
		end)
		if OGCCW.Staff then
			print("here?")
			if !table.HasValue(OGCCW.Staff,ply:SteamID64()) then
				return
			end
		else
			return
		end
		print("Hi")
		local str = GenerateName(math.random(4, 8))
		CreateCharacter(str,ply, "Staff")
		net_CharGet(ply)
	end)
	
	
	function net_ChatLoadout(ply, num)
		local self = ply
		if !self.character then self.character = ply:GetCharacters() end
		if self.character[num] then
			if self.character[num].faction == "Staff" then
				timer.Simple(0.2, function()
					RequestStaffTable()
				end)
			
				if OGCCW.Staff then
					if !table.HasValue(OGCCW.Staff,ply:SteamID64()) then
						return
					end
				else
					return
				end
			end
			ply.Char = self.character[num]
			net.Start("Char_Loadout")
				net.WriteEntity(ply)
				net.WriteTable(self.character[num])
			net.Broadcast()
			
			ply:KillSilent()
			ply:Spawn()
			net_CharGet(ply)
		end
	end
else
	net.Receive("Char_Loadout", function(len,pl)
		local ply = net.ReadEntity()
		local tbl = net.ReadTable()
		ply.Char = tbl
	end)
	
	net.Receive("Char_GetCharacters", function(len , pl)
		local tbl = net.ReadTable()
		local ply = net.ReadEntity()
		if !ply.character then 
			ply.character = {tbl}
		else
			ply.character[#ply.character + 1] = tbl
		end
	end)
	
	net.Receive("Char_Wipe", function(len , pl)
		if IsValid(LocalPlayer()) then
			LocalPlayer().character = nil
		end
	end)
	function Char_Create(name)
		net.Start("Char_Create")
			net.WriteString(name)
		net.SendToServer()
	end
	
	function Char_Net_Loadout(num)
		net.Start("Char_Loadout")
			net.WriteDouble(num)
		net.SendToServer()
	end
end