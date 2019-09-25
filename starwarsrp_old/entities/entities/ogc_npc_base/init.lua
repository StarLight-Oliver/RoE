
AddCSLuaFile("shared.lua")

include("shared.lua")

local Offset	= Vector(0,0,50)
local Up		= Vector(0,0,1)
local Mins,Maxs = Vector(-6,-6,0), Vector(6,6,4)

function ENT:InitializeBasics()
	self:SetUseType(SIMPLE_USE)
	
	self.Target 		= nil
	self.TargetRadius	= 100
	
	self.CanTarget		= true
	self.CanTakeDamage	= true
	
	self.WalkSpeed		= 70
	self.RunSpeed		= 200
	
	self.MoveType		= "Walk"
	self.Task			= ""
	
	self.SoundCD		= CurTime()
	self.JumpCD			= CurTime()
	self.LastLocation	= Vector(0,0,0)
	
	--ACTS
	self.ACT_Run 	= ACT_RUN
	self.ACT_Walk 	= ACT_WALK
	self.ACT_Idle 	= ACT_IDLE
	
	self.FreezeMovement	= false
	
	self.HP 			= self.HP or 100
	self.XP 			= (self.XP or 10)*1.02^self:GetLevel()
	
	local SCHP 			= self.HP*1.18^self:GetLevel()
	
	self:SetHealthCap( SCHP )
	self:SetHealth( SCHP )
	self:SetCollisionBounds( Vector(-8,-8,0), Vector(8,8,64) ) --I thank you facepunch for this fix "twoski" more specifically.

	self.loco:SetJumpHeight(50)
end

--Main Course
function ENT:RunBehaviour()
	while ( true ) do
		local t = self:GetTarget()
		
		if (IsValid(t)) then
			if (!self:InRangeOfTarget()) then
				self:AssignSpeedActivity()
				self:ChaseTarget()		
				self:StartActivity( self.ACT_Idle )
			else
				self.loco:FaceTowards( t:GetPos() )
			end
			
			coroutine.yield()
		else
			local SPos 	= self.Origin or self:GetPos()
			local pos 	= SPos+VectorRand()*(self.Radius or 1000)
			pos.z = SPos.z
			
			local cnav = navmesh.GetNearestNavArea( pos )
			local err = "interrupt"
			
			if (cnav) then
				pos = cnav:GetRandomPoint()
				
				if (pos) then
					self:AssignSpeedActivity()			
					
					err = self:MoveToPos( pos )
					
					self:StartActivity( self.ACT_Idle )
				end
			end
			
			if (err == "interrupt") then 
				coroutine.yield()
			else
				coroutine.wait(math.random(5,10))
			end
		end
		
	end
end	

--OVERRIDE
function ENT:PrimaryAttack()
end

function ENT:SecondaryAttack()
end

-- Movetype functions
function ENT:SetSpeedType( movetype )
	self.MoveType = movetype or "Walk"
end

function ENT:GetSpeedType()
	return self.MoveType
end

-- target functions
function ENT:SetTarget( ent )
	if (ent == self or !self.CanTarget) then return end
	
	if (IsValid(ent)) then self.MoveType = "Run"
	else self.MoveType = "Walk" end
	
	self.Target 	= ent
end

function ENT:GetTarget()
	return self.Target
end

function ENT:TargetRange()
	if (IsValid(self.Target)) then return self:GetRangeTo( self.Target:GetPos() ) end
	return false
end

function ENT:CanSeeTarget()
	if (!IsValid(self.Target)) then return end
	
	local tr = util.TraceLine({
		start=self:GetPos()+Offset,
		endpos=self.Target:GetPos()+Offset,
		filter={self,self.Target},
		mask=MASK_NPCSOLID
	})
	
	return (!tr.Hit or tr.Entity == self.Target)
end

function ENT:HaveTarget()
	return IsValid(self.Target)
end

function ENT:CheckTargetDeath()
	if (IsValid(self.Target) and self.Target:Health() <= 0) then
		self:OnTargetDeath()
	end
	return
end

function ENT:OnTargetDeath()
	self:SetLevel(self:GetLevel() + 1)
	return
end

function ENT:InRangeOfTarget()
	return self:TargetRange() < self.TargetRadius
end

--Speed and activity adjustments
function ENT:AssignSpeedActivity()
	if (self.MoveType == "Walk") then
		self:StartActivity( self.ACT_Walk )
		self.loco:SetDesiredSpeed( self.WalkSpeed )	
	else
		self:StartActivity( self.ACT_Run )
		self.loco:SetDesiredSpeed( self.RunSpeed )	
	end
end

--CheckJump
function ENT:CheckJump()
	if (self.JumpCD < CurTime() and !self.loco:IsClimbingOrJumping() and self.loco:IsAttemptingToMove()) then
		self.JumpCD	= CurTime()+0.5
		
		local vel = self.loco:GetVelocity()
		
		if (vel:Length() < 10) then
			local JumpHeight = self.loco:GetJumpHeight()
			local Pos1 = self:GetPos()+Vector(0,0,10)
			local Pos2 = self:GetPos()+Vector(0,0,JumpHeight)
			local Aim = self:EyeAngles():Forward()
			
			--What? Is this guy stuck or something? Try jumping
			local TrDN = util.TraceLine({
				start = Pos1,
				endpos = Pos1+Aim*40,
				filter = self,
				mask = MASK_SOLID_BRUSHONLY,
			})
			
			local TrUP = util.TraceLine({
				start = Pos2,
				endpos = Pos2+Aim*40,
				filter = self,
				mask = MASK_SOLID_BRUSHONLY,
			})
			
			if (TrDN.Hit and !TrUP.Hit and !TrDN.StartSolid) then
				self._OldActivity = self:GetActivity()
				self.loco:Jump()
			end
		end
		
	elseif (self.loco:IsClimbingOrJumping() and self.JumpCD < CurTime()+0.4) then
		self.loco:SetVelocity(self.loco:GetVelocity()+self:EyeAngles():Forward())
	end
end

--Function on EndChase
function ENT:OnEndChase()

end

--Activity functions
function ENT:PlayActivity(act)
	if self:GetActivity()~=act then
		self:StartActivity(act)
	end
end

--Default Chase Think function
function ENT:OnChaseThink()
		self:OnMovePos()
end

--Chase target function
function ENT:ChaseTarget( options )
	local options = options or {}

	local path = Path( "Chase" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self.Target:GetPos() )

	if (!path:IsValid()) then return "failed" end

	while (path:IsValid() and self:HaveTarget() and (!self:InRangeOfTarget() or !self:CanSeeTarget())) do
		path:Chase( self , self.Target ) 
		
		if ( path:GetAge() > 0.1 ) then				
			path:Compute( self, self.Target:GetPos() )
		end
		
		if ( options.draw ) then path:Draw() end
		
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			self:OnEndChase()
			return "stuck"
		end
		
		if (self:OnChaseThink()) then return "interrupt" end
		
		self:CheckTargetDeath()

		coroutine.yield()
	end

	self:OnEndChase()
	return "ok"
end

--Override MoveToPos with a hook, that allows me to interrupt it!
--(Basically garrys own function, but with the OnMovePos being called during the loop, so I can interrupt it.)
-- DEFAULT:
function ENT:OnMovePos()
	if (!self.CheckDoor or self.CheckDoor < CurTime()) then
		self:CheckDoorOpen()
		self.CheckDoor = CurTime()+1
	end
	
	return self:HaveTarget()
end


function ENT:MoveToPos( pos, options )
	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do
		path:Update( self ) 
		--self:CheckJump()

		-- Draw the path (only visible on listen servers or single player)
		if ( options.draw ) then
			path:Draw()
		end

		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then

			self:HandleStuck();
			
			return "stuck"

		end

		--
		-- If they set maxage on options then make sure the path is younger than it
		--
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		--
		-- If they set repath then rebuild the path every x seconds
		--
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end
		
		if (self:OnMovePos()) then return "interrupt" end

		coroutine.yield()

	end

	return "ok"
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

--Some hooks
function ENT:Use(user)
end

function ENT:NPCUse(npc)
end

function ENT:IsNextBot()
	return true
end

function ENT:OnStuck()
end

function ENT:OnLandOnGround()
	if (self._OldActivity) then self:StartActivity(self._OldActivity) end
	self.JumpCD	= CurTime()+0.5
end

function ENT:OnLeaveGround()
end

function ENT:OnKilled( dmginfo )
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	
	local att = dmginfo:GetAttacker()
--	if (IsValid(att) and att:IsPlayer()) then att:AddXP(self.XP,"MAIN") end
	
	if (self.DeathSound) then 
		local s = table.Random(self.DeathSound)
		self:EmitSound(s) 
	end
	 
	--self:BecomeRagdoll( dmginfo )
	self:Remove()
	if self.dropitems then
		local tbl = table.Random(self.dropitems)
		local item = getItems(tbl)
		CreateItem( att, tbl, self:GetPos(), {tbl, 1, {"false", {"fff", "fff"},},} )
	end
end

function ENT:OnInjured( dmginfo )
    if (self.InjuredSound) then
        local s = table.Random(self.InjuredSound)
        self:EmitSound(s)
    end
   
    local att = dmginfo:GetAttacker()
   
    if ((!IsValid(self:GetTarget())) and IsValid(att) and att:IsPlayer()) then
      	self:SetTarget(att)
    end 
 
    if (!self.CanTakeDamage) then
        dmginfo:SetDamage(0)
    end
end


function ENT:BodyUpdate()
	self:BodyMoveXY()
end







