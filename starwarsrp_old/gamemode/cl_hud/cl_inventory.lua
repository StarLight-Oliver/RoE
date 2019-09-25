local w,h = 500, 600

Inventorypanel = {}
local mat = Material("star/cw/player.png")


function InventoryMenu()
	if IsValid(InventoryMenuDerma) then return end
	InventoryMenuDerma = vgui.Create("DFrame")
	InventoryMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	InventoryMenuDerma:SetSize(w,h)
	InventoryMenuDerma:MakePopup()
	InventoryMenuDerma:SetDraggable(false)
	InventoryMenuDerma:SetTitle("")
	InventoryMenuDerma:ShowCloseButton(false)
	InventoryMenuDerma.lerp = 0
	InventoryMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Inventory", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.05, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #Inventorypanel do
					if !IsValid(Inventorypanel[x]) then continue end
					Inventorypanel[x]:Remove()
					Inventorypanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		faclist = vgui.Create("DScrollPanel", InventoryMenuDerma )
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
	if LocalPlayer().Inventory then 
		local val = #LocalPlayer().Inventory
		timer.Simple(0.5, function()
			for str,fac in pairs(LocalPlayer().Inventory || {}) do
				local x = xx
				timer.Simple( 0 + ( x / 1000), function()
					Inventorypanel[x] = faclist:Add("DButton")
					Inventorypanel[x]:SetPos(0, 45 * (x-1))
					Inventorypanel[x]:SetSize(w + 30, 40)
					Inventorypanel[x]:SetText("")
					Inventorypanel[x].Paint = function(self,c,h)
						
						local col = 100 * (x/val) + 155
						
					
					
						surface.SetDrawColor(col,col,col)
						surface.SetMaterial(mat)
						surface.DrawTexturedRect(0,0,w,h)
						surface.SetDrawColor(0,0,0,255)
						surface.DrawOutlinedRect( 0, 0, w, h)
						local col = Color(0,0,0,255)
						local fal = false
						for x = 1, 9 do
							if fac["mod" .. numtoword[x]] != "NULL" then
								fal = true
							end
						end
						local st = ""
						if fal then
							st = " (MOD)"
						end
						
						
						draw.SimpleText( fac.type .. st , "PlayerFont", w/2, h/2 , col, 1, 1 )
					end
					Inventorypanel[x].DoClick = function()
						InventoryMenuDerma.back = true
						InventoryMenuDerma.lerp = 0
						Inventorysub(fac.type, fac)
					end
				end)
				xx = xx + 1
			end
		end)
	end
	timer.Simple(0.2, function()
		Inventorybackbutton = vgui.Create("DButton", InventoryMenuDerma)
		Inventorybackbutton:SetPos(0, h- 65)
		Inventorybackbutton:SetSize(w, 60)
		Inventorybackbutton.DoClick = function()
			InventoryMenuDerma.back = true
			InventoryMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		Inventorybackbutton:SetText("")
		Inventorybackbutton.Paint = function(self,w,h)
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

Inventorysubpanel = {}

function Inventorysub(item, info)

	local tbl = {}
	
	if ITEMS[item].use then
		tbl[#tbl+1] = {name = "Use", func = net_inventory_use, }
	end

	if ITEMS[item].weapon then
		tbl[#tbl+1] = {name = "Equip", func = net_inventory_equip, }
	end

	if ITEMS[item].modifications then
		tbl[#tbl+1] = {name = "Modify", func = modify_panel, }
	end
	
	tbl[#tbl+1] = {name = "Drop", func = net_inventory_drop, }
	
	
	InventorysubMenuDerma = vgui.Create("DFrame")
	InventorysubMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	InventorysubMenuDerma:SetSize(w,h)
	InventorysubMenuDerma:MakePopup()
	InventorysubMenuDerma:SetDraggable(false)
	InventorysubMenuDerma:SetTitle("")
	InventorysubMenuDerma:ShowCloseButton(false)
	InventorysubMenuDerma.lerp = 0
	InventorysubMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "What to do with " .. item, "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
			self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
			self.lerp = math.Clamp(self.lerp + 0.05, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #Inventorysubpanel do
					if !IsValid(Inventorysubpanel[x]) then continue end
					Inventorysubpanel[x]:Remove()
					Inventorysubpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		subfaclist = vgui.Create("DScrollPanel", InventorysubMenuDerma )
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
	for x,facb in pairs(tbl) do
 		timer.Simple( 0.5 + ( x / 1000), function()
			Inventorysubpanel[x] = subfaclist:Add("DButton")
			Inventorysubpanel[x]:SetPos(0, 45 * (x-1))
			Inventorysubpanel[x]:SetSize(w + 30, 40)
			Inventorysubpanel[x]:SetText("")
			Inventorysubpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText( facb.name , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			Inventorysubpanel[x].DoClick = function()
				facb.func(info)
				InventorysubMenuDerma.back = true
				InventorysubMenuDerma.lerp = 0
				gui.EnableScreenClicker(false)
				if facb.name == "Modify" then return end
				InventoryMenu()
			end
		end)
	end
	timer.Simple(0.2, function()
		Inventorysubbackbutton = vgui.Create("DButton", InventorysubMenuDerma)
		Inventorysubbackbutton:SetPos(0, h- 65)
		Inventorysubbackbutton:SetSize(w, 60)
		Inventorysubbackbutton.DoClick = function()
			InventorysubMenuDerma.back = true
			InventorysubMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			InventoryMenu()
		end
		Inventorysubbackbutton:SetText("")
		Inventorysubbackbutton.Paint = function(self,w,h)
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
