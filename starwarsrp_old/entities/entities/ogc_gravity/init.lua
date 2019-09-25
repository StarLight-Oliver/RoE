AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/hawksstarwarsplacements/grav_gen.mdl" )
	self:DrawShadow(true)
	--self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/citadel_hub_ambience1.mp3" )
	--self.BuildingSound:Play()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:DropToFloor()
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType( SIMPLE_USE )
	
end


function ENT:Use( ply )
	ply:ChatPrint(self:GetComms())
	ply:ChatPrint(ply:GetGravity())
	ply:ChatPrint("Health is currently at " .. math.ceil(self:GetFakeHealth()) .. " out of a max of " .. self:GetMaxFakeHealth())
end

function ENT:OnTakeDamage(dmginfo)
	local dmg = dmginfo:GetDamage()
	if self:GetFakeHealth() > 0 then
		self:SetFakeHealth(self:GetFakeHealth() - dmg)
		if self:GetFakeHealth() <= 0 then
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos() + Vector(math.Rand(-30, 30),math.Rand(-30, 30), math.Rand(-60, 60) ))
			util.Effect("Explosion", effectdata)
			util.Effect("WheelDust", effectdata)
			self.Entity:SetSkin(2)
		elseif self:GetFakeHealth() < self:GetMaxFakeHealth()/2 then
			self.Entity:SetSkin(1)
		else
			self.Entity:SetSkin(0)
		end
		for index, ply in pairs(player.GetAll()) do
			ply:SetGravity(self:GetComms())
		end
	end
	return false
end

function ENT:OnRepair(dmg)
	if self:GetFakeHealth() <= 0 then
		self.Entity:SetSkin(1)
	end
	if self:GetFakeHealth() > self:GetMaxFakeHealth()/2 then
		self.Entity:SetSkin(0)
	end
	
	
	for index, ply in pairs(player.GetAll()) do
		ply:SetGravity(self:GetComms())		
	end
	
	self:SetFakeHealth(math.Clamp(self:GetFakeHealth() + dmg, 0, self:GetMaxFakeHealth() * 2))
end


function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end


function ENT:OnRemove()
	GRAVITYGEN = ents.Create("ogc_gravity")
	GRAVITYGEN:SetPos(Vector("1470.996460 -8252.791992 -2894.811768"))
	GRAVITYGEN:SetAngles(Angle(0,0,0))
	GRAVITYGEN:SetModel("models/hawksstarwarsplacements/grav_gen.mdl")
	GRAVITYGEN:Spawn()
	GRAVITYGEN:Activate()
	GRAVITYGEN:OnRepair(0)
end