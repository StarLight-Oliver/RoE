local PANEL = {}

function PANEL:Init()

	self:EnableVerticalScrollbar()
	self:SetTall( 66 * 2 + 2 )

end

function PANEL:SetHeight( numHeight )

	self:SetTall( 66 * ( numHeight or 2 ) + 2 )

end

function PANEL:SetModelList( ModelList, strConVar, bDontSort, bDontCallListConVars )

	for v, model in pairs( ModelList ) do

		local icon = vgui.Create( "SpawnIcon" )
		icon:SetModel( model )
		icon:SetSize( 64, 64 )
		icon:SetTooltip( model )
		icon.Model = model
		--icon.ConVars = v
		self:AddPanel( icon )

	end

	if ( !bDontSort ) then
		self:SortByMember( "Model", false )
	end

end

derma.DefineControl( "SLModelSelect", "", PANEL, "DPanelSelect" )