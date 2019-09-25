if SERVER then
	util.AddNetworkString("hook_send")

	function plymeta:SetHookMode(bool, pos, ang)

		self.hooked = ang
		net.Start("hook_send")
			net.WriteEntity(self)
			net.WriteBool(bool)
			if bool then
				net.WriteVector(pos)
				net.WriteAngle(ang)
			end
		net.Broadcast()
	end
	concommand.Add("+hook", function(ply)
		if ply.hooked then
			print("HI")
			ply:SetHookMode(false)
			return
		end
		local pos = ply:GetPos()
		local aimvec = ply:GetAimVector()
		aimvec.z = 0
		local aim = ply:GetPos() + aimvec * 32
		local tr = util.TraceLine({
			start = pos + Vector(0,0,60),
			endpos = aim,
			filter = {self},
		})

		if tr.Hit then
			local dist = tr.HitPos:Distance(ply:GetPos() + Vector(0,0,60))
			local scale = 0
			for x = 2, 10 do
				local tr = util.TraceLine({
					start = pos + Vector(0,0,60 * x),
					endpos = aim,
					filter = {self},
				})
				if !tr.Hit or tr.HitPos:Distance(ply:GetPos() + Vector(0,0,60 * x)) > dist then
					scale = {tr.HitPos, tr.HitNormal}
					break
				end
			end
			if scale != 0 then
				-- We have found a space
				local po = scale[1]
				local tr = util.TraceLine({
					start = po,
					endpos = po + Angle(90,0,0):Forward() * 100,
				})

				ply:SetHookMode(true, scale[1] + Vector(0,0, 10), aimvec:Angle())
			end
		end
	end)
else
	net.Receive("hook_send", function()
		local ply = net.ReadEntity()
		local bool = net.ReadBool()
		if bool then
			ply.hookedpos = net.ReadVector()
			ply.hooked = net.ReadAngle()
		else
			ply.hooked = false
		end
	end)
end
