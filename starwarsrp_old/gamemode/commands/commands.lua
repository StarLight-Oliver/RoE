RPCOMMANDS = RPCOMMANDS or {}

function RegisterRPCommands(tbl)
	RPCOMMANDS[tbl.name] = tbl
	print("Registered Command " .. tbl.name)
end

local Folder  		= GM.Folder:gsub("gamemodes/","").."/gamemode/commands/rpcmd"

local Class   		= file.Find(Folder.."/*.lua","LUA")

for k,v in pairs(Class) do
	if SERVER then AddCSLuaFile(Folder.."/"..v) end
	include(Folder.."/"..v)
end


local Folder  		= GM.Folder:gsub("gamemodes/","").."/gamemode/commands/admin"

local Class   		= file.Find(Folder.."/*.lua","LUA")
function RegisterRPCommands(tbl)
	RPCOMMANDS[tbl.name] = tbl
	print("Registered Admin Command " .. tbl.name)
end
for k,v in pairs(Class) do
	if SERVER then AddCSLuaFile(Folder.."/"..v) end
	include(Folder.."/"..v)
end

    
local perm = {
	["Salute"] = true,
	["Sit"] = true,
	["Strip Weapon and Comms"] = true,
	["Toggle View"] = true,
	["I need Health"] = true,
	["I need Ammo"] = true,
	["Scout Area"] = true,
	["The Player you are looking at needs health"] = true,
	["The Player you are looking at needs ammo"] = true,
	["Join Faction"] = true,
	["Enemy Spotted"] = true,
	["Join Simulation"] = true,
--	["Start Shooting Range"] = true,
	--["Start Simulation"] = true,
}

function plymeta:GetCommands()
	local tblc = {}
	local fac = FACTIONS[self.Char.faction]
	local cmd = fac.Ranks[fac.RankID[self.Char.rank]].Commands
	for name, tbl in pairs(RPCOMMANDS) do
		if self.Char.faction != "Staff" then
			if perm[name] then
				tblc[name] = tbl
				continue
			end
		end
			if table.HasValue(cmd, name) then
				tblc[name] = tbl
			end
		
	end
	return tblc
end

function plymeta:HasCommand(cmd)
	local cmds = self:GetCommands()
	if cmds[cmd] then
		return true
	else
		return false
	end
end

if SERVER then

	hook.Add("PlayerSay", "ogc_chathook", function(ply, str)
		if string.sub(str, 1,1) == "!" then
			local cmdfound = false
			local cmd = string.Explode(" ", str)[1]
			for x,y in pairs(ply:GetCommands()) do
				if cmd == y.cmd then
					cmdfound = true
					y.svfunction(ply)
					break
				end
			end 
			if cmdfound then
				return ""
			end
		elseif string.sub(str, 1,1) == "/" then
			-- RP Mode
			if string.sub(str, 1,4) == "/me " then
				for index, pl in pairs(ents.FindInSphere(ply:GetPos(), 512)) do
					if pl:IsPlayer() then
						pl:SLChatMessage({Color(255,125,0 ), "[ME] " .. ply:Name() .. " " .. string.sub(str, 5)})
					end
				end
			end	

			local cmds = {

			["/ooc "]		= "ooc",
			["// "]			= "ooc",
			["/looc "]		= "looc",
			["/l "]			= "looc",
			["/comms "]		= "comms",
			["/advert "]	= "comms", 
			["/r "]			= "comms",
			["/faction "]	= "faction",
			["/f "]			= "faction",

	}
	    if (ply.muteged || 0) > CurTime() then return "" end
			for index, cmd in pairs(cmds) do
				if string.sub(str, 1, #index) == index then
						ply:ConCommand(cmd .. "\"" .. string.sub(str, #index + 1) .. "\"")
				end
			end

			if string.sub(str, 1, 5) == "/ooc " then
				ply:ConCommand("ooc " .. "\"" .. string.sub(str, 6) .. "\"")
			end

			return ""
		end
		log(ply, "[Normal] " .. str)
		
	end)

end