local w,h = 500, 600

Partypanel = {}
local mat = Material("star/cw/basehexagons.png")
function PartyMenu()
	PartyMenuDerma = vgui.Create("DFrame")
	PartyMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	PartyMenuDerma:SetSize(w,h)
	PartyMenuDerma:MakePopup()
	PartyMenuDerma:SetDraggable(false)
	PartyMenuDerma:SetTitle("")
	PartyMenuDerma:ShowCloseButton(false)
	PartyMenuDerma.lerp = 0
	PartyMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Party", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #Partypanel do
					if !IsValid(Partypanel[x]) then continue end
					Partypanel[x]:Remove()
					Partypanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		paclist = vgui.Create("DScrollPanel", PartyMenuDerma )
		paclist:SetPos( 0, 65 )
		paclist:SetSize( w + 30, h-135 )
		paclist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		paclist.VBar.Paint = function() end
		paclist.VBar.btnUp.Paint = function() end
		paclist.VBar.btnDown.Paint = function() end
		paclist.VBar.btnGrip.Paint = function() end
	end)
	local xx = 1
	
	local tbl = {}
	if party_table and party_stat then
		tbl["party"] = {Name = "Current Party", func = part_info_func}
		tbl["leave"] = {Name = "Leave Current Party", func = net_leave_party}
		tbl["upgade"] = {Name = "Upgrade Party", func = part_upgrade_party}
	
	end
	if (lastinvite || 0) > CurTime() then
		tbl["invite"] = {Name = "Invites", func = part_invite_func}
	end
	
	if (party_stat || {rank = "1"}).rank != "1" then
		tbl["invite_shit"] = {Name = "Invite to Party", func = part_invite_menu_func}
		--tbl["perks"] = {Name = "Perks", func = part_perk_func}
	end
	
	tbl["Create Party"] = {Name = "Create Party", func = part_create_party}
	
	if LocalPlayer() then 
		timer.Simple(0.5, function()
			for str,fac in pairs(tbl || {}) do
				local x = xx
				timer.Simple( 0 + ( x / 10), function()
					Partypanel[x] = paclist:Add("DButton")
					Partypanel[x]:SetPos(0, 45 * (x-1))
					Partypanel[x]:SetSize(w + 30, 40)
					Partypanel[x]:SetText("")
					Partypanel[x].Paint = function(self,c,h)
						surface.SetDrawColor(255,255,255)
						surface.SetMaterial(Material("star/cw/player.png"))
						surface.DrawTexturedRect(0,0,w,h)
						surface.SetDrawColor(0,0,0,255)
						surface.DrawOutlinedRect( 0, 0, w, h)
						local col = Color(0,0,0,255)
						
						
						draw.SimpleText( fac.Name , "PlayerFont", w/2, h/2 , col, 1, 1 )
					end
					Partypanel[x].DoClick = function()
						PartyMenuDerma.back = true
						PartyMenuDerma.lerp = 0
						fac.func()
					end
				end)
				xx = xx + 1
			end
		end)
	end
	timer.Simple(0.2, function()
		Partybackbutton = vgui.Create("DButton", PartyMenuDerma)
		Partybackbutton:SetPos(0, h- 65)
		Partybackbutton:SetSize(w, 60)
		Partybackbutton.DoClick = function()
			PartyMenuDerma.back = true
			PartyMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
		end
		Partybackbutton:SetText("")
		Partybackbutton.Paint = function(self,w,h)
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

Partysubpanel = {}

function part_info_func()

	local par = party_table
	PartysubMenuDerma = vgui.Create("DFrame")
	PartysubMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	PartysubMenuDerma:SetSize(w,h)
	PartysubMenuDerma:MakePopup()
	PartysubMenuDerma:SetDraggable(false)
	PartysubMenuDerma:SetTitle("")
	PartysubMenuDerma:ShowCloseButton(false)
	PartysubMenuDerma.lerp = 0
	PartysubMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( par.name .. " (" .. par.tag .. ")", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
			self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
			self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #Partysubpanel do
					if !IsValid(Partysubpanel[x]) then continue end
					Partysubpanel[x]:Remove()
					Partysubpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		subpaclist = vgui.Create("DScrollPanel", PartysubMenuDerma )
		subpaclist:SetPos( 0, 65 )
		subpaclist:SetSize( w + 30, h-135 )
		subpaclist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		subpaclist.VBar.Paint = function() end
		subpaclist.VBar.btnUp.Paint = function() end
		subpaclist.VBar.btnDown.Paint = function() end
		subpaclist.VBar.btnGrip.Paint = function() end
	end)
	for x,facb in pairs(party || {}) do
 		timer.Simple( 0.5 + ( x / 10), function()
			Partysubpanel[x] = subpaclist:Add("DButton")
			Partysubpanel[x]:SetPos(0, 45 * (x-1))
			Partysubpanel[x]:SetSize(w + 30, 40)
			Partysubpanel[x]:SetText("")
			Partysubpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255, 255, 255, 255)
				local col = Color(0,0,0,255)
				local tag = ""
				if facb.rank == tostring(2) then
					surface.SetDrawColor(100, 255, 100, 255)
					tag = "[Admin] "
				end
				if facb.rank == tostring(3) then
					surface.SetDrawColor(255, 100, 100, 255)
					tag = "[Owner] "
				end
				
				if par.founder == facb.Name then
					tag = tag .. "(Founder) "
				end
				
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				
				draw.SimpleText( tag .. facb.Name , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			Partysubpanel[x].DoClick = function()
				PartysubMenuDerma.back = true
				PartysubMenuDerma.lerp = 0
				gui.EnableScreenClicker(false)
			
				if tonumber(party_stat.rank) > tonumber(facb.rank) then
					Member_Mod(facb)
				else
					PartyMenu()
				end
				
				
			end
		end)
	end
	timer.Simple(0.2, function()
		Partysubbackbutton = vgui.Create("DButton", PartysubMenuDerma)
		Partysubbackbutton:SetPos(0, h- 65)
		Partysubbackbutton:SetSize(w, 60)
		Partysubbackbutton.DoClick = function()
			PartysubMenuDerma.back = true
			PartysubMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			PartyMenu()
		end
		Partysubbackbutton:SetText("")
		Partysubbackbutton.Paint = function(self,w,h)
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









partymemmodpanel = {}

function Member_Mod(member)
	partymemmodMenuDerma = vgui.Create("DFrame")
	partymemmodMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	partymemmodMenuDerma:SetSize(w,h)
	partymemmodMenuDerma:MakePopup()
	partymemmodMenuDerma:SetDraggable(false)
	partymemmodMenuDerma:SetTitle("")
	partymemmodMenuDerma:ShowCloseButton(false)
	partymemmodMenuDerma.lerp = 0
	partymemmodMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText(member.Name, "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
			self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
			self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #partymemmodpanel do
					if !IsValid(partymemmodpanel[x]) then continue end
					partymemmodpanel[x]:Remove()
					partymemmodpanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	
	
	local tbl = {
		[1] = {Name = "Rankup", func = net_part_rankup},
		[2] = {Name = "Kick From Party", func = net_part_kick},
		
	}
	if member.rank == "2" then
		tbl[1] = {Name = "Demote", func = net_part_rankdown}
	end
	if party_stat.rank == "3" then
		tbl[3] = {Name = "Make Owner", func = net_part_makeowner}
	end
	
	local basey = 65
	timer.Simple(0.1, function()
		subpaclist = vgui.Create("DScrollPanel", partymemmodMenuDerma )
		subpaclist:SetPos( 0, 65 )
		subpaclist:SetSize( w + 30, h-135 )
		subpaclist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		subpaclist.VBar.Paint = function() end
		subpaclist.VBar.btnUp.Paint = function() end
		subpaclist.VBar.btnDown.Paint = function() end
		subpaclist.VBar.btnGrip.Paint = function() end
	end)
	for x,facb in pairs(tbl) do
 		timer.Simple( 0.5 + ( x / 10), function()
			partymemmodpanel[x] = subpaclist:Add("DButton")
			partymemmodpanel[x]:SetPos(0, 45 * (x-1))
			partymemmodpanel[x]:SetSize(w + 30, 40)
			partymemmodpanel[x]:SetText("")
			partymemmodpanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText(facb.Name , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			partymemmodpanel[x].DoClick = function()
				facb.func(member)
				partymemmodMenuDerma.back = true
				partymemmodMenuDerma.lerp = 0
				gui.EnableScreenClicker(false)
				PartyMenu()
			end
		end)
	end
	timer.Simple(0.2, function()
		partymemmodbackbutton = vgui.Create("DButton", partymemmodMenuDerma)
		partymemmodbackbutton:SetPos(0, h- 65)
		partymemmodbackbutton:SetSize(w, 60)
		partymemmodbackbutton.DoClick = function()
			partymemmodMenuDerma.back = true
			partymemmodMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			part_info_func()
		end
		partymemmodbackbutton:SetText("")
		partymemmodbackbutton.Paint = function(self,w,h)
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

partyinvitepanel = {}

function part_invite_func()
	partyinviteMenuDerma = vgui.Create("DFrame")
	partyinviteMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	partyinviteMenuDerma:SetSize(w,h)
	partyinviteMenuDerma:MakePopup()
	partyinviteMenuDerma:SetDraggable(false)
	partyinviteMenuDerma:SetTitle("")
	partyinviteMenuDerma:ShowCloseButton(false)
	partyinviteMenuDerma.lerp = 0
	partyinviteMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText("List of Invites", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
			self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
			self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #partyinvitepanel do
					if !IsValid(partyinvitepanel[x]) then continue end
					partyinvitepanel[x]:Remove()
					partyinvitepanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	local basey = 65
	timer.Simple(0.1, function()
		invitesubpaclist = vgui.Create("DScrollPanel", partyinviteMenuDerma )
		invitesubpaclist:SetPos( 0, 65 )
		invitesubpaclist:SetSize( w + 30, h-135 )
		invitesubpaclist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		invitesubpaclist.VBar.Paint = function() end
		invitesubpaclist.VBar.btnUp.Paint = function() end
		invitesubpaclist.VBar.btnDown.Paint = function() end
		invitesubpaclist.VBar.btnGrip.Paint = function() end
	end)
	local xx = 1
	for str,facb in pairs(invite || {}) do
		local x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			partyinvitepanel[x] = invitesubpaclist:Add("DButton")
			partyinvitepanel[x]:SetPos(0, 45 * (x-1))
			partyinvitepanel[x]:SetSize(w + 30, 40)
			partyinvitepanel[x]:SetText("")
			partyinvitepanel[x].Paint = function(self,c,h)
			
				if facb[2] > CurTime() then
					surface.SetDrawColor(255, 255, 255, 255)
				else
					surface.SetDrawColor(100, 100, 100, 255)
				end
				
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText(facb[1] , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			partyinvitepanel[x].DoClick = function()
				if facb[2] > CurTime() then
					net_joinparty(str)
				end
				partyinviteMenuDerma.back = true
				partyinviteMenuDerma.lerp = 0
				gui.EnableScreenClicker(false)
				PartyMenu()
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		partyinvitebackbutton = vgui.Create("DButton", partyinviteMenuDerma)
		partyinvitebackbutton:SetPos(0, h- 65)
		partyinvitebackbutton:SetSize(w, 60)
		partyinvitebackbutton.DoClick = function()
			partyinviteMenuDerma.back = true
			partyinviteMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			PartyMenu()
		end
		partyinvitebackbutton:SetText("")
		partyinvitebackbutton.Paint = function(self,w,h)
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



partyinvitetopanel = {}
function part_invite_menu_func()
	partyinvitetoMenuDerma = vgui.Create("DFrame")
	partyinvitetoMenuDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	partyinvitetoMenuDerma:SetSize(w,h)
	partyinvitetoMenuDerma:MakePopup()
	partyinvitetoMenuDerma:SetDraggable(false)
	partyinvitetoMenuDerma:SetTitle("")
	partyinvitetoMenuDerma:ShowCloseButton(false)
	partyinvitetoMenuDerma.lerp = 0
	partyinvitetoMenuDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText("Invite to Party", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
			self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
			self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #partyinvitetopanel do
					if !IsValid(partyinvitetopanel[x]) then continue end
					partyinvitetopanel[x]:Remove()
					partyinvitetopanel[x] = nil
				end
				self:Remove()
			end
		end
		
	end
	local basey = 65
	timer.Simple(0.1, function()
		invitetosubpaclist = vgui.Create("DScrollPanel", partyinvitetoMenuDerma )
		invitetosubpaclist:SetPos( 0, 65 )
		invitetosubpaclist:SetSize( w + 30, h-135 )
		invitetosubpaclist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		invitetosubpaclist.VBar.Paint = function() end
		invitetosubpaclist.VBar.btnUp.Paint = function() end
		invitetosubpaclist.VBar.btnDown.Paint = function() end
		invitetosubpaclist.VBar.btnGrip.Paint = function() end
	end)
	local xx = 1
	for index, ply in pairs(player.GetAll() || {}) do
		if !ply.Char or ply == LocalPlayer() then continue end
		x = xx
 		timer.Simple( 0.5 + ( x / 10), function()
			partyinvitetopanel[x] = invitetosubpaclist:Add("DButton")
			partyinvitetopanel[x]:SetPos(0, 45 * (x-1))
			partyinvitetopanel[x]:SetSize(w + 30, 40)
			partyinvitetopanel[x]:SetText("")
			partyinvitetopanel[x].Paint = function(self,c,h)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				local col = Color(0,0,0,255)
				draw.SimpleText(ply:Name() , "PlayerFont", w/2, h/2 , col, 1, 1 )
			end
			partyinvitetopanel[x].DoClick = function()
				net_inviteparty(ply)
				partyinvitetoMenuDerma.back = true
				partyinvitetoMenuDerma.lerp = 0
				gui.EnableScreenClicker(false)
				PartyMenu()
			end
		end)
		xx = xx + 1
	end
	timer.Simple(0.2, function()
		partyinvitetobackbutton = vgui.Create("DButton", partyinvitetoMenuDerma)
		partyinvitetobackbutton:SetPos(0, h- 65)
		partyinvitetobackbutton:SetSize(w, 60)
		partyinvitetobackbutton.DoClick = function()
			partyinvitetoMenuDerma.back = true
			partyinvitetoMenuDerma.lerp = 0
			gui.EnableScreenClicker(false)
			PartyMenu()
		end
		partyinvitetobackbutton:SetText("")
		partyinvitetobackbutton.Paint = function(self,w,h)
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



function part_create_party()
	local col = Color(0,0,0)
	partycreatepanel = vgui.Create("DFrame")
	partycreatepanel:SetSize(400,190)
	partycreatepanel:Center()
	partycreatepanel:SetTitle("")
	partycreatepanel:ShowCloseButton(true)
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
	
	
	
		draw.SimpleText("Create Party", "ServerFont", w/2, 35,col, 1, 1 )
		
		
		
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	
	textentry = vgui.Create("DTextEntry", partycreatepanel)
	textentry:SetSize(380,50)
	textentry:SetPos(10, 70)
	textentry:SetText("Name")
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
		draw.SimpleText("Request Party Creation", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		local name = textentry:GetValue()
		if name == "Name" then return end
		if #name <= 3 then return end
		net_make_party(name)
	end
	
	 
end

function part_upgrade_party()
	local col = Color(0,0,0)
	partycreatepanel = vgui.Create("DFrame")
	partycreatepanel:SetSize(400,512)
	partycreatepanel:Center()
	partycreatepanel:SetTitle("")
	partycreatepanel:ShowCloseButton(true)
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
	
	
	
		draw.SimpleText("Upgrade Party", "ServerFont", w/2, 35,col, 1, 1 )
		
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	
	local scroll = vgui.Create("DScrollPanel", partycreatepanel)
	scroll:SetSize(380, 512- 50)
	scroll:SetPos(10, 60)

	local x, y = 0, 0

	local grades = party_up || {}
	for index, tbl in pairs(PARTYUPGRADES) do
		local grade  = 0
		for k,v in pairs(grades) do
			if tonumber(v.type) == index then
				grade = tonumber(v.up)
				break
			end
		end
			

		local mat2 = Material("star/cw/slot.png")
		local button = vgui.Create("DButton", scroll)	
		button:SetSize(180, 180)
		button:SetText("")
		button:SetPos(x*200, 10 + y * 200)
		button.Paint = function(self, w, h)
			--draw.LinearGradient(0,0,w,h,color_black,tbl.Color,0)
			local col = Color(tbl.Color.r/2, tbl.Color.g/2, tbl.Color.b/2) 
			grades = party_up || {}
			local grade  = 0
		for k,v in pairs(grades) do
			if tonumber(v.type) == index then
				grade = tonumber(v.up)
				break
			end
		end

			surface.SetDrawColor(tbl.Color.r, tbl.Color.g, tbl.Color.b, 255)
			surface.SetMaterial(mat2)
			surface.DrawTexturedRect(0,0,w,h)


			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawOutlinedRect( 0, 0, w, h )
			draw.SimpleText(tbl.Name .. " (" .. grade .. ")", "Trebuchet24", w/2, 15, color_white, 1, 1)


			surface.SetDrawColor(tbl.Icon.Color.r, tbl.Icon.Color.g, tbl.Icon.Color.b, 255)
			surface.SetMaterial(tbl.Icon.Mat)
			surface.DrawTexturedRect(w/2 - w/4,h/2 - h/4,h/2,w/2)

			local price = tbl.Price(grade + 1)
			draw.SimpleText(price, "Trebuchet18", w/2, h-15, color_white, 1, 1)
		end
		button.DoClick = function()
			net.Start("party_upgrades")
				net.WriteDouble(index)
			net.SendToServer()
		end
				x = x +1 
				if x == 2 then
					y = y +1
					x = 0
				end
	end
	 
end