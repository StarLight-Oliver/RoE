AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.CWNEXTBOT       = true

--We localise some expensive functions to improve performance.
local HasValue 	= table.HasValue
local Offset	= Vector(0,0,30)

--DefaultVars
local MovementPathOptions = {
	lookahead = 300,
	tolerance = 20,
	drawpath  = false,
}

local MovementOptions = {
	runspeed 	= 300,
	walkspeed 	= 80,
	searchrange = 1000,
	looserange 	= 5000,
	jumpheight	= 60,
	health		= 30,
	model		= "models/antlion.mdl",
	runact 		= ACT_RUN,
	walkact 	= ACT_WALk,
	idleact 	= ACT_IDLE,
}

function ENT:SetupNextbot(Options)
	self.MovementOptions 		= Options or MovementOptions
end

--Initialize
function ENT:Initialize()
	self:PreInitialize()

	self.MovementOptions 		= self.MovementOptions or MovementOptions
	self:SetModel( self.MovementOptions.model or MovementOptions.model )



	self.LoseTargetDist	= self.MovementOptions.looserange or MovementOptions.looserange
	self.SearchRadius 	= self.MovementOptions.searchrange or MovementOptions.searchrange
	self.MaxRunSpeed	= self.MovementOptions.runspeed or MovementOptions.runspeed
	self.MaxWalkSpeed	= self.MovementOptions.walkspeed or MovementOptions.walkspeed
	self.MaxJumpHeight	= self.MovementOptions.jumpheight or MovementOptions.jumpheight
	self.MaxHealth		= self.MovementOptions.health or MovementOptions.health



	self.LastPos		= Vector(0,0,0)

	self:SetHealth(self.MaxHealth)
	if SERVER then
		self.loco:SetJumpHeight(self.MaxJumpHeight)
		self.loco:SetAcceleration( 900 )
		if self.MovementOptions.shield then
			self:SetShield(self.MovementOptions.shield)
			self:SetMaxShield(self.MovementOptions.shield)
		end
		self:SetCollisionBounds( Vector(-8,-8,0), Vector(8,8,64) )
		self:EnableCustomCollisions( true )
	end
	self.Enemy = nil

	self:PostInitialize()
end

function ENT:PreInitialize()
end

function ENT:PostInitialize()
end

local shield = {
	[true] = "shieldon",
	[false] = "shieldoff",
}
function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "ShieldEnabled")


	self:NetworkVar("Float", 0 ,"Shield")
	self:NetworkVar("Float", 1, "MaxShield")

	self:NetworkVarNotify("ShieldEnabled", function(self, str, old, new)
		local ss = shield[new]
		local snd = table.Random(self.Sounds[ss])
		self:EmitSound(snd)
	end )
end

--Set and get enemy. Pretty standard.
function ENT:SetEnemy( ent )
	self.Enemy = ent
end
function ENT:GetEnemy()
	return self.Enemy
end


--Function for getting a range to the current target. Returns -1, if there is no target.
function ENT:EnemyRange()
	if (IsValid(self.Enemy)) then return self:GetRangeTo( self.Enemy:GetPos() ) end
	return -1
end

--Simple function for outside stuff.
function ENT:HaveEnemy()
	return (IsValid(self.Enemy))
end

function ENT:AssignSpeedActivity()
	if (self:GetVelocity():Length() < self.MaxWalkSpeed) then
		self:StartActivity( self.MovementOptions.walkact || Options.walkact )
	else
		self:StartActivity(self.MovementOptions.runact || Options.runact )
	end
end

function ENT:CheckJump()
	if (self.LastPos:Distance(self:GetPos()) < 2) then
	end

	self.LastPos = self:GetPos()
end

--Dear AwesomeX.
--We create a simple function for use with other npcs. Don't need to edit this.
--Simply call entity:ScanEnemy() to make the npc find an enemy, thereby it will
--automatically start hunting it!
function ENT:ScanEnemy()
	local obs = ents.FindInSphere( self:GetPos(), self.SearchRadius )

	for k,v in pairs( obs ) do
		if (v:IsPlayer() and v:Alive()) then
			self:SetEnemy(v)
			break
		end
	end
end

--This function checks if the npc can see the enemy
function ENT:CanSeeEnemy()
	if (!self:HaveEnemy()) then return end

	local tr = util.TraceLine({
		start=self:GetPos()+Offset,
		endpos=self.Enemy:GetPos()+Offset,
		filter={self,self.Enemy},
		mask=MASK_NPCSOLID
	})

	return !tr.Hit
end

function ENT:CanAttackEntity()
	local tr = util.TraceLine({
		start = self:GetPos() + Offset,
		endpos = self:GetPos()+ Offset+ self:GetAngles():Forward() * self.MovementOptions.attackrange,
		filter = {self},
	})
	if IsValid(tr.Entity) then
		local ent = tr.Entity
		if ent == self:GetEnemy() then
			return true
		else
			if ent:IsPlayer() then
				self:SetEnemy(ent)
				return true
			else
				return false
			end
		end
	else
		return false
	end
end






--This function is called, when the big monster is chasing a target
function ENT:OnChase()
end

--This function is called, when the big monster is simply moving to a given vector pos
--Return true to interrupt
function ENT:OnMovePos()
end

--THIS IS OUR MAIN FUNCTION. This is the main loop. The "Think" sortaspeak for this NPC.
--Though, you can still use the regular think function for basic stuff, but anything related
--to Nextbot and AI stuff, should go here.
function ENT:RunBehaviour()
	while ( true ) do
		local En = self:GetEnemy()

		if ( IsValid(En) ) then
			self.loco:FaceTowards( En:GetPos() )
			if En:GetPos():Distance(self:GetPos()) < (self.MovementOptions.attackrange || 512) then
				self:OnAttack()
				coroutine.wait( 0.01 )
			else
				self:StartActivity(self.MovementOptions.runact || Options.runact )
				self.loco:SetDesiredSpeed( self.MaxRunSpeed )
				self:ChaseEnemy()
				self:StartActivity(self.MovementOptions.idleact || Options.idleact )
			end
		else
			self:StartActivity( self.MovementOptions.walkact || Options.walkact )
			self.loco:SetDesiredSpeed( self.MaxWalkSpeed )
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 300 )
			self:StartActivity(self.MovementOptions.idleact || Options.idleact )
			coroutine.wait( 1 )
		end

	end
end

function ENT:OnAttack()

end
--The Chase Enemy function. Classic, but useful.
function ENT:ChaseEnemy( )
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( MovementPathOptions.lookahead )
	path:SetGoalTolerance( MovementPathOptions.tolerance )
	path:Compute( self, self:GetEnemy():GetPos() )

	if (!path:IsValid()) then 	coroutine.yield() return "failed" end

	while (path:IsValid() and self:HaveEnemy()) do

		if (path:GetAge() > 0.1 )then
			path:Compute( self, self:GetEnemy():GetPos() )
		end

		path:Update( self )

		local val = self:OnChase()
		if val then
			return "interrupt"
		end
		self:CheckJump()

		if ( MovementPathOptions.drawpath ) then path:Draw() end

		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()
	end

	return "ok"
end


--We override Garrys fcking annoying MoveToPos, because we want to be able to interrupt it!
function ENT:MoveToPos( pos, options )
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( MovementPathOptions.lookahead )
	path:SetGoalTolerance( MovementPathOptions.tolerance )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then 	coroutine.yield() return "failed" end

	while ( path:IsValid() ) do
		path:Update( self )

		if ( MovementPathOptions.drawpath ) then path:Draw() end

		if ( self.loco:IsStuck() ) then
			self:HandleStuck();
			return "stuck"
		end

		--self:CheckJump()

		if (self:OnMovePos()) then return "interrupt" end

		coroutine.yield()

	end

	return "ok"
end


--These functions below are some standard hooks bound to be overrided.
function ENT:OnStuck()
    if (!self.CheckDoor or self.CheckDoor < CurTime()) then
		self:CheckDoorOpen()
		self.CheckDoor = CurTime()+1
	end
end

function ENT:OnLandOnGround()
	self:StartActivity( ACT_RUN )
end

function ENT:OnLeaveGround()
	self:StartActivity(ACT_JUMP)
end

function ENT:OnKilled( dmginfo )
	self:BecomeRagdoll( dmginfo )
end

function ENT:OnInjured( dmginfo )


	if self:GetShieldEnabled() then
		local dmg = dmginfo:GetDamage()


		-- Effect code here

		if self:GetShield() >= dmg then
			self:SetShield(self:GetShield() - dmg)
			dmginfo:SetDamage(0)
		else
			self:SetShield(0)
		end

    end
    if dmginfo:GetAttacker():IsPlayer() then
	    self:SetEnemy(dmginfo:GetAttacker())
	end
end

function ENT:CheckDoorOpen()
	local tr = util.TraceLine({
		start=self:GetPos()+Offset,
		endpos=self:GetPos()+(self:EyeAngles():Forward()*70)+Offset,
		filter=self,
		mask=MASK_NPCSOLID
	})
	
	local door = tr.Entity
	if (IsValid(door)) then
		if (string.match(door:GetClass(),"door")) then
			if (IsValid(door)) then
				door:Fire("Unlock","",0)
				door:Fire("Open","",0)
				door:SetNotSolid(true)
				
				timer.Simple(2,function() if (IsValid(door)) then door:SetNotSolid(false) end end)
			end
		end
	end
end

local starcolor = Material("starcolor")
function ENT:Draw()
	if !self.size then self.size = 0 end
	self:DrawModel()
	if self:GetShieldEnabled() and self:GetShield() > 0 then
		self.size = math.Clamp(self.size + FrameTime() * 200, 0, 50)
	elseif self.size != 0 then
		self.size = math.Clamp(self.size - FrameTime() * 400, 0, 50)
	end


	if self.size > 0 then
		render.SetMaterial(starcolor)
		render.DrawSphere(self:GetPos() + Offset, self.size, 30, 30, Color( 0, 175, 175, 100 * (self:GetShield()/self:GetMaxShield()) ) )
	end
end