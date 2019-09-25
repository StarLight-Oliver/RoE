


local tbl = {}

tbl.name = "Join Faction"
tbl.args = false
tbl.panel = false
tbl.cmd = "!joinfaction"
tbl.svfunction = function(ply)
end
tbl.clfunction = function(ply)
	local fac = ply.Char.faction
	local tbl = {}
	for index, ent in pairs(player.GetAll()) do
		if ent.Char then
			if ent.Char.faction == fac then
				tbl[#tbl + 1] = ent
			end
		end
	end
	selectupplayerselect(tbl, fac)

	--net_com_selectup(ent, factionjoin)
end


local w,h = 500, 600

selectpanel = {}

function selectupplayerselect(tbl, fac)
	selectupMenuDerma = vgui.Create("DFrame")
	selectupMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	selectupMenuDerma:SetSize(w,h)
	selectupMenuDerma:MakePopup()
	selectupMenuDerma:SetDraggable(false)
	selectupMenuDerma:SetTitle("")
	selectupMenuDerma:ShowCloseButton(false)
	selectupMenuDerma.lerp = 0
	selectupMenuDerma.Paint = function(self, w,h)
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
				for x = 1, #factionjoinpanel do
					if !IsValid(factionjoinpanel[x]) then continue end
					factionjoinpanel[x]:Remove()
					factionjoinpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		selectuplist = vgui.Create("DScrollPanel", selectupMenuDerma )
		selectuplist:SetPos( 0, 65 )
		selectuplist:SetSize( w + 30, h-135 )
		selectuplist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		selectuplist.VBar.Paint = function() end
		selectuplist.VBar.btnUp.Paint = function() end
		selectuplist.VBar.btnDown.Paint = function() end
		selectuplist.VBar.btnGrip.Paint = function() end
	end)
	factionjoinpanel = {}
	local xx = 1
	for index, fac in pairs(REALFACTIONS) do
		local x = xx
		xx = xx + 1
 		timer.Simple( 0.5 + ( x / 10), function()
			factionjoinpanel[x] = selectuplist:Add("DButton")
			factionjoinpanel[x]:SetPos(0, 45 * (x-1))
			factionjoinpanel[x]:SetSize(w + 30, 40)
			factionjoinpanel[x]:SetText("")
			factionjoinpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = color_black
				draw.SimpleText( fac.Name , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			factionjoinpanel[x].DoClick = function()
				selectupMenuDerma.back = true
				selectupMenuDerma.lerp = 0
				net_request_fac_join(fac.Name)
			end
		end)
	end 
	timer.Simple(0.2, function()
		selectupbackbutton = vgui.Create("DButton", selectupMenuDerma)
		selectupbackbutton:SetPos(0, h- 65)
		selectupbackbutton:SetSize(w, 60)
		selectupbackbutton.DoClick = function()
			selectupMenuDerma.back = true
			selectupMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		selectupbackbutton:SetText("")
		selectupbackbutton.Paint = function(self,w,h)
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