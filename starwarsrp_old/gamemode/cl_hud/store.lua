local w,h = 500, 600

storepanel = {}

function storeMenu()
	storeMenuDerma = vgui.Create("DFrame")
	storeMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	storeMenuDerma:SetSize(w,h)
	storeMenuDerma:MakePopup()
	storeMenuDerma:SetDraggable(false)
	storeMenuDerma:SetTitle("")
	storeMenuDerma:ShowCloseButton(false)
	storeMenuDerma.lerp = 0
	storeMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Store", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #storepanel do
					if !IsValid(storepanel[x]) then continue end
					storepanel[x]:Remove()
					storepanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		faclist = vgui.Create("DScrollPanel", storeMenuDerma )
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
	for str,fac in pairs(BUYITEMS) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			storepanel[x] = faclist:Add("DButton")
			storepanel[x]:SetPos(0, 45 * (x-1))
			storepanel[x]:SetSize(w + 30, 40)
			storepanel[x]:SetText("")
			storepanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText(str , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			storepanel[x].DoClick = function()
				storeMenuDerma.back = true
				storeMenuDerma.lerp = 0
				storesub(fac, str)
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		storebackbutton = vgui.Create("DButton", storeMenuDerma)
		storebackbutton:SetPos(0, h- 65)
		storebackbutton:SetSize(w, 60)
		storebackbutton.DoClick = function()
			storeMenuDerma.back = true
			storeMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		storebackbutton:SetText("")
		storebackbutton.Paint = function(self,w,h)
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

storesubpanel = {}

function storesub(facc, str)
	storesubMenuDerma = vgui.Create("DFrame")
	storesubMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	storesubMenuDerma:SetSize(w,h)
	storesubMenuDerma:MakePopup()
	storesubMenuDerma:SetDraggable(false)
	storesubMenuDerma:SetTitle("")
	storesubMenuDerma:ShowCloseButton(false)
	storesubMenuDerma.lerp = 0
	storesubMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Store", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #storesubpanel do
					if !IsValid(storesubpanel[x]) then continue end
					storesubpanel[x]:Remove()
					storesubpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		subfaclist = vgui.Create("DScrollPanel", storesubMenuDerma )
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
	for typ,val in pairs(facc) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			storesubpanel[x] = subfaclist:Add("DButton")
			storesubpanel[x]:SetPos(0, 45 * (x-1))
			storesubpanel[x]:SetSize(w + 30, 40)
			storesubpanel[x]:SetText("")
			storesubpanel[x].Paint = function(self,c,h)
				local store = GetItemNumber(str)
				if typ == "sell" then
					if store > 0 then
						surface.SetDrawColor(0, 255, 0, 255)
					else
						surface.SetDrawColor(255, 0, 0, 255)
					end
				end
				if typ == "buy" then
					local mon = LocalPlayer():GetMoney()
					mon = tonumber(mon)
					if mon < val then
						surface.SetDrawColor(255, 0, 0, 255)
					else
						surface.SetDrawColor(0, 255, 0, 255)
					end
				end
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				local typ = string.upper( string.sub(typ, 1, 1) ) .. string.sub(typ, 2)
				draw.SimpleText( typ .. " : " .. val , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			storesubpanel[x].DoClick = function()
			
				if typ == "sell" then
					local store = GetItemNumber(str)
					if store > 0 then
						net_store(str, false)
					end
				else
					local mon = LocalPlayer():GetMoney()
					if mon > val then
						net_store(str, true)
					end
				end
			end
		end)
		xx = xx + 1
	end 
	timer.Simple(0.2, function()
		storesubbackbutton = vgui.Create("DButton", storesubMenuDerma)
		storesubbackbutton:SetPos(0, h- 65)
		storesubbackbutton:SetSize(w, 60)
		storesubbackbutton.DoClick = function()
			storesubMenuDerma.back = true
			storesubMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			storeMenu()
		end
		storesubbackbutton:SetText("")
		storesubbackbutton.Paint = function(self,w,h)
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

concommand.Add("store_panel", storeMenu)
