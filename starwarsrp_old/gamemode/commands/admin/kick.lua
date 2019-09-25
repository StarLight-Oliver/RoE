local tbl = {}

tbl.name = "Kick"
tbl.args = false
tbl.panel = false
tbl.cmd = "!kick"
tbl.svfunction = function(ply)
	ply.expectingkick = true
end
tbl.clfunction = function(ply)
	kickMenu()
end
RegisterRPCommands(tbl)


local w,h = 500, 600

kickpanel = {}
local mat = Material("star/cw/basehexagons.png")
local mat2 = Material("star/cw/headerv2.png")
function kickMenu()
	kickMenuDerma = vgui.Create("DFrame")
	kickMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	kickMenuDerma:SetSize(w,h)
	kickMenuDerma:MakePopup()
	kickMenuDerma:SetDraggable(false)
	kickMenuDerma:SetTitle("")
	kickMenuDerma:ShowCloseButton(false)
	kickMenuDerma.lerp = 0
	kickMenuDerma.Paint = function(self, w,h)
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
				for x = 1, #kickpanel do
					if !IsValid(kickpanel[x]) then continue end
					kickpanel[x]:Remove()
					kickpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		faclist = vgui.Create("DScrollPanel", kickMenuDerma )
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
			kickpanel[x] = faclist:Add("DButton")
			kickpanel[x]:SetPos(0, 45 * (x-1))
			kickpanel[x]:SetSize(w + 30, 40)
			kickpanel[x]:SetText("")
			kickpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText( fac:Name() , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			kickpanel[x].DoClick = function()
				kickMenuDerma.back = true
				kickMenuDerma.lerp = 0
				kicksub(fac)
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		kickbackbutton = vgui.Create("DButton", kickMenuDerma)
		kickbackbutton:SetPos(0, h- 65)
		kickbackbutton:SetSize(w, 60)
		kickbackbutton.DoClick = function()
			kickMenuDerma.back = true
			kickMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		kickbackbutton:SetText("")
		kickbackbutton.Paint = function(self,w,h)
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

function kicksub(fac)
	local col = Color(0,0,0)
	partycreatepanel = vgui.Create("DFrame")
	partycreatepanel:SetSize(400,250)
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

		draw.SimpleText("Kick " .. fac:Name() , "ServerFont", w/2, 35,col, 1, 1 )
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	
	textentry = vgui.Create("DTextEntry", partycreatepanel)
	textentry:SetSize(380,50)
	textentry:SetPos(10, 70)
	textentry:SetText("Reason")
	textentry:SetFont("PlayerFont")
	

	
	button = vgui.Create("DButton", partycreatepanel)
	button:SetSize(380,50)
	button:SetPos(10,130)
	button:SetText("")
	button.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("kick Player", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		local rea = textentry:GetValue()
		if rea == "Reason" then return end
		net_kick(fac, rea)
		
		partycreatepanel:Remove()
		timer.Simple(0.2, function()
			kickMenu()
		end)
	end
	
	
	local button2 = vgui.Create("DButton", partycreatepanel)
	button2:SetSize(380,50)
	button2:SetPos(10,190)
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
		kickMenu()
	end
	
	 
end


if SERVER then
	util.AddNetworkString("admin_kick")

	net.Receive("admin_kick", function(len , ply)
		if !ply.expectingkick then return end
		ply.expectingkick = nil
		local pl = net.ReadEntity()
		local reason = net.ReadString()
		
		if OGCCW.Staff[pl:SteamID64()] then
			if !ply:HasCommand("admin_kick") then
				return
			end
		end 
		local name = pl:Name() .. " (" .. pl:SteamID() .. ")"
		pl:Kick(reason)
		log(adminply, ply:Name() .. " has kicked **" .. name .. "** with the reason of __" .. reason .. "__", logs["admin"] )
	end)

else

	function net_kick(ply, reason)
		net.Start("admin_kick")
			net.WriteEntity(ply)
			net.WriteString(reason)
		net.SendToServer()
	end

end