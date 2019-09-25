AddCSLuaFile()

ENT.Base 			= "cw_basic_npc"
ENT.PrintName = "Droideka"
ENT.Author = "StarLight"
ENT.CWNEXTBOTS = true
ENT.Spawnable		= true
ENT.AdminSpawnable		= true

local basesounds = "ogc/droideka/"
sound.Add( {
	name = "droideka_chase",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 90,
	pitch = { 95, 110 },
	sound = basesounds .. "rolling.mp3"
} )

sound.Add( {
	name = "droideka_unfold",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = { 95, 110 },
	sound = basesounds .. "foldout.mp3"
} )

for x = 1,2 do
	sound.Add( {
		name = "droideka_attack" .. x,
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 140,
		pitch = { 95, 110 },
		sound = basesounds .. "attack" .. x ..".wav"
	} )
end
 -- walking.mp3
sound.Add( {
	name = "droideka_walk",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = { 95, 110 },
	sound = basesounds .. "walking.mp3"
})

sound.Add( {
	name = "droideka_shieldon",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = { 95, 110 },
	sound = basesounds .. "shieldon.mp3"
} )

sound.Add( {
	name = "droideka_shieldoff",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = { 95, 110 },
	sound = basesounds .. "shieldoff.mp3"
} )




ENT.Sounds = {
	["walk"] = {"droideka_walk"},
	["chase"] = {"droideka_chase"},
	["attack"] = {"droideka_attack1", "droideka_attack2"},
	["shieldon"] = {"droideka_shieldon"},
	["shieldoff"] = {"droideka_shieldoff"},
}

function ENT:PreInitialize()
	self:SetupNextbot({
		runspeed 	= 800,
		walkspeed 	= 100,
		searchrange = 800,
		attackrange = 1120,
		looserange 	= 2000,
		jumpheight	= 200,
		health		= 5000,
		model		= "models/player/clonewars/perpgamer/droideka.mdl",
		runact 		= ACT_HL2MP_RUN_SLAM,
		walkact		= ACT_HL2MP_WALK,
		idleact		= ACT_IDLE,
		shield		= 10000,
	})
end
function ENT:PostInitialize()
end
function ENT:OnChase()
	if self:GetShieldEnabled() then
		self:SetShieldEnabled(false)
	end
	if (self.nextchasesound || 0 ) < CurTime() then
		local snd = table.Random(self.Sounds["chase"])
		self:EmitSound(snd)
		self.nextchasesound = CurTime() + 0.65
	end
	if (self:EnemyRange() < (self.MovementOptions.attackrange || 512)*0.5  and self:CanSeeEnemy()) then
		-- Might try the fold out sound
		self:EmitSound("droideka_unfold")
		return true
	end
end

function ENT:OnAttack()
	local A = self:GetEnemy()
	--A:TakeDamage(10,self)
	--A:SetVelocity((A:GetShootPos()-self:GetPos()):GetNormal()*100)
		if !self:GetShieldEnabled() then
			self:SetShieldEnabled(true)
		end

		while self:CanSeeEnemy() and !self:CanAttackEntity() do
			if A:GetPos():Distance(self:GetPos()) > (self.MovementOptions.attackrange || 512) then
				break
			end
			self.loco:FaceTowards( A:GetPos() )
			coroutine.yield()
		end
	--coroutine.wait(1)

	if (self.cooldown || 0 ) < CurTime() then
		self.cooldown = CurTime() + 1

		local pos = Vector(30,18,40)
		if math.random(0,1) then
			pos.y = -pos.y
		end

		local cone = 0.2
		local bullet = {}
		bullet.Num 	= 1
		bullet.Src 	= self:LocalToWorld(pos)
		bullet.Dir 	=  ( (A:GetPos() + Vector(0,0,45))-bullet.Src  ):GetNormalized()
		bullet.Spread 	= Vector( cone/2, cone/2, 0 )
		bullet.Tracer	= 1
		bullet.TracerName = "star_bullet"
		bullet.Force	= 100
		bullet.Damage	= 15

        self:FireBullets(bullet)
		local snd = table.Random(self.Sounds["attack"])
		self:EmitSound(snd)
		if A:Health() <= 0 then
			self:SetEnemy(nil)
		end
	end

	self:StartActivity( self.MovementOptions.idleact )
	return "ok"
end


function ENT:OnMovePos()
	if self:GetShieldEnabled() then
		self:SetShieldEnabled(false)
	end
	if (self.nextwalksound || 0 ) < CurTime() then
		local snd = table.Random(self.Sounds["walk"])
		self:EmitSound(snd)
		self.nextwalksound = CurTime() + 0.65
	end
	self:ScanEnemy()
	return self:HaveEnemy()
end

function ENT:OnKilled( dmginfo )
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self:BecomeRagdoll( dmginfo )
	self:Remove()
end