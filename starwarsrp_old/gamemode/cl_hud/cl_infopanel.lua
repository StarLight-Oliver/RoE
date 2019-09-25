if SERVER then return end
local staff = nil
http.Fetch( "http://steamcommunity.com/groups/OGCROESG/memberslistxml/?xml=1",
		function(body)
			body = tostring(body)
		local __, ind = string.find( body, "<members>" )
		local ex, __ = string.find(body, "</members>")
			local bob = string.sub(body, ind + 1, ex -1 )
			local bo = string.Explode("<steamID64>", bob)
			table.remove(bo, 1)
			for index, str in pairs(bo) do
				bo[index] = string.sub(bo[index], 1, #bo[index] - 14)
			end
			staff = bo
	end,
	function(fal)
	end
	)



local apikey = "C7D95C136D61632C38E475B37A3744B8" -- This is not mine, it was given to me so I use it for all clientside steam api keys
timer.Simple(4, function()
	for index, str in pairs(staff || {}) do
		http.Fetch("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v2/?key=" .. apikey .. "&steamids=" .. str .. "&format=json", function(body, size, headers, code)
			local response = util.JSONToTable(body).response
			local plyInfo
			local image
			if not response.players[1] then
				image = false
				staff[index] = nil
			else
				plyInfo = response.players[1]
				image = plyInfo.avatarfull
				staff[index] = {plyInfo.personaname, plyInfo.profileurl, plyInfo.avatarfull}
			end
		end)
	end
	timer.Simple(4,function()
		staffinfo = "" 
		for index, tbl in pairs(staff) do
			staffinfo = staffinfo .. [[
				<a href= "">
				<img src="]] .. tbl[3]  ..[[" title="]] .. tbl[1] ..[[">
				</a>
			]]
		end
		
	end)
end)		

function InfoPanel()
			if !staffinfo then 
				timer.Simple(1, function()
					InfoPanel()
				end)
			end
	local frame = vgui.Create("DFrame")
        frame:SetSize(590, 690)
        frame:SetTitle("")
        frame:MakePopup()
        frame:Center()
		frame:SetDraggable(false)
		frame.Paint = function()
		 
		end
 
        frame.html = frame:Add("DHTML")
        frame.html:Dock(FILL)
        frame.html:SetHTML([[
		<html>
			<body background="https://trello-attachments.s3.amazonaws.com/59734f86f79d44f83ca06c4f/5a81ee43dd4147e31153e2c1/7ca821700a19e91ae29a1420324bbe6a/basehexagons.png" text = #282B2D >
				<center>
					<font face="verdana">
						<img src="https://puu.sh/x6PMv/471ef3005f.png" alt="" width="530" height="227.932011">
						<h3>Welcome to the Osiris Gaming Community</h3>
						<h4>We are gaming community that was founded on the 19th of April 2017 
							We strive to create servers of the highest quality.
							<br/>
							<br/>
							Common Questions: 
							<br/>
							<br/>
								Q:Are you looking for Developers?
								<br/> 
								A:Yes, We are always looking for Developers.
							<br/>
							<br/>
								Q:Are you looking for Staff?
								<br/>
								A:Yes we are always looking for Staff.
							<br/>
							<br/>
								Q:WOW this is custom, How long did it take?
								<br/>
								A: It has taken around a month to two months.
							<br/>
							<br/>
								Q:Can I get Member?
								<br/>
								A: Yes, put OGC in your name and join the Steam Group. 
							<br/>
							<br/>
								Q:What are the benefits of being a member?
								<br/>
								A: You get an increase the money you earn by 20% and money off buying items.
							<br/>
							<br/>
								Q:Can I get into this faction?
								<br/>
								A: You are invited through tryouts.
							<br/>
							
							
							<br/>
							List of Current Staff
						</h4>
						]].. 
						staffinfo
						.. [[
					</font>
				</center>
			</body>
		</html>
		]])
end
concommand.Add("open_info_panel", InfoPanel)