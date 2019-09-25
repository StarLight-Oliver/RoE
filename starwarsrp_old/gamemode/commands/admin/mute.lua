local tbl = {}

tbl.name = "Mute"
tbl.args = false
tbl.panel = false
tbl.cmd = "!admin_mute"
tbl.svfunction = function(ply)
	ply.expectingmute = true
end
tbl.clfunction = function(ply)
	admin_mute()
end
RegisterRPCommands(tbl)

local mat = Material("star/cw/basehexagons.png")

function admin_mute()
	local col = Color(0,0,0)
	partycreatepanel = vgui.Create("DFrame")
	partycreatepanel:SetSize(400,310)
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

		draw.SimpleText("Mute Player", "ServerFont", w/2, 35,col, 1, 1 )
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	-- net_admin_rank(mute, rank, fac,num, wep1, wep2, wep3)
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
	textentry2 = vgui.Create("DTextEntry", partycreatepanel)
	textentry2:SetSize(380,50)
	textentry2:SetPos(10, 130)
	textentry2:SetText("Time (Minutes)")
	textentry2:SetFont("PlayerFont")
		

	button = vgui.Create("DButton", partycreatepanel)
	button:SetSize(380,50)
	button:SetPos(10,190)
	button:SetText("")
	button.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Mute", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		if !ent then return end
		local Rank = textentry2:GetValue()
		if !tonumber(Rank) then return end
		net_mute_change(ent, tonumber(Rank))
		partycreatepanel:Remove()
	end
	
	
	local button2 = vgui.Create("DButton", partycreatepanel)
	button2:SetSize(380,50)
	button2:SetPos(10,250)
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
	util.AddNetworkString("admin_mute_change")
	net.Receive("admin_mute_change", function(len , ply)
		if !ply.expectingmute then return end
		ply.expectingmute = nil
		local ent = net.ReadEntity()
		local pl = ent
		if OGCCW.Staff[pl:SteamID64()] then
			if !ply:HasCommand("admin_mute") then
				return
			end
		end 

		local mute = net.ReadDouble()
		
		pl.muteged = CurTime() + (mute*60)
		log(adminply, ply:Name() .. " has muted **" .. ent:Name() .. "** for __" .. mute *60 .. " Seconds__", logs["admin"] )
	end)

else

	function net_mute_change(ent, mute)
		net.Start("admin_mute_change")
			net.WriteEntity(ent)
			net.WriteDouble(mute)
		net.SendToServer()
	end

end 