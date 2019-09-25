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


DEFAULT_MONEY = 100

function CheckMoney()
	if !sql.TableExists("moneytbl") then
		sql.Query( "CREATE TABLE moneytbl(money INTEGER,id INTEGER);" )
		print("Money Made")
	end

end


function plymeta:GetMoney()
    CheckMoney()
	if !self.Char then return false end
	local val = sql.Query( "SELECT money FROM moneytbl WHERE id = " .. self.Char.id )
	if !val then
		return DEFAULT_MONEY
	else
		return tonumber(val[1].money)
	end
end
function plymeta:SetMoney(mon)
    CheckMoney()
	if !self.Char then return false end
		if self.Char.event then return end
	local id = self.Char.id
	local val = sql.Query( "SELECT money FROM moneytbl WHERE id = " .. id )
	if val then
		sql.Query("UPDATE moneytbl SET money = " .. mon .. " WHERE id = " .. id .."")
	else
		CheckMoney()
		timer.Simple(0.2 , function()
			sql.Query( "INSERT INTO moneytbl ( money, id ) VALUES ( " .. mon .. ", " .. id .. " );" )
		end)
	end

	networkmoney(self)
end

function SetMoneyID(id,mon)
    CheckMoney()
	local val = sql.Query( "SELECT money FROM moneytbl WHERE id = " .. id )
	if val then
		sql.Query("UPDATE moneytbl SET money = " .. mon .. " WHERE id = " .. id .."")
	else
		CheckMoney()
		timer.Simple(0.2 , function()
			sql.Query( "INSERT INTO moneytbl ( money, id ) VALUES ( " .. mon .. ", " .. id .. " );" )
		end)
	end
end

function GetMoneyID(id)
    CheckMoney()
	local val = sql.Query( "SELECT money FROM moneytbl WHERE id = " .. id )
	if !val then
		return DEFAULT_MONEY
	else
		return val[1].money
	end
end