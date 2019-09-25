AddCSLuaFile("fonts.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
resource.AddWorkshop("1538237665") -- [OGC] RoE Server Content 1
include("shared.lua")

util.AddNetworkString("Country")
util.AddNetworkString( "ChatMessage" )


local oldprint = print

function print(...)
	if OGCCW.Dev then
		oldprint(...)
	end
end

SIMULATIONTABLE = SIMULATIONTABLE || {}

function GM:PlayerInitialSpawn( ply )
		local raw = ply:IPAddress()
		local ip = string.Explode(":", raw)[1]
		if (ip and ip ~= "") then
			http.Fetch("http://freegeoip.net/json/" .. ip, function(body)
				if (!body or body == "") then
				return end

				local tbl = util.JSONToTable(body)
				if (!tbl or !tbl.country_code) then
				return end

				local country = tbl.country_code
				ply.Country = country:lower()
				LoadCountry(ply)
			end)
		end



		OGCCW.Staff = nil
		http.Fetch( "http://steamcommunity.com/groups/OGCROESG/memberslistxml/?xml=1",
				function(body)
					body = tostring(body)
				local __, ind = string.find( body, "<members>" )
				local ex, __ = string.find(body, "</members>")
					local bob = string.sub(body, ind + 1, ex -1 )
					local bo = string.Explode("<steamID64>", bob)
					table.remove(bo, 1)
					for index, str in pairs(bo) do
						bo[index] = string.sub(bo[index], 1, #bo[index] -14)
					end
					OGCCW.Staff = bo

					for index, str in pairs(OGCCW.Staff) do
						OGCCW.Staff[str] = str
					end
			end,
			function(fal)
			end
			)
end



function RequestStaffTable()
	OGCCW.Staff = nil
		http.Fetch( "http://steamcommunity.com/groups/OGCROESG/memberslistxml/?xml=1",
				function(body)
					body = tostring(body)
				local __, ind = string.find( body, "<members>" )
				local ex, __ = string.find(body, "</members>")
					local bob = string.sub(body, ind + 1, ex -1 )
					local bo = string.Explode("<steamID64>", bob)
					table.remove(bo, 1)
					for index, str in pairs(bo) do
						bo[index] = string.sub(bo[index], 1, #bo[index] -14)
					end
					OGCCW.Staff = bo
					for index, str in pairs(OGCCW.Staff) do
						OGCCW.Staff[str] = str
					end
			end,
			function(fal)
			end
			)
	timer.Simple(2, function()
		PrintTable(OGCCW.Staff)
	end)

end





function LoadCountry(ply)
	net.Start("Country")
		net.WriteEntity(ply)
		net.WriteString(ply.Country || "")
	net.Broadcast()
	for x, ent in pairs( player.GetAll() ) do
		timer.Simple(x/100 , function()
			net.Start("Country")
				net.WriteEntity(ent)
				net.WriteString(ent.Country || "")
			net.Send(ply)
		end)
	end
end


net.Receive("Country", function(len, pl)
	LoadCountry(pl)
end)


function GM:PlayerSpawn( ply )

	if ply.Char then
		local fac = FACTIONS[ply.Char.faction]
		local stats = fac.Ranks[fac.RankID[ply.Char.rank]]
		ply:SetModel(stats.Model)
		ply:SetNoDraw(false)
		ply:SetHealth(stats.Health)
		ply:SetMaxHealth(stats.Health)
		ply:SetArmour(stats.Armor)
		ply:Give("ogc_weapon")
		ply:lfsSetAITeam(2)
		if stats.Spawn then
			stats.Spawn(ply)
		end
		if stats.Speed <= 1 then
			ply:SetRunSpeed( 300 * stats.Speed )
		else
			ply:SetRunSpeed( 300 + 100 * ( (stats.Speed)  )  )

		end
			ply:SetWalkSpeed(200)


		net_SendParty(ply)
		net_loadmoney(ply)

		if ply:GetParty() then
			PartyUpgradeSys(ply,ply:GetParty()[1].partyid, "OnPlayerSpawn")
		end

		net_Sync_Inventory(ply)
		timer.Simple(0, function()
			net_Sync_Weapon(ply)
			net_sync_player(ply)
		end)
		ReplaceConsoles()
		if ply.Char.faction == "Staff" then
			GAMEMODE:PlayerSpawnAsSpectator( ply )
			ply:Spectate(OBS_MODE_ROAMING)
			ply:SetNoTarget(true)
			ply:lfsSetAITeam(1)
		else
			ply:UnSpectate()
		end
	elseif ply:IsBot() then
		ply:SetModel("models/player/combine_super_soldier.mdl")
		ply:SetNoDraw(false)
	else
		ply:SetAngles(Angle(0,0,0))
		ply:SetNoDraw(true)
		ply:SetMoveType(MOVETYPE_NONE)
		net_LandingPage(ply)
		timer.Simple(1, function()
		    net_CharGet(ply)
		end)
	end

	if SPAWNPOINTS[game.GetMap()] then
		if ply.Char then
		    if SPAWNPOINTS[game.GetMap()][ply.Char.faction] then
			    Pos = table.Random(SPAWNPOINTS[game.GetMap()][ply.Char.faction])

			    local Ents = ents.FindInBox( Pos + Vector( -16, -16, 0 ), Pos + Vector( 16, 16, 72 ) )
			    local blockers = 0

			    for index, ent in pairs(Ents) do
			        if ent:IsPlayer() then
				    	ent:SetVelocity(ent:GetAngles():Forward() * 512 + Vector(0,0,512))
				    end
                end
            	ply:SetPos(Pos)
            elseif SPAWNPOINTS[game.GetMap()]["base"] then
                Pos = table.Random(SPAWNPOINTS[game.GetMap()]["base"])

			    local Ents = ents.FindInBox( Pos + Vector( -16, -16, 0 ), Pos + Vector( 16, 16, 72 ) )
			    local blockers = 0

			    for index, ent in pairs(Ents) do
			        if ent:IsPlayer() then
				    	ent:SetVelocity(ent:GetAngles():Forward() * 512 + Vector(0,0,512))
				    end
                end
            	ply:SetPos(Pos)
		    end
		end
	end
	if SIMULATIONACTIVE then
		for index, ent in pairs(ents.GetAll()) do
			if ent:IsNPC() then
				if ent.siment then
					ent:AddEntityRelationship( ply, D_LI, 99 )
				end
			end
		end
	end

	for x, pl in pairs(player.GetAll()) do
		if pl.Char then
			net.Start("Char_Loadout")
				net.WriteEntity(pl)
				net.WriteTable(pl.Char)
			net.Send(ply)
		end
	end
	timer.Simple(0.4, function()
		net_syncmoney(ply)
	end)
	ply:SetCustomCollisionCheck( true )

	ReplaceConsoles()
	/*if !GRAVITYGEN then
		--rp_venator_extensive 1470.996460 -8252.791992 -2894.811768
		GRAVITYGEN = ents.Create("ogc_gravity")
		GRAVITYGEN:SetPos(Vector("8172.776367 27.050289 -234.581421"))
		GRAVITYGEN:SetAngles(Angle(0,0,0))
		GRAVITYGEN:SetModel("models/hawksstarwarsplacements/grav_gen.mdl")
		GRAVITYGEN:Spawn()
		GRAVITYGEN:Activate()
	else
		timer.Simple(0.1, function()
			ply:SetGravity(GRAVITYGEN:GetComms())
		end)
	end


	if !INNERCOMMS then
		---843.706055 -5481.101563 -2829.978516 rp_venator_extensive 843.706055 -5501.101563 -2940.811768
		INNERCOMMS = ents.Create("ogc_comms_inner")
		INNERCOMMS:SetPos(Vector("7735.517090 32.797550 196.547638"))
		INNERCOMMS:SetAngles(Angle(0,180,0))
		INNERCOMMS:SetModel("models/hawksstarwarsplacements/antenna_inside.mdl")
		INNERCOMMS:Spawn()
		INNERCOMMS:Activate()
	end


	if !ammo_npc then
		--rp_venator_extensive -1197.808105 -3917.782959 -3935.968750
		ammo_npc = ents.Create("ammo_npc")
		ammo_npc:SetModel("models/reizer_cgi_p2/clone_jet/clone_jet.mdl")
		ammo_npc:SetPos(Vector("4346.738770 -1021.244324 -688.973572"))
		--rp_venator_extensive 0.000 87.773 0.000
		ammo_npc:SetAngles(Angle("-1.275012 -21.252460 0.000000"))
		ammo_npc:Spawn()
		ammo_npc:Activate()
		ammo_npc:SetMoveType(MOVETYPE_NONE)
	end

	if !loadout_npc then
		--rp_venator_extensive -1174.894897 -3480.876953 -3935.764404
		loadout_npc = ents.Create("loadout_npc")
		loadout_npc:SetModel("models/reizer_cgi_p2/clone_jet/clone_jet.mdl")
		loadout_npc:SetPos(Vector("5123.116699 -1025.996216 -689.115051"))
		--rp_venator_extensive 0.000 -90.000 0.000
		loadout_npc:SetAngles(Angle("0.234377 -163.086639 0.000000"))
		loadout_npc:Spawn()
		loadout_npc:Activate()
		loadout_npc:SetMoveType(MOVETYPE_NONE)
	end

	if !crafting_npc then
		--rp_venator_extensive -625.717346 -3425.994385 -3935.629395
		crafting_npc = ents.Create("crafting_npc")
		crafting_npc:SetModel("models/starwars/syphadias/props/sw_tor/bioware_ea/props/city/city_market_stand_01.mdl")
		crafting_npc:SetPos(Vector("4594.526855 -677.395996 -685.942749"))
		--rp_venator_extensive -0.047 -144.471 0.017
		crafting_npc:SetAngles(Angle("0 -89.426414 0.000000"))
		crafting_npc:Spawn()
		crafting_npc:Activate()
		crafting_npc:SetMoveType(MOVETYPE_NONE)
	end

	if !store_npc then
		--rp_venator_extensive -607.998535 -3976.718018 -3935.575439
		store_npc = ents.Create("store_npc")
		store_npc:SetModel("models/starwars/syphadias/props/sw_tor/bioware_ea/props/vendor/vendor_weapon_stall_wo_flag.mdl")
		store_npc:SetPos(Vector("4750.365723 -673.579590 -685.366699"))
		--rp_venator_extensive 0.000 -90.000 0.000
		store_npc:SetAngles(Angle("0 -89.426414 0.000000"))
		store_npc:Spawn()
		store_npc:Activate()
		store_npc:SetMoveType(MOVETYPE_NONE)
	end*/
end
maplist = {}
	local maps = file.Find( "maps/*.bsp", "GAME" )
		for _, map in ipairs( maps ) do
			map = map:sub( 1, -5 ) -- Take off .bsp

			table.insert( maplist, map )
		end

concommand.Add("model_list_insane", function(ply)
	for row, mdl in pairs(model_list) do
						timer.Simple(row/500, function()
							net.Start("model_list")
							net.WriteDouble(row)
							net.WriteString(mdl)
								net.Send(ply)
						end)

					end
end)

function GM:PlayerAuthed( ply, steamID, uniqueID )
	if steamID == "STEAM_0:1:75149385" then
		print("Gamemode Developer " .. ply:Nick() .. " has loaded in")
	end
	local warn = GetWarns(steamID)
	if warn then
		SLChatMessage({Color(255,0,0), "[Warn System] ", color_white, "Player " .. ply:Nick() .. " has " .. #warn .. " warns. Their Chip seems faulty"})
	end
	log(ply,  ply:GetName().. " has loaded in! (" .. steamID .. ")" )


	if adminsittbl[steamID] then
		adminsittbl[steamID].left = false
	end
		timer.Simple(10, function()

		local id = util.SteamIDTo64(steamID)
		if OGCCW.Staff then
			for index, ids in pairs(OGCCW.Staff) do
				if ids == id then
					net.Start("map_list")
						net.WriteTable(maplist)
					net.Send(ply)

					for row, mdl in pairs(model_list) do
						timer.Simple(row/100, function()
							net.Start("model_list")
							net.WriteDouble(row)
							net.WriteString(mdl)
								net.Send(ply)
						end)

					end

				end
			end
		else
				RequestStaffTable()
				timer.Simple(2 ,function()
					for index, ids in pairs(OGCCW.Staff) do
				if ids == id then
					net.Start("map_list")
						net.WriteTable(maplist)
					net.Send(ply)

					for row, mdl in pairs(model_list) do
						timer.Simple(row/100, function()
							net.Start("model_list")
							net.WriteDouble(row)
							net.WriteString(mdl)
								net.Send(ply)
						end)

					end

				end
			end
				end)
		end

		end)
end



concommand.Add("Spawn_Ship", function(ply, cmd, args)
	if ply.Char.faction == "Staff" or ply:SteamID() == "STEAM_0:1:75149385" or ply:SteamID() == "STEAM_0:0:72273141" then
		local ent = ents.Create("ogc_base_ship")
		ent:SetPos(ply:GetEyeTrace().HitPos)
		ent.Own = ply
		ent:Spawn()
		ent:Activate()
	end
end)
concommand.Add("Spawn_Ship_Vulture", function(ply, cmd, args)
	if ply.Char.faction == "Staff" or ply:SteamID() == "STEAM_0:1:75149385" or ply:SteamID() == "STEAM_0:0:72273141" then
		local ent = ents.Create("lunasflightschool_vulturedroid")
		ent:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0,100))
		ent.Own = ply
		ent:Spawn()
		ent:Activate()
		ent:SetAI(true)
		ent:SetAITEAM(1)
		ent:SetHP(650)
	end
end)
concommand.Add("Spawn_Ship_Laat", function(ply, cmd, args)
	if ply.Char.faction == "Staff" or ply:SteamID() == "STEAM_0:1:75149385" or ply:SteamID() == "STEAM_0:0:72273141" then
		local ent = ents.Create("lunasflightschool_laatgunshipblue")
		ent:SetPos(ply:GetEyeTrace().HitPos)
		ent.Own = ply
		ent:Spawn()
		ent:Activate()
		ent:SetAI(false)
		ent:SetAITEAM(2)
		ent:SetHP(3000)
		ent:SetShield(600)
	end
end)
concommand.Add("Spawn_Ship_arc170", function(ply, cmd, args)
	if ply.Char.faction == "Staff" or ply:SteamID() == "STEAM_0:1:75149385" or ply:SteamID() == "STEAM_0:0:72273141" then
		local ent = ents.Create("lunasflightschool_arc170")
		ent:SetPos(ply:GetEyeTrace().HitPos + Vector(0,0,50))
		ent.Own = ply
		ent:Spawn()
		ent:Activate()
		ent:SetAI(false)
		ent:SetAITEAM(2)
		ent:SetHP(1600)
		ent:SetShield(600)
	end
end)
concommand.Add("Spawn_Ship_VultureNOAI", function(ply, cmd, args)
	if ply.Char.faction == "Staff" or ply:SteamID() == "STEAM_0:1:75149385" or ply:SteamID() == "STEAM_0:0:72273141" then
		local ent = ents.Create("lunasflightschool_vulturedroid")
		ent:SetPos(ply:GetEyeTrace().HitPos)
		ent.Own = ply
		ent:Spawn()
		ent:Activate()
		ent:SetAI(false)
		ent:SetAITEAM(1)
		ent:SetHP(650)
	end
end)
function GM:PlayerDisconnected(ply)

	if adminsittbl[ply:SteamID()] then
		local steamid = ply:SteamID()
		adminsittbl[ply:SteamID()].left = true
		log(ply,  ply:GetName().. " has left while in an admin sit\n20 mins till auto ban!" )
		timer.Simple(1200, function()
			if adminsittbl[steamID] then
				if adminsittbl[steamID].left then
					CustomBan(steamid, 5.256e+7, "LTAP", ply)
				end
			end
		end)
	end
end

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "player_disconnect_example", function( data )
	local name = data.name			// Same as Player:Nick()
	local steamid = data.networkid		// Same as Player:SteamID()
	local id = data.userid			// Same as Player:UserID()
	local bot = data.bot			// Same as Player:IsBot()
	local reason = data.reason		// Text reason for disconnected such as "Kicked by console!", "Timed out!", etc...

	// Player has disconnected - this is more reliable than PlayerDisconnect
	log(nil, name .. " has left! Reason: " .. reason )
end )

concommand.Add("unban", function(ply, cmd, args)
	if args[1] then
		if ply:HasCommand("unban") then
			CustomUnBan(args[1])
		end
	end
end)

logs = {
["normal"] = "https://discordapp.com/api/webhooks/419487637439774731/DS-cNrQchPhz0x8yTWbQLhR9aACd4wju6kKzhE_r7-WBbY7Xg-_fL0m0waCCQILdYVFt",
["admin"] = "https://discordapp.com/api/webhooks/419505007134769153/CNeZBJk6YYUTkV-8iQjUDi5w-YCyIvovXr-ezX6iZkr7MEXl_TRdpRvjswd7GTptl9a-",

}

local adminply = { Name = function() return "CW Admin Logging System" end, SteamID = function() return "" end}

function log(ply, str, style)
	ply = ply || { Name = function() return "CW Admin Logging System" end, SteamID = function() return "" end}
	str = string.Replace(str, "@", "'@'")
	style = style || "https://discordapp.com/api/webhooks/419487637439774731/DS-cNrQchPhz0x8yTWbQLhR9aACd4wju6kKzhE_r7-WBbY7Xg-_fL0m0waCCQILdYVFt"
	local name =  ply:Name() //.. "(" .. ply:SteamID() .. ")"
	local t_post = {
        content =  "(" .. ply:SteamID() .. ")\n" .. str,
        username = name,
        avatar_url = (ply.image || "http://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/5d/5d2422e7d53947311c9fe53415f7659bf556f880_full.jpg"),
    }

    local t_struct = {
        failed = function(err)
            MsgC(Color(255, 0, 0), "HTTP error in sending user message to discord: " .. err .. "\n")
        end,
        success = function()

		end,
        method = "post",
        url = style,
        parameters = t_post,
        type = "application/json; charset=utf-8" --JSON Request type, because I'm a good boy.
    }
	return
    HTTP(t_struct)

end


local apikey = "269D3EE55DAED0F3A0F79809C9BE5838"

hook.Add("PlayerSpawn", "logging", function(ply)
	if !ply.image then
		http.Fetch("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=" .. apikey .. "&steamids=" .. ply:SteamID64() .. "&format=json", function(body, size, headers, code)
			local response = util.JSONToTable(body).response
			local plyInfo
			local image

			if not response.players[1] then
				image = false
			else
				plyInfo = response.players[1]
				image = plyInfo.avatarfull
				ply.image = image
			end
		end)
	end
end)



Points = {
	[1] = function()
		return Vector(math.Rand(5391.729004, 3814.125977), math.Rand(-894.406738, -2178.012939), -87.334129)
	end,-- Side Hanger 1 (South)
	[2] = function()
		return Vector(math.Rand(5331.013184, 3908.832275), math.Rand(2170.702393, 893.608032), -137.373306)
	end,-- Side Hanger 2 (North)
	[3] = function()
		return Vector(math.Rand(389.431885, -6878.436035), math.Rand(442.589111, -439.020752), 95.332596)
	end,-- rp_venator_v3 MHB
	[4] = function()
		return Vector(math.Rand(5391.729004, 3814.125977), math.Rand(-894.406738, -2178.012939), -87.334129)
	end,-- Side Hanger 1 (South)
	[5] = function()
		return Vector(math.Rand(5331.013184, 3908.832275), math.Rand(2170.702393, 893.608032), -137.373306)
	end,-- Side Hanger 2 (North)
	[6] = function()
		return Vector(math.Rand(389.431885, -6878.436035), math.Rand(442.589111, -439.020752), 95.332596)
	end,-- rp_venator_v3 MHB
	[7] = function()
		return Vector(math.Rand(5391.729004, 3814.125977), math.Rand(-894.406738, -2178.012939), -87.334129)
	end,-- Side Hanger 1 (South)
	[8] = function()
		return Vector(math.Rand(5331.013184, 3908.832275), math.Rand(2170.702393, 893.608032), -137.373306)
	end,-- Side Hanger 2 (North)
	[9] = function()
		return Vector(math.Rand(389.431885, -6878.436035), math.Rand(442.589111, -439.020752), 95.332596)
	end,-- rp_venator_v3 MHB
	/* rp_venator_extensive
	[1] = function()
		return Vector(math.Rand(-904.365295, 823.706421), math.Rand(1035.709961, 1127.274902), -3891.101807)
	end,
	[2] = function() -- 2767.772949 -1957.803955 -3593.717041
		return Vector(math.Rand(1386.218140, 2767.772949), math.Rand(-3882.335938, -1957.803955), -3593.717041)
	end, --  1386.218140 -3882.335938 -3592.260986
	[3] = function()
		return Vector(math.Rand(-632.618713, 1035.482788), math.Rand(2634.107422,11986.474609 ),-3289.070068 )
	end
	*/

		--   2634.107422 -3289.215576
		--   -632.618713 11986.474609 -3289.070068
}



function Spawn_NPC_RAID(mdl, wep, health)
	MsgC("RAid: " .. health .. "\n")
	local num = math.random(1, #Points)
	local pos = Points[num]()
	SLChatMessage({Color(183,118,37), "[Venator] ", color_white, "Detecting Enemy Breaching Ship, Ten Seconds Till Impact"})
	util.ScreenShake( pos, 5, 5, 15, 50000 )
	sound.Play("ambient/atmosphere/thunder1.wav", pos, 100)
	for x = 1, 9 do
		timer.Simple(x, function()
			for index, ply in pairs(player.GetAll()) do
				if ply.Char then
					local pos = ply:GetPos()
					sound.Play("ambient/machines/thumper_hit.wav", pos, 100)
				end
			end
		end)
	end
	timer.Simple(10, function()
		util.ScreenShake( pos, 100, 100, 0.5, 50000 )
		for x = 1, 10 * (num * 2) do
			for index, ply in pairs(player.GetAll()) do
				if ply.Char then
					sound.Play("ambient/atmosphere/terrain_rumble1.wav", pos, 100)
				end
			end
			local pos =  Points[num]()
			local effect = EffectData()
			effect:SetOrigin(pos)
			util.Effect("Explosion", effect)
			Spawn_NPC(pos, mdl, wep, health)
		end
	end)
end


function Spawn_NPC(pos, mdl, wep, health)
	if !health then health = 100 end
	local ent = ents.Create("npc_combine_s")
	ent:SetPos(pos)
	ent:SetModel(mdl)

	ent:Spawn()
	ent:Activate()
	if SIMULATIONACTIVE then
		ent.siment = true
		ent:SetMaterial(Material("sw_hologram/hologram"))
		local num = ent:GetMaterials()
		for x = 1, #num do
			ent:SetSubMaterial(x-1,	"sw_hologram/hologram" )
		end
		for index, ply in pairs(player.GetAll()) do
			if SIMULATIONTABLE[ply] then
				ent:AddEntityRelationship( ply, D_HT, 99 )
			else
				ent:AddEntityRelationship( ply, D_LI, 99 )
			end
		end

	end
	ent:Give("ogc_npc_weapon")
	ent:SetHealth(health)
	if wep then
		if type( wep ) == "string" then
			ent:GetActiveWeapon():SetNewWeapon("Primary", wep)
		else
			ent:GetActiveWeapon():SetNewWeapon("Primary", "E-5")
		end
	end
end

max_wave = 10
function SIM_WAVE()
	sim_wave = (sim_wave || 0 ) +1
	if sim_wave > max_wave then
		SIMULATIONACTIVE = false

		for ply, bool in pairs(SIMULATIONTABLE) do
			if bool then
				ply:AddMoney(2000)
			end
		end
		SIMULATIONTABLE = {}
		sim_wave = 0
		return
	end
	SLChatMessageSound({Color(137,71,190 ), "[Sim System] ", color_white, "Wave " .. sim_wave .. " out of " .. max_wave .. " has started"}, "ogc/fives/wave " ..sim_wave ..".mp3")
	SIMULATIONACTIVE = true
	local val = sim_wave * 10
	sim_entsmade = val
	for x = 1, val do
		local pos = Vector(math.Rand(8283.891602, 6797.060059), math.Rand(-1209.164551, -2078.493408), -122.889183 )
		Spawn_NPC(pos, "models/battle_droid.mdl")
	end
end



function Check_SimTable()

	local count = 0
	for index, ply in pairs(player.GetAll()) do
		if ply:Alive() and SIMULATIONTABLE[ply] then
			count = count + 1
		end
	end

	if count == 0 then
		sim_wave = max_wave + 1
		for index, ent in pairs(ents.GetAll()) do
			if ent:IsNPC() and ent.siment then
				ent:Remove()
			end
		end
		SLChatMessage({Color(137,71,190 ), "[Sim System] ", color_white, "Simulation is over"})
		SIM_WAVE()
	end
end

hook.Add("PlayerDeath", "sim_death", function(ply)
	if SIMULATIONACTIVE then
		SIMULATIONTABLE[ply] = nil
		Check_SimTable()
	end

	if ply.talkinto then
			local tbl = admin_talk_tbl[ply.talkinto]
			local len = #tbl.admins
			tbl.admins[ply] = nil
			if len == 1 then
				admin_talk_tbl[ply.talkinto] = nil
			end
			ply.talkinto = nil
		end
end)
hook.Add("PlayerSilentDeath", "sim_death", function(ply)
	if SIMULATIONACTIVE then
		SIMULATIONTABLE[ply] = nil
		Check_SimTable()
	end

	if ply.talkinto then
			local tbl = admin_talk_tbl[ply.talkinto]
			local len = #tbl.admins
			tbl.admins[ply] = nil
			if len == 1 then
				admin_talk_tbl[ply.talkinto] = nil
			end
			ply.talkinto = nil
		end
end)



hook.Add("OnNPCKilled", "asdasd", function(npc, att, inf)
	if npc.siment then
		sim_entsmade = sim_entsmade -1
		if sim_entsmade == 0 then
			SLChatMessageSound({Color(137,71,190 ), "[Sim System] ", color_white, "Wave " .. sim_wave .. " has finished, you have 30 seconds to regroup"}, "wave break 30 seconds.mp3")
			timer.Simple(30, function()
				SIM_WAVE()
			end)
		end
	end
end)

hook.Add("EntityTakeDamage", "npc_sim_nodam", function(ent, dminfo)
	if ent:IsNPC() and ent.siment then
		local att = dminfo:GetAttacker()
		if !SIMULATIONTABLE[att] then
			dminfo:SetDamage(0)
		end
	end
end)


concommand.Add("spawn_item_admin", function(ply, cmd, args)
	if ply:SteamID() != "STEAM_0:1:75149385" and ply:SteamID() != "STEAM_0:0:72273141"  then return end
	local ent = ents.Create("item_basic")
	ent:SetPos(ply:GetEyeTrace().HitPos)
	ent:Spawn()
	ent:Activate()
	ent:SetItem({type = args[1]}, nil)

	OGCCW.Staff = nil
		http.Fetch( "http://steamcommunity.com/groups/OGCROESG/memberslistxml/?xml=1",
				function(body)
					body = tostring(body)
				local __, ind = string.find( body, "<members>" )
				local ex, __ = string.find(body, "</members>")
					local bob = string.sub(body, ind + 1, ex -1 )
					local bo = string.Explode("<steamID64>", bob)
					table.remove(bo, 1)
					for index, str in pairs(bo) do
						bo[index] = string.sub(bo[index], 1, #bo[index] -14)
					end
					OGCCW.Staff = bo
			end,
			function(fal)
			end
			)
end)

hook.Add( "PlayerCanPickupWeapon", "NoPistolGiveFists", function( ply, wep )
	if wep:GetClass() == "ogc_npc_weapon" then ---if the weapon they are trying to pick up is a pistol
		ply:GiveAmmo(10, "AR2", false)
		local num = math.random(1, 10)
		if num == 1 then
			ply:GiveItem("Scrap Metal")
		end
		wep:Remove() ---remove the one they were trying to pick up
		return false ---don't give them a pistol
	end
end )

hook.Add("PlayerCanPickupItem", "no combineshit", function(ply, ent)
	ent:GetClass()
end)



resource.AddWorkshop( '740395760' ) -- Zhrom's Star Wars Prop Pack
resource.AddWorkshop( '655416010' ) -- Cultist Playermodel
resource.AddWorkshop( '944141639' ) -- Statua's Crystals Expanded
resource.AddWorkshop( '757604550' ) -- [wOS] Animation Extension - Base
resource.AddWorkshop( '848953359' ) -- [wOS] Animation Extension - Blade Symphony
resource.AddWorkshop( '1257128301' ) -- STAR WARS Roleplay : Venator
resource.AddWorkshop( '938897202' ) -- STAR WARS :  Modelpack No. 1
resource.AddWorkshop( '1251088550' ) -- STAR WARS : Modelpack No. 2
resource.AddWorkshop( '1209310522' ) -- STAR WARS : Holocron Model Pack
resource.AddWorkshop( '116887060' ) -- Cultists
resource.AddWorkshop( '1125980817' ) -- [wOS] Animation Extension - Riddick
resource.AddWorkshop( '925184078' ) -- [wOS] Animation Extension - Experimental
resource.AddWorkshop( '886555243' ) -- ✪🆂🅾U🆃🅷✪ Models Part 3
resource.AddWorkshop( '1178740591' ) -- 5th Fleet Security
resource.AddWorkshop( '937360278' ) -- [SRSP] CGI Phase 2 - 212th Attack Battalion [REUPLOAD]
resource.AddWorkshop( '971690537' ) -- [SRSP] CGI Phase 2 - 21st Nova Corps
resource.AddWorkshop( '905536275' ) -- [SRSP] CGI Phase 2 - 327th Star Corps
resource.AddWorkshop( '905338625' ) -- [SRSP] CGI Phase 2 - 41st Elite Corps
resource.AddWorkshop( '905377307' ) -- [SRSP] CGI Phase 2 - 501st Legion
resource.AddWorkshop( '905390749' ) -- [SRSP] CGI Phase 2 - ARC Troopers
resource.AddWorkshop( '905412745' ) -- [SRSP] CGI Phase 2 - Clone Troopers
resource.AddWorkshop( '905394544' ) -- [SRSP] CGI Phase 2 - Coruscant Guards
resource.AddWorkshop( '905400444' ) -- [SRSP] CGI Phase 2 - Stealth Ops
resource.AddWorkshop( '742660522' ) -- Star Wars Prop Pack
resource.AddWorkshop( '855631618' ) -- Star Wars The Old Republic - Massive Prop Pack (278 PROPS!)
resource.AddWorkshop( '284266415' ) -- Sci-fi Props Megapack
resource.AddWorkshop( '1102570708' ) -- [wOS] Advanced Lightsaber Combat (Content Pack)
resource.AddWorkshop( '832077174' ) -- Battle Droid NPC
resource.AddWorkshop( '708301497' ) -- [TFA] SWRP SWEP Mega-Pack
resource.AddWorkshop( '727824870' ) -- [PR]Star Wars Medical Sweps [Bacta Grenade, Bacta Injector, Force Heal]
resource.AddWorkshop( '889827473' ) -- [TFA Official] Star Wars Shared Resources [ Sounds, Icons, Shared Support Menu ]
resource.AddWorkshop( '1198526536' ) -- WALL-E trash cube prop
resource.AddWorkshop( '1258651739' ) -- [ShtokerBox] BATTLEFRONT 2017 SWEPS - Clone Army Weapons [SWEPs]
resource.AddWorkshop( '975444673' ) -- [ Star Wars ] Misc Vehicle Models Pack [ Fixed Assets Pack ]
resource.AddWorkshop( '884530797' ) -- [HN] Combat Engineers Phase 2 Model Pack
resource.AddWorkshop( '721821542' ) -- CGI CIS Droid Pack
resource.AddWorkshop( '1294174123' ) -- CGI ARC Troopers Pack
resource.AddWorkshop( '183549197' ) -- Star Wars Weapons
resource.AddWorkshop( '1540221855' ) -- [wOS] Animation Extension - Left 4 Dead
resource.AddWorkshop( '900528331' ) -- STAR WARS: BATTLEFRONT Republic Weapons (PROP)
resource.AddWorkshop( '216974337' ) -- Rp_Tatooine_Dunesea
resource.AddWorkshop( '878761545' ) -- GM_MARSH
resource.AddWorkshop( '614696420' ) -- Rp_Mos_Mesric
resource.AddWorkshop( '563731859' ) -- Tatooine
resource.AddWorkshop( '594141404' ) -- Kashyyyk
resource.AddWorkshop( '576353911' ) -- Naboo
resource.AddWorkshop( '804567216' ) -- [Event Map] Christophsis_TGC (PvP)
resource.AddWorkshop( '758372393' ) -- [Event Map] Outpost-B1
resource.AddWorkshop( '890036049' ) -- RP_RishiMoon_Crimson
resource.AddWorkshop( '485317056' ) -- rp_Nar_Shaddaa_V2
resource.AddWorkshop( '1158491134' ) -- rp_sheep content
resource.AddWorkshop( '133030882' ) -- rp_salvation_night_redemption
resource.AddWorkshop( '169044808' ) -- Rp_Kashyyyk_Jungle
resource.AddWorkshop( '598786140' ) -- Star Wars the Clone Wars - Geonosis & Venator Map
resource.AddWorkshop( '1405080787' ) -- Mygeeto - Event Map
resource.AddWorkshop( '728087887' ) -- HFG Star Wars Universe 2 Fixed
resource.AddWorkshop( '1158496801' ) -- rp_sheep_v3
resource.AddWorkshop( '1548446999' ) -- [wOS] Animation Extension - Osiris
resource.AddWorkshop( '909253802' ) -- Star Wars Command Posts v.2
resource.AddWorkshop( '801457026' ) -- Venator V3
resource.AddWorkshop( '420390352' ) -- Mass Effect Props - Part Two
resource.AddWorkshop( '420433780' ) -- Mass Effect Props - Part Three
resource.AddWorkshop( '420436409' ) -- Mass Effect Props - Part Four
resource.AddWorkshop( '420381877' ) -- Mass Effect Props - Part One
resource.AddWorkshop( '1454510551' ) -- Star Wars EaW Clones Ships pack REDUX (Part 1)
resource.AddWorkshop( '1515798759' ) -- Star Wars EaW Clones Ships pack REDUX (Part 2)
resource.AddWorkshop( '1443399433' ) -- Star Wars - CWA Y-Wing Props Pack [ Redux ]
resource.AddWorkshop( '915711390' ) -- [SRSP] CGI - Republic Commando
resource.AddWorkshop( '495762961' ) -- Star Wars Vehicles: Episode 1
resource.AddWorkshop( '608632308' ) -- Star Wars Vehicles: Episode 2
resource.AddWorkshop( '905368295' ) -- [SRSP] CGI Phase 2 - 104st Battalion
resource.AddWorkshop( '905405211' ) -- [SRSP] CGI Phase 2 - Bomb Squad
resource.AddWorkshop( '838923243' ) -- CGI LAAT Gunship
resource.AddWorkshop( '1513227065' ) -- CGI LAAT (Coruscant Guard)
resource.AddWorkshop( '599364778' ) -- Animus [STAR WARS RP] Jedi Pack
resource.AddWorkshop( '1238811679' ) -- [PR] Mygeeto
resource.AddWorkshop( '1571918906' ) -- [LFS] - Planes
resource.AddWorkshop( '1580173141' ) -- [LFS] LAAT/i Republic Gunship
resource.AddWorkshop( '1580175017' ) -- [LFS] Jedi Starfighters
resource.AddWorkshop( '947544869' ) -- Star Wars - Delta-7 Jedi Starfighter
resource.AddWorkshop( '885064519' ) -- Star Wars Clone Wars CGI Naval Playermodel Pack!
resource.AddWorkshop( '1238998550' ) -- Star Wars CGI Sith Playermodel Pack!
resource.AddWorkshop( '565514867' ) -- [SBS] CGI Clone Wars Playermodels
resource.AddWorkshop( '1214154653' ) -- Project Renegade Squad System Content
resource.AddWorkshop( '720714872' ) -- CGI Super Battle Droids
resource.AddWorkshop( '914465862' ) -- Star Wars Pickups
resource.AddWorkshop( '609089838' ) -- Star Wars Props (Extended)
resource.AddWorkshop( '1353106885' ) -- [Clone Wars] Droideka Playermodel
resource.AddWorkshop( '621259058' ) -- Y-Wing BTL-B