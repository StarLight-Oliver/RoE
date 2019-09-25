function AdminCheckDB()
	if !sql.TableExists("ban_list") then
		sql.Query( "CREATE TABLE ban_list( steamid TEXT, time INTEGER, reason TEXT);" )	
		print("Ban List Made")
	end
	if !sql.TableExists("warn_list") then
		sql.Query( "CREATE TABLE warn_list( steamid  TEXT, reason TEXT )")
		print("Warns Made")
	end
end


function CustomBan(steamid, val, reason, ply)
	AdminCheckDB()
	
	local time = os.time() + val
	if val == 0 then time = -1 end
	local steamid = SQLStr(steamid)
	local reason = SQLStr(reason)
	log(adminply,  steamid.. " has been banned!" )
	if sql.Query("SELECT * FROM ban_list WHERE steamid=" .. steamid) then
		if ply:HasCommand("unban") then
			sql.Query("UPDATE ban_list SET time = " .. time .. " WHERE  steamid = " ..  steamid .."")
			sql.Query("UPDATE ban_list SET time = " .. reason .. " WHERE  steamid = " ..  steamid .."")
		end
		return
	end
	sql.Query("INSERT INTO ban_list(steamid, time, reason) VALUES( " .. steamid ..", ".. time ..", " ..  reason ..")")
	
end


function GetCustomBan(steamid)
	AdminCheckDB()
	local steamid = SQLStr(steamid)
	local val = sql.Query("SELECT * FROM ban_list WHERE steamid=" .. steamid)
	if val then
		return val[1]
	else
		return false
	end
end

local GLOBALBAN ={

}


function UnCustomBan(steamid)
	if GLOBALBAN[steamid] then return false end
	local steamid = SQLStr(steamid)
	local val = sql.Query("SELECT * FROM ban_list WHERE steamid=" .. steamid)
	if val then
		sql.Query("DELETE FROM ban_list WHERE steamid=" .. steamid .. "")
		return true
	end
	return false
end


function plymeta:warn(reason)
	local steamid = SQLStr(self:SteamID())
	local reason = SQLStr(reason)
	sql.Query("INSERT INTO warn_list(steamid, reason) VALUES(" .. steamid, reason )
	self:SLChatMessage({Color(255,0,0), "[Warn System] ", color_white, "You have been warned for " .. reason})
end

function GetWarns(steamid)
	local steamid = SQLStr(steamid)
	local val = sql.Query("SELECT * FROM warn_list WHERE steamid=" .. steamid)
	
	return val
end




hook.Add( "CheckPassword", "ban", function( steamID64, ip, pass, pass2 )
	 if #pass != 0 then
	local info = GetCustomBan(util.SteamIDFrom64(steamID64) )
	if info then
	
		if tonumber(info.time) < os.time() then 
			UnCustomBan(util.SteamIDFrom64(steamID64))
			return true
		end
	
	
		local reason ="You were Banned \nReason: ".. info.reason .. "\nYou will be unbanned on " .. os.date( "%H:%M:%S - %d/%m/%Y" , tonumber(info.time) ) .. "\nCurrent Time " .. os.date( "%H:%M:%S - %d/%m/%Y" , os.time())
		return false, reason
	end
	
	
	timer.Simple(0.2, function()
			RequestStaffTable()
		end)
		if OGCCW.Staff then
			if table.HasValue(OGCCW.Staff,steamID64) then
				return true
			end
		end
	
	
	if pass !=pass2 then
		return false, "Is your ID Chip wrong?\n(The Password you entered is wrong)"
	end
    
else
    
    return true
	end
end )