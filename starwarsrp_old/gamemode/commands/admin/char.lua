local tbl = {}

tbl.name = "Event Character"
tbl.args = false
tbl.panel = false
tbl.cmd = "!event_char"
tbl.svfunction = function(ply)
	ply.expectingevent_char = true
end
tbl.clfunction = function(ply)
	event_charsub()
end
RegisterRPCommands(tbl)


local w,h = 500, 600

event_charpanel = {}
local mat = Material("star/cw/basehexagons.png")

function event_charsub()
	local col = Color(0,0,0)
	partycreatepanel = vgui.Create("DFrame")
	partycreatepanel:SetSize(400,550)
	partycreatepanel:Center()
	partycreatepanel:SetTitle("")
	partycreatepanel:ShowCloseButton(false)
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

		draw.SimpleText("Event Character", "ServerFont", w/2, 35,col, 1, 1 )
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	-- net_event_char(name, rank, fac,num, wep1, wep2, wep3)
	textentry = vgui.Create("DTextEntry", partycreatepanel)
	textentry:SetSize(380,50)
	textentry:SetPos(10, 70)
	textentry:SetText("Name")
	textentry:SetFont("PlayerFont")
	
	
	local Rank = ""
	local Faction = ""
	list_view = vgui.Create("DComboBox", partycreatepanel)
	list_view:SetPos(10, 130)
	list_view:SetSize(380,50)
	list_view:SetValue( "Faction" )
	list_view.OnSelect = function( panel, index, value )
      		if value == "Staff" then return end
            Faction = value
			if IsValid(rank_view) then
				rank_view:Remove()
			end
			Rank = ""
			rank_view = vgui.Create("DComboBox", partycreatepanel)
			rank_view:SetPos(10, 190)
			rank_view:SetSize(380,50)
			rank_view:SetValue( "Rank" )
			rank_view.OnSelect = function( panel, index, value )
				Rank = value
			end
			for k,v in pairs(FACTIONS[Faction].Ranks) do
				if k == "Staff" then continue end
				local line = rank_view:AddChoice(v.Name)       
			end
		end
	
	for k,v in pairs(FACTIONS) do
		if k == "Staff" then continue end
		local line = list_view:AddChoice(k)       
	end
	
	local prim = ""
	local sec = ""
	local mel = ""
	
	wep_view = vgui.Create("DComboBox", partycreatepanel)
	wep_view:SetPos(10, 250)
	wep_view:SetSize(380,50)
	wep_view:SetValue( "Primary" )
	wep_view.OnSelect = function( panel, index, value )
		prim = value
	end
	for k,v in pairs(WEAPONS["Primary"]) do
		local line = wep_view:AddChoice(k)       
	end
	
	sec_view = vgui.Create("DComboBox", partycreatepanel)
	sec_view:SetPos(10, 310)
	sec_view:SetSize(380,50)
	sec_view:SetValue( "Secondary" )
	sec_view.OnSelect = function( panel, index, value )
		sec = value
	end
	for k,v in pairs(WEAPONS["Secondary"]) do
		local line = sec_view:AddChoice(k)       
	end
	
	mel_view = vgui.Create("DComboBox", partycreatepanel)
	mel_view:SetPos(10, 370)
	mel_view:SetSize(380,50)
	mel_view:SetValue( "Melee" )
	mel_view.OnSelect = function( panel, index, value )
		mel = value
	end
	for k,v in pairs(WEAPONS["Melee"]) do
		local line = mel_view:AddChoice(k)       
	end
	
	
	button = vgui.Create("DButton", partycreatepanel)
	button:SetSize(380,50)
	button:SetPos(10,430)
	button:SetText("")
	button.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Create Character", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		local name = textentry:GetValue()
		if Rank == "" then return end
		if Faction == "" then return end
		if prim == "" then return end
		net_event_char(name, Rank, Faction, prim, sec, mel)
		partycreatepanel:Remove()
	end
	
	
	local button2 = vgui.Create("DButton", partycreatepanel)
	button2:SetSize(380,50)
	button2:SetPos(10,490)
	button2:SetText("")
	button2.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Back", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button2.DoClick = function()
		partycreatepanel:Remove()
	end
	
	 
end


if SERVER then
	util.AddNetworkString("admin_event_char")
	net.Receive("admin_event_char", function(len , ply)
		if !ply.expectingevent_char then return end
		ply.expectingevent_char = nil
		local name = net.ReadString()
		local rank = net.ReadString()
		local fac = net.ReadString()
		local wep1 = net.ReadString()
		local wep2 = net.ReadString()
		local wep3 = net.ReadString()
		if name == "" then
			name = GenerateName(math.random(5, 10))
		end
		local char = {
			name = name,
			faction = fac,
			rank = rank,
			steamid = ply:SteamID(),
			id = "  " .. tostring(math.random(1, 20)),
			numbers = CloneNumbers(),
			wep1 = wep1,
			wep2 = wep2,
			wep3 = wep3,
			event = true,
		}
		ply.Char = char
		net.Start("Char_Loadout")
			net.WriteEntity(ply)
			net.WriteTable(char)
		net.Broadcast()
			
		ply:KillSilent()
		ply:Spawn()
		log(adminply, ply:Name() .. " has made an event charater", logs["admin"] )
	end)

else

	function net_event_char(name, rank, fac, wep1, wep2, wep3)
		net.Start("admin_event_char")
			net.WriteString(name)
			net.WriteString(rank)
			net.WriteString(fac)
			net.WriteString(wep1)
			net.WriteString(wep2)
			net.WriteString(wep3)
		net.SendToServer()
	end

end

