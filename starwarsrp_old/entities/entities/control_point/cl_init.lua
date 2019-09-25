include("shared.lua")
local grad_up = Material( "gui/gradient_down" )
local cent = ClientsideModel("models/hunter/blocks/cube1x1x025.mdl")
cent:SetNoDraw(true)
cent:SetModelScale(3)
local ghost = Material("models/shiny")

function ENT:Initialize()
	self:SetRenderBounds(Vector(-50, -50, -50), Vector(50,50,100))

	self.mesh = Mesh()
	mesh.Begin(self.mesh, MATERIAL_QUADS, 4)
		for x = 1,4 do
			local pos = Vector(0,0,0)
			local ang = Angle(0,x/4*360, 0)
			local fo = ang:Forward()
			local ri = ang:Right()

			mesh.Position( pos + fo * 10 - ri * 10)
			mesh.TexCoord(0, 0, 0.5)
			--mesh.Color(255, 255, 255, 255 )
			mesh.AdvanceVertex()

			mesh.Position( pos + fo * 20 - ri * 20 + Vector(0,0,80))
			mesh.TexCoord(0, 0, 0.9)
			--mesh.Color(255, 255, 255, 10 )
			mesh.AdvanceVertex()

			mesh.Position( pos + fo * 20 + ri * 20 + Vector(0,0,80))
			mesh.TexCoord(0, 1, 0.9)
			--mesh.Color(255, 255, 255, 10 )
			mesh.AdvanceVertex()

			mesh.Position( pos + fo * 10 + ri * 10)
			mesh.TexCoord(0, 1, 0.5)
			--mesh.Color(255, 255, 255, 255 )
			mesh.AdvanceVertex()
		end
	mesh.End()

	--self.mesh =

end

function MixColor(col1,col2,mixAmount)
	return Color(
		Lerp(mixAmount,col1.r,col2.r),
		Lerp(mixAmount,col1.g,col2.g),
		Lerp(mixAmount,col1.b,col2.b),
		Lerp(mixAmount,col1.a,col2.a))
end
baaah = false
local Lights = {}
Lights[1] = {
	type 	= MATERIAL_LIGHT_DIRECTIONAL,
	color 	= Vector(1,1,1),
	pos 	= Vector(0,0,0),
	dir 	= Vector(1,0,0),
	range 	= 1,
}
function ENT:RenderMesh(r, g, b)
	--if baaah then return end
		baaah = true
	render.SuppressEngineLighting(true)

	render.ResetModelLighting(2,2,2)
	render.SetLocalModelLights(Lights)
	render.SetLightingOrigin(self:GetPos() + Vector(0,0,80))
		mesh.Begin(MATERIAL_QUADS, 4)
		local pos = self:GetPos()
		for x = 1,4 do
			local ang = Angle(0,x/4*360, 0)
			local fo = ang:Forward()
			local ri = ang:Right()

			mesh.Position( pos+ fo * 10 - ri * 10)
			mesh.TexCoord(0, 0, 0.5)
			--mesh.Color(255,g,b, 255 )
			mesh.AdvanceVertex()

			mesh.Position( pos + fo * 20 - ri * 20 + Vector(0,0,80))
			mesh.TexCoord(0, 0, 0.9)
			--mesh.Color(r,g,b, 255 )
			mesh.AdvanceVertex()

			mesh.Position( pos + fo * 20 + ri * 20 + Vector(0,0,80))
			mesh.TexCoord(0, 1, 0.9)
			--mesh.Color(r,g,b, 255 )
			mesh.AdvanceVertex()

			mesh.Position( pos+ fo * 10 + ri * 10)
			mesh.TexCoord(0, 1, 0.5)
			--mesh.Color(r,g,b, 255 )
			mesh.AdvanceVertex()
		end
	mesh.End()
	render.SuppressEngineLighting(false)
end

local mat = Material("star/grad_holo")
function ENT:Draw()
	if LocalPlayer():GetPos():Distance(self:GetPos()) > 512 + 256 then self:DrawModel() return end
	local val = self:GetProgress() / self:GetMaxProgress()
	local per = Lerp(val, 50, 110)
	local col = MixColor(Color(255,0,0), Color(0,0,255), val)
	local cola = col
	cola.a = 150
	--[[render.SetMaterial(grad_up)
	render.StartBeam( 2 )
		render.AddBeam( self:GetPos(), 10, 0, col )
		render.AddBeam( self:GetPos() + Vector(0,0,80), 50, 0.9, cola )
	render.EndBeam()

	render.StartBeam(2)
		render.AddBeam(self:GetPos() + Vector(0,0,80) + Vector(0,10, 0),20, 0, cola)
		render.AddBeam(self:GetPos() + Vector(0,0,80) - Vector(0,0, 0), 20, 1, cola)

	render.EndBeam()]]--
	mat:SetVector("$color", Vector(col.r/255, col.g/255, col.b/255))
	render.SetMaterial(mat)
	local ma = Matrix()
	ma:Translate(self:GetPos())
	--cam.PushModelMatrix(ma)
	--	self.mesh:Draw()
	--cam.PopModelMatrix()
	self:RenderMesh(col.r, col.g, col.b)
	--render.DrawSprite( self:GetPos() + Vector(0,0, 40), 50, 80, Color( 255, 255, 255, 200 ) )
	--print(ma)
	--render.SetColorModulation(col.r, col.g, col.b  )

	self.ang = (self.ang || 0 ) + FrameTime() * 60

	local ang = Angle(25,self.ang, 0 )

	render.SetColorModulation(col.r/255, col.g/255, col.b/255  )

	render.SetBlend(0.5)
	render.MaterialOverride(ghost)

	cent:SetModel("models/osiris/star/cislogo.mdl")
	cent:SetPos(self:GetPos() + Vector(0,0,80))
	cent:SetAngles(ang )
	cent:SetupBones()

	local normal = ang:Up():GetNormalized()
	local oldEC = render.EnableClipping( true )
	local position = normal:Dot( self:GetPos() + Vector(0,0, per) )
	render.PushCustomClipPlane( normal, position )

	cent:DrawModel()


	render.PopCustomClipPlane()
	local normal = -ang:Up():GetNormalized()

	local position = normal:Dot( self:GetPos() + Vector(0,0, per) )
	cent:SetModel("models/osiris/doctor/republiclogo.mdl")
	cent:SetPos(self:GetPos() + Vector(0,0,80) - ang:Up() * 20 )
	cent:SetupBones()
	render.PushCustomClipPlane( normal, position )
	cent:DrawModel()
	render.PopCustomClipPlane()

	render.EnableClipping( oldEC )
	-- clip this?

	render.SetBlend(1)
	render.MaterialOverride(nil)
		render.SetColorModulation( 1,1, 1 )
	self:DrawModel()
end