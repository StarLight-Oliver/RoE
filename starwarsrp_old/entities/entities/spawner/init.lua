AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel( "models/Mechanics/gears/gear24x6.mdl" )
	self:SetModelScale( 1 )

	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)

	--self:SetRenderMode( RENDERMODE_TRANSALPHA )
end

function ENT:OnRemove()

end


function ENT:Think()
	if (self.spawncooldown || 0 ) < CurTime() then
		self:SetHealth(1)
		local data = self.data
		if !data then
			Spawn_NPC(self:GetPos() + Vector(0,0, 100), "models/battle_droid.mdl", true)
		else
			if data.num == 1 then
				Spawn_NPC(ply:GetEyeTrace().HitPos, data.mdl, data.wep, data.health)
			else
				local val = 360 / (data.num+1)

				for x = 1, data.num do
					Spawn_NPC(self:GetPos() + Angle(0, val*x,0 ):Forward() * (10*data.num), data.mdl, data.wep, data.health)
				end
			end

		end

		self.spawncooldown = CurTime() + math.random(60, 120)
	end
end

function ENT:SetNPCData(tbl)
	self.data = tbl
	self:SetNPCHealth(tbl.health)
end