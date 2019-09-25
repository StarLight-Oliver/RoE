


local tbl = {}

tbl.name = "Invite To Faction"
tbl.args = false
tbl.panel = false
tbl.cmd = "!invitefaction"
tbl.svfunction = function(ply)
	ply.expectinginvite = true
end
tbl.clfunction = function(ply)
	local fac = ply.Char.faction
	local tbl = {}
	for index, ent in pairs(player.GetAll()) do
		if ent.Char then
			if ent.Char.faction != fac then
				tbl[#tbl + 1] = ent
			end
		end
	end
	inviteupplayerselect(tbl, fac)
end


local w,h = 500, 600

selectpanel = {}

function inviteupplayerselect(tbl, fac)
	inviteupMenuDerma = vgui.Create("DFrame")
	inviteupMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	inviteupMenuDerma:SetSize(w,h)
	inviteupMenuDerma:MakePopup()
	inviteupMenuDerma:SetDraggable(false)
	inviteupMenuDerma:SetTitle("")
	inviteupMenuDerma:ShowCloseButton(false)
	inviteupMenuDerma.lerp = 0
	inviteupMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Invite Player", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #invitejoinpanel do
					if !IsValid(invitejoinpanel[x]) then continue end
					invitejoinpanel[x]:Remove()
					invitejoinpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		inviteuplist = vgui.Create("DScrollPanel", inviteupMenuDerma )
		inviteuplist:SetPos( 0, 65 )
		inviteuplist:SetSize( w + 30, h-135 )
		inviteuplist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		inviteuplist.VBar.Paint = function() end
		inviteuplist.VBar.btnUp.Paint = function() end
		inviteuplist.VBar.btnDown.Paint = function() end
		inviteuplist.VBar.btnGrip.Paint = function() end
	end)
	invitejoinpanel = {}
	for x, fac in pairs(tbl) do
 		timer.Simple( 0.5 + ( x / 10), function()
			invitejoinpanel[x] = inviteuplist:Add("DButton")
			invitejoinpanel[x]:SetPos(0, 45 * (x-1))
			invitejoinpanel[x]:SetSize(w + 30, 40)
			invitejoinpanel[x]:SetText("")
			invitejoinpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = color_black
				draw.SimpleText( fac:Name() , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			invitejoinpanel[x].DoClick = function()
				inviteupMenuDerma.back = true
				inviteupMenuDerma.lerp = 0
				net_request_fac_invite(fac)
			end
		end)
	end 
	timer.Simple(0.2, function()
		inviteupbackbutton = vgui.Create("DButton", inviteupMenuDerma)
		inviteupbackbutton:SetPos(0, h- 65)
		inviteupbackbutton:SetSize(w, 60)
		inviteupbackbutton.DoClick = function()
			inviteupMenuDerma.back = true
			inviteupMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		inviteupbackbutton:SetText("")
		inviteupbackbutton.Paint = function(self,w,h)
			surface.SetDrawColor(255,255,255,255)
			if self.Hovered then surface.SetDrawColor(200,200,200,255) end
			surface.SetMaterial(Material("star/cw/headerv2.png"))
			surface.DrawTexturedRect(0,0,w,h)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawOutlinedRect( 0, 0, w, h)
			draw.SimpleText( "Back", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		end
	end)
end








RegisterRPCommands(tbl)