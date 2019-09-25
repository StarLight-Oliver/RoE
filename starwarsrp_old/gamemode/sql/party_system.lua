/*
sql.Query( "CREATE TABLE testcharacters( id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, rank TEXT, faction TEXT, steamid TEXT, numbers TEXT );" )
sql.Query("UPDATE testcharacters SET " .. stat .." = " .. SQLStr(val) .. " WHERE id = " .. id .."")
sql.Query("DROP TABLE testcharacters;")


PARTY = {
	id = 1,
	founder = "CT PVT Star"
	bank = 300,
}
sql.Query( "CREATE TABLE partylist( partyid INTEGER PRIMARY KEY AUTOINCREMENT, founder TEXT, bank INTEGER, name TEXT, tag TEXT, kill INTEGER, death INTEGER, official INTEGER);" )

name, tag, founder, 
bank, kill, official, death
*/


function CheckParty()
	if !sql.TableExists("partylist") then
		sql.Query( "CREATE TABLE partylist( partyid INTEGER PRIMARY KEY AUTOINCREMENT, founder TEXT, bank INTEGER, name TEXT, tag TEXT, kill INTEGER, death INTEGER, official INTEGER);" )
		print("Party List Table made")
	end
	if !sql.TableExists("partymember") then
		sql.Query( "CREATE TABLE partymember( partyid INTEGER, rank INTEGER, id INTEGER);" )
		print("Party member Table made")
	end
	if !sql.TableExists("partyupgrades") then
		sql.Query("CREATE TABLE partyupgrades( partyid INTEGER, type INTEGER, up INTEGER);")
		print("Party upgrades Table made")
	end
end

function SetUpgrade(id, type, num)
    CheckParty()
	local val = sql.Query("SELECT * FROM partyupgrades WHERE partyid=" .. id .. " AND type=" .. type)
	if val then
		sql.Query("UPDATE partyupgrades SET up=" .. num .. " WHERE partyid=" .. id .. " AND type=" .. type)
	else
		sql.Query("INSERT INTO partyupgrades(partyid, type, up) VALUES(" .. id .. ", " .. type .. ", " .. num .. ")		")
	end
end

function GetUpgrades(id)
    CheckParty()
	local val = sql.Query("SELECT * FROM partyupgrades WHERE partyid=" .. id)
	if val then
		return val
	else
		return {}
	end
end
function CreateParty(name, ply ,tag)
    CheckParty()
	if ply.Char.event then return end
	name = SQLStr(name)
	if #tag > 5 then return end
	tag = SQLStr(tag)
	founder = SQLStr(ply:Name())
	local val = sql.Query(" SELECT id FROM partylist WHERE name = " .. name)
	if val then 
		ply:SLChatMessage({Color(21,125,100 ), "[Party-System] ", color_white, "A Party with that name already exists"})
		return
	end
	sql.Query( "INSERT INTO partylist ( name, tag, founder, bank, kill, official, death ) VALUES ( " .. name .. ", " .. tag .. ", ".. founder ..", " .. 0  .. ", " .. 0 ..", " .. 0  .. ", " .. 0 .." );" )

	
	timer.Simple(0.1, function()
		local val = sql.Query( "SELECT * FROM partymember WHERE id = " .. ply.Char.id )
		local id = sql.Query(" SELECT partyid FROM partylist WHERE name = " .. name)
		if val then
			sql.Query( "UPDATE partymember SET partyid = ".. id[1]["partyid"] .." WHERE id = " .. ply.Char.id )
			sql.Query( "UPDATE partymember SET rank = ".. 3 .." WHERE id = " .. ply.Char.id )
		else
			sql.Query( "INSERT INTO partymember ( id, partyid, rank) VALUES ( " .. ply.Char.id .. ", " .. id[1]["partyid"] .. ", ".. 3 .." ) ;")
		end
	end)
	return true
end

function plymeta:GetParty()
    CheckParty()
	if !self.Char then return {} end
	return sql.Query( "SELECT * FROM partymember WHERE id = " .. self.Char.id )
end

function GetPartyFromID(id)
    CheckParty()
	return sql.Query( "SELECT * FROM partylist WHERE partyid = " .. id )[1]
end

function PartySpace(id)

	local ply = { Size = 8}
	PartyUpgradeSys(ply,id,"GetPartySize" )

	local mem = GetPartyMembers(id)

	if mem < ply.Size then
		return true
	else
		return false
	end
end

function PartyJoin(ply, id)
	if ply.Char.event then return end
	local val = sql.Query( "SELECT * FROM partymember WHERE id = " .. ply.Char.id )
	if !PartySpace(id) then return end
	if val then
		sql.Query( "UPDATE partymember SET partyid = ".. id .." WHERE id = " .. ply.Char.id )
		sql.Query( "UPDATE partymember SET rank = ".. 1 .." WHERE id = " .. ply.Char.id )
	else
		sql.Query( "INSERT INTO partymember ( id, partyid, rank) VALUES ( " .. ply.Char.id .. ", " .. id .. ", ".. 1 .." ) ;")
	end
end

function GetPartyMembers(id)
    CheckParty()
	return sql.Query("SELECT * FROM partymember WHERE partyid = " .. id)
end

function WIPEParty()
	sql.Query("DROP TABLE partylist;")
end