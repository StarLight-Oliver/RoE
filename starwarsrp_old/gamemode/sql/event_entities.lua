function CheckEventEntities()
	if !sql.TableExists("event_entities") then
		sql.Query("CREATE TABLE event_entities(x INTEGER, y INTEGER, z INTEGER, ax INTEGER, ay INTEGER, az INTEGER, ent TEXT, mdl TEXT, lua TEXT, map TEXT )")
	end


	if !sql.TableExists("event_entities_examples") then
		sql.Query("CREATE TABLE event_entities_examples(name TEXT, x INTEGER, y INTEGER, z INTEGER, ax INTEGER, ay INTEGER, az INTEGER, ent TEXT, mdl TEXT, lua TEXT, map TEXT )")
	end
end

function DeleteEventExample(name, map)
		sql.Query("DELETE FROM event_entities_examples WHERE map=" .. SQLStr(map) .. " AND name=" .. SQLStr(name)) 
end


function GiveEventEntityExamoke(name, map)
	SetEventEntityExample("SaveState " .. os.date(os.time() ), map)
	local ent = GetEventEntity(nil, map)
	for index, en in pairs(ent) do
		RemoveEventEntities(en.x,en.y,en.z, map, en.ent)
	end
	local newent = GetEventEntityExample(name, map)
	for index, tbl in pairs(newent) do
		SetEventEntity(Vector(tbl.x .. " " .. tbl.y .." " .. tbl.z), Angle(tbl.ax .. " " .. tbl.ay .." " .. tbl.az), tbl.ent, tbl.mdl, map, tbl.lua )
	end
end

function SetEventEntityExample(name, map)
	CheckEventEntities()
	if table.Count(GetEventEntityExample(name, map) ) > 0 then return end -- Can't update examples. deleting done by admins

	local cas = sql.Query("SELECT * FROM event_entities WHERE map =" ..  SQLStr(map ) )

	name = SQLStr(name)

	if cas then
		for index, row in pairs(cas) do
			print("INSERT INTO event_entities_examples(x, y, z, ax, ay, az, ent, mdl, map, lua, name) VALUES (" .. row.x  .. ", " .. row.y .. ", " .. row.z .. ", " .. row.ax .. ", " .. row.ay .. ", " .. row.az .. ", ".. SQLStr(row.ent) .. ", " .. SQLStr(row.mdl) .. ", " .. SQLStr(row.map) .. ", " .. SQLStr(row.lua) .. ", "	.. name .. ")")
			sql.Query("INSERT INTO event_entities_examples(x, y, z, ax, ay, az, ent, mdl, map, lua, name) VALUES (" .. row.x  .. ", " .. row.y .. ", " .. row.z .. ", " .. row.ax .. ", " .. row.ay .. ", " .. row.az .. ", ".. SQLStr(row.ent) .. ", " .. SQLStr(row.mdl) .. ", " .. SQLStr(row.map) .. ", " .. SQLStr(row.lua) .. ", "	.. name .. ")")
		end
 	else
		return false
	end
end

function GetEventEntityExample(name, map)
	CheckEventEntities()
	if name then
		local val = sql.Query("SELECT * FROM  event_entities_examples WHERE name=" .. SQLStr(name) .. (map and " AND map=" .. SQLStr(map) ) )
		if val then 
			return val
		else
			return {}
		end
	else
		local val = sql.Query("SELECT * FROM  event_entities_examples WHERE map=" .. SQLStr(map))
		if val then 
			return val
		else
			return {}
		end
	end
end


function SetEventEntity(vec, ang, ent, mdl, map, lua )
	CheckEventEntities()
	if !lua then lua = "" end

	sql.Query("INSERT INTO event_entities(x, y, z, ax, ay, az, ent, mdl, map, lua) VALUES(" .. vec.x .. ", " .. vec.y .. ", " .. vec.z .. ", "	.. ang.p .. ", " .. ang.y .. ", " .. ang.r  .. ", ".. SQLStr(ent) .. ", " .. SQLStr(mdl) .. ", " .. SQLStr(map) .. ", " .. SQLStr(lua) .. ")")



	PrintTable(GetEventEntity(map))
end


function GetEventEntity(map)
	CheckEventEntities()
	if map then
		local val = sql.Query("SELECT * FROM event_entities WHERE map=" .. SQLStr(map))
		if !val then
			return {}
		end
		return val
	else
		local val = sql.Query("SELECT * FROM event_entities")
		if !val then 
			return {}
		end
		return val
	end
end

function RemoveEventEntities(x,y,z, map, str)
	CheckEventEntities()
	sql.Query("DELETE FROM event_entities WHERE map=" .. SQLStr(map) .. " AND x=" .. x .. " AND y=" .. y .. " AND z=" .. z .. " AND ent=" .. SQLStr(str) ) 
	print(sql.LastError())
end

function UpdateEventEntities(oldx, oldy, oldz, map, str, x, y, z, ax, ay, az,mdl, lua)
	-- Write the sql query, using oldx, oldy, and old z as constants 
	MsgC(x, y, z .. "\n")
	lua = lua || ""
	sql.Query([[
		UPDATE event_entities SET
		x = ]] .. x .. [[,
		y = ]] .. y .. [[,
		z = ]] .. z .. [[,
		ax = ]] .. ax .. [[,
		ay = ]] .. ay .. [[,
		az = ]] .. az .. [[,
		mdl = ]] .. SQLStr(mdl) .. [[,
		ent = ]] .. SQLStr(str) .. [[,
		lua = ]] .. SQLStr(lua) .. [[


		WHERE 
		x = ]] .. oldx .. [[ AND 
		y = ]] .. oldy .. [[ AND
		z = ]] .. oldz .. [[ AND
		map = ]] .. SQLStr(map) .. [[

		]])
		MsgC(sql.LastError() .. "\n")
end