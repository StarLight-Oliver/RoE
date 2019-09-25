
--[[
EMOTE_Info = {
	{
		mat = "star/cw/emotes/heath.png",
		dietime = 10,
		basecol = Color(255,255,255,255),
		fadeto = Color(255,255,255,0)
	}
}

]]


local dif = math.AngleDifference
hook.Add("PostDrawTranslucentRenderables", "emotes", function()

	local ply = LocalPlayer()
    if table.Count(EMOTES) > 0 then
		for x,y in pairs(EMOTES) do
			if y.dietime < CurTime() then
				table.remove(EMOTES, x)
			else
				if !y.ent:IsValid() then 
					table.remove(EMOTES, x)
					continue
				end
			
			
				local ent = y.ent
				local ahAngle = y.ent:GetAngles()
				local AhEyes = LocalPlayer():EyeAngles()
				local pos = y.ent:GetPos() + Vector(0,0,90)
				local num = y.num
				local col1 = EMOTE_Info[num].basecol
				local col2 = EMOTE_Info[num].fadeto
				local lerp = (y.dietime - CurTime()) / EMOTE_Info[num].dietime
				
				ahAngle:RotateAroundAxis(ahAngle:Forward(), 90)
				ahAngle:RotateAroundAxis(ahAngle:Right(), -90)		
				cam.IgnoreZ(true)
				cam.Start3D2D(y.ent:GetPos() + Vector(0,0,90), Angle(0, AhEyes.y-90, 90), 0.175)
						local col = LerpColor( lerp ,col2, col1)
					
						surface.SetDrawColor(col.r, col.g, col.b, col.a)
						surface.SetMaterial(Material(EMOTE_Info[num].mat))
						surface.DrawTexturedRect( -( (EMOTE_Info[num].size ||64 ) / 2), -( (EMOTE_Info[num].size ||64 ) / 2), EMOTE_Info[num].size || 64, EMOTE_Info[num].size ||64)
				
					cam.End3D2D()	
					cam.IgnoreZ(false)
			end
		end
	end
end)






function LerpColor(lerp, col1, col2)
	return Color(Lerp(lerp, col1.r, col2.r), Lerp(lerp, col1.g, col2.g), Lerp(lerp, col1.b, col2.b), Lerp(lerp, col1.a, col2.a) )
end