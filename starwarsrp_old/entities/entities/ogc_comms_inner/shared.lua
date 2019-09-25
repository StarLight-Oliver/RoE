ENT.Type 		= "anim"
ENT.PrintName	= "Comms"
ENT.Author		= "StarLight"
ENT.Contact		= ""
ENT.Category = "OGC CW"
ENT.Engineering = true
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:SetupDataTables()
	self:NetworkVar( "Float", 0, "FakeHealth" )
	self:NetworkVar( "Float", 1, "MaxFakeHealth" )
	
	if SERVER then
		self:SetFakeHealth(500)
		self:SetMaxFakeHealth(500)
	end
end

function ENT:GetComms()
	return math.Clamp(self:GetFakeHealth() / self:GetMaxFakeHealth(), 0, 1)
end

function ENT:OnTakeDamage(dmginfo)
	local dmg = dmginfo:GetDamage()
	if self:GetFakeHealth() > 0 then
		self:SetFakeHealth(self:GetFakeHealth() - dmg)
	else
		self:SetSkin(1)
	end
	return false
end


function ENT:Think()
	/*if not self.BuildingSound then
		self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/citadel_hub_ambience1.mp3" )
		self.BuildingSound:Play()
	end*/
end

function ENT:OnRemove()
	--self.BuildingSound:Stop()
end
