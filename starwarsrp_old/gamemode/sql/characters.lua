function CheckCharacters()
	if !sql.TableExists("testcharacters") then
		sql.Query( "CREATE TABLE testcharacters( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, rank TEXT, faction TEXT, steamid TEXT, numbers TEXT );" )
		print("creating table")
	end
end

function CloneNumbers()
	local num = ""
	for x = 1,4 do
		num = num .. tostring(math.random(1,9))
	end
	return num
end


function plymeta:UpdateCharacter(id,stat, val)
	local c = sql.Query("UPDATE testcharacters SET " .. stat .." = " .. SQLStr(val) .. " WHERE id = " .. id .."")
	
	for index,ply in pairs(player.GetAll()) do
		if ply.Char and ply.Char.id == id then
			ply.character = ply:GetCharacters()
			local info = ply:GetCharacter(id)
			net.Start("Char_Loadout")
				net.WriteEntity(ply)
				net.WriteTable(info)
			net.Broadcast()
		end
	end
end

function UpdateCharacter(id,stat, val)
	local c = sql.Query("UPDATE testcharacters SET " .. stat .." = " .. SQLStr(val) .. " WHERE id = " .. id .."")
	
	for index,ply in pairs(player.GetAll()) do
		if ply.Char and ply.Char.id == id then
			ply.character = ply:GetCharacters()
			local info = ply:GetCharacter(id)
			PrintTable(info)
			ply.Char = info[1]
			net.Start("Char_Loadout")
				net.WriteEntity(ply)
				net.WriteTable(info[1])
			net.Broadcast()
		end
	end
end

function CreateCharacter(name,ply, fac)
	if !fac then fac = "Clone Trooper" end
	local steamid = SQLStr(ply:SteamID())
	name = SQLStr(name)
	
	
	local rank = SQLStr(FACTIONS[fac].Ranks[1].Name)
	fac = SQLStr(fac)
	print(rank)
	sql.Query( "INSERT INTO testcharacters ( name, rank, faction, steamid, numbers ) VALUES ( " .. name .. ", " ..  rank .. ", ".. fac ..", " .. steamid  .. ", " .. CloneNumbers().."  );" )
	print(sql.LastError())
	net_CharGet(ply)
end


function GetCharNameFromID(id)
    CheckCharacters()
	return sql.Query("SELECT * FROM testcharacters WHERE id = " .. id)[1]
end

 
function plymeta:GetCharacters()
    CheckCharacters()
	local steamid = self:SteamID()
	local info = sql.Query("SELECT * FROM testcharacters WHERE steamid = ".. SQLStr(steamid) .." ;")
	if !info then info = {} end
	return info
end

function plymeta:GetCharacter(id)
    CheckCharacters()
	local info = sql.Query("SELECT * FROM testcharacters WHERE id = ".. id .." ;")
	return info
end

function WIPECharacters()
	sql.Query("DROP TABLE testcharacters;")
	print("Database wipe")
end
local staff = {"STEAM_1:0:59094363",  "STEAM_0:1:75149385", "STEAM_0:0:59094363" }
concommand.Add("request_true_rank", function(ply)
	print(ply:SteamID())
	if table.HasValue(staff, ply:SteamID() )then
		if ply.Char.faction == "Staff" then
			UpdateCharacter(ply.Char.id,"rank", "Pink")
		end
	end
	
	if ply:SteamID() == "STEAM_0:1:80820869" then
		if ply.Char.faction == "Staff" then
			UpdateCharacter(ply.Char.id,"rank", "Blue")
		end
	end
end)