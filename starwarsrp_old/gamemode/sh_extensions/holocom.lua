HOLOCOM = HOLOCOM || {}
HOLOCOM.CoolDown = 30

HOLOCOMConfig = HOLOCOMConfig or {}

HOLOCOMConfig.Taste = KEY_L
HOLOCOMConfig.Commands = {"!holocom"}


HOLOCOMConfig.Colors = {}
HOLOCOMConfig.Colors.Orange = Color(255,165,0,255)
HOLOCOMConfig.Colors.White = Color(255,255,255,255)

HOLOCOMConfig.Colors.LightBlack = Color(40,40,40,255)
HOLOCOMConfig.Colors.LightBlack2 = Color(30,30,30,255)
HOLOCOMConfig.Colors.LightBlack3 =Color(100,100,100,255)
HOLOCOMConfig.Colors.LightBlack4 = Color(60,60,60,255)
HOLOCOMConfig.Colors.CC = Color(255, 255, 255, 0)



if SERVER then
  
util.AddNetworkString("holo_InviteSend")
util.AddNetworkString("holo_update")
util.AddNetworkString("holo_open")

	net.Receive("holo_InviteSend", function(len, pl)
    	local ply = net.ReadEntity()
      	if (ply[pl:EntIndex() .. "holocom"] || 0 ) > CurTime() then
        	if pl.InHoloChat then -- Are they talking to someone, 
          		net.Start("holo_update")
                  net.WriteBool(false)
              	net.Send({pl.InHoloChat, pl})
          		pl.InHoloChat.InHoloChat = nil
              	pl.InHoloChat = nil
          	end
        	net.Start("holo_update")
        		net.WriteBool(true)
        		net.WriteTable({ply, pl})
            net.Send({ply, pl})
        	-- We are assigning the variables to each others metatable
        	ply.InHoloChat = pl
        	pl.InHoloChat = ply
        	-- Preventing them from trying to breat this again
			ply[pl:EntIndex() .. "holocom"] = 0
        	pl[ply:EntIndex() .. "holocom"] = 0
        else
        	net.Start("holo_InviteSend")
        		net.WriteDouble(HOLOCOM.CoolDown)
        		net.WriteEntity(pl)
        	net.Send(ply) -- Telling them they have an invite
			ply:SLChatMessage({Color(255,165,0), "[Holocom] ", color_white, "Player " .. pl:Nick() .. " is calling you"})
        	pl[ply:EntIndex() .. "holocom"] = CurTime() + HOLOCOM.CoolDown
        
        	if pl.InHoloChat then
          		net.Start("holo_update")
                  net.WriteBool(false)
              	net.Send({pl.InHoloChat, pl})
              	pl.InHoloChat.InHoloChat = nil
              	pl.InHoloChat = nil
          	end
        end
    end)

  
  	net.Receive("holo_update", function(len, pl)
    	if pl.InHoloChat then
        	net.Start("holo_update")
            	net.WriteBool(false)
            net.Send({pl.InHoloChat, pl})
            pl.InHoloChat.InHoloChat = nil
            pl.InHoloChat = nil
        end
    end)
  
  	hook.Add( "PlayerCanHearPlayersVoice", "HolocomVoiceHook_chat", function( ply, pl )
	
		if (pl.Gagged || 0 ) > CurTime() then return false end
		if admin_talk_tbl[pl] then
			if admin_talk_tbl[pl].admins[ply] then
				return true
			end
			if admin_talk_tbl[pl].talks then
				return false
			end
		elseif pl.talkinto then
			if ply == pl.talkinto then
				return ply == pl.talkinto
			end
			return ply.Char.faction == "Staff"
		end
		if pl.broadcastingvoice then
			return true
		end
		  if  pl.InHoloChat == ply and ply.InHoloChat == pl then
			 return true 
		  end
		if pl:GetPos():Distance(ply:GetPos() ) > 512 then return false end
		return true
	end)
  
	hook.Add("PlayerDisconnect", "holocom_off", function(pl)
		if pl.InHoloChat then
        	net.Start("holo_update")
            	net.WriteBool(false)
            net.Send({pl.InHoloChat, pl})
            pl.InHoloChat.InHoloChat = nil
            pl.InHoloChat = nil
        end
	end)
else
	HOLOCOM.Invites = {}
  
	surface.CreateFont("HOLOCOM_Font_1", {
		font = "Arial",
		extended = false,
		size = 24,
		weight = 2000,
	})

	surface.CreateFont("HOLOCOM_Font_2", {
		font = "Arial",
		extended = false,
		size = 30,
		weight = 2000,
	})

	surface.CreateFont("HOLOCOM_Font_3", {
		font = "Arial",
		extended = false,
		size = 24,
		weight = 2000,
	})
  	-- Yep there is no way to run this yet
  
  	net.Receive("holo_open", function() InviteDerma() end)
  	function InviteDerma()
          if (LocalPlayer().BaseFrameCooldown || 0 ) > CurTime() then return end
          LocalPlayer().BaseFrameCooldown = CurTime() + 0.5
    
          Base = vgui.Create("DFrame")
			Base:SetSize(900,500)
			Base:Center()
    		Base:MakePopup()
			Base:SetTitle("")
			Base:SetKeyboardInputEnabled( false )
			Base:SetMouseInputEnabled( true )
			Base:SetDraggable(false)
		
          Base.Paint = function(self, w, h)
            
            surface.SetDrawColor(HOLOCOMConfig.Colors.LightBlack3)
			surface.SetMaterial(Material("star/cw/basehexagons.png") )
			local b = 900
			surface.DrawTexturedRectUV(0,0,w,h,0,0,w/b,h/b)
			
			surface.SetDrawColor(HOLOCOMConfig.Colors.Orange)
            surface.DrawRect(0,0,w,30)
            draw.SimpleText("Holocom Message Service","HOLOCOM_Font_1",w/2,3,HOLOCOMConfig.Colors.White,1)
            draw.SimpleText("Start Call:","HOLOCOM_Font_3",90,50,HOLOCOMConfig.Colors.White,TEXT_ALIGN_CENTER)
			end
    
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
    	
    end
  
  function GetNameToPlayer(ply) --Function to find the player, using the nick passed.
	if !ply then return false end
	for k,v in pairs(player.GetAll()) do
		if v:Nick() == (ply) then
			return v
		end
	end
	return false
end
  
  
  	net.Receive("holo_update", function(len,pl)
      	if pl then return end -- Means a client can't just create this themselves, but if they could do this then well they don't need this
      	local bool = net.ReadBool()
      	if bool then 
			RunConsoleCommand("-voicerecord")
        	local ents = net.ReadTable()
        	local ent = ents[1]
        	if LocalPlayer() == ent then ent = ents[2] end
        -- This is where you will have your view render derma
			if !IsValid(Base) then
				InviteDerma()
			end
        	HOLOCOM.VoicePanel = vgui.Create("DFrame")
        	HOLOCOM.VoicePanel:SetSize(500,490)
        	HOLOCOM.VoicePanel:SetPos(ScrW() / 2, ScrH() /2 - 400/2)
       		HOLOCOM.VoicePanel:MakePopup()
			HOLOCOM.VoicePanel:SetTitle("")
			HOLOCOM.VoicePanel:SetDraggable(false)
        	HOLOCOM.VoicePanel:ShowCloseButton(false)
        	HOLOCOM.VoicePanel.ent = ent
        	HOLOCOM.VoicePanel.Paint = function(self, w,h)
              local CamData = {}
              local panel_w = 0
              local panel_h = -20
              local panel_dist = 40
              local ang = self.ent:EyeAngles() -- this needed the value from the list
              local pos =  self.ent:EyePos() + Vector( 0, 0, panel_h/2 ) + (ang:Forward()*panel_dist) + ang:Right()*-panel_w/2 -- this needed the value from the list
              ang:RotateAroundAxis( ang:Up(), 180 )	
              local x, y = self:GetPos()
              CamData.x = ScrW() / 2
              CamData.y = ScrH() /2 - 400/2
              CamData.w = 390
              CamData.h = 400
              CamData.origin = pos
              CamData.angles =  ang
              CamData.aspectratio = 1
              render.RenderView( CamData )
          	end
        	local close = vgui.Create("DButton", HOLOCOM.VoicePanel)
        	close:SetSize(100,50)
        	close:SetPos(0, 0)
			close:SetText("End Call")
        	close.DoClick = function()
          		net.Start("holo_update")
          		net.SendToServer()
				RunConsoleCommand("-voicerecord")
       		end
			
			
			local voice = vgui.Create("DButton", HOLOCOM.VoicePanel)
        	voice:SetSize(100,50)
        	voice:SetPos(0, 50)
			voice:SetText("Enable Mic")
        	voice.DoClick = function()
          		if voicethen then 
					voice:SetText("Enable Mic")
					RunConsoleCommand("-voicerecord")
				else
					voice:SetText("Disable Mic")
					RunConsoleCommand("+voicerecord")
				end
				voicethen = !voicethen
       		end
			
			
        	-- need a button to cancel the call, this will use
        else
			if HOLOCOM.VoicePanel then
            	HOLOCOM.VoicePanel:Remove()
          		HOLOCOM.VoicePanel = nil
          		RunConsoleCommand("-voicerecord")
        	end
        end
    end)
end