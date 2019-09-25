GM.Name = "StarwarsRP"
GM.Author = "StarLight"
GM.Email = "Don't"
GM.Website = ""

DefaultInventorySize = 20
OGCCW = OGCCW || {}
OGCCW.Version = "Open Beta v 1"
OGCCW.Dev = true
OGCCW.Config = OGCCW.Config or {}
OGCCW.Config.Map = "rp_venator_v3"
TFA = {}
TFA.SUCKS = true
TFA.Enum = {}

plymeta = FindMetaTable("Player")


function GM:Initialize()
	self.BaseClass.Initialize( self )
	if SERVER then
		CheckInventory()
	
	end
end 

function AddLuaCSFolder(DIR)
	local Dir 		= GM.Folder:gsub("gamemodes/","").."/gamemode/"
	local GAMEFIL 	= file.Find(Dir..DIR.."/*.lua","LUA")
	
	for k,v in pairs( GAMEFIL ) do
		if (CLIENT) then include(Dir..DIR.."/"..v)
		else AddCSLuaFile(Dir..DIR.."/"..v) end
	end
end

function AddLuaSVFolder(DIR)
	if (CLIENT) then return end
	local Dir 		= GM.Folder:gsub("gamemodes/","").."/gamemode/"
	local GAMEFIL 	= file.Find(Dir..DIR.."/*.lua","LUA")
	
	for k,v in pairs( GAMEFIL ) do
		include(Dir..DIR.."/"..v)
	end
end

function AddLuaSHFolder(DIR)
	local Dir 		= GM.Folder:gsub("gamemodes/","").."/gamemode/"
	local GAMEFIL 	= file.Find(Dir..DIR.."/*.lua","LUA")
	
	for k,v in pairs( GAMEFIL ) do
		if (CLIENT) then include(Dir..DIR.."/"..v)
		else AddCSLuaFile(Dir..DIR.."/"..v) include(Dir..DIR.."/"..v) end
	end
end
AddLuaCSFolder("cl_hud")
AddLuaCSFolder("cl_extensions") 
AddLuaCSFolder("vgui") 

AddLuaSHFolder("factions")
AddLuaSHFolder("commands")
AddLuaSHFolder("net")
AddLuaSHFolder("sh_extensions") 
AddLuaSHFolder("inventory")
AddLuaSVFolder("sql")

function GM:PlayerConnect( name, ip )
	local name = player:DisplayName(name)
	CheckInventory()
end