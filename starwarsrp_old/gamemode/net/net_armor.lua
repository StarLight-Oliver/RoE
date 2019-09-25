
if SERVER then
	util.AddNetworkString("net_armor_set")

	function plymeta:SetArmour(int)
		self.MaxArmor = int
		self:SetArmor(int)
		net.Start("net_armor_set")
			net.WriteDouble(int)
		net.Send(self)
	end

	function ArmorRegen(ent)
		if !IsValid(ent) then return end
		ent:SetArmor(math.Clamp(ent:Armor() + 1, 0, ent.MaxArmor))
		ent.regenval = math.Clamp( ent.regenval - 0.5, 0.1, 5)
		if ent:Armor() == ent.MaxArmor then return end
		timer.Create("armorregen" .. ent:EntIndex(), ent.regenval, 1, function()
			ArmorRegen(ent)
		end)
	end

	hook.Add("EntityTakeDamage", "armor_system", function(ent, dmg)
		if ent:IsPlayer() then
			if dmg:GetDamageType() == DMG_BULLET then
				local dm = dmg:GetDamage() / 5
				if ent:Armor() - dm < 0 then
					dm = dm - ent:Armor()
					ent:SetArmor(0)
				else
					ent:SetArmor(ent:Armor() - dm)
					dm = dm * 0.25
				end
				dmg:SetDamage(dm * 5)
				ent.regenval = 5
				timer.Create("armorregen" .. ent:EntIndex(), ent.regenval, 1, function()
					ArmorRegen(ent)
				end)
			end
			ent.regenval = 5
			timer.Create("armorregen" .. ent:EntIndex(), ent.regenval, 1, function()
				ArmorRegen(ent)
			end)
		end
	end)


else
	net.Receive("net_armor_set", function(len, pl)
		local num = net.ReadDouble()
		LocalPlayer().MaxArmor = num
	end)
end
