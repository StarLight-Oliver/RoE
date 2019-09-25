local consolemdl = {
	["models/kingpommes/venator/bridge_console1.mdl"] = true,
	["models/kingpommes/venator/bridge_console2.mdl"] = true,
	["models/kingpommes/venator/bridge_console3.mdl"] = true,
	["models/kingpommes/venator/bridge_console_wall_2.mdl"] = true,
	["models/kingpommes/venator/bridge_console_wall_4.mdl"] = true,
	["models/kingpommes/venator/bridge_consoled.mdl"] = true,
	["models/kingpommes/venator/corner_console.mdl"] = true,
}


local consolemdl = {
	["models/kingpommes/venator/bridge_console1.mdl"] = true,
	["models/kingpommes/venator/bridge_console2.mdl"] = true,
	["models/kingpommes/venator/bridge_console3.mdl"] = true,
	["models/kingpommes/venator/bridge_console_wall_2.mdl"] = true,
	["models/kingpommes/venator/bridge_console_wall_4.mdl"] = true,
	["models/kingpommes/venator/bridge_consoled.mdl"] = true,
	["models/kingpommes/venator/corner_console.mdl"] = true,
}


function ReplaceConsoles()
	print("replacing consolestw")
	timer.Simple(4, function()
		print(#ents.GetAll())
		for index, ent in pairs(ents.GetAll()) do
		
			if ent:GetClass() == "trigger_physics_trap" then
				ent:Remove()
			end
		
			if !IsValid(ent) then continue end
			local mdl = ent:GetModel()
			if consolemdl[mdl] then
				local pos, ang, skin = ent:GetPos(), ent:GetAngles(), ent:GetSkin()
				print("consolemade")
				local en = ents.Create("ogc_console")
				en:SetPos(pos)
				en:SetAngles(ang)
				en:SetModel(mdl) 
				en:Spawn()
				en:Activate()
				
				ent:Remove()
			elseif ent:GetClass() == "env_laser" then
				print("wiping the damage from the laser")
				ent:Remove()
			end
		end
	end)
end
model_list = model_list || {}

if CLIENT then
	net.Receive("model_list", function()
		model_list[net.ReadDouble()] = net.ReadString()
	end)

end

if CLIENT then return end
util.AddNetworkString("model_list")

if #model_list > 0 then return end

local function AddRecursive( pnl, folder, path, wildcard )

	local files, folders = file.Find( folder .. "*", path )
	if ( !files ) then MsgN( "Warning! Not opening '" .. folder .. "' because we cannot search in it!"  ) return end

	for k, v in pairs( files ) do

		if ( !string.EndsWith( v, ".mdl" ) ) then continue end

		model_list[#model_list + 1] = folder .. v

	end

	for k, v in pairs( folders ) do

		AddRecursive( pnl, folder .. v .. "/", path, wildcard )

	end

end


for _, addon in SortedPairsByMemberValue( engine.GetAddons(), "title" ) do

	if ( !addon.downloaded || !addon.mounted ) then continue end
	if ( addon.models <= 0 ) then continue end

		AddRecursive( ViewPanel, "models/", addon.title, "*.mdl" )

end


--[[
	for k, v in pairs( model_list ) do

		-- Don't search in the models/ bit of every model, because every model has this bit
		local modelpath = v
		if ( modelpath:StartWith( "models/" ) ) then modelpath = modelpath:sub( 8 ) end

		if ( modelpath:find( str ) ) then

			if ( IsUselessModel( v ) ) then continue end

			local entry = {
				text = v:GetFileFromFilename(),
				func = function() RunConsoleCommand( "gm_spawn", v ) end,
				icon = spawnmenu.CreateContentIcon( "model", g_SpawnMenu.SearchPropPanel, { model = v } ),
				words = { v }
			}

			table.insert( models, entry )

		end

		if ( #models >= 512 ) then break end

	end

	return models
end
]]--












