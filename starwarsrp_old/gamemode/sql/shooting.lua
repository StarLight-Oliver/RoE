function CheckShootingRange()
	if !sql.TableExists("shooting_range") then
		sql.Query("CREATE TABLE shooting_range(id INTEGER, score INTEGER, wep TEXT )")
		MsgC(sql.LastError())
	end
end

function GetAllShoot()
    CheckShootingRange()
	local tbl = {}
	local val = sql.Query("SELECT id FROM shooting_range")

	for index, data in pairs(val) do
		if tbl[data.id] then continue end
		tbl[data.id] = {
			Scores 		= GetShootingScores(data.id, wep),
			High 		= GetShootingHighScore(data.id),
			Name        = CharacterNameFromID(data.id),
		}
		print(data.id, tbl[data.id]["Name"])
	end

	return tbl





end


function GetShootingScores(id, wep)
		 CheckShootingRange()

	if wep then
		local val = sql.Query("SELECT * FROM shooting_range WHERE id=" .. id .. " AND wep=" .. wep)
		if val then
			return tonumber(val[1].score)
		else
			return 0
		end
	else
		local val = sql.Query("SELECT * FROM shooting_range WHERE id=" .. id)
		if val then
			tb = {}
			for index, tbl in pairs(val) do
				tb[index] ={
					score = tonumber(tbl.score),
					weapon = tbl.wep,
				} 
			end
 
 

			return tb
		else
			return {{score = 0, weapon = nil}}
		end
	end
end

function plymeta:GetShootingScores(wep)
	 CheckShootingRange()
	local id = self.Char.id

	if wep then
	    wep = SQLStr(wep)
		local val = sql.Query("SELECT * FROM shooting_range WHERE id=" .. id .. " AND wep=" .. wep)
		if val then
			return tonumber(val[1].score)
		else
			return 0
		end
	else
		local val = sql.Query("SELECT * FROM shooting_range WHERE id=" .. id)
		if val then
			tb = {}
			for index, tbl in pairs(val) do
				tb[index] ={
					score = tonumber(tbl.score),
					weapon = tbl.wep,
				} 
			end
 
 

			return tb
		else
			return {{score = 0, weapon = nil}}
		end
	end
end

function plymeta:SetShootingScore(score, wep)
	 CheckShootingRange()
	wep = SQLStr(wep)
	score = math.floor(score)

	SLChatMessage({Color(100,210, 141), "[Shooting-System] ", color_white, "Player " .. self:Name() .. " has just got a new high score of " .. score .. " with a " .. wep})


	local id = self.Char.id
	print(id, type(id), sql.LastError())
	if self:GetShootingScores(wep) == 0 then
		sql.Query("INSERT INTO shooting_range(id, score, wep) VALUES(".. id .. ", " ..score .. "," .. wep ..")" )
	else
		sql.Query("UPDATE shooting_range SET score=" .. score .. " WHERE id = " .. id .. " AND wep=" .. wep)
	end 
	net_sync_player(self,true)
end

function plymeta:GetShootingHighScore()
	 CheckShootingRange()
	local id = self.Char.id
	local val = sql.Query("SELECT * FROM shooting_range WHERE id=" .. id)
	if val then
		local score = 0
		for index, tbl in pairs(val) do
			if tonumber(tbl.score) > score then
				score = tonumber(tbl.score)
			end
		end
		return score
	else
		return 0
	end
end

function GetShootingHighScore(id)
	 CheckShootingRange()
	local val = sql.Query("SELECT * FROM shooting_range WHERE id=" .. id)
	if val then
		local score = 0
		for index, tbl in pairs(val) do
			if tonumber(tbl.score) > score then
				score = tonumber(tbl.score)
			end
		end
		return score
	else
		return 0
	end
end