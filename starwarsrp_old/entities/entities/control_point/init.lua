AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

	self:SetModel( "models/starwars/syphadias/props/sw_tor/bioware_ea/props/imperial/imp_cantina_holopad.mdl" )

	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysicsInit(SOLID_VPHYSICS)
end

local nocap = {
	["Jedi"] = true,
	["CIS"]  = true,
	["Staff"] = true,
}


function ENT:Think()
	if self:GetProgress() == self:GetMaxProgress() then return end
	if ( self.last || 0) >= CurTime() then return end
	local val = 0
	local pl = {}
	for b,e in pairs(ents.FindInSphere( self:GetPos(), 250 )) do
		if !e:IsPlayer() then
			if e:GetClass() == "npc_combine_s" then return end
			continue
		end
		if !e.Char then continue end 
		if nocap[e.Char.faction] then
			return
		end
		pl[ #pl + 1] = e
		val = val + self:GetIncrement()
	end
	if val != 0 then

		for index, ply in pairs(pl) do
			ply:AddMoney(50)
		end

		self:SetProgress(math.Clamp(self:GetProgress() + val, 0 ,self:GetMaxProgress()))
		self.last = CurTime() + self:GetDelay()
	end

end

function ENT:Use()

	print( "Number to get to = " .. (self.progress || 0) )

end
