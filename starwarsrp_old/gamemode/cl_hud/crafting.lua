local w,h = 500, 600

craftingpanel = {}

function CraftingMenu()
	craftingMenuDerma = vgui.Create("DFrame")
	craftingMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	craftingMenuDerma:SetSize(w,h)
	craftingMenuDerma:MakePopup()
	craftingMenuDerma:SetDraggable(false)
	craftingMenuDerma:SetTitle("")
	craftingMenuDerma:ShowCloseButton(false)
	craftingMenuDerma.lerp = 0
	craftingMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Crafting Panel", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #craftingpanel do
					if !IsValid(craftingpanel[x]) then continue end
					craftingpanel[x]:Remove()
					craftingpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		faclist = vgui.Create("DScrollPanel", craftingMenuDerma )
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
	for str,fac in pairs(CRAFTING) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			craftingpanel[x] = faclist:Add("DButton")
			craftingpanel[x]:SetPos(0, 45 * (x-1))
			craftingpanel[x]:SetSize(w + 30, 40)
			craftingpanel[x]:SetText("")
			craftingpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText(str , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			craftingpanel[x].DoClick = function()
				craftingMenuDerma.back = true
				craftingMenuDerma.lerp = 0
				craftingsub(fac, str)
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		craftingbackbutton = vgui.Create("DButton", craftingMenuDerma)
		craftingbackbutton:SetPos(0, h- 65)
		craftingbackbutton:SetSize(w, 60)
		craftingbackbutton.DoClick = function()
			craftingMenuDerma.back = true
			craftingMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		craftingbackbutton:SetText("")
		craftingbackbutton.Paint = function(self,w,h)
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

craftingsubpanel = {}

function craftingsub(facc, str)
	craftingsubMenuDerma = vgui.Create("DFrame")
	craftingsubMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	craftingsubMenuDerma:SetSize(w,h)
	craftingsubMenuDerma:MakePopup()
	craftingsubMenuDerma:SetDraggable(false)
	craftingsubMenuDerma:SetTitle("")
	craftingsubMenuDerma:ShowCloseButton(false)
	craftingsubMenuDerma.lerp = 0
	craftingsubMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Crafting " .. str, "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #craftingsubpanel do
					if !IsValid(craftingsubpanel[x]) then continue end
					craftingsubpanel[x]:Remove()
					craftingsubpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		subfaclist = vgui.Create("DScrollPanel", craftingsubMenuDerma )
		subfaclist:SetPos( 0, 65 )
		subfaclist:SetSize( w + 30, h-135 - 65 )
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
	for name,count in pairs(facc) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			craftingsubpanel[x] = subfaclist:Add("DPanel")
			craftingsubpanel[x]:SetPos(0, 45 * (x-1))
			craftingsubpanel[x]:SetSize(w + 30, 40)
			craftingsubpanel[x].Paint = function(self,c,h)
				local store = GetItemNumber(name)
				if store > count then
					surface.SetDrawColor(0, 255, 0, 255)
				else
					surface.SetDrawColor(255, 0, 0, 255)
				end
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText( name , "PlayerFont", 40, h/2 , col, 0, 1 )
				draw.SimpleText(count .. " (" .. store .. ")" , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
		end)
		xx = xx + 1
	end 
	timer.Simple(0.2, function()
		craftingsubbackbutton = vgui.Create("DButton", craftingsubMenuDerma)
		craftingsubbackbutton:SetPos(0, h- 65)
		craftingsubbackbutton:SetSize(w, 60)
		craftingsubbackbutton.DoClick = function()
			craftingsubMenuDerma.back = true
			craftingsubMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			CraftingMenu()
		end
		craftingsubbackbutton:SetText("")
		craftingsubbackbutton.Paint = function(self,w,h)
			surface.SetDrawColor(255,255,255,255)
			if self.Hovered then surface.SetDrawColor(200,200,200,255) end
			surface.SetMaterial(Material("star/cw/headerv2.png"))
			surface.DrawTexturedRect(0,0,w,h)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawOutlinedRect( 0, 0, w, h)
			draw.SimpleText( "Back", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		end
		
		
		craftingsubcraftbutton = vgui.Create("DButton", craftingsubMenuDerma)
		craftingsubcraftbutton:SetPos(0, h- 65 - 65)
		craftingsubcraftbutton:SetSize(w, 60)
		craftingsubcraftbutton.DoClick = function()
			
			local fal = true
			
			for name, count in pairs(facc) do
				local store = GetItemNumber(name)
				if store < count then
					fal = false
					break
				end
			end
			
			if !fal then return end
		
		
			craftingsubMenuDerma.back = true
			craftingsubMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			
			net_craft(str)
		end
		craftingsubcraftbutton:SetText("")
		craftingsubcraftbutton.Paint = function(self,w,h)
			surface.SetDrawColor(255,255,255,255)
			if self.Hovered then surface.SetDrawColor(200,200,200,255) end
			surface.SetMaterial(Material("star/cw/headerv2.png"))
			surface.DrawTexturedRect(0,0,w,h)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawOutlinedRect( 0, 0, w, h)
			draw.SimpleText( "Craft", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		end
	end)
	
end 

concommand.Add("crafting_panel", CraftingMenu)
