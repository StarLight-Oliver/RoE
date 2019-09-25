ENT.Type 		= "anim"
ENT.PrintName	= "Scout"
ENT.Author		= "StarLight"
ENT.Contact		= ""
ENT.Category = "OGC CW"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true



function ENT:OnTakeDamage(dmginfo)
	local dmg = dmginfo:GetDamage()
	if self:GetFakeHealth() > 0 then
		self:SetFakeHealth(self:GetFakeHealth() - dmg)
	end
	return false
end


function ENT:Think()

end

function ENT:OnRemove()
end
