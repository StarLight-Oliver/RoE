AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:EnableGravity(true) phys:Wake() end
	self.Entity:SetCustomCollisionCheck( true )
end
	
function ENT:SetItem( tbl, id, count )
	self.Item = tbl
	if id then
		self.ItemID = id
	end
	self.count = self.count
	self:SetItemType(tbl.type)
	self.Entity:SetModel(ITEMS[tbl.type].model)
	self:Initialize()
end
	
function ENT:Use( a, c)
	if a:IsPlayer() then
		if self.ItemID then
			a:GiveDatabaseItem(self.ItemID)
			self:Remove()
		else
			a:GiveItem(self.Item.type)
			if (self.count || 0) > 0 then
				self.count = self.count - 1
			else
				self:Remove()
			end
		end
	end
end

function ENT:Touch( ent )
end

function ENT:OnRemove()
end

function ENT:Think()
	self:SetAnimation("all_idle")
end