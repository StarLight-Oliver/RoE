

if SERVER then
	util.AddNetworkString("shooing_range_sync")
  util.AddNetworkString("Request_ShootName")
	function net_sync_player(ply, bool)
		if !bool then
			count = 0
			for index, pl in pairs( GetAllShoot() ) do
        PrintTable(pl)
				--pl.Name, pl.score, pl.weapon
					timer.Simple(count/100, function()
						net.Start("shooing_range_sync")
							print(index, type(index))
							net.WriteDouble(index)
							net.WriteTable(pl.Scores)
							net.WriteDouble(pl.High)
							net.WriteString(pl.Name)
						net.Send(ply)
					end)
				count = count + 1
			end 
		end

		net.Start("shooing_range_sync")
			net.WriteDouble(ply.Char.id)
			net.WriteTable(ply:GetShootingScores())
			net.WriteDouble(ply:GetShootingHighScore())
			net.WriteString(ply:Name())
		net.Broadcast()				
	end

  net.Receive("Request_ShootName", function(len, ply)
    local id = net.ReadDouble()
    print("hi?")
    local name = CharacterNameFromID(id)
    print(id, name, ply)
    net.Start("Request_ShootName")
      net.WriteDouble(id)
      net.WriteString(name)
    net.Send(ply)
  end)

else
	SHOOTINGHIGHSCORE = {
	["weapon"] = {

	},
	["player"] = {

	}	
}

net.Receive("Request_ShootName", function(len, ply)
local id, name = net.ReadDouble(), net.ReadString()
  print(id, name)
  IDTONAME[id] = name
end)
IDTONAME = IDTONAME || {}
netcheckid = {}
		function CHAR_GetNameID(id)   
     if !IDTONAME[id] then
       print("Invalid ID : " .. id .. ", the id also has a datatype of " .. type(id))
       if !netcheckid[id] then
         print("We have not checked ID: " .. id .. " we are sending a message now ") 
         net.Start("Request_ShootName")
           net.WriteDouble(id)
         net.SendToServer()
         end
     end
			return IDTONAME[id] || ""
		end

	net.Receive("shooing_range_sync", function(len)
		local id = net.ReadDouble()
		local tbl = net.ReadTable()
		local high = net.ReadDouble()
		local str = net.ReadString()
		IDTONAME[id] = str
		SHOOTINGHIGHSCORE["player"][id] = high
		for index, val in pairs(tbl) do
				if !val.weapon then continue end
			if !SHOOTINGHIGHSCORE["weapon"][val.weapon] then
				SHOOTINGHIGHSCORE["weapon"][val.weapon] = {}
			end
      print(id, val.score, val.weapon)
			SHOOTINGHIGHSCORE["weapon"][val.weapon][id] = val.score
		end
		timer.Create("Shooting_range_sort", 1, 1, function()
			--table.SortByMember( SHOOTINGHIGHSCORE["player"] )
			for index, val in pairs(SHOOTINGHIGHSCORE["weapon"]) do
        PrintTable(val)
        PrintTable(SHOOTINGHIGHSCORE["weapon"][index])
        print(index)
				--SHOOTINGHIGHSCORE["weapon"][index] = table.SortByKey(SHOOTINGHIGHSCORE["weapon"][index])
				table.sort( SHOOTINGHIGHSCORE["weapon"][index], function(a, b)
          print(a,b)
          if !a then
          return false
          end
          if !b then return false end
          return a > b
        end)
			end


			print("table sorted")

			PrintTable(SHOOTINGHIGHSCORE)
		end)
	end)

end 