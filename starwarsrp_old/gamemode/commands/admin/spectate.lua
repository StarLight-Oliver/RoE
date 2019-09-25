local tbl = {}

tbl.name = "Spectate"
tbl.args = false
tbl.panel = false
tbl.cmd = "!spectate"
tbl.svfunction = function(ply)
	ply.ExpectingSpectatoring = true
	
end
tbl.clfunction = function(ply)
	spectatesub()
end
RegisterRPCommands(tbl)


local w,h = 500, 600

spectatepanel = {}

local mat = Material("star/cw/basehexagons.png")
function spectatesub()
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
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)
	
		surface.SetDrawColor(255,255,255, 255)
		local b =  w-20
		local c,d = w-20, 50
		surface.DrawTexturedRectUV(10,10,w-20,50,0,0,c/b,d/b)

		draw.SimpleText("Spectate Player", "ServerFont", w/2, 35,col, 1, 1 )
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	-- net_spectate(name, rank, fac,num, wep1, wep2, wep3)
	local pl = nil
	list_view = vgui.Create("DComboBox", partycreatepanel)
	list_view:SetPos(10, 70)
	list_view:SetSize(380,50)
	list_view:SetValue( "Player" )
	list_view.OnSelect = function( panel, index, value )
		for index, ply in pairs(player.GetAll()) do
			if ply:Name() == value then
				pl = ply
			end
		end
	end
	
	for k,v in pairs(player.GetAll()) do
		local line = list_view:AddChoice(v:Name())       
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
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Spectate", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		if !IsValid(pl) then return end
		net.Start("admin_spectate")
			net.WriteEntity(pl)
		net.SendToServer()
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

	util.AddNetworkString("admin_spectate")
	
	net.Receive("admin_spectate", function(len , pl)
		local ply = net.ReadEntity()
		if pl.ExpectingSpectatoring then
			if IsValid(ply) then
				pl.ExpectingSpectatoring = false
				pl:SetPos(ply:GetPos() + Vector(0,0, 45))
			end
		end
	end)
end