local tbl = {}

tbl.name = "Warn"
tbl.args = false
tbl.panel = false
tbl.cmd = "!warn"
tbl.svfunction = function(ply)
	ply.expectingwarn = true
end
tbl.clfunction = function(ply)
	warnMenu()
end
RegisterRPCommands(tbl)


local w,h = 500, 600

warnpanel = {}
local mat = Material("star/cw/basehexagons.png")
local mat2 = Material("star/cw/headerv2.png")
function warnMenu()
	warnMenuDerma = vgui.Create("DFrame")
	warnMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	warnMenuDerma:SetSize(w,h)
	warnMenuDerma:MakePopup()
	warnMenuDerma:SetDraggable(false)
	warnMenuDerma:SetTitle("")
	warnMenuDerma:ShowCloseButton(false)
	warnMenuDerma.lerp = 0
	warnMenuDerma.Paint = function(self, w,h)
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
				for x = 1, #warnpanel do
					if !IsValid(warnpanel[x]) then continue end
					warnpanel[x]:Remove()
					warnpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		faclist = vgui.Create("DScrollPanel", warnMenuDerma )
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
			warnpanel[x] = faclist:Add("DButton")
			warnpanel[x]:SetPos(0, 45 * (x-1))
			warnpanel[x]:SetSize(w + 30, 40)
			warnpanel[x]:SetText("")
			warnpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText( fac:Name() , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			warnpanel[x].DoClick = function()
				warnMenuDerma.back = true
				warnMenuDerma.lerp = 0
				warnsub(fac)
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		warnbackbutton = vgui.Create("DButton", warnMenuDerma)
		warnbackbutton:SetPos(0, h- 65)
		warnbackbutton:SetSize(w, 60)
		warnbackbutton.DoClick = function()
			warnMenuDerma.back = true
			warnMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		warnbackbutton:SetText("")
		warnbackbutton.Paint = function(self,w,h)
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

function warnsub(fac)
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

		draw.SimpleText("Warn " .. fac:Name() , "ServerFont", w/2, 35,col, 1, 1 )
		
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
		draw.SimpleText("Warn Player", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		local rea = textentry:GetValue()
		if rea == "Reason" then return end
		net_warn(fac, rea)
		
		partycreatepanel:Remove()
		timer.Simple(0.2, function()
			warnMenu()
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
		warnMenu()
	end
	
	 
end


if SERVER then
	util.AddNetworkString("admin_warn")

	net.Receive("admin_warn", function(len , ply)
		if !ply.expectingwarn then return end
		ply.expectingwarn = nil
		local pl = net.ReadEntity()
		local reason = net.ReadString()
		
		if OGCCW.Staff[pl:SteamID64()] then
			if !ply:HasCommand("admin_warn") then
				return
			end
		end 
		local name = pl:Name() .. " (" .. pl:SteamID() .. ")"
		pl:warn(reason)
		log(adminply, ply:Name() .. " has warned **" .. name .. "** with the reason of __" .. reason .. "__", logs["admin"] )
	end)

else

	function net_warn(ply, reason)
		net.Start("admin_warn")
			net.WriteEntity(ply)
			net.WriteString(reason)
		net.SendToServer()
	end

end