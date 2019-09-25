
if SERVER then
	util.AddNetworkString("landing_page")
	
	function net_LandingPage(ply)
		if adminsittbl[ply:SteamID()] then
			timer.Simple(3, function()
				local self = ply
				
				local id = adminsittbl[ply:SteamID()].id
				local num = nil
				self.character = ply:GetCharacters()
				for index, tbl in pairs(self.character) do
					if tbl.id == id then
						num = index
					end
				end
				
				if !num then return end
				ply.Char = self.character[num]
				net.Start("Char_Loadout")
					net.WriteEntity(ply)
					net.WriteTable(self.character[num])
				net.Broadcast()
				net_CharGet(ply)
				
				ply.OutofRP = true
			
				timer.Simple(0.1, function()
					ply:KillSilent()
					ply:Spawn()
					ply:SetPos(Vector("-1846.824829 -7123.243164 -3597.976318"))
				end)
			end)
			return
		end
		net.Start("landing_page")
		net.Send(ply)
	end

else
	net.Receive("landing_page", function()
		landing_page()
	end)
end