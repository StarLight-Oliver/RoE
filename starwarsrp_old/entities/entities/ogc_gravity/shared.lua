ENT.Type 		= "anim"
ENT.PrintName	= "Gravity"
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
		self:SetFakeHealth(1000)
		self:SetMaxFakeHealth(1000)
	end
end

function ENT:GetComms()
	return math.Clamp(self:GetFakeHealth() / self:GetMaxFakeHealth(), 0.000000001, 2)
end


function ENT:Think()
	/*if not self.BuildingSound then
		self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/citadel_hub_ambience1.mp3" )
		self.BuildingSound:Play()
	end*/
	
	
	if (self.timethink || 0 ) < CurTime() then
		GRAVITY_HEALTH = self:GetFakeHealth()
		self.timethink = CurTime() + 5
	end
	
	if self:GetSkin() == 1 then
		if (self.Sparks || 0 ) < CurTime() then
			for x = 1, 10 do
				local effectdata = EffectData()
				effectdata:SetOrigin(self:GetPos() + Vector(math.Rand(-100,100), math.Rand(-100, 100), math.Rand(20, 250)))
				--util.Effect("ManhackSparks", effectdata)
				--util.Effect("cball_explode", effectdata)
			end
			self.Sparks = CurTime() + 5
		end
	end
	if CLIENT then return end
	if self:GetComms() >= 1.5 then
		if (self.playerdamage || 0) < CurTime() then
				
			for index, ply in pairs(player.GetAll()) do
				if IsValid(ply) and ply.Char and ply:Alive() then 
					local d = DamageInfo()
					d:SetDamage( 1 * self:GetComms() )
					d:SetAttacker(ply)
					d:SetDamageType(DMG_DIRECT)
					
					ply:TakeDamageInfo( d )
				end
			end
			self.playerdamage = CurTime() + math.random(10, 20)
		end
	end
end

