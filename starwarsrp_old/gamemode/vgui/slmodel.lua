
local PANEL = {}

AccessorFunc( PANEL, "m_bFirstPerson", "FirstPerson" )

function PANEL:Init()

	self.mx = 0
	self.my = 0
	self.aLookAngle = Angle( 0, 0, 0 )

end

function PANEL:OnMousePressed( mousecode )

	self:MouseCapture( true )
	self.Capturing = true
	self.MouseKey = mousecode

	self:SetFirstPerson( true )

	self:CaptureMouse()

end

function PANEL:Think()

	if ( !self.Capturing ) then return end

	if ( self.m_bFirstPerson ) then
		return self:FirstPersonControls()
	end

end

function PANEL:CaptureMouse()

	local x, y = input.GetCursorPos()

	local dx = x - self.mx
	local dy = y - self.my

	local centerx, centery = self:LocalToScreen( self:GetWide() * 0.5, self:GetTall() * 0.5 )
	input.SetCursorPos( centerx, centery )
	self.mx = centerx
	self.my = centery

	return dx, dy

end

function PANEL:FirstPersonControls()

	local x, y = self:CaptureMouse()
	local scale = self:GetFOV() / 180
	
	x = x * -0.5 * scale
	y = y * 0.5 * scale

	if ( self.MouseKey == MOUSE_LEFT ) then
		y = 0
		self.aLookAngle = self.aLookAngle + Angle( y * 4, x * 4, 0 )
		self.vCamPos = (self:GetEntity():GetPos() + Vector(0,0,15)) - self.aLookAngle:Forward() * 10
		return
	end
	self.fFOV = math.Clamp(self.fFOV + y * 0.5, 60, 120)
end 

function PANEL:OnMouseWheeled( dlta )
	
end

function PANEL:OnMouseReleased( mousecode )
	self:MouseCapture( false )
	self.Capturing = false
end

function PANEL:LayoutEntity( Entity )

	--
	-- This function is to be overriden
	--
	self:RunAnimation()
	if ( self.bAnimated ) then
		self:RunAnimation()
	end

	Entity:SetAngles( Angle( 0,180,0) )

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local ctrl = vgui.Create( ClassName )
	ctrl:SetSize( 300, 300 )
	ctrl:SetModel( "models/player/ogc/wraith/red/wraith.mdl" )
	ctrl:GetEntity():SetModelScale(0.25)
	ctrl:GetEntity():SetSkin( 2 )
	ctrl:SetLookAng( Angle( -10, 0, 0 ) )
	ctrl:SetCamPos( (ctrl:GetEntity():GetPos() + Vector(0,0,15)) - Angle( -10, 0, 0 ):Forward() * 10 )
	ctrl:GetEntity():SetCycle(1)
	PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )

end

derma.DefineControl( "SLModel", "A panel containing a model", PANEL, "DModelPanel" )
