local w,h = 500, 600

scoreboardpanel = {}
local mat = Material("star/cw/player.png")
function f3Menu()
	scoreboardMenuDerma = vgui.Create("DFrame")
	scoreboardMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	scoreboardMenuDerma:SetSize(w,h)
	scoreboardMenuDerma:MakePopup()
	scoreboardMenuDerma:SetDraggable(false)
	scoreboardMenuDerma:SetTitle("")
	scoreboardMenuDerma:ShowCloseButton(false)
	scoreboardMenuDerma.lerp = 0
	scoreboardMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Leaderboard", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		 
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #scoreboardpanel do
					if !IsValid(scoreboardpanel[x]) then continue end
					scoreboardpanel[x]:Remove()
					scoreboardpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		faclist = vgui.Create("DScrollPanel", scoreboardMenuDerma )
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
	for str,fac in pairs(SHOOTINGHIGHSCORE) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			scoreboardpanel[x] = faclist:Add("DButton")
			scoreboardpanel[x]:SetPos(0, 45 * (x-1))
			scoreboardpanel[x]:SetSize(w + 30, 40)
			scoreboardpanel[x]:SetText("")
			scoreboardpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(200,200,200)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				if col == fac.Color then col = color_white end
				draw.SimpleText( string.upper(str) , "PlayerFont", w/2, h/2 , col, 1, 1 )
				--draw.SimpleText("Desc: " .. fac.Desc , "PlayerFont", 40 + (10 * #fac.Name), h/2 , col, 0, 1 )
			end
			scoreboardpanel[x].DoClick = function()
				scoreboardMenuDerma.back = true
				scoreboardMenuDerma.lerp = 0
				scoreboardsub(fac, str)
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		scoreboardbackbutton = vgui.Create("DButton", scoreboardMenuDerma)
		scoreboardbackbutton:SetPos(0, h- 65)
		scoreboardbackbutton:SetSize(w, 60)
		scoreboardbackbutton.DoClick = function()
			scoreboardMenuDerma.back = true
			scoreboardMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		scoreboardbackbutton:SetText("")
		scoreboardbackbutton.Paint = function(self,w,h)
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

scoreboardsubpanel = {}

function scoreboardsub(facc, index)


	PrintTable(facc)
	scoreboardsubMenuDerma = vgui.Create("DFrame")
	scoreboardsubMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	scoreboardsubMenuDerma:SetSize(w,h)
	scoreboardsubMenuDerma:MakePopup()
	scoreboardsubMenuDerma:SetDraggable(false)
	scoreboardsubMenuDerma:SetTitle("")
	scoreboardsubMenuDerma:ShowCloseButton(false)
	scoreboardsubMenuDerma.lerp = 0
	scoreboardsubMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( string.upper( index ), "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #scoreboardsubpanel do
					if !IsValid(scoreboardsubpanel[x]) then continue end
					scoreboardsubpanel[x]:Remove()
					scoreboardsubpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		subfaclist = vgui.Create("DScrollPanel", scoreboardsubMenuDerma )
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
		-- table.GetKeys(facc)
		if type(facc[table.GetKeys(facc )[1]]) != "table" then
			fac_c = facc
			facc = {}

			for index, val in pairs(fac_c) do
				facc[#facc+1] = { index, val}
			end
			table.sort( facc, function( a, b ) return a[2] > b[2] end )
			faccc = {}
			for index, val in pairs(facc) do
        if val[1] then
				  faccc[index] = val[1]
        end
			end
			facc = faccc
		end		
		xx = 1
		for str, fac in pairs(facc) do
			local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			scoreboardsubpanel[x] = subfaclist:Add("DButton")
			scoreboardsubpanel[x]:SetPos(0, 45 * (x-1))
			scoreboardsubpanel[x]:SetSize(w + 30, 40)
			scoreboardsubpanel[x]:SetText("")
			scoreboardsubpanel[x].Paint = function(self,c,h)
				--surface.SetDrawColor(facc.Color.r, facc.Color.g, facc.Color.b, facc.Color.a)
				surface.SetDrawColor(255,255,255 )
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255) 
				--if col == facc.Color then col = color_white end
				if type(fac) != "table" then
          if !fac then
            -- WHAt?
          end
          print(CHAR_GetNameID(fac) .. ": " .. fac_c[fac] || "" .. "  " .. fac)
					draw.SimpleText(CHAR_GetNameID(fac) .. ": " .. fac_c[fac] || "" .. "  " .. fac , "PlayerFont", w/2, h/2 , col, 1, 1 )
				else
					draw.SimpleText(str, "PlayerFont", w/2, h/2 , col, 1, 1 )
				end
				--draw.SimpleText("Health: " .. fac.Health , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			scoreboardsubpanel[x].DoClick = function()
				if type(fac) != "table" then return end
					scoreboardsubMenuDerma:Remove()
					scoreboardsubMenuDerma = nil
					scoreboardsub(fac, str)

			end
			
		end)xx = xx + 1
	end
	timer.Simple(0.2, function()
		scoreboardsubbackbutton = vgui.Create("DButton", scoreboardsubMenuDerma)
		scoreboardsubbackbutton:SetPos(0, h- 65)
		scoreboardsubbackbutton:SetSize(w, 60)
		scoreboardsubbackbutton.DoClick = function()
			scoreboardsubMenuDerma.back = true
			scoreboardsubMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			f3Menu()
		end
		scoreboardsubbackbutton:SetText("")
		scoreboardsubbackbutton.Paint = function(self,w,h)
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
