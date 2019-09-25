local player = player

function player.FindInSphere(pos, range)
	local tbl = false
	for x,y in pairs(ents.FindInSphere(pos,range)) do
		if y:IsPlayer() then
			if !tbl then tbl = {} end
			table.insert(tbl, y)
		end
	end
	return tbl
end

local BadNames = {
	"Emperor.Host",
	"Emperor.Hos",
	"[KG]",
	".xyz/a",
	"{CRN}",
	"lastrevenant.xyz",
	"[Rapadant Networks]",
	"[RN]",
	"|VN|",
	"HFG",
	"IFN",
	"[IG]",
	"[IFN]",
	"SuperiorServers.co",
	"◄Reborn►",
	"[W-G]",
	"[GL]",
	"SPEC |",
	"❬«G§A»",
}

function plymeta:DisplayName()
	if !IsValid(self) then return self.displayname || "" end
	local name = self:GetName()
	--if self.displayname then
	--	return self.displayname
	--else
		for x,y in pairs(BadNames) do
			local tbl = string.Explode(y, name)
			name = table.concat(tbl, "")
		end
		self.displayname = name
		return name
	--end
end

local playernamefunction = function(self)
	local name = ""
	if self.Char then
		local fac = FACTIONS[self.Char.faction]

		if fac.Ranks[fac.RankID[self.Char.rank]].numbers then
			name =	fac.Tag .. " " .. self.Char.rank .. " " .. self.Char.numbers .. " " .. self.Char.name
		elseif fac.Tag then
			name =	fac.Tag .. " " .. self.Char.rank .. " " .. self.Char.name
		else
			name = self.Char.rank .. " " .. self.Char.name
		end
	else
		name = self:DisplayName()
	end
	return name
end

if SERVER then
function CharacterNameFromID(id)
	tbl = GetCharNameFromID(id)
	return playernamefunction({Char = tbl})
end

end
function plymeta:Nick()
	return playernamefunction(self)
end

function plymeta:Name()
	return playernamefunction(self)
end

function player:DisplayName(name)
	for x,y in pairs(BadNames) do
		local tbl = string.Explode(y, name)
		name = table.concat(tbl, "")
	end
	return name
end

if SERVER then
	function GM:PlayerCanSeePlayersChat( str, tea, ply1, ply2 )
		if ply1:GetPos():Distance( ply2:GetPos()) <= 512 then
			return true
		else
			return false
		end
	end

	function GM:PlayerSwitchFlashlight(ply)
		return true
	end

	function GM:CanPlayerSuicide(ply)
		if !ply.Sui then
			ply.Sui = true
			ply:SLChatMessage({Color(60,220,100), "[Player Thoughts] ", color_white, "Do I really need to kill myself?"})
			return false
		else

		    if ply:GetActiveWeapon():GetStripped() then
		        return false
		    end


			ply.Sui = false
			return true
		end
	end
end
/*

	ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, anim, 0, true )
	ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, 1 )
*/
hook.Add("CalcMainActivity", "ogc_animations", function(ply, velocity)

	if ply.RunActAnim then
		--local anim = ply:LookupSequence( "wallflip_back" )
		ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ply.RunActAnim, true)
		ply.RunActAnim = false
	end

	if ply.RunAnim then
		local anim = ply:LookupSequence(ply.RunAnim)
		ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, anim, 0, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, 1 )
		ply.RunAnim = false
	end

	if ply.Sitting then
		if SERVER then
			if ply:GetMoveType() != MOVETYPE_NONE then
				ply:SetSitting(false)
			end
		end
		return -1, ply:LookupSequence("wos_bs_shared_sit_idle")
	end


	--[[if (ply:Health() / ply:GetMaxHealth() )* 100 <= 10 then
		if !ply.LastStand then
			ply.LastStand = true
			if SERVER then
				ply:SetLocalVelocity(Vector(0,0,0))
				ply:SetMoveType(MOVETYPE_NONE)
			else
				if LocalPlayer() == ply then
				 net.Start("weapon_select")
				net.WriteDouble(2)
				net.SendToServer()
			end
			end

		end

		ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, ply:LookupSequence("ogc_kneeling"), 0, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, 1 )
	elseif ply.LastStand then
		ply.LastStand = nil
		if SERVER then
		ply:SetMoveType(MOVETYPE_WALK)
	end
		--return -1, ply:LookupSequence("wos_bs_shared_kneeling")
	end]]--

	if ply.Animation then
		return -1, ply:LookupSequence(ply.Animation)
	end


end)


function plymeta:GetMember()
	http.Fetch( "https://steamcommunity.com/groups/osirisgamingcommunity/memberslistxml/?xml=1",
	function(body)
		local playerIDStartIndex = string.find( tostring(body), "<steamID64>"..self:SteamID64().."</steamID64>" )
		if playerIDStartIndex == nil then
			self.member = false
		else

			if string.find(self:DisplayName(), "OGC" ) then
				self.member = true
			end
		end
	end,
	function()
		print("GROUP ERROR")
	end)
	return self.member
end






local Vocals = {
	"a",
	"e",
	"i",
	"o",
	"u",
}

local Consulants = {
	"b",
	"c",
	"f",
	"g",
	"h",
	"j",
	"k",
	"l",
	"m",
	"n",
	"p",
	"q",
	"r",
	"s",
	"t",
	"v",
	"w",
	"x",
	"z",
}

local random = math.random

function GenerateName(NumLetters)
	local FL 	= false
	local Name 	= ""
	local CH 	= false

	for i=1,NumLetters do
		if (!CH) then
			if (!FL) then Name=Name..Consulants[random(1,#Consulants)]:upper() FL = true
			else Name=Name..Consulants[random(1,#Consulants)] end

			CH = !CH
		else
			Name=Name..Vocals[random(1,#Vocals)]

			CH = !CH
		end
	end

	return Name
end

local Distance = 128
hook.Add( "SetupMove", "Arrest", function(ply, mv, cmd)


	if ply.hooked then
		local fo = mv:GetForwardSpeed()
		mv:SetVelocity( Vector(0,0,fo/40 ) )
		-- Check trace
		local trace =  util.TraceLine( {
			start = ply:GetPos(),
			endpos = ply:GetPos() + ply.hooked:Forward() * 32,
			filter = {self},
		})
		if !trace.Hit then
			if SERVER then
				ply:SetHookMode(false)
			end
		end
	end


	if ply.arrested then
		mv:SetMaxClientSpeed( mv:GetMaxClientSpeed()*0.1 )
		local kidnapper = ply.arrested
		local TargetPoint = (kidnapper:IsPlayer() and kidnapper:GetShootPos()) or kidnapper:GetPos()
		local MoveDir = (TargetPoint - ply:GetPos()):GetNormal()
		local ShootPos = ply:GetShootPos() + (Vector(0,0, (ply:Crouching() and 0)))

		local distFromTarget = ShootPos:Distance( TargetPoint )
		if distFromTarget<=(Distance+5) then return end
		if ply:InVehicle() then
			if SERVER and (distFromTarget>(Distance*3)) then
				ply:ExitVehicle()
			end

			return
		end

		local TargetPos = TargetPoint - (MoveDir*Distance)

		local xDif = math.abs(ShootPos[1] - TargetPos[1])
		local yDif = math.abs(ShootPos[2] - TargetPos[2])
		local zDif = math.abs(ShootPos[3] - TargetPos[3])

		local speedMult = 3+ ( (xDif + yDif)*0.5)^1.01
		local vertMult = math.max((math.Max(300-(xDif + yDif), -10)*0.08)^1.01  + (zDif/2),0)

		if kidnapper:GetGroundEntity()==ply then vertMult = -vertMult end

		local TargetVel = (TargetPos - ShootPos):GetNormal() * 10
		TargetVel[1] = TargetVel[1]*speedMult
		TargetVel[2] = TargetVel[2]*speedMult
		TargetVel[3] = TargetVel[3]*vertMult
		local dir = mv:GetVelocity()

		local clamp = 50
		local vclamp = 20
		local accel = 200
		local vaccel = 30*(vertMult/200)

		dir[1] = (dir[1]>TargetVel[1]-clamp or dir[1]<TargetVel[1]+clamp) and math.Approach(dir[1], TargetVel[1], accel) or dir[1]
		dir[2] = (dir[2]>TargetVel[2]-clamp or dir[2]<TargetVel[2]+clamp) and math.Approach(dir[2], TargetVel[2], accel) or dir[2]

		if ShootPos[3]<TargetPos[3] then
			dir[3] = (dir[3]>TargetVel[3]-vclamp or dir[3]<TargetVel[3]+vclamp) and math.Approach(dir[3], TargetVel[3], vaccel) or dir[3]
		end

		mv:SetVelocity( dir )
	end
end)



SPAWNPOINTS = SPAWNPOINTS || {}




local GRENADES = {
	["basic_grenade"] = {3, 6},
}

function plymeta:ThrowGrenade(ent, vel)
	self:EmitSound(Sound("WeaponFrag.Throw"))
	local e = ents.Create(ent)
	e:SetPos(self:GetShootPos())
	e:SetAngles(VectorRand():Angle())
	e:SetOwner(self)
	e:Spawn()
	e:Activate()
	if GRENADES[ent] then
		e:SetTimer(math.random(GRENADES[ent][1], GRENADES[ent][2]))
	else
		e:SetTimer(math.random(5, 10) )
	end
	local phys = e:GetPhysicsObject()
	if (IsValid(phys)) then
		phys:AddVelocity(self:GetAimVector()*phys:GetMass()*vel)
	end
end

_GRENADES = _GRENADES || {
	["Medical Supplies"] = {
		Name = "Medical Supplies",
		Spawn = function(ply)
			ITEMS["Medical Supplies"].use(ply)
		end,
	}
}

function RegisterGrenade(class, name, force)
	_GRENADES[class] ={Name = name, Spawn = function(ply)
		ply:ThrowGrenade(class, force)
	end}
	PrintTable(_GRENADES)
end
RegisterGrenade("basic_grenade", "Basic Grenade", 5)
function GetGrenades()
	return _GRENADES
end




SPECIALMDL = {}

function RegisterIdMDL(tbl)
    SPECIALMDL[tbl.Id] = tbl  
end

RegisterIdMDL({
    Name    = "Fives",
    Id      = 2,
    Model   = "asdasdasd",
})