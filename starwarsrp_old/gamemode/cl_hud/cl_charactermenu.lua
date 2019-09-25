local w,h = 500, 600

characterpanel = {}
charmodel = charmodel || ""
local charnum = 1

local iconum = 1
local wpmax = 5
local alpha = 255
function CharacterMenu()
	CharDerma = vgui.Create("DFrame")
	CharDerma:SetPos(20, ScrH() - 10)
	CharDerma:SetSize(w,h+65)
	CharDerma:MakePopup()
	CharDerma:SetDraggable(false)
	CharDerma:SetTitle("")
	CharDerma:ShowCloseButton(false)
	CharDerma.lerp = 0
	CharDerma.Paint = function(self, w,h)

		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "CharacterList", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )

		local c, b = self:GetPos()
		if !self.back then
			self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
			self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(Lerp(self.lerp,ScrW() / 2 - w/2, ScrW() + w/2), b)
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #characterpanel do
					characterpanel[x]:Remove()
					characterpanel[x] = nil
				end
				self:Remove()
				CharDerma = false
			end
		end

		if LocalPlayer().CharModel then
			local ent = LocalPlayer().CharModel
			ent:SetSequence(ent:LookupSequence("run_lower"))
			ent:SetCycle(CurTime() % 1)
		end
	end


	local basey = 65
	timer.Simple(0.1, function()
		charlist = vgui.Create("DScrollPanel", CharDerma )
		charlist:SetPos( 0, 65 )
		charlist:SetSize( w + 30, h-120 )
		charlist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		charlist.VBar.Paint = function() end
		charlist.VBar.btnUp.Paint = function() end
		charlist.VBar.btnDown.Paint = function() end
		charlist.VBar.btnGrip.Paint = function() end
	end)
	if LocalPlayer().character then
		for x,Char in pairs(LocalPlayer().character) do
			timer.Simple( 0.5 + ( x / 10), function()
			characterpanel[x] = charlist:Add("DButton")
			characterpanel[x]:SetPos(0, 45 * (x-1))
			characterpanel[x]:SetText("")
			characterpanel[x]:SetSize(w + 30, 40)
			characterpanel[x].Paint = function(self,c,h)
				local fac = FACTIONS[Char.faction]
				local name = ""
				if fac.Ranks[fac.RankID[Char.rank]].numbers then
					name =	fac.Tag .. " " .. Char.rank .. " " .. Char.numbers .. " " .. Char.name
				elseif fac.Tag then
					name =	fac.Tag .. " " .. Char.rank .. " " .. Char.name
				else
					name =	Char.rank .. " " .. Char.name
				end
				surface.SetDrawColor(fac.Color.r,fac.Color.g,fac.Color.b,255)
				surface.SetMaterial(Material("star/cw/player.png"))
				surface.DrawTexturedRect(0,0,w,h)
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( 0, 0, w, h)
				draw.SimpleText( name, "PlayerFont", 40, h/2 , Color( 0, 0, 0, 255 ), 0, 1 )
				draw.SimpleText( fac.Name, "PlayerFont",	w-40, h/2 , Color( 0, 0, 0, 255 ), 2, 1 )

			end
			characterpanel[x].DoClick = function()
				charmodel = Char
				charnum = x
				RebuildCharacter()
			end
			end)
		end
	end
	local x = 1
	if LocalPlayer().character then x = #LocalPlayer().character + 1 end
	timer.Simple( 0.5 + (x / 10), function()
		characterpanel[x] = charlist:Add("DPanel")
		characterpanel[x]:SetPos(0, 45 * (x-1))
		characterpanel[x]:SetSize(w + 30, 40)
		characterpanel[x].Paint = function(self,c,h)
			surface.SetDrawColor(255,255,255,255)
			surface.SetMaterial(Material("star/cw/player.png"))
			surface.DrawTexturedRect(0,0,w,h)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawOutlinedRect( 0, 0, w, h)
			draw.SimpleText( "Create Character", "PlayerFont",	w-40, h/2 , Color( 0, 0, 0, 255 ), 2, 1 )
		end
		text = vgui.Create("DTextEntry", characterpanel[x])
		text:SetPos(10, 5)
		text:SetFont("PlayerFont")
		text:SetText("Character Name")
		text:SetSize(w/2, 30)
		local butt = vgui.Create("DButton", characterpanel[x] )
		butt:SetPos(w-w/2 + 5, 5)
		butt:SetText("")
		butt:SetSize(w/2 - 10,30)
		butt.Paint = function()

		end
		butt.DoClick = function()
			local val = text:GetValue()
			if val != "Character Name" and #val > 3 then

				if LocalPlayer().character then
					if #LocalPlayer().character > 3 then
						return
					end
					LocalPlayer().tempcharnum = (#LocalPlayer().character + 1 || 1 )
				else
					timer.Simple(0.4, function()
						Char_Net_Loadout(1)
					end)
				end
				butt:SetEnabled(false)
				Char_Create(val)
				CharDerma.back = true
				CharDerma.lerp = 0
				char_lerp = 0
			end
		end

	end)


	timer.Simple(0.2, function()
		loadoutbutton = vgui.Create("DButton", CharDerma )
		loadoutbutton:SetPos(0, h-65)
		loadoutbutton:SetSize(w, 60)
		loadoutbutton.DoClick = function()
			if type(charmodel) == "table" then

				gui.EnableScreenClicker(false)
				if LocalPlayer().Char then
					if charmodel.id == LocalPlayer().Char.id then
						LocalPlayer().CharModel:Remove()
						LocalPlayer().CharModel = false
						LocalPlayer().Ship:Remove()
						LocalPlayer().Ship = false
						for x = 1, #characterpanel do
							if IsValid(characterpanel) then
								characterpanel[x]:Remove()
								characterpanel[x] = nil
							end
						end
						CharDerma:Remove()
						CharDerma = false
						return
					end
				end
				CharDerma.back = true
				CharDerma.lerp = 0
				char_lerp = 0
				LocalPlayer().tempcharnum = charnum
			end
		end
		loadoutbutton:SetText("")
		loadoutbutton.Paint = function(self,w,h)
			surface.SetDrawColor(255,255,255,255)
			if self.Hovered then surface.SetDrawColor(200,200,200,255) end
			surface.SetMaterial(Material("star/cw/headerv2.png"))
			surface.DrawTexturedRect(0,0,w,h)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawOutlinedRect( 0, 0, w, h)
			draw.SimpleText( "Loadout", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		end
		backbutton = vgui.Create("DButton", CharDerma )
		backbutton:SetPos(0, h)
		backbutton:SetSize(w, 60)
		backbutton.DoClick = function()
			if LocalPlayer().CharModel then
				LocalPlayer().CharModel:Remove()
				LocalPlayer().CharModel = false
				LocalPlayer().Ship:Remove()
				LocalPlayer().Ship = false
			end
			for x = 1, #characterpanel do
				characterpanel[x]:Remove()
				characterpanel[x] = nil
			end
			CharDerma:Remove()
			CharDerma = false
			 landing_page()
		end
		backbutton:SetText("")
		backbutton.Paint = function(self,w,h)
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

function RebuildCharacter()
	local fac = FACTIONS[charmodel.faction]
	local mdl = fac.Ranks[fac.RankID[charmodel.rank]].Model
	if !LocalPlayer().CharModel then
		LocalPlayer().CharModel = ClientsideModel( mdl, RENDERGROUP_OTHER )
		LocalPlayer().CharModel:SetPos(Vector("166.865967 -696.599854 -12300.599609") + Angle(0,0,0):Forward() * 100 - Angle(0,90,0):Forward() * 70)
		LocalPlayer().CharModel:SetAngles(Angle(0,180,0))
	end

	if !LocalPlayer().Ship then
		LocalPlayer().Ship = ClientsideModel("models/props/laat/laat.mdl")
		LocalPlayer().Ship:SetPos(Vector("166.865967 -696.599854 -12300.599609") + Angle(0,0,0):Forward() * 400 - Angle(0,90,0):Forward() * 90)
		LocalPlayer().Ship:SetBodyGroups("01")
		LocalPlayer().Ship:SetAngles(Angle(0,40,0))
	end
	LocalPlayer().CharModel:SetModel(mdl)
end
