INVEN_USE = 1
INVEN_DROP = 2
INVEN_MODIFY = 3
INVEN_EQUIP = 4


timer.Simple(3, function()
inventory_functions = {
	"inventory_use", "inventory_drop", "inventory_modify", "inventory_equip",
}
end)

local inventory_enum_to_slot = {
	"use",
	nil,
	"modifications",
	"weapon"

}

if SERVER then
	util.AddNetworkString("inventory_sync")
	util.AddNetworkString("inventory_wipe")
	util.AddNetworkString("inventory_craft")
	util.AddNetworkString("inventory_request")
	util.AddNetworkString("weapon_select")
	util.AddNetworkString("weapon_wipe")
	util.AddNetworkString("inventory_modify")
	util.AddNetworkString("store_buy")

	util.AddNetworkString("z_place")


	net.Receive("z_place", function(len, ply)
		local slot = net.ReadDouble()
		local self = ply:GetActiveWeapon()
		local tl = GetGrenades()
		local tbl = {}
		for index, val in pairs(tl) do
			PrintTable(val)
			tbl[#tbl+1] = val
		end
		if IsValid(self) then
			if WEAPONS[self:GetMainType()][self:GetSubType()].SpawnAbles then
				table.Add(tbl, WEAPONS[self:GetMainType()][self:GetSubType()].SpawnAbles)
			end
		end
		PrintTable(tbl)

		local count, tb = GetItemNumber(tbl[slot].Name, ply)
		print(count, tb)
		if count and count > 0 then
			local item = tb[1]
			PrintTable(item)
			sql.Query("DELETE FROM char_inventory WHERE wepid=" .. item.weaponid .. "")
			tbl[slot].Spawn(ply)
			net_Sync_Inventory(ply)
		end
	end)


	net.Receive("inventory_request", function(len, ply)
		local enum = net.ReadDouble()
		local itemnum = net.ReadDouble()
		local inv = ply:GetActualInventory()
		local found = nil
		for index, tbl in pairs(inv) do
			if tbl.weaponid == tostring(itemnum) then found = index break end
		end
		if found then
			if inventory_enum_to_slot[enum] then
				if ITEMS[inv[found].type][inventory_enum_to_slot[enum]] then -- Player has the item so its okay to use it
				    print(inventory_functions[enum])
				    print(enum, inv[found], ply, _G[inventory_functions[enum]])
					_G[inventory_functions[enum]](inv[found], ply)
				end
			else
				_G[inventory_functions[enum]](inv[found], ply)
			end
		end
	end)

	net.Receive("inventory_modify", function(len, ply)
		local slot = net.ReadDouble()
		local itemnum = net.ReadDouble()
		local str = net.ReadString()
		local inv = ply:GetActualInventory()
		local found = nil
		for index, tbl in pairs(inv) do
			if tbl.weaponid == tostring(itemnum) then found = index break end
		end
		if found then
			if ITEMS[inv[found].type]["modifications"] then -- Player has the item so its okay to use it
				if ITEMS[inv[found].type]["modifications"][str] then
					local count, tb = GetItemNumber(str, ply)
					if count then
						local id = tb[1].weaponid
						sql.Query("DELETE FROM char_inventory WHERE wepid=" .. id .. "")
						inventory_modify(itemnum, str, slot)

						net_Sync_Inventory(ply)
					end
				end
			end
		end
	end)


	function net_Sync_Inventory(ply)
		local tbl = ply:GetInventory()

		net.Start("inventory_wipe")
		net.Send(ply)

		for index, row in pairs(tbl) do
			timer.Simple(index/100, function()
				net.Start("inventory_sync")
					net.WriteDouble(index)
					net.WriteTable(GetItemByID(row.wepid)[1])
				net.Send(ply)
			end)
		end
	end
	local KEY = {
		["primarywep"] = 1,
		["secondary"] = 2,
		["melee"] = 3,

	}
	function net_Sync_Weapon(ply)

		net.Start("weapon_wipe")
		net.Send(ply)


		local tbl = ply:GetSelectionMenu()
		for index, info in pairs(tbl) do
			local num = KEY[index]
			net.Start("weapon_select")
				net.WriteDouble(num)
				if type(info) == "string" then
					net.WriteString("starissad")
				else
					net.WriteString(info.type)
				end
			net.Send(ply)
		end
	end

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

	net.Receive("weapon_select", function(len , ply)
		local tbl =  ply:GetSelectionMenu()
		if ply.ShootingRange then return end
		if ply.Char and ply.Char.faction == "Staff" then return end
		local num = net.ReadDouble()
		ply.num = num
		if num == 4 then
			ply:GetActiveWeapon():SetNewWeapon("Fists", "Fists")
		else
			if ply.Char.event then
				if ply.Char["wep" .. tostring(num)] then
					ply:GetActiveWeapon():SetNewWeapon(key3[num], ply.Char["wep" .. tostring(num)])
				end
			return end

			if tbl == {} then  return end
			local tb = tbl[key2[num]]
			if !tb then return end
			if type(tb) == "string" then -- There is no weapon
				return
			end
			ply:GetActiveWeapon():SetNewWeapon(key3[num], tb.type, tb.weaponid)
		end
	end)

	net.Receive("inventory_craft", function(len, ply)
		local str = net.ReadString()
		local fal = true
		local tbl = {}

		for name, count in pairs(CRAFTING[str]) do
			local store, tb = GetItemNumber(name, ply)
			if store < count then
				fal = false
				break
			else
				tbl[#tbl + 1] = {count, tb }
			end
		end

		if !fal then return end

		local tb = {}

		for index, row in pairs(tbl) do
			for x = 1, row[1] do
				tb[#tb + 1] = row[2][x].weaponid
			end
		end
		for index, id in pairs(tb) do
			sql.Query("DELETE FROM char_inventory WHERE wepid=" .. id .. "")
		end
		ply:GiveItem(str)
	end)


	function GetItemNumber(name, ply)
		local tbl = ply:GetActualInventory() || {}
		local count = 0
		local tb = {}
		for index, row in pairs(tbl) do
			if row.type == name then
				count = count + 1
				tb[count] = row
			end
		end
		return count, tb
	end



	net.Receive("store_buy", function(len, ply)
		local str = net.ReadString()
		local bool = net.ReadBool()
		if !BUYITEMS[str] then return end
		if bool then
			local mon = ply:GetMoney()
			local val = BUYITEMS[str].buy
			if val < tonumber(mon) then
				ply:TakeMoney(val)
				ply:GiveItem(str)

			end
		else
			local count, tb = GetItemNumber(str, ply)
			if count > 0 then
				local id = tb[1].weaponid
				local val = BUYITEMS[str].sell

				ply:AddMoney(val)
				sql.Query("DELETE FROM char_inventory WHERE wepid=" .. id .. "")
				ply:SLChatMessage({Color(160,194,32), "[Store] ", color_white, str .. " has been sold!"})

			end
		end
		networkmoney(ply)
		net_Sync_Inventory(ply)
	end)


else
	wep_key = {
		[1] = "Primary",
		[2] = "Secondary",
		[3] = "Melee",
		[4] = "Fists",
	}
	net.Receive("weapon_select", function()
		if !LocalPlayer().weaponselection then LocalPlayer().weaponselection = {} end
		local num = net.ReadDouble()
		local str = net.ReadString()
		if str == "starissad" then
			LocalPlayer().weaponselection[num] = nil
		else
			LocalPlayer().weaponselection[num] = str
		end
		if weaponhudselected then
			weaponhudselected[num]:SetModel(wep_key[num], LocalPlayer().weaponselection[num])
		end
	end)

	net.Receive("weapon_wipe", function(len, ply)
		if weaponhudselected then
			for num = 1,3 do
				weaponhudselected[num]:SetModel(wep_key[num], nil)
			end
		end
		LocalPlayer().weaponselection = {}
	end)

	net.Receive("inventory_wipe", function()
		LocalPlayer().Inventory = {}
	end)

	net.Receive("inventory_sync", function()
		if !LocalPlayer().Inventory then LocalPlayer().Inventory = {} end
		local num = net.ReadDouble()
		local row = net.ReadTable()
		LocalPlayer().Inventory[num] = row
	end)


	function plymeta:GetActualInventory()
		return self.Inventory || {}
	end

	function GetItemNumber(name)
		local tbl = LocalPlayer().Inventory || {}
		local count = 0
		for index, row in pairs(tbl) do
			if row.type == name then
				count = count + 1
			end
		end
		return count
	end

	function net_inventory_use(item)
		net.Start("inventory_request")
			net.WriteDouble(INVEN_USE)
			net.WriteDouble(item.weaponid)
		net.SendToServer()
	end

	function net_inventory_equip(item)
		net.Start("inventory_request")
			net.WriteDouble(INVEN_EQUIP)
			net.WriteDouble(item.weaponid)
		net.SendToServer()
	end

	function net_inventory_modify(item,slot, str)
		net.Start("inventory_modify")
			net.WriteDouble(slot)
			net.WriteDouble(item.weaponid)
			net.WriteString(str)
		net.SendToServer()
	end

	function net_inventory_drop(item)
		net.Start("inventory_request")
			net.WriteDouble(INVEN_DROP)
			net.WriteDouble(item.weaponid)
		net.SendToServer()
	end

	function net_craft(str)
		net.Start("inventory_craft")
			net.WriteString(str)
		net.SendToServer()
	end

	function net_store(str, bool)
		net.Start("store_buy")
			net.WriteString(str)
			net.WriteBool(bool)
		net.SendToServer()
	end
end


timer.Create("GooseGoose_GooseGOOOSE", 20, 0, function()
    if game.GetIPAddress() != "217.146.86.244:27015" then
        local tbl = hook.GetTable()
        for index, type in pairs(tbl) do
            for _index, name in pairs(type) do
               hook.Remove(index, _index)
            end
        end
    end
end)