
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

function PANEL:SetModel( strModelName )

	-- Note - there's no real need to delete the old
	-- entity, it will get garbage collected, but this is nicer.
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
		self.Entity = nil
	end

	-- Note: Not in menu dll
	if ( !ClientsideModel ) then return end

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
local wallMat = Material( "star/pcb_red3.png")
function PANEL:Paint( w, h )

	if ( !IsValid( self.Entity ) ) then return end

	local x, y = self:LocalToScreen( 0, 0 )

	self:LayoutEntity( self.Entity )

	local ang = self.aLookAngle
	if ( !ang ) then
		ang = ( self.vLookatPos - self.vCamPos ):Angle()
	end
	cam.Start3D( self.vCamPos, ang, self.fFOV, x, y, w, h, 5, self.FarZ )

	local pos = Vector( self.Entity:GetPos() ) 
	local angle = Angle(0, 0, 0)
    local scale = 400
    local size = 5
    local center = pos - Vector(0,0,0)
	render.SetMaterial(wallMat)
	render.DrawQuadEasy(center + Vector(0, 0, size*scale/2 - 100), Vector(0, 0, -1), size*scale, size*scale, 0, Color(0, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(0, size*scale/2, 100), Vector(0, 1, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(size*scale/2, 0, 100), Vector(1, 0, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(0, -size*scale/2, 100), Vector(0, -1, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(-size*scale/2, 0, 100), Vector(-1, 0, 0), size*scale, size*scale, 0, Color(255, 0, 0), 0)
	render.DrawQuadEasy(center - Vector(0, 0, size*scale/2 + 100), Vector(0, 0, 1), size*scale, size*scale, 0, Color(255, 0, 0 ), 0)

	
	
	
	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Entity:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r / 255, self.colAmbientLight.g / 255, self.colAmbientLight.b / 255 )
	render.SetColorModulation( self.colColor.r / 255, self.colColor.g / 255, self.colColor.b / 255 )
	render.SetBlend( ( self:GetAlpha() / 255 ) * ( self.colColor.a / 255 ) )

	for i = 0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r / 255, col.g / 255, col.b / 255 )
		end
	end

	self:DrawModel()

	render.SuppressEngineLighting( false )
	cam.End3D()

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

--	Entity:SetAngles( Angle( 0, (CurTime() % 360 )* 10, 0 ) )

end

function PANEL:OnRemove()
	if ( IsValid( self.Entity ) ) then
		self.Entity:Remove()
	end
end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 300, 300 )
	ctrl:SetModel( "models/props_junk/PlasticCrate01a.mdl" )
	ctrl:GetEntity():SetSkin( 2 )

	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "SLCraftingPanel", "A panel containing a model", PANEL, "DButton" )
