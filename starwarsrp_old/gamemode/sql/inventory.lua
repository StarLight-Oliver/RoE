function CheckInventory()
	if !sql.TableExists("item_database") then
		sql.Query( "CREATE TABLE item_database( weaponid INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, modone TEXT, modtwo TEXT, modthree TEXT, modfour TEXT, modfive TEXT, modsix TEXT, modseven TEXT, modeight TEXT, modnine TEXT);" )	
		print("Item Database Made")
	end
	if !sql.TableExists("char_weapons") then
		sql.Query( "CREATE TABLE char_weapons( charid INTEGER, primarywep INTEGER, secondary INTEGER, melee INTEGER )")
		print("Slots Made")
	end
	if !sql.TableExists("char_inventory") then
		sql.Query( "CREATE TABLE char_inventory( charid INTEGER, wepid INTEGER)")
		print("Inventory Made")
	end
end
 

function plymeta:GetInventory()
	CheckInventory()
	local id = self.Char.id
	local val = sql.Query("SELECT * FROM char_inventory WHERE charid = " .. id .. "")
	if !val then
		return {}
	end
	return val
end

function plymeta:GetActualInventory()
	local tbl = self:GetInventory()
	local tb = {}
	for index, row in pairs(tbl) do
		tb[index] = GetItemByID(row.wepid)[1]
	end
	return tb
end


function GetItemByID(id)
	local val = sql.Query("SELECT * FROM item_database WHERE weaponid =" .. id .. "")
	return val || {}
end

function inventory_drop(item, ply)
    
    local charid = ply.Char.id
    local wep = ITEMS[item.type]
    if wep.weapon then 
        local stat = WEAPONDAT[wep.weapon[1]]
        if stat then
            local val = sql.Query("SELECT * FROM char_weapons WHERE charid=" .. charid ) 
            if val then
                local id = val[1][stat] 
                if id == item.weaponid then
                    print("hi")
                     ply:SLChatMessage( {Color(255,100, 0), "[Inventory System] ", color_white, "You can't drop an equipped item"})
                     return
                end
            end
        end
    end
    

	local id = item.weaponid
	local info = sql.Query("DELETE FROM char_inventory WHERE wepid=" .. id .. "")
	local ent = ents.Create("item_basic")
	ent:SetPos(ply:GetEyeTrace().HitPos)
	ent:Spawn()
	ent:Activate()
	ent:SetItem(item, item.weaponid)
	net_Sync_Inventory(ply)
end

function inventory_use(item, ply)
    
    local charid = ply.Char.id
	local id = item.weaponid

	local tbl = ITEMS[item.type]
	if tbl then
		local val  = tbl.use(ply)
		if val then 
			sql.Query("DELETE FROM char_inventory WHERE wepid=" .. id .. "")
		end
	end 

	net_Sync_Inventory(ply)
end


WEAPONDAT = {
	["Primary"] = "primarywep",
	["Secondary"] = "secondary",
	["Melee"] = "melee",
}

local key2 = {
		[1] = "primarywep",
		[2] = "secondary",
		[3] = "melee",
	}
	
	local key3 = {
		[1] = "Primary",
		[2] = "Secondary",
		[3] = "Melee",
		[4] = "Fists",
	}


function inventory_equip(item, ply)
	local id = item.weaponid
	local charid =  ply.Char.id
	local wep = ITEMS[item.type]
	if !wep.weapon then return end
	local stat = WEAPONDAT[wep.weapon[1]]
	if !stat then return end
	local val = sql.Query("SELECT * FROM char_weapons WHERE charid =" .. charid .. "")
	if val then
		sql.Query("UPDATE char_weapons SET " .. stat .." = " .. id .. " WHERE charid = " ..  charid .."")
	else
		sql.Query("INSERT INTO char_weapons(charid," .. stat .. ") VALUES( " .. charid ..", ".. id ..")")
	end
	
	
	net_Sync_Weapon(ply)
	timer.Simple(0.2, function()
	local tbl = ply:GetSelectionMenu()
	local num = ply.num	|| 4
		if num == 4 then
			ply:GetActiveWeapon():SetNewWeapon("Fists", "Fists")
		else
			if tbl == {} then  return end
			local tb = tbl[key2[num]]
			if type(tb) == "string" then -- There is no weapon
				return
			end
			ply:GetActiveWeapon():SetNewWeapon(key3[num], tb.type, tb.weaponid)
		end
	end)
end

numtoword = {
	[1] = "one",
	[2] = "two",
	[3] = "three",
	[4] = "four",
	[5] = "five",
	[6] = "six",
	[7] = "seven",
	[8] = "eight",
	[9] = "nine",
}

function inventory_modify(itemnum, str, slot)
	local val = GetItemByID(itemnum)[1]
	
	if val["mod" .. numtoword[slot]] != "NULL" then
		ply:GiveItem(val["mod" .. numtoword[slot]])
	end
	sql.Query("UPDATE item_database SET " .. ( "mod".. numtoword[slot]) .. " = ".. SQLStr(str) .." WHERE weaponid = " .. itemnum )
	print(sql.LastError())
end


function plymeta:GetSelectionMenu()
	local charid = self.Char.id
	local val = sql.Query("SELECT * FROM char_weapons WHERE charid =" .. charid .. "")
	if !val then return {} end
	local tbl = {}
	for index, tb in pairs(val[1]) do
		if index == "charid" then continue end
		if tb == "NULL" then
			tbl[index] = "Null"
		else
			tbl[index] = GetItemByID(tb)[1]
		end
	end
	return tbl
end

/*
	sql.Query("UPDATE testcharacters SET " .. stat .." = " .. SQLStr(val) .. " WHERE id = " .. id .."")
	char_weapons( charid INTEGER, primarywep INTEGER, secondary INTEGER, melee INTEGER )
{
	name = "DC-15S", -- name of the item
	weapon = {"Primary", "DC-15S"}, -- is it a weapon
	model = "models/Gibs/HGIBS.mdl", -- the model of it
	modifications = {
		["Scrap Metal"] = {damage = 40,}
	},
	crafting = {
		["Scrap Metal"] = 4,
	}, -- what is the cost for crafting it
	price = {
		sell = 10, -- base value for selling it
		buy = 20, -- base value for buying it 
	},
	drop = nil, -- chance of it droping from a player
	use = nil, -- can it be used
}
*/


function GetPlayerByID(id)
	
	return false
end


function plymeta:GiveDatabaseItem(id)
	if self.Char.event then return end
	CheckInventory()
	local val = sql.Query("SELECT * from char_inventory WHERE wepid=" .. id .. "")
	if val then
		sql.Query("DELETE FROM char_inventory WHERE wepid=" .. id .. "") -- Removes the current item from the person inventory
		local ply = GetPlayerByID(val.charid)
		if ply then
			net_Sync_Inventory(ply)
		end
	end
	sql.Query("INSERT INTO char_inventory(charid, wepid) VALUES(" .. self.Char.id .. ", " .. id .. ")" )
	
	local typc = GetItemByID(id)
	
	
	net_Sync_Inventory(self)
	self:SLChatMessage( {Color(255,100, 0), "[Inventory System] ", color_white, "You have picked up " .. typc[1].type })
end

function plymeta:GiveItem(typc)
	if self.Char.event then return end
	CheckInventory()
	if !ITEMS[typc] then return end
	sql.Query("INSERT INTO item_database( type ) VALUES( " .. SQLStr(typc) .. ")")
	self:SLChatMessage( {Color(255,100, 0), "[Inventory System] ", color_white, "You have picked up " .. typc })
	local val = sql.Query("SELECT * FROM item_database")
	local info = val[#val].weaponid
	local info = sql.Query("INSERT INTO char_inventory( charid, wepid ) VALUES(" .. self.Char.id .. ", " .. info .." )")
	net_Sync_Inventory(self)
end