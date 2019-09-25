AdminChats = {}

function AdminChatCreate(ply)
	if IsValid( AdminChats[ply:Nick()]) then return end
	AdminChats[ply:Nick()] = vgui.Create("DFrame")
	local frame = AdminChats[ply:Nick()]
	frame:SetPos(ScrW()/2 - ScrW() / 2, ScrH() / 2 - ScrH() /2)
	frame:SetSize(ScrW(), ScrH())
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame.Paint = function(self, w, h)
		--DrawMaterialOverlay("effects/tp_eyefx/tpeye", 0 )
		draw.SimpleText("An Admin Is Talking to YOU!", "AdminFont", w / 2, h / 2 - h/4, Color(255,0,0), TEXT_ALIGN_CENTER)
	end
	local screen = ScrH()
	if ScrW() < ScrH() then screen = ScrW() end
	local ctrl = vgui.Create( "SL2Model", frame )
	ctrl:SetPos(ScrW() /2 - (screen / 2), ScrH() /2 - (screen / 2))
	ctrl:SetSize( screen, screen)
	print(ply:GetModel())
	--ctrl:SetModel( "models/player/starlight/cultist_pm/cultist_pm.mdl" )
	--ctrl:GetEntity():SetModelScale(0.25) 
	--ctrl:GetEntity():SetSkin( 2 )
	--ctrl:SetLookAng( Angle( -10, 0, 0 ) )
	--ctrl:SetCamPos( (ctrl:GetEntity():GetPos() + Vector(0,0,15)) - Angle( 0, 0, 0 ):Forward() * 10 )
	--ctrl:GetEntity():SetCycle(0)
end

function AdminChatRemove(ply)
	if !IsValid( AdminChats[ply:Nick()]) then return end
	AdminChats[ply:Nick()]:Remove()
	AdminChats[ply:Nick()] = nil
end
