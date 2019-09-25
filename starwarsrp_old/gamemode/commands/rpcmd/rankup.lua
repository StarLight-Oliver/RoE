


local tbl = {}

tbl.name = "Rankup"
tbl.args = false
tbl.panel = false
tbl.cmd = "!rankupinfac"
tbl.svfunction = function(ply)
	ply.ExpectingRankuprequest = true
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
	
	rankupplayerselect(tbl, fac)

	--net_com_rankup(ent, rank)
end


local w,h = 500, 600

rankpanel = {}
local mat = Material("star/cw/player.png")
function rankupplayerselect(tbl, fac)
	RankupMenuDerma = vgui.Create("DFrame")
	RankupMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	RankupMenuDerma:SetSize(w,h)
	RankupMenuDerma:MakePopup()
	RankupMenuDerma:SetDraggable(false)
	RankupMenuDerma:SetTitle("")
	RankupMenuDerma:ShowCloseButton(false)
	RankupMenuDerma.lerp = 0
	RankupMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
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
				for x = 1, #rankpanel do
					if !IsValid(rankpanel[x]) then continue end
					rankpanel[x]:Remove()
					rankpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		rankuplist = vgui.Create("DScrollPanel", RankupMenuDerma )
		rankuplist:SetPos( 0, 65 )
		rankuplist:SetSize( w + 30, h-135 )
		rankuplist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		rankuplist.VBar.Paint = function() end
		rankuplist.VBar.btnUp.Paint = function() end
		rankuplist.VBar.btnDown.Paint = function() end
		rankuplist.VBar.btnGrip.Paint = function() end
	end)
	for x, ent in pairs(tbl) do
 		timer.Simple( 0.5 + ( x / 10), function()
			rankpanel[x] = rankuplist:Add("DButton")
			rankpanel[x]:SetPos(0, 45 * (x-1))
			rankpanel[x]:SetSize(w + 30, 40)
			rankpanel[x]:SetText("")
			rankpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255,255,255)
				surface.SetMaterial(mat)
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = color_black
				draw.SimpleText( ent:Name() , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			rankpanel[x].DoClick = function()
				RankupMenuDerma.back = true
				RankupMenuDerma.lerp = 0
				rankupsub(ent, FACTIONS[fac], tbl)
			end
		end)
	end 
	timer.Simple(0.2, function()
		rankupbackbutton = vgui.Create("DButton", RankupMenuDerma)
		rankupbackbutton:SetPos(0, h- 65)
		rankupbackbutton:SetSize(w, 60)
		rankupbackbutton.DoClick = function()
			RankupMenuDerma.back = true
			RankupMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		rankupbackbutton:SetText("")
		rankupbackbutton.Paint = function(self,w,h)
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

rankupsubpanel = {}

function rankupsub(ent, facc, tbl)
	rankupsubMenuDerma = vgui.Create("DFrame")
	rankupsubMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	rankupsubMenuDerma:SetSize(w,h)
	rankupsubMenuDerma:MakePopup()
	rankupsubMenuDerma:SetDraggable(false)
	rankupsubMenuDerma:SetTitle("")
	rankupsubMenuDerma:ShowCloseButton(false)
	rankupsubMenuDerma.lerp = 0
	rankupsubMenuDerma.Paint = function(self, w,h)
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
				for x = 1, #rankupsubpanel do
					if !IsValid(rankupsubpanel[x]) then continue end
					rankupsubpanel[x]:Remove()
					rankupsubpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		rankupsublist = vgui.Create("DScrollPanel", rankupsubMenuDerma )
		rankupsublist:SetPos( 0, 65 )
		rankupsublist:SetSize( w + 30, h-135 )
		rankupsublist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		rankupsublist.VBar.Paint = function() end
		rankupsublist.VBar.btnUp.Paint = function() end
		rankupsublist.VBar.btnDown.Paint = function() end
		rankupsublist.VBar.btnGrip.Paint = function() end
	end)
	local xx = 1
	for str,facb in pairs(facc.Ranks) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			local fac = facc.Ranks[x]
			rankupsubpanel[x] = rankupsublist:Add("DButton")
			rankupsubpanel[x]:SetPos(0, 45 * (x-1))
			rankupsubpanel[x]:SetText("")
			rankupsubpanel[x]:SetSize(w + 30, 40)
			rankupsubpanel[x].DoClick = function()
				net_com_rankup(ent, fac.Name)
			end
			rankupsubpanel[x].Paint = function(self,c,h)
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
		rankupsubbackbutton = vgui.Create("DButton", rankupsubMenuDerma)
		rankupsubbackbutton:SetPos(0, h- 65)
		rankupsubbackbutton:SetSize(w, 60)
		rankupsubbackbutton.DoClick = function()
			rankupsubMenuDerma.back = true
			rankupsubMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			rankupplayerselect(tbl, facc.Name)
		end
		rankupsubbackbutton:SetText("")
		rankupsubbackbutton.Paint = function(self,w,h)
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