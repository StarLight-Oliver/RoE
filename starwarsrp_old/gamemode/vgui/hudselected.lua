
local PANEL = {}

AccessorFunc( PANEL, "m_fAnimSpeed",	"AnimSpeed" )
AccessorFunc( PANEL, "Entity",			"Entity" )
AccessorFunc( PANEL, "vCamPos",			"CamPos" )
AccessorFunc( PANEL, "fFOV",			"FOV" )
AccessorFunc( PANEL, "vLookatPos",		"LookAt" )
AccessorFunc( PANEL, "aLookAngle",		"LookAng" )
AccessorFunc( PANEL, "colAmbientLight",	"AmbientLight" )
AccessorFunc( PANEL, "colColor",		"Color" )
AccessorFunc( PANEL, "bAnimated",		"Animated" )

function PANEL:Init()

	self.Entity = nil
	self.LastPaint = 0
	self.DirectionalLight = {}
	self.FarZ = 4096

	self:SetCamPos( Vector( 50, 50, 50 ) )
	self:SetLookAt( Vector( 0, 0, 40 ) )
	self:SetFOV( 70 )

	self:SetText( "" )
	self:SetAnimSpeed( 0.5 )
	self:SetAnimated( false )

	self:SetAmbientLight( Color( 50, 50, 50 ) )

	self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )

	self:SetColor( Color( 255, 255, 255, 255 ) )

end

function PANEL:SetDirectionalLight( iDirection, color )
	self.DirectionalLight[ iDirection ] = color
end

function PANEL:SetModel( typ, wep )

	-- Note - there's no real need to delete the old
	-- entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
		self.Entity = nil
	end

	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end
	if !wep then self.noweap = true return end
	self.noweap = false
	self.weapon = WEAPONS[typ][wep]
	local strModelName = WEAPONS[typ][wep].wmodel
	self.Entity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid( self.Entity ) ) then return end

	self.Entity:SetNoDraw( true )
	self.Entity:SetIK( false )

	-- Try to find a nice sequence to play
	local iSeq = self.Entity:LookupSequence( "walk_all" )
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
	if ( iSeq <= 0 ) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end

	if ( iSeq > 0 ) then self.Entity:ResetSequence( iSeq ) end

end

function PANEL:GetModel()

	if ( !IsValid( self.Entity ) ) then return end

	return self.Entity:GetModel()

end

function PANEL:DrawModel()

	local curparent = self
	local rightx = self:GetWide()
	local leftx = 0
	local topy = 0
	local bottomy = self:GetTall()
	local previous = curparent
	while( curparent:GetParent() != nil ) do
		curparent = curparent:GetParent()
		local x, y = previous:GetPos()
		topy = math.Max( y, topy + y )
		leftx = math.Max( x, leftx + x )
		bottomy = math.Min( y + previous:GetTall(), bottomy + y )
		rightx = math.Min( x + previous:GetWide(), rightx + x )
		previous = curparent
	end
	render.SetScissorRect( leftx, topy, rightx, bottomy, true )

	local ret = self:PreDrawModel( self.Entity )
	if ( ret != false ) then
		self.Entity:SetColor(Color(255,255,255,  math.Clamp((huddietime || CurTime()) - CurTime(), 0,4) / 4 * 255))
		self.Entity:DrawModel()
		self:PostDrawModel( self.Entity )
	end

	render.SetScissorRect( 0, 0, 0, 0, false )

end

function PANEL:PreDrawModel( ent )
	return true
end

function PANEL:PostDrawModel( ent )

end
local mat = Material("star/cw/slot.png")
local mat2 = Material("star/cw/slotfront.png")
function PANEL:Paint( w, h )

	if ( !IsValid( self.Entity ) ) then return end

			local alpha = math.Clamp((huddietime || CurTime()) - CurTime(), 0,4) / 4 * 255
			local sel = LocalPlayer():GetActiveWeapon()
			if !LocalPlayer():Alive() then return end
			if !IsValid(sel) then return end
			
			if self.weapon == WEAPONS[sel:GetMainType()][sel:GetSubType()] then
				self.colColor = Color(0,0,200,255)
				alpha = 255
			else
				self.colColor = Color(255,255,255,255)
			end
		
			surface.SetDrawColor(self.colColor.r, self.colColor.g, self.colColor.b, alpha)
			surface.SetMaterial(mat)

			GenerateView(self)
			local x, y = self:LocalToScreen( 0, 0 )

			self:LayoutEntity( self.Entity )
	
			local ang = self.aLookAngle
			if ( !ang ) then
				ang = ( self.vLookatPos - self.vCamPos ):Angle()
			end
	
	if CharDerma then return end
	if (char_backtime || 0) > CurTime() then return end
	
	
	local alpha = math.Clamp((huddietime || CurTime()) - CurTime(), 0,4) / 4 * 255
	local sel = LocalPlayer():GetActiveWeapon()
	if !sel then return end
	if self.weapon == WEAPONS[sel:GetMainType()][sel:GetSubType()] then
		self.colColor = Color(0,0,200,255)
		alpha = 255
	else
		self.colColor = Color(255,255,255,255)
	end
	surface.SetDrawColor(self.colColor.r, self.colColor.g, self.colColor.b, alpha)
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(-128,-64, 2048/4, 2048/4)
	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )

	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
	render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
	render.SetBlend( ( self:GetAlpha() / 255 ) * ( alpha / 255 ) )

	for i = 0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
		end
	end
	if alpha > 0 then
		self:DrawModel()
	end

	render.SuppressEngineLighting( false )
	cam.End3D()
	surface.SetMaterial(mat2)
	surface.DrawTexturedRect(0,0, w,h)
	self.LastPaint = RealTime()
end

function PANEL:RunAnimation()
	self.Entity:FrameAdvance( ( RealTime() - self.LastPaint ) * self.m_fAnimSpeed )
end

function PANEL:StartScene( name )

	if ( IsValid( self.Scene ) ) then
		self.Scene:Remove()
	end

	self.Scene = ClientsideScene( name, self.Entity )

end

function PANEL:LayoutEntity( Entity )

	--
	-- This function is to be overriden
	--

	if ( self.bAnimated ) then
		self:RunAnimation()
	end

	Entity:SetAngles( Angle( 0, RealTime() * 10 % 360, 0 ) )
end

function PANEL:OnRemove()
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
	end
end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 300, 300 )
	ctrl:SetModel("Primary", "DC-15A")
	ctrl:GetEntity():SetSkin( 2 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "SLHudSelect", "A panel containing a model", PANEL, "DButton" )
