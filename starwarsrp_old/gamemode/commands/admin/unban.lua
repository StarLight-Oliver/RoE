	local tbl = {}

tbl.name = "BanID"
tbl.args = false
tbl.panel = false
tbl.cmd = "!banid"
tbl.svfunction = function(ply)
	ply.expectingbanid = true
end
tbl.clfunction = function(ply)
	banidsub()
end
RegisterRPCommands(tbl)

local mat = Material("star/cw/basehexagons.png")
local w,h = 500, 600

function banidsub(fac)
	local col = Color(0,0,0)
	partycreatepanel = vgui.Create("DFrame")
	partycreatepanel:SetSize(400,430)
	partycreatepanel:Center()
	partycreatepanel:SetTitle("")
	partycreatepanel:ShowCloseButton(false)
	partycreatepanel:SetDraggable(false)
	partycreatepanel:MakePopup()
	partycreatepanel.Paint = function(self, w,h)
		
		surface.SetDrawColor(150,150,150, 200)
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)
	
		surface.SetDrawColor(255,255,255, 255)
		local b =  w-20
		local c,d = w-20, 50
		surface.DrawTexturedRectUV(10,10,w-20,50,0,0,c/b,d/b)

		draw.SimpleText("Ban SteamID", "ServerFont", w/2, 35,col, 1, 1 )
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	
	steaentry = vgui.Create("DTextEntry", partycreatepanel)
	steaentry:SetSize(380,50)
	steaentry:SetPos(10, 70)
	steaentry:SetText("STEAMID")
	steaentry:SetFont("PlayerFont")
	
	
	textentry = vgui.Create("DTextEntry", partycreatepanel)
	textentry:SetSize(380,50)
	textentry:SetPos(10, 130)
	textentry:SetText("Reason")
	textentry:SetFont("PlayerFont")
	
	timeentry = vgui.Create("DTextEntry", partycreatepanel)
	timeentry:SetSize(380,50)
	timeentry:SetPos(10, 190)
	timeentry:SetText("Time (Number)")
	timeentry:SetFont("PlayerFont")
	
	dayentry = vgui.Create("DTextEntry", partycreatepanel)
	dayentry:SetSize(380,50)
	dayentry:SetPos(10, 250)
	dayentry:SetText("Time Type (m,h, d, mon, yr)")
	dayentry:SetFont("PlayerFont")
	
	button = vgui.Create("DButton", partycreatepanel)
	button:SetSize(380,50)
	button:SetPos(10,310)
	button:SetText("")
	button.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("banid Player", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		local stem = steaentry:GetValue()
		local rea = textentry:GetValue()
		local tim = timeentry:GetValue()
		local typ = dayentry:GetValue()
		if stem == "STEAMID" then return end
		if rea == "Reason" then return end
		if tim == "Time (Number)" then return end
		if typ == "Time Type (m,h, d, mon, yr)" then return end
		net_banid(stem, rea, tim, typ)
		
		partycreatepanel:Remove()
	end
	
	
	local button2 = vgui.Create("DButton", partycreatepanel)
	button2:SetSize(380,50)
	button2:SetPos(10,370)
	button2:SetText("")
	button2.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Back", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button2.DoClick = function()
		partycreatepanel:Remove()
		banidMenu()
	end
	
	 
end


if SERVER then
	util.AddNetworkString("admin_banid")
	typc = {
		["m"] = 1,
		["h"] = 60,
		["d"] = 1440,
		["yr"] = 525600,
	}
	net.Receive("admin_banid", function(len , ply)
		if !ply.expectingbanid then return end
		ply.expectingbanid = nil
		local pl = net.ReadString()
		local reason = net.ReadString()
		local time = tonumber(net.ReadString())
		local typ = typc[net.ReadString()]
		if !typ then return end
		typ = typ * 60
		if OGCCW.Staff[util.SteamIDTo64(pl)] then
			if !ply:HasCommand("admin_ban") then
				return
			end
		end 
		local val = time * typ
		Customban(pl, val, reason, ply)
		
		local plc = player.GetBySteamID(pl)
		if plc then
			local name = plc:Name() .. " (" .. plc:SteamID() .. ")"
			pl:Kick(reason)
			log(adminply, ply:Name() .. " has banned **" .. name .. "** for " .. val .. " seconds with the reason of __" .. reason .. "__", logs["admin"] )
		else
			log(adminply, ply:Name() .. " has banned steamID **" .. pl .. "** for " .. val .. " seconds with the reason of __" .. reason .. "__", logs["admin"] )
		end
		
	end)

else

	function net_banid(ply, reason, time, typ)
		net.Start("admin_banid")
			net.WriteString(ply)
			net.WriteString(reason)
			net.WriteString(time)
			net.WriteString(typ)
		net.SendToServer()
	end

end