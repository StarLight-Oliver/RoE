local tbl = {}

NPCModel = {
	[1] = "models/tfa/comm/gg/npc_comb_sw_droid_b1.mdl",
	[2] = "models/tfa/comm/gg/npc_comb_sw_droid_commander.mdl",
	[3] = "models/tfa/comm/gg/npc_comb_sw_droid_commando.mdl",
	[4] = "models/tfa/comm/gg/npc_comb_sw_droid_tactical.mdl",
	[5] = "models/tfa/comm/gg/npc_comb_sw_t_droid_b1.mdl",
}


local YawIncrement = 20
local PitchIncrement = 10
local flightspeed = 5000
local flighttime = 8
local damage = 90
local damageradius = 512
local smoketime = 8
local startingheight = 1000
local timebeforeremove = 15
NPC_MODE = {
	["Normal"] = function(ply, data)
		if data.num == 1 then
			Spawn_NPC(ply:GetEyeTrace().HitPos, data.mdl, data.wep, data.health)
		else
			local val = 360 / (data.num+1)

			for x = 1, data.num do
				Spawn_NPC(ply:GetEyeTrace().HitPos + Angle(0, val*x,0 ):Forward() * (10*data.num), data.mdl, data.wep, data.health)
			end
		end
	end,
	["Spawner"] = function(ply, data)
		local ent = ents.Create("spawner")
		ent:SetPos(ply:GetEyeTrace().HitPos)
		ent:Spawn()
		ent:Activate()
		ent:SetMoveType(MOVETYPE_NONE)
		ent:SetNPCData(data)
	end,
	["Breach"] = function(ply, data)
		local time = 0
		local mdl, wep, health = data.mdl, data.wep, data.health
		for x = 1, data.num do
			timer.Simple(time, function()
				Spawn_NPC_RAID(mdl, wep, health)
			end)
			time = time + math.random(120, 300)
		end
	end,
	["Droppod"] = function(ply, data)
			-- Can we cry
		local tr = ply:GetEyeTrace()
		local aBaseAngle = tr.HitNormal:Angle()
        local aBasePos = tr.HitPos
        local bScanning = true
        local iPitch = 10
        local iYaw = -180
        local iLoopLimit = 0
        local iProcessedTotal = 0
        local tValidHits = {}

        while (bScanning == true && iLoopLimit < 500) do
            iYaw = iYaw + YawIncrement
            iProcessedTotal = iProcessedTotal + 1
            if (iYaw >= 180) then
                iYaw = -180
                iPitch = iPitch - PitchIncrement
            end

            local tLoop = util.QuickTrace( aBasePos, (aBaseAngle+Angle(iPitch,iYaw,0)):Forward()*40000 )
            if (tLoop.HitSky || bSecondary) then
                table.insert(tValidHits,tLoop)
            end

            if (iPitch <= -80) then
                bScanning = false
            end
            iLoopLimit = iLoopLimit + 1
        end

        local iHits = table.Count(tValidHits)
        if (iHits > 0) then
            local iRand = math.random(1,iHits)
            local tRand = tValidHits[iRand]

            local ent = ents.Create( "env_headcrabcanister" )
            ent:SetPos( aBasePos )
            ent:SetAngles( (tRand.HitPos-tRand.StartPos):Angle() )
            ent:SetKeyValue( "HeadcrabCount", 0 )
            ent:SetKeyValue( "FlightSpeed", flightspeed )
            ent:SetKeyValue( "FlightTime", flighttime )
            ent:SetKeyValue( "Damage", damage )
            ent:SetKeyValue( "DamageRadius", damageradius )
            ent:SetKeyValue( "SmokeLifetime", smoketime )
            ent:SetKeyValue( "StartingHeight", startingheight )
            ent:Spawn()

            ent:Input("FireCanister", ply, ply)

            local val = 360 / 6

            timer.Simple(9, function()
					local val = 360 / (data.num+1)

					for x = 1, data.num do
						Spawn_NPC(aBasePos + Angle(0, val*x,0 ):Forward() * (100 + 10*(data.num) ), data.mdl, data.wep, data.health)
					end
            end)
        end

	end,
	["Droideka"] = function(ply, data)
		if data.num == 1 then
			--Spawn_NPC(ply:GetEyeTrace().HitPos, data.mdl, data.wep, data.health)
			local ent = ents.Create("cw_droideka")
			ent:SetPos(ply:GetEyeTrace().HitPos)
			ent:Spawn()
			ent:Activate()
		else
			local val = 360 / (data.num+1)

			for x = 1, data.num do
				--Spawn_NPC(ply:GetEyeTrace().HitPos + Angle(0, val*x,0 ):Forward() * (10*data.num), data.mdl, data.wep, data.health)
				local ent = ents.Create("cw_droideka")
				ent:SetPos(ply:GetEyeTrace().HitPos + Angle(0, val*x,0 ):Forward() * (10*data.num))
				ent:Spawn()
				ent:Activate()
			end
		end
	end,
}

local tbl = {}
tbl.name = "Spawn NPC"
tbl.args = false
tbl.panel = false
tbl.cmd = "!spawnnpc"
tbl.svfunction = function(ply)
	if (ply.NPCSPAWNING || 0) < CurTime() then
		MsgC("Spawning\n")
			ply.NPCSPAWNING = CurTime() + 1
	if !ply.NPCData then
		Spawn_NPC(ply:GetEyeTrace().HitPos, "models/battle_droid.mdl", true)
	else
		PrintTable(ply.NPCData)
		NPC_MODE[ply.NPCData.mode](ply, ply.NPCData)
	end
end
end
tbl.clfunction = function(ply)
end
RegisterRPCommands(tbl)


local tbl = {}

tbl.name = "NPC Modify"
tbl.args = false
tbl.panel = false
tbl.cmd = "!npcmodify"
tbl.svfunction = function(ply)
end
tbl.clfunction = function(ply)
	npc_modifysub()
end
RegisterRPCommands(tbl)


local w,h = 500, 600

npc_modifypanel = {}

local mat = Material("star/cw/basehexagons.png")
function npc_modifysub()
	local col = Color(0,0,0)
	npc_modify2panel = vgui.Create("DFrame")
	npc_modify2panel:SetSize(400,550)
	npc_modify2panel:Center()
	npc_modify2panel:SetTitle("")
	npc_modify2panel:ShowCloseButton(false)
	npc_modify2panel:SetDraggable(false)
	npc_modify2panel:MakePopup()
	npc_modify2panel.Paint = function(self, w,h)

		surface.SetDrawColor(150,150,150, 200)
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)

		surface.SetDrawColor(255,255,255, 255)
		local b =  w-20
		local c,d = w-20, 50
		surface.DrawTexturedRectUV(10,10,w-20,50,0,0,c/b,d/b)

		draw.SimpleText("NPC Modify", "ServerFont", w/2, 35,col, 1, 1 )

		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end

	local prim = ""
	local model = ""
	local mode = ""

	local health_pnl = vgui.Create("DTextEntry", npc_modify2panel)
	health_pnl:SetSize(380, 50)
	health_pnl:SetPos(10, 130)
	health_pnl:SetText("Health")

	local count_pnl = vgui.Create("DTextEntry", npc_modify2panel)
	count_pnl:SetSize(380, 50)
	count_pnl:SetPos(10, 190)
	count_pnl:SetText("Number to Spawn")

	wep_view = vgui.Create("DComboBox", npc_modify2panel)
	wep_view:SetPos(10, 250)
	wep_view:SetSize(380,50)
	wep_view:SetValue( "Primary" )
	wep_view.OnSelect = function( panel, index, value )
		prim = value
	end
	for k,v in pairs(WEAPONS["Primary"]) do
		local line = wep_view:AddChoice(k)
	end

	sec_view = vgui.Create("DComboBox", npc_modify2panel)
	sec_view:SetPos(10, 310)
	sec_view:SetSize(380,50)
	sec_view:SetValue( "Model" )
	sec_view.OnSelect = function( panel, index, value )
		model = value
	end
	for k,v in pairs(NPCModel) do
		local line = sec_view:AddChoice(v)
	end

	mel_view = vgui.Create("DComboBox", npc_modify2panel)
	mel_view:SetPos(10, 370)
	mel_view:SetSize(380,50)
	mel_view:SetValue( "Mode" )
	mel_view.OnSelect = function( panel, index, value )
		mode = value
	end
	for k,v in pairs(NPC_MODE ) do
		local line = mel_view:AddChoice(k)
	end


	button = vgui.Create("DButton", npc_modify2panel)
	button:SetSize(380,50)
	button:SetPos(10,430)
	button:SetText("")
	button.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Update NPC Info", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()


	--	mode, model, prim, num, health

		local num = tonumber(count_pnl:GetValue())
		local health = tonumber( health_pnl:GetValue() )

		if model == "" then return end
		if prim == "" then return end
		if mode == "" then return end

		net_npc_modify(model, prim, mode, num, health)
		npc_modify2panel:Remove()
	end


	local button2 = vgui.Create("DButton", npc_modify2panel)
	button2:SetSize(380,50)
	button2:SetPos(10,490)
	button2:SetText("")
	button2.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Back", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button2.DoClick = function()
		npc_modify2panel:Remove()
	end


end


if SERVER then
	util.AddNetworkString("admin_npc_modify")
	net.Receive("admin_npc_modify", function(len , ply)
		ply.NPCData = {
			["mdl"]		= net.ReadString(),
			["wep"]		= net.ReadString(),
			["mode"]	= net.ReadString(),
			["num"]		= net.ReadDouble(),
			["health"]	= net.ReadDouble(),
		}
		log(adminply, ply:Name() .. " has made a new npc(" .. table.concat(ply.NPCData,  " ") .. ")", logs["admin"] )
	end)

else
	function net_npc_modify(mdl, wep, mode, num, health)
		net.Start("admin_npc_modify")
			net.WriteString(mdl)
			net.WriteString(wep)
			net.WriteString(mode)
			net.WriteDouble(num)
			net.WriteDouble(health)
		net.SendToServer()
	end

end


/*
local list_view = vgui.Create("DComboBox", Base)
		list_view:SetParent(Base)
		list_view:SetPos(25, 100)
		list_view:SetSize(200, 25)
		list_view:SetValue( "Name" )
		list_view.OnSelect = function( panel, index, value )
      		if value == LocalPlayer():Nick() then return end
            PlayerName = GetNameToPlayer(value)
      		net.Start("holo_InviteSend")
      			net.WriteEntity(PlayerName)
      		net.SendToServer()
		end

		for k,v in pairs(player.GetAll()) do
			if LocalPlayer() == v then continue end
			local line = list_view:AddChoice(v:Nick())
		end

*/
