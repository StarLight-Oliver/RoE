AddCSLuaFile()

ENT.Base 			= "ogc_npc_base"
ENT.Name			= "Human Thug"

if (CLIENT) then return end

function ENT:Initialize()
	self:SetModel( "models/Humans/Group03/Male_04.mdl" )
	--self:SetModel( "models/AntLion.mdl" )
	
	self.HP = 100
	
	self:InitializeBasics()
	self.AttackDelay = 7
	self.Damage = 10
	self.WalkSpeed = 70
	self.Group = true
	self.InjuredSound = {
		"",
	}
	self.dropitems = saberhilts
end


function ENT:Think()
end

