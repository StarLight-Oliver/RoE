AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/plates/plate1x1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:EnableGravity(false) phys:Wake() end
	self:SetCustomCollisionCheck( true )
end
	
function ENT:Use( a, c)
end

function ENT:Touch( ent )
end

function ENT:OnRemove()
end

function ENT:Think()
	--self:SetAnimation("all_idle")
end


hook.Add("ShouldCollide", "shooting_range", function(ent1, ent2)
	if ent1:GetClass() == "shooting_range" then
		if ent2:GetOwner() != ent1:GetTarget() then
			return false
		elseif ent1:GetTarget() != ent2 then
			return false
		else
			return true
		end
	elseif ent2:GetClass() == "shooting_range" then
		if ent1:GetTarget() != ent2:GetOwner() then
			return false
		elseif ent2:GetTarget() != ent1 then
			return false
		else
			return true
		end
	end
end)