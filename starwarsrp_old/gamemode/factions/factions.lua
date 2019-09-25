FACTIONINVITES = FACTIONINVITES || {}	
FACTIONS = FACTIONS or {}
REALFACTIONS = REALFACTIONS or {}
function RegisterFaction(tbl)
	for x,y in pairs(tbl.Ranks) do
		tbl.RankID[y.Name] = x
	end
	FACTIONS[tbl.Name] = tbl
	if tbl.Hide == true then 
		-- YEAH
	else
		REALFACTIONS[tbl.Name] = tbl
		FACTIONINVITES[tbl.Name] = {}
	end
	
	print("Registered " .. tbl.Name)
end

local Folder  		= GM.Folder:gsub("gamemodes/","").."/gamemode/factions/factions"

local Class   		= file.Find(Folder.."/*.lua","LUA")

for k,v in pairs(Class) do
	if SERVER then AddCSLuaFile(Folder.."/"..v) end
	include(Folder.."/"..v)
end  

--.hide