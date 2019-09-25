EFFECT.Mat = Material( "effects/laser_tracer" )


function MixColor(col1,col2,mixAmount)
	return Color(
		Lerp(mixAmount,col1.r,col2.r),
		Lerp(mixAmount,col1.g,col2.g),
		Lerp(mixAmount,col1.b,col2.b),
		Lerp(mixAmount,col1.a,col2.a))
end




function EFFECT:Init( data )
	self.Position = data:GetStart()
	self.WeaponEnt = data:GetEntity()
	self.Attachment = data:GetAttachment()

	self.StartPos = self:GetTracerShootPos( self.Position, self.WeaponEnt, self.Attachment )
	self.EndPos = data:GetOrigin()
	
	self.Distance = self.EndPos:Distance(self.StartPos)
	self.CurDistance = 0
	
	self.Speed = 6000
	self.TraceLength = 15
	
	
	self.Life = CurTime() + self.Distance / self.Speed

	self:SetRenderBoundsWS( self.StartPos, self.EndPos )

end

function EFFECT:Think()
	self.CurDistance = self.CurDistance + self.Speed * FrameTime()
	
	
	if (self.CurDistance >= self.Distance) then
		local norm = (self.EndPos-self.StartPos):GetNormal()
		local tr = util.QuickTrace( self.EndPos-norm*10, norm*20, self.WeaponEnt)
		
		local effectdata = EffectData()
		effectdata:SetOrigin( tr.HitPos + tr.HitNormal )
		effectdata:SetNormal( tr.HitNormal )
		util.Effect( "AR2Impact", effectdata )
	end
	
	return (self.CurDistance < self.Distance)

end

function EFFECT:Render()
	render.SetMaterial( self.Mat )
	
	local t = math.Clamp(self.CurDistance / self.Distance,0,1)
	
	local pos = LerpVector(t,self.StartPos,self.EndPos)
	local norm = (self.EndPos-self.StartPos):GetNormal()
	
	local s1 = pos - norm * self.TraceLength
	local s2 = pos + norm * self.TraceLength
	local ent = self.WeaponEnt
    local oldcol = WEAPONS[ent:GetMainType()][ent:GetSubType()].Color || Color(255,50,50)
	local Col = Color(oldcol.x,oldcol.y, oldcol.z) or Color(250,50,50)

	render.DrawBeam( s1,s2,12,0,1,Col )
	render.DrawBeam( s1,s2,8,0,1,MixColor(Col,color_white,0.8) )

end