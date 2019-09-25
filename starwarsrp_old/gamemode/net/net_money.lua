if SERVER then
	util.AddNetworkString("money_send")
	
	function net_loadmoney(ply)
		local money = ply:GetMoney()
		net.Start("money_send")
			net.WriteDouble(ply.Char.id)
			net.WriteDouble(money)
		net.Broadcast()
		
		
		timer.Create("playertimer" .. ply:SteamID(), 60 * 30, 0 ,function()
			if IsValid(ply) then 
				local num = FACTIONS[ply.Char.faction].BasePay
				local tim = FACTIONS[ply.Char.faction].Ranks[  FACTIONS[ply.Char.faction].RankID[ply.Char.rank] ].Pay
				if ply:GetMember() then
					tim = tim + 0.2
				end
				if ply:GetParty() then
					tim = tim + 0.5
				end			
				
				num = num* tim 
				ply:AddMoney(num)
				networkmoney(ply)
			end
		end)
		
	end
	
	function plymeta:TakeMoney(num)
		local mon = self:GetMoney()
		mon = mon - num
		self:SetMoney(mon)
	end
	
	function networkmoney(ply)
		local money = ply:GetMoney()
		net.Start("money_send")
			net.WriteDouble(ply.Char.id)
			net.WriteDouble(money)
		net.Broadcast()
	end
	
	function plymeta:AddMoney(num)
		local increase = 1
		
		local mon = self:GetMoney()
		mon = mon + (num*increase)
		self:SLChatMessage({Color(255,100,100), "[Bank Account] ", color_white, num * increase .. " credits have been added to your account!"})
				
		self:SetMoney(mon)
	end
	
	function net_syncmoney(ply)
		for x,pl in pairs(player.GetAll()) do
			if pl.Char then
				timer.Simple(x/100, function()
					local money = pl:GetMoney()
					net.Start("money_send")
						net.WriteDouble(tonumber(pl.Char.id) )
						net.WriteDouble(money)
					net.Send(ply)
				end)
			end
		end
	end
	
else
	money = money || {}
	function plymeta:GetMoney()
		if !self.Char then return 0 end
		if money[self.Char.id] then
			return money[self.Char.id]
		else
			return 0
		end
	end
	
	net.Receive("money_send", function()
		local id = net.ReadDouble()
		local mon = net.ReadDouble()
		money[tostring(id)] = mon
	end)
	
end

function plymeta:GetPrice(num)
	local increase = 1
		
	return (num*increase)
end