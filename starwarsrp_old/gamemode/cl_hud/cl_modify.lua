local w,h = 500, 600

modifypanel = {}

numtoword = {
	[1] = "one",
	[2] = "two",
	[3] = "three",
	[4] = "four",
	[5] = "five",
	[6] = "six",
	[7] = "seven",
	[8] = "eight",
	[9] = "nine",
}
local mat = Material("star/cw/player.png")

function modify_panel(item)
	modifyMenuDerma = vgui.Create("DFrame")
	modifyMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	modifyMenuDerma:SetSize(w,h)
	modifyMenuDerma:MakePopup()
	modifyMenuDerma:SetDraggable(false)
	modifyMenuDerma:SetTitle("")
	modifyMenuDerma:ShowCloseButton(false)
	modifyMenuDerma.lerp = 0
	modifyMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Modify ".. item.type , "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
			self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
			self.lerp = math.Clamp(self.lerp + 0.05, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #modifypanel do
					if !IsValid(modifypanel[x]) then continue end
					modifypanel[x]:Remove()
					modifypanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		modifylist = vgui.Create("DScrollPanel", modifyMenuDerma )
		modifylist:SetPos( 0, 65 )
		modifylist:SetSize( w + 30, h-135 )
		modifylist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		modifylist.VBar.Paint = function() end
		modifylist.VBar.btnUp.Paint = function() end
		modifylist.VBar.btnDown.Paint = function() end
		modifylist.VBar.btnGrip.Paint = function() end
	end)
	timer.Simple(0.5, function()
		for x = 1, 9 do
			local index = "mod" .. numtoword[x]
			timer.Simple( 0 + ( x / 1000), function()
				modifypanel[x] = modifylist:Add("DButton")
				modifypanel[x]:SetPos(0, 45 * (x-1))
				modifypanel[x]:SetSize(w + 30, 40)
				modifypanel[x]:SetText("")
				modifypanel[x].Paint = function(self,w,h)
					
					surface.SetDrawColor(255,255,255)
					surface.SetMaterial(mat)
					surface.DrawTexturedRect(0,0,w,h)
					surface.SetDrawColor(0,0,0,255)
					surface.DrawOutlinedRect( 0, 0, w, h)
					local col = Color(0,0,0,255)	
					if item[index] then
						draw.SimpleText( "Modification " .. x .. ": " .. item[index], "PlayerFont", w/2, h/2 , col, 1, 1 )
					else
						draw.SimpleText( "Modification " .. x .. " None" , "PlayerFont", w/2, h/2 , col, 1, 1 )
					end
				end
				modifypanel[x].DoClick = function()
					modifyMenuDerma.back = true
					modifyMenuDerma.lerp = 0
					modifysub(item,x)
				end
			end)
		end
	end)
	timer.Simple(0.2, function()
		modifybackbutton = vgui.Create("DButton", modifyMenuDerma)
		modifybackbutton:SetPos(0, h- 65)
		modifybackbutton:SetSize(w, 60)
		modifybackbutton.DoClick = function()
			modifyMenuDerma.back = true
			modifyMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			InventoryMenu()
		end
		modifybackbutton:SetText("")
		modifybackbutton.Paint = function(self,w,h)
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

modifysubpanel = {}

function modifysub(item,info)
	
	modifysubMenuDerma = vgui.Create("DFrame")
	modifysubMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	modifysubMenuDerma:SetSize(w,h)
	modifysubMenuDerma:MakePopup()
	modifysubMenuDerma:SetDraggable(false)
	modifysubMenuDerma:SetTitle("")
	modifysubMenuDerma:ShowCloseButton(false)
	modifysubMenuDerma.lerp = 0
	modifysubMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "What to do with " .. item.type, "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
			self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
			self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #modifysubpanel do
					if !IsValid(modifysubpanel[x]) then continue end
					modifysubpanel[x]:Remove()
					modifysubpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		subfaclist = vgui.Create("DScrollPanel", modifysubMenuDerma )
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
	local tbl =  ITEMS[item.type].modifications 
	for str,facb in pairs(tbl) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			modifysubpanel[x] = subfaclist:Add("DButton")
			modifysubpanel[x]:SetPos(0, 45 * (x-1))
			modifysubpanel[x]:SetSize(w + 30, 40)
			modifysubpanel[x]:SetText("")
			modifysubpanel[x].Paint = function(self,c,h)
				if GetItemNumber(str) then
					surface.SetDrawColor(0, 255, 0, 255)
				else
					surface.SetDrawColor(255, 0, 0, 255)
				end
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText(str, "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			modifysubpanel[x].DoClick = function()
				net_inventory_modify(item,info, str) 
				modifysubMenuDerma.back = true
				modifysubMenuDerma.lerp = 0
				gui.EnableScreenClicker(false)
				timer.Simple(0.5, function()
					InventoryMenu()
				end)
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		modifysubbackbutton = vgui.Create("DButton", modifysubMenuDerma)
		modifysubbackbutton:SetPos(0, h- 65)
		modifysubbackbutton:SetSize(w, 60)
		modifysubbackbutton.DoClick = function()
			modifysubMenuDerma.back = true
			modifysubMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			modify_panel(item)
		end
		modifysubbackbutton:SetText("")
		modifysubbackbutton.Paint = function(self,w,h)
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
