local tbl = {}

tbl.name = "Ban"
tbl.args = false
tbl.panel = false
tbl.cmd = "!ban"
tbl.svfunction = function(ply)
	ply.expectingban = true
end
tbl.clfunction = function(ply)
	 BanMenu()
end
RegisterRPCommands(tbl)
local mat = Material("star/cw/basehexagons.png")
local mat2 = Material("star/cw/headerv2.png")
local w,h = 500, 600

banpanel = {}

function BanMenu()
	banMenuDerma = vgui.Create("DFrame")
	banMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	banMenuDerma:SetSize(w,h)
	banMenuDerma:MakePopup()
	banMenuDerma:SetDraggable(false)
	banMenuDerma:SetTitle("")
	banMenuDerma:ShowCloseButton(false)
	banMenuDerma.lerp = 0
	banMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(mat2)
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "List of Players", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #banpanel do
					if !IsValid(banpanel[x]) then continue end
					banpanel[x]:Remove()
					banpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		faclist = vgui.Create("DScrollPanel", banMenuDerma )
		faclist:SetPos( 0, 65 )
		faclist:SetSize( w + 30, h-135 )
		faclist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		faclist.VBar.Paint = function() end
		faclist.VBar.btnUp.Paint = function() end
		faclist.VBar.btnDown.Paint = function() end
		faclist.VBar.btnGrip.Paint = function() end
	end)
	local xx = 1
	for str,fac in pairs(player.GetAll()) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			banpanel[x] = faclist:Add("DButton")
			banpanel[x]:SetPos(0, 45 * (x-1))
			banpanel[x]:SetSize(w + 30, 40)
			banpanel[x]:SetText("")
			banpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText( fac:Name() , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			banpanel[x].DoClick = function()
				banMenuDerma.back = true
				banMenuDerma.lerp = 0
				bansub(fac)
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		banbackbutton = vgui.Create("DButton", banMenuDerma)
		banbackbutton:SetPos(0, h- 65)
		banbackbutton:SetSize(w, 60)
		banbackbutton.DoClick = function()
			banMenuDerma.back = true
			banMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		banbackbutton:SetText("")
		banbackbutton.Paint = function(self,w,h)
			surface.SetDrawColor(255,255,255,255)
			if self.Hovered then surface.SetDrawColor(200,200,200,255) end
			surface.SetMaterial(mat2)
			surface.DrawTexturedRect(0,0,w,h)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawOutlinedRect( 0, 0, w, h)
			draw.SimpleText( "Back", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		end
	end)
	
end

function bansub(fac)
	local col = Color(0,0,0)
	partycreatepanel = vgui.Create("DFrame")
	partycreatepanel:SetSize(400,370)
	partycreatepanel:Center()
	partycreatepanel:SetTitle("")
	partycreatepanel:ShowCloseButton(false)
	partycreatepanel:SetDraggable(false)
	partycreatepanel:MakePopup()
	partycreatepanel.Paint = function(self, w,h)
		
		surface.SetDrawColor(150,150,150, 200)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)
	
		surface.SetDrawColor(255,255,255, 255)
		local b =  w-20
		local c,d = w-20, 50
		surface.DrawTexturedRectUV(10,10,w-20,50,0,0,c/b,d/b)

		draw.SimpleText("Ban " .. fac:Name() , "ServerFont", w/2, 35,col, 1, 1 )
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	
	textentry = vgui.Create("DTextEntry", partycreatepanel)
	textentry:SetSize(380,50)
	textentry:SetPos(10, 70)
	textentry:SetText("Reason")
	textentry:SetFont("PlayerFont")
	
	timeentry = vgui.Create("DTextEntry", partycreatepanel)
	timeentry:SetSize(380,50)
	timeentry:SetPos(10, 130)
	timeentry:SetText("Time (Number)")
	timeentry:SetFont("PlayerFont")
	
	dayentry = vgui.Create("DTextEntry", partycreatepanel)
	dayentry:SetSize(380,50)
	dayentry:SetPos(10, 190)
	dayentry:SetText("Time Type (m,h, d, mon, yr)")
	dayentry:SetFont("PlayerFont")
	
	button = vgui.Create("DButton", partycreatepanel)
	button:SetSize(380,50)
	button:SetPos(10,250)
	button:SetText("")
	button.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Ban Player", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		local rea = textentry:GetValue()
		local tim = timeentry:GetValue()
		local typ = dayentry:GetValue()
		if rea == "Reason" then return end
		if tim == "Time (Number)" then return end
		if typ == "Time Type (m,h, d, mon, yr)" then return end
		net_ban(fac, rea, tim, typ)
		
		partycreatepanel:Remove()
		timer.Simple(0.2, function()
			BanMenu()
		end)
	end
	
	
	local button2 = vgui.Create("DButton", partycreatepanel)
	button2:SetSize(380,50)
	button2:SetPos(10,310)
	button2:SetText("")
	button2.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Back", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button2.DoClick = function()
		partycreatepanel:Remove()
		BanMenu()
	end
	
	 
end


if SERVER then
	util.AddNetworkString("admin_ban")
	typc = {
		["m"] = 1,
		["h"] = 60,
		["d"] = 1440,
		["yr"] = 525600,
	}
	net.Receive("admin_ban", function(len , ply)
		if !ply.expectingban then return end
		ply.expectingban = nil
		local pl = net.ReadEntity()
		local reason = net.ReadString()
		local time = tonumber(net.ReadString())
		local typ = typc[net.ReadString()]
		if !typ then return end
		typ = typ * 60
		if OGCCW.Staff[pl:SteamID64()] then
			if !ply:HasCommand("admin_ban") then
				return
			end
		end 
		local val = time * typ
		local name = pl:Name() .. " (" .. pl:SteamID() .. ")"
		CustomBan(pl:SteamID(), val, reason, ply)
		pl:Kick(reason)
		log(adminply, ply:Name() .. " has banned **" .. name .. "** for " .. val .. " seconds with the reason of __" .. reason .. "__", logs["admin"] )
	end)

else

	function net_ban(ply, reason, time, typ)
		net.Start("admin_ban")
			net.WriteEntity(ply)
			net.WriteString(reason)
			net.WriteString(time)
			net.WriteString(typ)
		net.SendToServer()
	end

end