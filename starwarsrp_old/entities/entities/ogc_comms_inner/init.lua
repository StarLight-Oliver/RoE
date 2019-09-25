AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )
include( 'shared.lua' )

function ENT:Initialize()
	self:SetModel( "models/hawksstarwarsplacements/antenna_inside.mdl" )
	self:DrawShadow(true)
	--self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/citadel_hub_ambience1.mp3" )
	--self.BuildingSound:Play()
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetUseType( SIMPLE_USE )
	
	self:SetCollisionGroup( COLLISION_GROUP_NONE )	

end


function ENT:Use( ply )
	ply:ChatPrint("Health is currently at " .. math.ceil(self:GetFakeHealth()) .. " out of a max of " .. self:GetMaxFakeHealth())
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

function ENT:OnRepair(dmg)
	self:SetFakeHealth(math.Clamp(self:GetFakeHealth() + dmg, 0, self:GetMaxFakeHealth()))
	if self:GetComms() > 0.5 then
		self:SetSkin(0)
	end
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

function ENT:Think()
	if (self.timethink || 0 ) < CurTime() then
		INNERCOMMS_HEALTH = self:GetFakeHealth()
		self.timethink = CurTime() + 5
	end

end


function ENT:OnRemove()
	INNERCOMMS = ents.Create("ogc_comms_inner")
	INNERCOMMS:SetPos(Vector("843.706055 -5501.101563 -2940.811768"))
	INNERCOMMS:SetAngles(Angle(0,0,0))
	INNERCOMMS:SetModel("models/hawksstarwarsplacements/antenna_inside.mdl")
	INNERCOMMS:Spawn()
	INNERCOMMS:Activate()
	INNERCOMMS:SetFakeHealth(INNERCOMMS_HEALTH)
end
