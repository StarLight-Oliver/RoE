local tbl = {}

tbl.name = "Talk to Player"
tbl.args = false
tbl.panel = false
tbl.cmd = "!admin_changetalk"
tbl.svfunction = function(ply)
	ply.expectingchangetalk = true
end
tbl.clfunction = function(ply)
	admin_changetalk()
end
RegisterRPCommands(tbl)
local mat = Material("star/cw/basehexagons.png")
function admin_changetalk()
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

		draw.SimpleText("Talk to a Player", "ServerFont", w/2, 35,col, 1, 1 )
		
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	-- net_admin_rank(changetalk, rank, fac,num, wep1, wep2, wep3)
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
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Start Talking", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		if !ent then return end
		net_changetalk_change(ent)
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
	util.AddNetworkString("admin_changetalk_change")
	util.AddNetworkString("talking_value")
	util.AddNetworkString("talking_end")
	
	admin_talk_tbl = {
		["ent"] = {
			admins = {
				["ply"] = true,
			},
			talk = false,
		}, 
	}
	
	
	net.Receive("admin_changetalk_change", function(len , ply)
		if !ply.expectingchangetalk then return end
		ply.expectingchangetalk = nil
		local ent = net.ReadEntity()
		local pl = ent
		
		if admin_talk_tbl[ent] then
			net.Start("talking_value")
				net.WriteBool(admin_talk_tbl[ent].talk)
				net.WriteEntity(ent)
			net.Send(ply)
			admin_talk_tbl[ent].admins[ply] = true
		else
			admin_talk_tbl[ent] = {
				admins = {
					[ply] = true,
				},
				talk = false,
			}
			net.Start("talking_value")
				net.WriteBool(false)
				net.WriteEntity(ent)
			net.Send(ply)
			admin_talk_tbl[ent].admins[ply] = true
		end
		ply.talkinto = ent
		log(adminply, ply:Name() .. " has started talking to **" .. ent:Name() .. "**", logs["admin"] )

	end)

	net.Receive("talking_value", function(len, ply)
		if !ply.talkinto then return end
		admin_talk_tbl[ply.talkinto].talk = !admin_talk_tbl[ply.talkinto].talk
		net.Start("talking_value")
			net.WriteBool(admin_talk_tbl[ply.talkinto].talk)
			net.WriteEntity(ply.talkinto)
		net.Send(admin_talk_tbl[ply.talkinto].admins)
	end)
	
	net.Receive("talking_end", function(len, ply)
		if ply.talkinto then
			local tbl = admin_talk_tbl[ply.talkinto]
			local len = #tbl.admins
			tbl.admins[ply] = nil
			if len == 1 then
				admin_talk_tbl[ply.talkinto] = nil
			end
			ply.talkinto = nil
		end
	end)
	
else

	function net_changetalk_change(ent)
		net.Start("admin_changetalk_change")
			net.WriteEntity(ent)
		net.SendToServer()
	end

	net.Receive("talking_value", function(len, pl)
		local value = net.ReadBool()
		playertalkingval = value
		playertalkingent = net.ReadEntity()
		if IsValid(TALKINGDERMA) then
		
			return
		end
		local col = Color(0,0,0)
		TALKINGDERMA = vgui.Create("DFrame")
		TALKINGDERMA:SetSize(400,250)
		TALKINGDERMA:Center()
		TALKINGDERMA:SetTitle("")
		TALKINGDERMA:ShowCloseButton(false)
		TALKINGDERMA:SetDraggable(false)
		TALKINGDERMA:MakePopup()
		TALKINGDERMA.Paint = function(self, w,h)
		
			surface.SetDrawColor(150,150,150, 200)
			surface.SetMaterial(mat )
			surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)
		
			surface.SetDrawColor(255,255,255, 255)
			local b =  w-20
			local c,d = w-20, 50
			surface.DrawTexturedRectUV(10,10,w-20,50,0,0,c/b,d/b)

			draw.SimpleText(playertalkingent:Name() , "ServerFont", w/2, 35,col, 1, 1 )
			
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawOutlinedRect( 0, 0, w, h )
			surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
		end
		
		/*
		if voicethen then 
					voice:SetText("Enable Mic")
					RunConsoleCommand("-voicerecord")
				else
					voice:SetText("Disable Mic")
					RunConsoleCommand("+voicerecord")
				end
				voicethen = !voicethen
		*/
		
		local button2 = vgui.Create("DButton", TALKINGDERMA)
		button2:SetSize(380,50)
		button2:SetPos(10,70)
		button2:SetText("")
		button2.Paint = function(self, w, h)
			if self.Hovered then
				surface.SetDrawColor(200,200,200)
			else
				surface.SetDrawColor(255,255,255)
			end
			surface.SetMaterial(mat )
			surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
			if voicethen2 then
				draw.SimpleText("Disable Mic", "PlayerFont", w/2, h/2,col, 1, 1 )
			else
				draw.SimpleText("Enable Mic", "PlayerFont", w/2, h/2,col, 1, 1 )
			end
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawOutlinedRect( 0, 0, w, h )
		end 
		button2.DoClick = function()
				if voicethen2 then 
					RunConsoleCommand("-voicerecord")
				else
					RunConsoleCommand("+voicerecord")
				end
				voicethen2 = !voicethen2
		end
		
		
		
		
		
		
		local button2 = vgui.Create("DButton", TALKINGDERMA)
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
			draw.SimpleText("End Talking", "PlayerFont", w/2, h/2,col, 1, 1 )
			surface.SetDrawColor(Color(0,0,0,255))
			surface.DrawOutlinedRect( 0, 0, w, h )
		end 
		button2.DoClick = function()
			TALKINGDERMA:Remove()
			TALKINGDERMA = nil
			net.Start("talking_end")
			net.SendToServer()
		end
	end)
	
	
	
end 

/*
ent:GetActiveWeapon():Setchangetalkped(false)
*/