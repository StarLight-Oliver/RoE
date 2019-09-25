local w,h = 500, 600

playerpanel = {}

local mat = Material("star/cw/player.png")

function GM:ScoreboardShow()
	ScoreBoardDerma = vgui.Create("DFrame")
	ScoreBoardDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	ScoreBoardDerma:SetSize(w,h)
	ScoreBoardDerma:MakePopup()
	ScoreBoardDerma:SetDraggable(false)
	ScoreBoardDerma:SetTitle("")
	ScoreBoardDerma:ShowCloseButton(false)
	ScoreBoardDerma.lerp = 0
	ScoreBoardDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "Osiris Clonewars", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
		self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
		self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		plylist = vgui.Create("DScrollPanel", ScoreBoardDerma )
		plylist:SetPos( 0, 65 )
		plylist:SetSize( w + 30, h-60 )
		plylist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		plylist.VBar.Paint = function() end
		plylist.VBar.btnUp.Paint = function() end
		plylist.VBar.btnDown.Paint = function() end
		plylist.VBar.btnGrip.Paint = function() end
	end)
	for x,ply in pairs(player.GetAll()) do
		timer.Simple( 0 + 0.1, function()
		local but = plylist:Add("DButton")
	    but:SetPos(0, 45 * (x-1))
		but:SetText("")
		but:SetSize(w + 30, 40)
		but.Paint = function(self,c,h)
			if !IsValid(ply) then return end
			local text = Color(0,0,0,255)
			if !ply.Char then
				surface.SetDrawColor( 10,10,10,25)
				text = color_white
			else
				local fac = FACTIONS[ply.Char.faction]
				surface.SetDrawColor(fac.Color.r, fac.Color.g, fac.Color.b, fac.Color.a)
				if text == fac.Color then text = color_white end
			end
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(0,0,w,h)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawOutlinedRect( 0, 0, w, h)
			draw.SimpleText( ply:Name(), "PlayerFont", 40, h/2 , text, 0, 1 )
			draw.SimpleText( ply:Ping() .. "ms", "PlayerFont",	w-40, h/2 , text, 2, 1 )
		end
		but.DoClick = function()
			CreatePlayerInfo(ply)
		end
		
		local av = vgui.Create("AvatarImage",  but)
		av:SetSize( 34, 34 )
		av:SetPlayer(ply, 128)
        if ply.Char and ply.Char.faction == "Staff" then
            av:SetSteamID("STEAM_0:0:115636139")
        end
		av:SetPos(3,3)
		end)
	end
end

function GM:ScoreboardHide()
	if IsValid(ScoreBoardDerma) then
		ScoreBoardDerma.back = true
		ScoreBoardDerma.lerp = 0
	end
end


net.Receive("Country", function(len,pl)
	local ply = net.ReadEntity()
	local str = net.ReadString()
	ply.Country = str
end)

function CreatePlayerInfo(ply)
	local backcol =  Color(255,255,255)
	if ply.Char then
		if FACTIONS[ply.Char.faction] then
			 backcol = FACTIONS[ply.Char.faction].Color
		end
	end
	if plyinfopanel then
		plyinfopanel:Remove()
		plyinfopanel = nil
	
	end
	plyinfopanel = vgui.Create("DFrame")
	plyinfopanel:SetSize(800,400)
	plyinfopanel:Center()
	plyinfopanel:SetTitle("")
	plyinfopanel:ShowCloseButton(false)
	plyinfopanel:SetDraggable(false)
	plyinfopanel:MakePopup()
	plyinfopanel.Paint = function(self, w,h)
		
		surface.SetDrawColor(backcol.r,backcol.g,backcol.b,backcol.a)
		surface.SetMaterial(Material("star/cw/basehexagons.png") )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)
		local col =  Color( 0, 0, 0, 255 )
		local spacer = 40
		draw.SimpleText( "In Game Name: " .. ply:Name(), "PlayerFont", w/2 + 40, 20 + (1 * spacer) ,col, 0, 1 )
		draw.SimpleText( "Display Name: " .. ply:DisplayName(), "PlayerFont", w/2 + 40, 20 + (2 * spacer) ,col, 0, 1 )
		if ply.Char then
			draw.SimpleText( "Character ID: " .. ply.Char.id, "PlayerFont", w/2 + 40, 20 + (3 * spacer) ,col, 0, 1 )
			draw.SimpleText( "Character Rank: " .. ply.Char.rank, "PlayerFont", w/2 + 40, 20 + (4 * spacer) ,col, 0, 1 )
			draw.SimpleText( "Faction: " .. ply.Char.faction, "PlayerFont", w/2 + 40, 20 + (5 * spacer) ,col, 0, 1 )
			draw.SimpleText( "Numbers: " .. ply.Char.numbers, "PlayerFont", w/2 + 40, 20 + (6 * spacer) ,col, 0, 1 )
			draw.SimpleText( "Balance: " .. ply:GetMoney(), "PlayerFont", w/2 + 40, 20 + (7 * spacer) ,col, 0, 1 )
		end
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( w/2, 20, w/2 - 20, h - 40 )
	end
	if IsValid(ply) then
	local ctrl = vgui.Create("SL2Model", plyinfopanel)
	ctrl:SetSize( 400, 400 )
	ctrl:SetModel( ply:GetModel() )
	ctrl:GetEntity():SetModelScale(0.25)
	ctrl:GetEntity():SetSkin( 2 )
	ctrl:SetLookAng( Angle( -10, 0, 0 ) )
	ctrl:SetCamPos( (ctrl:GetEntity():GetPos() + Vector(0,0,15)) - Angle( -10, 0, 0 ):Forward() * 10 )
	ctrl:GetEntity():SetCycle(1)
	end
	local but = vgui.Create("DButton", plyinfopanel)
	but:SetSize(800/2 - 30, 44.4)
	but:SetPos(800/2 + 5, 400 - 44.4 - 20)
	but:SetFont("PlayerFont")
	but:SetText("Close")
	but.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		if self.Hovered then
			surface.SetDrawColor(200,200,200,255)	
		end
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,h)
	end
	but.DoClick = function()
		plyinfopanel:Remove()
		plyinfopanel = nil
	end 
	
end

print("ScoreBoardDermaLoaded!")