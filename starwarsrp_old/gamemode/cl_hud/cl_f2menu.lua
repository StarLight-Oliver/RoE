local w,h = 500, 600

factionpanel = {}

function f2Menu()
	FactionMenuDerma = vgui.Create("DFrame")
	FactionMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	FactionMenuDerma:SetSize(w,h)
	FactionMenuDerma:MakePopup()
	FactionMenuDerma:SetDraggable(false)
	FactionMenuDerma:SetTitle("")
	FactionMenuDerma:ShowCloseButton(false)
	FactionMenuDerma.lerp = 0
	FactionMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "List of Factions", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #factionpanel do
					if !IsValid(factionpanel[x]) then continue end
					factionpanel[x]:Remove()
					factionpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		faclist = vgui.Create("DScrollPanel", FactionMenuDerma )
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
	for str,fac in pairs(REALFACTIONS) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			factionpanel[x] = faclist:Add("DButton")
			factionpanel[x]:SetPos(0, 45 * (x-1))
			factionpanel[x]:SetSize(w + 30, 40)
			factionpanel[x]:SetText("")
			factionpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(fac.Color.r, fac.Color.g, fac.Color.b, fac.Color.a)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				if col == fac.Color then col = color_white end
				draw.SimpleText( fac.Name , "PlayerFont", 40, h/2 , col, 0, 1 )
				draw.SimpleText("Desc: " .. fac.Desc , "PlayerFont", 40 + (10 * #fac.Name), h/2 , col, 0, 1 )
			end
			factionpanel[x].DoClick = function()
				FactionMenuDerma.back = true
				FactionMenuDerma.lerp = 0
				factionsub(fac)
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		factionbackbutton = vgui.Create("DButton", FactionMenuDerma)
		factionbackbutton:SetPos(0, h- 65)
		factionbackbutton:SetSize(w, 60)
		factionbackbutton.DoClick = function()
			FactionMenuDerma.back = true
			FactionMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		factionbackbutton:SetText("")
		factionbackbutton.Paint = function(self,w,h)
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

factionsubpanel = {}

function factionsub(facc)
	factionsubMenuDerma = vgui.Create("DFrame")
	factionsubMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	factionsubMenuDerma:SetSize(w,h)
	factionsubMenuDerma:MakePopup()
	factionsubMenuDerma:SetDraggable(false)
	factionsubMenuDerma:SetTitle("")
	factionsubMenuDerma:ShowCloseButton(false)
	factionsubMenuDerma.lerp = 0
	factionsubMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Ranks for " .. facc.Name, "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #factionsubpanel do
					if !IsValid(factionsubpanel[x]) then continue end
					factionsubpanel[x]:Remove()
					factionsubpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		subfaclist = vgui.Create("DScrollPanel", factionsubMenuDerma )
		subfaclist:SetPos( 0, 65 )
		subfaclist:SetSize( w + 30, h-135 )
		subfaclist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		subfaclist.VBar.Paint = function() end
		subfaclist.VBar.btnUp.Paint = function() end
		subfaclist.VBar.btnDown.Paint = function() end
		subfaclist.VBar.btnGrip.Paint = function() end
	end)
	local xx = 1
	for str,facb in pairs(facc.Ranks) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			local fac = facc.Ranks[x]
			factionsubpanel[x] = subfaclist:Add("DPanel")
			factionsubpanel[x]:SetPos(0, 45 * (x-1))
			factionsubpanel[x]:SetSize(w + 30, 40)
			factionsubpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(facc.Color.r, facc.Color.g, facc.Color.b, facc.Color.a)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				if col == facc.Color then col = color_white end
				draw.SimpleText( fac.Name , "PlayerFont", 40, h/2 , col, 0, 1 )
				draw.SimpleText("Health: " .. fac.Health , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		factionsubbackbutton = vgui.Create("DButton", factionsubMenuDerma)
		factionsubbackbutton:SetPos(0, h- 65)
		factionsubbackbutton:SetSize(w, 60)
		factionsubbackbutton.DoClick = function()
			factionsubMenuDerma.back = true
			factionsubMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			f2Menu()
		end
		factionsubbackbutton:SetText("")
		factionsubbackbutton.Paint = function(self,w,h)
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
