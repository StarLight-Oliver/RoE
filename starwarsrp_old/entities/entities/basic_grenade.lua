--basic_grenade

AddCSLuaFile()

ENT.Base 		= "ogc_projectile_base"
ENT.Model		= "models/bf2/compiled 0.34/thermaldetonator.mdl"
function ENT:OnExplode()
	local pos = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetOrigin(pos)
	util.Effect( "HelicopterMegaBomb", effectdata, true, true )
	--util.Effect("bacta_effect", effectdata, true, true)
	self:EmitSound( Sound( "lfs/plane_explosion.wav" ) )
	util.BlastDamage(self, self.Owner, pos,250, 400)
end
--RegisterGrenade("basic_grenade", "Basic Grenade", 5)

RegisterITEMS( {
	name = "Basic Grenade", -- name of the item
	weapon = nil, -- is it a weapon
	model = ENT.Model, -- the model of it
	crafting = nil, -- what is the cost for crafting it
	price = nil,
	drop = nil, -- chance of it droping from a player
	use = nil,
})
