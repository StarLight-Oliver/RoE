local tbl = {}

tbl.name = "Rankup For Admins"
tbl.args = false
tbl.panel = false
tbl.cmd = "!admin_rank"
tbl.svfunction = function(ply)
	ply.expectingadmin_rank = true
end
tbl.clfunction = function(ply)
	admin_ranksub()
end
RegisterRPCommands(tbl)


local w,h = 500, 600

admin_rankpanel = {}
local mat = Material("star/cw/basehexagons.png")

function admin_ranksub()
	local col = Color(0,0,0)
	partycreatepanel = vgui.Create("DFrame")
	partycreatepanel:SetSize(400,370)
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

		draw.SimpleText("RankUp", "ServerFont", w/2, 35,col, 1, 1 )
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	-- net_admin_rank(name, rank, fac,num, wep1, wep2, wep3)
	local ent = nil
	textentry = vgui.Create("DComboBox", partycreatepanel)
	textentry:SetSize(380,50)
	textentry:SetPos(10, 70)
	textentry:SetValue("Player")
	textentry:SetFont("PlayerFont")
	textentry.OnSelect = function( panel, index, value )
		for index, ply in pairs(player.GetAll()) do
			if ply:Name() == value then
				ent = ply
			end
		end
	end
	for k,v in pairs(player.GetAll()) do
		if !v.Char then continue end
		if v.Char.faction == "Staff" then continue end
		local line = textentry:AddChoice(v:Name())       
	end
	
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
	
	for k,v in pairs(REALFACTIONS) do
		if k == "Staff" then continue end
		local line = list_view:AddChoice(k)       
	end	
	
	button = vgui.Create("DButton", partycreatepanel)
	button:SetSize(380,50)
	button:SetPos(10,250)
	button:SetText("")
	button.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Change Rank", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		if !ent then return end
		if Rank == "" then return end
		if Faction == "" then return end
		net_admin_rank(ent, Rank, Faction)
		partycreatepanel:Remove()
	end
	
	
	local button2 = vgui.Create("DButton", partycreatepanel)
	button2:SetSize(380,50)
	button2:SetPos(10,310)
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
	util.AddNetworkString("admin_admin_rank")
	net.Receive("admin_admin_rank", function(len , ply)
		if !ply.expectingadmin_rank then return end
		ply.expectingadmin_rank = nil
		local ent = net.ReadEntity()
		local rank = net.ReadString()
		local fac = net.ReadString()
		if !ent.Char then return end
		if !REALFACTIONS[fac] then return end -- No event or staff xD
		if !FACTIONS[fac].RankID[rank] then return end
		local id = ent.Char.id
		local name = ent:Name()
		UpdateCharacter(id,"faction", fac)
		UpdateCharacter(id,"rank", rank)
		log(adminply, ply:Name() .. " has modified the character of **" .. name .. "**  changing faction to __" .. fac .. "__ and rank to __" .. rank .. "__", logs["admin"] )
	end)

else

	function net_admin_rank(ent, rank, fac)
		net.Start("admin_admin_rank")
			net.WriteEntity(ent)
			net.WriteString(rank)
			net.WriteString(fac)
		net.SendToServer()
	end

end


/*
local list_view = vgui.Create("DComboBox", Base)
		list_view:SetParent(Base)
		list_view:SetPos(25, 100)
		list_view:SetSize(200, 25)
		list_view:SetValue( "Name" )
		list_view.OnSelect = function( panel, index, value )
      		if value == LocalPlayer():Nick() then return end
            PlayerName = GetNameToPlayer(value)
      		net.Start("holo_InviteSend")
      			net.WriteEntity(PlayerName)
      		net.SendToServer()
		end
	
		for k,v in pairs(player.GetAll()) do
			if LocalPlayer() == v then continue end
			local line = list_view:AddChoice(v:Nick())       
		end

*/