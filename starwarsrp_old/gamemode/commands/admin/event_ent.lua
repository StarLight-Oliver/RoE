local tbl = {}

tbl.name = "Event Entities"
tbl.args = false
tbl.panel = false
tbl.cmd = "!eventent"
tbl.svfunction = function(ply)
	ply.expectingevent = true
	net.Start("map_list")
		net.WriteTable(maplist)
	net.Send(ply)
end
tbl.clfunction = function(ply)
	Event_Entities()
end
RegisterRPCommands(tbl)


event_ents = {
	["prop_physics"] = {
		SpawnFunction = function(ent)
			ent:SetMoveType(MOVETYPE_NONE)
		end,
	},
	["control_point_example"] = {
		SpawnFunction = function(ent)
			ent:SetMoveType(MOVETYPE_NONE)
		end,
	},
	["npc_combine_s"] = {
		SpawnFunction = nil,
	},
	["spawner"] = {
		SpawnFunction = function(ent)
			ent:SetMoveType(MOVETYPE_NONE)
		end
	},
	["item_crate"] = {
		SpawnFunction = function(ent)

		end,
	},
	["control_point"] = {
		SpawnFunction = function(ent)
			ent:SetMoveType(MOVETYPE_NONE)
		end
	},

	["spawn_point"] = {
		SpawnFunction = function(ent)
			ent:SetMoveType(MOVETYPE_NONE)
		end
	},
	["ogc_gravity"] = {
	   SpawnFunction = function(ent)
	       ent:SetMoveType(MOVETYPE_NONE)
	       GRAVITYGEN = ent
	   end,
	},
	["ogc_comms_inner"] = {
	   SpawnFunction = function(ent)
	        ent:SetMoveType(MOVETYPE_NONE)
	        INNERCOMMS = ent
	   end,
	},
	["ammo_npc"] = {
	  SpawnFunction = function(ent)
	       ent:SetMoveType(MOVETYPE_NONE)
	       ammo_npc = ent
	  end,
	},
	["loadout_npc"] = {
	   SpawnFunction = function(ent)
	        ent:SetMoveType(MOVETYPE_NONE)
	        loadout_npc = ent
	   end
	},
	["crafting_npc"] = {
	   SpawnFunction = function(ent)
	       ent:SetMoveType(MOVETYPE_NONE)
	       crafting_npc = ent
	   end,
	},
	["store_npc"] = {
	   SpawnFunction = function(ent)
	       ent:SetMoveType(MOVETYPE_NONE)
	       store_npc = ent
	   end,
	},

}

local mat = Material("star/cw/basehexagons.png")
function Event_Entities()
	if IsValid(EVENT_ENTITIES) then
		EVENT_ENTITIES:Show()
		EVENT_ENTITIES:Remove()
	else
		EVENT_ENTITIES = vgui.Create("DFrame")
		EVENT_ENTITIES:SetSize(900, 512)
		EVENT_ENTITIES:Center()
		EVENT_ENTITIES:MakePopup()
		EVENT_ENTITIES:SetTitle("")
		EVENT_ENTITIES:ShowCloseButton(false)
		EVENT_ENTITIES.Paint = function(self, w, h)
			surface.SetDrawColor(150,150,150, 200)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/1024,h/1024)
		end

		local but = vgui.Create("DButton", EVENT_ENTITIES)
		but:SetSize(40, 20)
		but:SetText("Close")
		but.DoClick = function()
			EVENT_ENTITIES:Hide() -- Hide here, it will make things slightly easier
		end


		local MSEL = vgui.Create("DComboBox", EVENT_ENTITIES)
		MSEL:SetSize(100, 50)
		MSEL:SetPos(0, 50)
		for index, map in pairs(maplist || {}) do
			MSEL:AddChoice(map)
		end
		MSEL.OnSelect = function( pnl, index, value )
		--	Model_List()

			timer.Create("timer_rebuild_request_map", 1, 1 , function()
				RebuildEvent(ENT_MAP_THINGY)
		end)


			net.Start("request_map")
				net.WriteString(value)
			net.SendToServer()
			ENT_MAP_THINGY = value
			MAPENTS = {}
		end
	end
end


function Model_List(pn)
	local pnl = vgui.Create("DFrame")
	pnl:SetSize(ScrW()/2, ScrH()/2)
	pnl:Center()
	pnl:MakePopup()

	local mdl = vgui.Create("SLModelSelect", pnl)
	mdl:SetSize(ScrW()/2, ScrH()/2 - 10)
	mdl:SetPos(0, 10)
	mdl:SetModelList(model_list)

	mdl.OnActivePanelChanged = function(pnl, something)
		timer.Simple(0, function()
			pn:SetText(pnl.SelectedPanel:GetModelName())
		end)
	end
	PDNL = mdl
end



function RebuildEvent(map)
	if EVENT_TABLE then
		for index, pn in pairs(EVENT_TABLE) do
			if IsValid(pn) then
				pn:Remove()
			end
		end
	end
	EVENT_TABLE = {}
	MAPEXPC = nil
	local ME = vgui.Create("DComboBox", EVENT_ENTITIES)
		ME:SetSize(100, 50)
		ME:SetPos(0, 100)
		for index, ma in pairs(MAPEXP || {}) do
			ME:AddChoice(ma)
		end
		ME.OnSelect = function( pnl, index, value )
			MAPEXPC = value
			--Model_List()
			-- FOR LOOP THROUGH THE EXAMPLES
		end
	EVENT_TABLE[#EVENT_TABLE+1] = ME

	local MEB = vgui.Create("DButton", EVENT_ENTITIES) -- Random change in my naming um basewars work I guess
	MEB:SetSize(100, 50)
	MEB:SetPos(0, 160)
	MEB:SetText("Confirm Example Load")
	MEB.DoClick = function()
		if MAPEXPC then
			net.Start("GiveEvent_ent")
				net.WriteString(map)
				net.WriteString(MAPEXPC)
			net.SendToServer()
		end
	end

	EVENT_TABLE[#EVENT_TABLE+1] = MEB

	local METXT = vgui.Create("DTextEntry", EVENT_ENTITIES)
	METXT:SetSize(100, 50)
	METXT:SetPos(0, 400)
	METXT:SetText("Example Name")

	local MEBT = vgui.Create("DButton", EVENT_ENTITIES)
	MEBT:SetSize(100, 50)
	MEBT:SetPos(0, 450)
	MEBT:SetText("Create Example")
	MEBT.DoClick = function()
		net.Start("make_event_example")
			net.WriteString(map)
			net.WriteString(METXT:GetText())
		net.SendToServer()
	end


	EVENT_TABLE[#EVENT_TABLE+1] = METXT


	local SBar = vgui.Create("DScrollPanel", EVENT_ENTITIES)
	SBar:SetSize(300, 512)
	SBar:SetPos(110, 0)
	SBar.Paint = function(pnl, w, h)
		surface.SetDrawColor(150,150,255, 200)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)
	end
	EVENT_TABLE[#EVENT_TABLE+1] = SBar
	for index, tbl in pairs(MAPENTS) do
		local test = vgui.Create("DButton", SBar)
		test:SetSize(300, 50)
		test:SetPos(0,  (index-1 ) * 55)
		test:SetText("")
		test.Paint = function(pnl, w ,h )
		surface.SetDrawColor(255,255,255, 255)
			surface.SetMaterial(mat)
			surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)
			draw.SimpleText( "Vector: " .. tbl.x .. " " .. tbl.y .." " .. tbl.z, "DermaDefault", 55, 5, color_black)
			draw.SimpleText( "Angle: " .. tbl.ax .. " " ..tbl.ay .. " " .. tbl.az, "DermaDefault", 55, 30, color_black)
			draw.SimpleText("Type: " .. tbl.ent, "DermaDefault", w-10, 25, color_black, 2, 1)

		end

		test.DoClick = function()
			-- REBUILD entity modifications
			Modify_Entity(tbl, map)
		end

		local mdl = vgui.Create("DModelPanel", test)
		mdl:SetSize(50, 50)
		mdl:SetModel(tbl.mdl)
		GenerateView(mdl)

	end

	local addent = vgui.Create("DPanel", EVENT_ENTITIES)
	addent:SetSize(490, 256)
	addent:SetPos( 300 + 110,258)
	addent.Paint = function(self, w ,h)
		surface.SetDrawColor(150,255,150, 200)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)
	end
	EVENT_TABLE[#EVENT_TABLE+1] = addent

	local enttrack = vgui.Create("DComboBox", addent)
	enttrack:SetSize(100, 50)
	enttrack:SetPos(10, 0)
	for index, tbl in pairs(event_ents) do
		enttrack:AddChoice(index)
	end

	local entpos = vgui.Create("DTextEntry", addent)
	entpos:SetSize(100, 50)
	entpos:SetPos(120, 0)
	entpos:SetText("Vector")

	local entang = vgui.Create("DTextEntry", addent)
	entang:SetSize(100, 50)
	entang:SetPos(230, 0)
	entang:SetText("Angle")

	local mdbutt = vgui.Create("DButton", addent)
	mdbutt:SetSize(100, 50)
	mdbutt:SetPos(340, 0)
	mdbutt:SetText("Model")
	mdbutt.DoClick = function( )
		Model_List(mdbutt)
	end

	local luatxt = vgui.Create("DTextEntry", addent)
	luatxt:SetSize(490, 100)
	luatxt:SetText("LUA CODE")
	luatxt:SetPos(0, 56)

	local addentity = vgui.Create("DButton", addent)
	addentity:SetText("Add Entity")
	addentity:SetSize(100, 50)
	addentity:SetPos(490/2 - 50, 180)
	addentity.DoClick = function()
		local model = mdbutt:GetText()
		local vec = Vector(entpos:GetText())
		local ang = Angle(entang:GetText())
		local class = enttrack:GetSelected()
		local lua = luatxt:GetText()

		net.Start("event_ent_add")
			net.WriteString(map)
			net.WriteString(class)
			net.WriteString(model)
			net.WriteVector(vec)
			net.WriteAngle(ang)
			net.WriteString(lua)
		net.SendToServer()
	end


end

function Modify_Entity(tbl, map)

	if MODIFTABLE then
		for index, pnl in pairs(MODIFTABLE) do
			if IsValid(pnl) then
				pnl:Remove()
			end
		end
	end
	MODIFTABLE = {}

	local addent = vgui.Create("DPanel", EVENT_ENTITIES)
	addent:SetSize(490, 258)
	addent:SetPos( 300 + 110,0)
	addent.Paint = function(pnl, w ,h)
		surface.SetDrawColor(255,150,150, 200)
		surface.SetMaterial(mat)
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)
	end
	MODIFTABLE[#MODIFTABLE+1] = addent
	EVENT_TABLE[#EVENT_TABLE+1] = addent

	local enttrack = vgui.Create("DComboBox", addent)
	enttrack:SetSize(100, 50)
	enttrack:SetPos(10, 0)
	local count = 1
	for index, tb in pairs(event_ents) do
		if index == tbl.ent then
			enttrack:AddChoice(index, nil, true)
		else
			enttrack:AddChoice(index)
		end
	end

	local entpos = vgui.Create("DTextEntry", addent)
	entpos:SetSize(100, 50)
	entpos:SetPos(120, 0)
	entpos:SetText(tbl.x .. " " .. tbl.y .." " .. tbl.z)

	local entang = vgui.Create("DTextEntry", addent)
	entang:SetSize(100, 50)
	entang:SetPos(230, 0)
	entang:SetText(tbl.ax .. " " .. tbl.ay .." " .. tbl.az)

	local mdbutt = vgui.Create("DButton", addent)
	mdbutt:SetSize(100, 50)
	mdbutt:SetPos(340, 0)
	mdbutt:SetText(tbl.mdl)
	mdbutt.DoClick = function( )
		Model_List(mdbutt)
	end

	local luatxt = vgui.Create("DTextEntry", addent)
	luatxt:SetSize(490, 100)
	luatxt:SetText(tbl.lua)
	luatxt:SetPos(0, 56)

	local addentity = vgui.Create("DButton", addent)
	addentity:SetText("Remove Entity")
	addentity:SetSize(100, 50)
	addentity:SetPos(490/3 - 50, 180)
	addentity.DoClick = function()
		--[[local model = mdbutt:GetText()
		local vec = Vector(entpos:GetText())
		local ang = Angle(entang:GetText())
		local class = enttrack:GetSelected()
		local lua = luatxt:GetText()

		net.Start("event_ent_add")
			net.WriteString(map)
			net.WriteString(class)
			net.WriteString(model)
			net.WriteVector(vec)
			net.WriteAngle(ang)
			net.WriteString(lua)
		net.SendToServer()]]--


		net.Start("event_ent_remove")
			net.WriteString(map)
			net.WriteString(tbl.ent)
			net.WriteVector(Vector(tbl.x .. " " .. tbl.y .." " .. tbl.z))
		net.SendToServer()
	end


	local addentity = vgui.Create("DButton", addent)
	addentity:SetText("Modify Entity")
	addentity:SetSize(100, 50)
	addentity:SetPos( 2*(490/3) - 50, 180)
	addentity.DoClick = function()
		local model = mdbutt:GetText()
		local vec = Vector(entpos:GetText())
		local ang = Angle(entang:GetText())
		local class = enttrack:GetSelected()
		local lua = luatxt:GetText()

		net.Start("event_ent_update")
			net.WriteString(map)
			net.WriteString(tbl.lua)
			net.WriteVector(Vector(tbl.x .. " " .. tbl.y .." " .. tbl.z))
			net.WriteString(class)
			net.WriteString(model)
			net.WriteVector(vec)
			net.WriteAngle(ang)
			net.WriteString(lua)
		net.SendToServer()
	end
end

if SERVER then
	--util.AddNetworkString("admin_warn")
	util.AddNetworkString("map_list")
	util.AddNetworkString("event_ent_add")
	util.AddNetworkString("event_ent_update")
	util.AddNetworkString("event_ent_remove")

	util.AddNetworkString("GiveEvent_ent")

	util.AddNetworkString("make_event_example")
		util.AddNetworkString("Change_Map")

	util.AddNetworkString("request_map")
	util.AddNetworkString("map_example")

	Map_Perms = {
	["rp_venator_extensive"] = 5,
	["rp_venator_v3"] = 5,

}



	net.Receive("GiveEvent_ent", function(len, ply)
		local map = net.ReadString()
		local name = net.ReadString()

		--if FACTIONS[ply.Char.faction].RankID[ply.Char.rank] < 3 then return end

		if Map_Perms[map] and Map_Perms[map] > FACTIONS[ply.Char.faction].RankID[ply.Char.rank] then return end
		log(adminply, ply:Name() .. " has loaded example **" .. name .. "** with the map **" .. map .. "**", logs["admin"] )

		GiveEventEntityExamoke(name, map)

		Request_Entity(ply, map)
	end)

	net.Receive("make_event_example", function(len, ply)
		local map = net.ReadString()
		local name = net.ReadString()

		--if FACTIONS[ply.Char.faction].RankID[ply.Char.rank] < 3 then return end

		if Map_Perms[map] and Map_Perms[map] > FACTIONS[ply.Char.faction].RankID[ply.Char.rank] then return end
		log(adminply, ply:Name() .. " has made an example **" .. name .. "** on the map **" .. map .. "**", logs["admin"] )

		SetEventEntityExample(name, map)

		Request_Entity(ply, map)
	end)


	function Request_Entity(ply, map)
		local ent = GetEventEntity(map) -- Don't even try its protected from injects
		--PrintTable(ent)
		for index, tbl in pairs(ent) do
			timer.Simple(index/100, function()
				net.Start("request_map")
					if index == 1 then
						net.WriteBool(true)
					else
						net.WriteBool(false)
					end
					net.WriteTable(tbl)
				net.Send(ply)
			end)
		end
		local names = {}
		local exp = GetEventEntityExample(nil, map)
		for index, tbl in pairs(exp) do
			timer.Simple(index/100, function()
				if names[tbl.name] then return end
				names[tbl.name] = true
				net.Start("map_example")
					net.WriteString(tbl.name)
				net.Send(ply)
			end)
		end
	end


	net.Receive("request_map", function(len, ply)
		if !ply.expectingevent then return end
		Request_Entity(ply, net.ReadString())
	end)

	net.Receive("event_ent_remove", function(len, ply)
		if !ply.expectingevent then return end
		local map = net.ReadString()
		local class= net.ReadString()
		local vec = net.ReadVector()
		log(adminply, ply:Name() .. " has removed **" .. class .. "** with the stuff __" .. tostring(vec) .. " __ for the map **" .. map .. "**", logs["admin"] )

		RemoveEventEntities(vec.x,vec.y,vec.z, map, class)
		Request_Entity(ply, map)
	end)


	net.Receive("event_ent_add", function(len, ply)
		if !ply.expectingevent then return end
		local map = net.ReadString()
		local class = net.ReadString()
		local mdl = net.ReadString()
		local vec = net.ReadVector()
		local ang = net.ReadAngle()
		local lua = net.ReadString()

		--if FACTIONS[ply.Char.faction].RankID[ply.Char.rank] < 3 then return end

		if Map_Perms[map] and Map_Perms[map] > FACTIONS[ply.Char.faction].RankID[ply.Char.rank] then return end

		if FACTIONS[ply.Char.faction].RankID[ply.Char.rank] < 4 then
			lua = ""
		end
		log(adminply, ply:Name() .. " has added **" .. class .. "** with the stuff __" .. tostring(vec) .. ", " .. tostring(ang) .. ", " .. mdl .. "__ for the map **" .. map .. "** with the lua code of (" .. lua .. ")"  , logs["admin"] )
		SetEventEntity(vec, ang, class, mdl, map, lua )
		Request_Entity(ply, map)
	end)

	net.Receive("event_ent_update", function(len, ply)
		if !ply.expectingevent then return end
		local map = net.ReadString()
		local oldlua = net.ReadString()
		local oldvec = net.ReadVector()
		local class = net.ReadString()
		local mdl = net.ReadString()
		local vec = net.ReadVector()
		local ang = net.ReadAngle()
		local lua = net.ReadString()

		--if FACTIONS[ply.Char.faction].RankID[ply.Char.rank] < 3 then return end

		if Map_Perms[map] and Map_Perms[map] > FACTIONS[ply.Char.faction].RankID[ply.Char.rank] then return end

		if FACTIONS[ply.Char.faction].RankID[ply.Char.rank] < 4 then
			if oldlua != lua then
				lua = ""
			end
	end
	if lua == "LUA CODE" then
	   lua = ""
	end
		log(adminply, ply:Name() .. " has updated **" .. class .. "** with the stuff __" .. tostring(vec) .. ", " .. tostring(ang) .. ", " .. mdl .. "__ for the map **" .. map .. "** with the lua code of (" .. lua .. ")"  , logs["admin"] )
		UpdateEventEntities(oldvec.x, oldvec.y, oldvec.z, map, class, vec.x, vec.y, vec.z, ang.p,  ang.y, ang.r, mdl, lua )
		Request_Entity(ply, map)
	end)


	net.Receive("Change_Map", function(len , ply)
		if !ply.expectingmap then return end
		local map = net.ReadString()
			game.ConsoleCommand("changelevel " .. map .. "\n")
	end)

else

	concommand.Add("get_event", function()
	-- Check for staff
	local str = file.Read("eventents.txt", "DATA")
	if str then
		local tbl = util.JSONToTable(str)
		if !tbl then
		   chat.AddText({Color(100,100,100),"[Event Ent] ", color_white, " Issue with converting JSON to Table\nData is corrupted"})
		   return
		end
		for index, ent in pairs(tbl) do
			timer.Simple(index/100 , function()
				net.Start("event_ent_add")
					net.WriteString(ent.map)
					net.WriteString(ent.ent)
					net.WriteString(ent.mdl)
					net.WriteVector(ent.pos)
					net.WriteAngle(ent.ang)
					net.WriteString("")
				net.SendToServer()
			end)
		end
	end
end)



	net.Receive("request_map", function()
		if net.ReadBool() then
			MAPENTS = {}
			MAPEXP = {}
		end
		MAPENTS[#MAPENTS + 1] = net.ReadTable()

		timer.Create("timer_rebuild_request_map", 0.3, 1 , function()
				RebuildEvent(ENT_MAP_THINGY)
		end)

	end)
	net.Receive("map_example", function()
		MAPEXP[#MAPEXP + 1] = net.ReadString()
	end)

	net.Receive("map_list", function()
		maplist = net.ReadTable()
	end)

end





local tbl = {}

tbl.name = "Map Change"
tbl.args = false
tbl.panel = false
tbl.cmd = "!mapc"
tbl.svfunction = function(ply)
	ply.expectingmap = true
	net.Start("map_list")
		net.WriteTable(maplist)
	net.Send(ply)
end
tbl.clfunction = function(ply)
	MAPPNL()
end
RegisterRPCommands(tbl)
col = Color(0,0,0)
function MAPPNL()
	partycreatepanel = vgui.Create("DFrame")
	partycreatepanel:SetSize(400,250)
	partycreatepanel:Center()
	partycreatepanel:SetTitle("")
	partycreatepanel:ShowCloseButton(false)
	--partycreatepanel:SetDraggable(false)
	partycreatepanel:MakePopup()
	partycreatepanel.Paint = function(self, w,h)

		surface.SetDrawColor(150,150,150, 200)
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/800,h/800)

		surface.SetDrawColor(255,255,255, 255)
		local b =  w-20
		local c,d = w-20, 50
		surface.DrawTexturedRectUV(10,10,w-20,50,0,0,c/b,d/b)

		draw.SimpleText("Change Map", "ServerFont", w/2, 35,col, 1, 1 )

		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
		surface.DrawOutlinedRect( 10, 10, w - 20, 50 )
	end
	-- net_admin_rank(strip, rank, fac,num, wep1, wep2, wep3)
	local ent = nil
	textentry = vgui.Create("DComboBox", partycreatepanel)
	textentry:SetSize(380,50)
	textentry:SetPos(10, 70)
	textentry:SetValue("Map")
	textentry:SetFont("PlayerFont")
	textentry.OnSelect = function( panel, index, value )
		ent = value
	end
	for index, map in pairs(maplist || {}) do
		textentry:AddChoice(map)
	end


	button = vgui.Create("DButton", partycreatepanel)
	button:SetSize(380,50)
	button:SetPos(10,130)
	button:SetText("")
	button.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Change Map", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button.DoClick = function()
		if !ent then return end
		net.Start("Change_Map")
			net.WriteString(ent)
		net.SendToServer()
		partycreatepanel:Remove()
	end


	local button2 = vgui.Create("DButton", partycreatepanel)
	button2:SetSize(380,50)
	button2:SetPos(10,190)
	button2:SetText("")
	button2.Paint = function(self, w, h)
		if self.Hovered then
			surface.SetDrawColor(200,200,200)
		else
			surface.SetDrawColor(255,255,255)
		end
		surface.SetMaterial(mat )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/380,h/380)
		draw.SimpleText("Back", "PlayerFont", w/2, h/2,col, 1, 1 )
		surface.SetDrawColor(Color(0,0,0,255))
		surface.DrawOutlinedRect( 0, 0, w, h )
	end
	button2.DoClick = function()
		partycreatepanel:Remove()
	end
end
