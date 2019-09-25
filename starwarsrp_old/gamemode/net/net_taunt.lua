

sitenum = {
	[true] = "down",
	[false]	= "up",
}


if SERVER then
	util.AddNetworkString("net_ogc_actanim")
	util.AddNetworkString("Star_Anim")
	util.AddNetworkString("sitting")
	function plymeta:SetActAnim(act)
		net.Start("net_ogc_actanim")
			net.WriteEntity(self)
			net.WriteDouble(act)
		net.Broadcast()
		self.RunActAnim = act
	end

	util.AddNetworkString("net_ogc_anim")
	function plymeta:SetAnim(act)
		net.Start("net_ogc_anim")
			net.WriteEntity(self)
			net.WriteString(act)
		net.Broadcast()
		self.RunAnim = act
	end



	function plymeta:SetSitting(bool)
		if (self.SitCoolDown || 0 ) > CurTime() then return end
		self.SitCoolDown = CurTime() + 2
		local id, dir = self:LookupSequence("wos_bs_shared_sit" .. sitenum[bool])
		self:SetStarAnim("wos_bs_shared_sit" .. sitenum[bool])
		self:SetLocalVelocity(Vector(0,0,0))
		if bool then
			self:SetMoveType(MOVETYPE_NONE)
		end


		timer.Simple(dir, function()
			self.Sitting = bool
			if !bool then
				self:SetMoveType(MOVETYPE_WALK)
			end
			net.Start("sitting")
				net.WriteEntity(self)
				net.WriteBool(bool)
			net.Broadcast()
		end)
	end 
 
	function  plymeta:SetStarAnim(anim)
		self.Animation = anim
		self:SetCycle(0)
		local id, dir = self:LookupSequence(anim)
		timer.Simple(dir, function()
			self.Animation = nil
		end)
		net.Start("Star_Anim")
				net.WriteEntity(self)
				net.WriteString(anim)
				net.WriteDouble(dir)
		net.Broadcast()
	end
	 
else

	net.Receive("sitting", function(len, ply)
		net.ReadEntity().Sitting = net.ReadBool()
	end)

		net.Receive("Star_Anim", function(len, ply)
			local ent = net.ReadEntity()
			local anim = net.ReadString()
			local dir = net.ReadDouble()
			ent.Animation = anim
			timer.Simple(dir, function()
				ent.Animation = nil
			end)
		end)

	net.Receive("net_ogc_actanim", function(len, pl)
		if pl then return end
		local ply = net.ReadEntity()
		local act = net.ReadDouble()
		ply.RunActAnim = act
	end)

	net.Receive("net_ogc_anim", function(len, pl)
		if pl then return end
		local ply = net.ReadEntity()
		local act = net.ReadString()
		ply.RunAnim = act
	end)

	
end
