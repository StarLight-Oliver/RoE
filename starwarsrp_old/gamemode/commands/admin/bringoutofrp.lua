local tbl = {}

tbl.name = "Bring Out of RP"
tbl.args = false
tbl.panel = false
tbl.cmd = "!admin_bringoutofrp"
tbl.svfunction = function(ply)
	ply.expectingbringoutofrp = true
end
tbl.clfunction = function(ply)
	admin_bringoutofrp()
end
RegisterRPCommands(tbl)
local mat = Material("star/cw/basehexagons.png")
function admin_bringoutofrp()
	local col = Color(0,0,0)
	partycreatepanel = vgui.Create("DFrame")
	partycreatepanel:SetSize(400,250)
	partycreatepanel:Center()
	partycreatepanel:SetTitle("")
	partycreatepanel:ShowCloseButton(false)
	partycreatepanel:SetDraggable(false)
	partycreatepanel:MakePopup()
	partycreatepanel.Paint = function(self, w,h)
		
		surface.SetDrawColor(150,150,150, 200)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)
	
		surface.SetDrawColor(255,255,255, 255)
		local b =  w-20
		local c,d = w-20, 50
		surface.DrawTexturedRectUV(10,10,w-20,50,0,0,c/b,d/b)

		draw.SimpleText("Bring Player Out Of RP", "ServerFont", w/2, 35,col, 1, 1 )
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	-- net_admin_rank(bringoutofrp, rank, fac,num, wep1, wep2, wep3)
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
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Bring Out Of RP", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		if !ent then return end
		net_bringoutofrp_change(ent)
		partycreatepanel:Remove()
	end
	
	
	local button2 = vgui.Create("DButton", partycreatepanel)
	button2:SetSize(380,50)
	button2:SetPos(10,190)
	button2:SetText("")
	button2.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat)
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
	util.AddNetworkString("admin_bringoutofrp_change")
	
	
	adminsittbl = {
	}
	
	
	net.Receive("admin_bringoutofrp_change", function(len , ply)
		if !ply.expectingbringoutofrp then return end
		ply.expectingbringoutofrp = nil
		local ent = net.ReadEntity()
		local pl = ent
		if OGCCW.Staff[pl:SteamID64()] then
			if !ply:HasCommand("admin_bringoutofrp") then
				return
			end
		end 
		if (ent.bringcooldown || 0 ) > CurTime() then return end
		if ent.OutofRP then
			ent.OutofRP = nil
			ent:SetPos(adminsittbl[ent:SteamID()].pos)
			adminsittbl[ent:SteamID()] = nil
			
			
			log(adminply, ply:Name() .. " has brought **" .. ent:Name() .. "** back into RP", logs["admin"] )
		else
			adminsittbl[ent:SteamID()] = {
				pos = ent:GetPos(),
				id = ent.Char.id
			}
			ent.OutofRP = true
			ent:SetPos(Vector("-1846.824829 -7123.243164 -3597.976318"))
			ply:SetPos(Vector("-1846.824829 -7123.243164 -3597.976318"))
			ent.bringcooldown = CurTime() + 10
			log(adminply, ply:Name() .. " has brought out **" .. ent:Name() .. "**, They are no longer in RP", logs["admin"] )
		end
		
	end)

else

	function net_bringoutofrp_change(ent)
		net.Start("admin_bringoutofrp_change")
			net.WriteEntity(ent)
		net.SendToServer()
	end

end 

/*
ent:GetActiveWeapon():Setbringoutofrpped(false)
*/