ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "NPC Spawner"
ENT.Author = "Anthony Fuller"
ENT.Category = "OGC | Events"
ENT.Spawnable = true
ENT.Contact = "An admin."

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 4, "NPCHealth")
end


function ENT:OnTakeDamage(dmginfo)
	local dmg = dmginfo:GetDamage()
	self:SetNPCHealth(self:GetNPCHealth() - dmg)
	if self:GetNPCHealth() <= 0 then
		self:Remove()
	end
end