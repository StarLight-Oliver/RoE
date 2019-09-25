if OGCCW.Voice then return end

local PANEL = {}
local PlayerVoicePanels = {}



OGCCW.Voice = true

function PANEL:Init()

	self.LabelName = vgui.Create( "DLabel", self )
	self.LabelName:SetFont( "GModNotify" )
	self.LabelName:Dock( FILL )
	self.LabelName:DockMargin( 8, 0, 0, 0 )
	self.LabelName:SetTextColor( Color( 255, 255, 255, 255 ) )

	self.Avatar = vgui.Create( "AvatarImage", self )
	self.Avatar:Dock( LEFT )
	self.Avatar:SetSize( 32, 32 )

	self.Color = color_transparent

	self:SetSize( 250, 32 + 8 )
	self:DockPadding( 4, 4, 4, 4 )
	self:DockMargin( 2, 2, 2, 2 )
	self:Dock( BOTTOM )

end

function PANEL:Setup( ply )

	self.ply = ply
	self.LabelName:SetText( ply:Nick()  )
	self.Avatar:SetPlayer( ply )
	if ply.Char then
	    self.Color = FACTIONS[ply.Char.faction ].Color
    end
    
	self:InvalidateLayout()

end

local mat = Material("star/cw/basehexagons.png")

function PANEL:Paint( w, h )

	if ( !IsValid( self.ply ) ) then return end
	local vol = self.ply:VoiceVolume()
	if vol == 0 then
		vol = 1
	end 
	surface.SetDrawColor(self.Color.r, self.Color.g, self.Color.b, 100 +140 * vol )
	surface.SetMaterial(mat)
	surface.DrawTexturedRectUV( 0, 0, w, h, 0, 0, w / 250, h / 250 )
	
end

function PANEL:Think()
	
	if ( IsValid( self.ply ) ) then
		self.LabelName:SetText( self.ply:Nick())
	end

	if ( self.fadeAnim ) then
		self.fadeAnim:Run()
	end

end

function PANEL:FadeOut( anim, delta, data )
	
	if ( anim.Finished ) then
	
		if ( IsValid( PlayerVoicePanels[ self.ply ] ) ) then
			PlayerVoicePanels[ self.ply ]:Remove()
			PlayerVoicePanels[ self.ply ] = nil
			return
		end
		
	return end
	
	self:SetAlpha( 255 - ( 255 * delta ) )

end

derma.DefineControl( "VoiceNotifyv2", "", PANEL, "DPanel" )



function GM:PlayerStartVoice( ply )

	if ( !IsValid( g_VoicePanelList ) ) then return end
	
	-- There'd be an exta one if voice_loopback is on, so remove it.
	GAMEMODE:PlayerEndVoice( ply )
	if !ply.Char then return end


	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then
			PlayerVoicePanels[ ply ].fadeAnim:Stop()
			PlayerVoicePanels[ ply ].fadeAnim = nil
		end

		PlayerVoicePanels[ ply ]:SetAlpha( 255 )

		return

	end

	if ( !IsValid( ply ) ) then return end
	if ply.Char and ply.Char.faction == "Staff" then
		AdminChatCreate(ply)
	return end
	local pnl = g_VoicePanelList:Add( "VoiceNotifyv2" )
	pnl:Setup( ply )
	
	PlayerVoicePanels[ ply ] = pnl

end

local function VoiceClean()

	for k, v in pairs( PlayerVoicePanels ) do
	
		if ( !IsValid( k ) ) then
			GAMEMODE:PlayerEndVoice( k )
		end
	
	end

end
timer.Create( "VoiceClean", 10, 0, VoiceClean )

function GM:PlayerEndVoice( ply )

	if ( IsValid( PlayerVoicePanels[ ply ] ) ) then

		if ( PlayerVoicePanels[ ply ].fadeAnim ) then return end
		
		PlayerVoicePanels[ ply ].fadeAnim = Derma_Anim( "FadeOut", PlayerVoicePanels[ ply ], PlayerVoicePanels[ ply ].FadeOut )
		PlayerVoicePanels[ ply ].fadeAnim:Start( 2 )

	end
	if ply.Char and ply.Char.faction == "Staff" then
		AdminChatRemove(ply)
	end

end

local function CreateVoiceVGUI()

	g_VoicePanelList = vgui.Create( "DPanel" )

	g_VoicePanelList:ParentToHUD()
	g_VoicePanelList:SetPos( 10, 100 )
	g_VoicePanelList:SetSize( 250, ScrH() - 200 )
	g_VoicePanelList:SetPaintBackground( false )
	g_VoicePanelList.Paint = function()
	
	end

end

hook.Add( "InitPostEntity", "CreateVoiceVGUI", CreateVoiceVGUI )