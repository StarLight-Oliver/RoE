if CLIENT then
surface.CreateFont( "PressPad_Font_1", {
	font = "Arial",
	extended = false,
	size = 55,
	weight = 1000,
} )


surface.CreateFont( "PressPad_Font_2", {
	font = "Arial",
	extended = false,
	size = 45,
	weight = 1000,
} )

net.Receive("entityupdate", function()
	local ent = net.ReadEntity()
	local tbl = net.ReadTable()
	tbl.ent = ent
end)
entstable = {}
   
   local counttable = {
   	["*134"] = {
		color = Color(0,0,0),
		name = "Clone Troopers",
	},
	["*141"] = {
		color = Color(1,84,33),
		name = "41st Elite Corps",
	},
	["*142"] = {
		color = Color(255,200,10),
		name = "327th Star Corps",
	},
	["*169"] = {
		color = Color(0,0,0),
		name = "Armoury",
	},
	["*155"] = {
		color = Color(0,0,128),
		name = "Republic Navy",
	},
	["*154"] = {
		color = Color(102,102,120),
		name = "Advanced Recon Force",
	},
	["*231"] = {
		color = Color(0,211,211),
		name = "Jedi",
	},
	["*152"] = {
		color = Color(255,100,0),
		name = "212th Attack Battalion",
	},
	["*153"] = {
		color = Color(0,80,255),
		name = "501st Legion",
	},
	["*150"] = {
		color = Color(200,50,238),
		name = "21st Nova Corps",
	},
	["*151"] = {
		color = Color(0,0,0),
		name = "Shadow Company",
	},
	["*228"] = {
		color = Color(255,69,0),
		name = "Delta Squad",
	},
	["*225"] = {
		color = Color(0,0,0),
		name = "A.R.C.",
	},
	["*135"] = {
		color = Color(255,0,0),
		name = "Shock",
	},
	["*157"] = {
		color = Color(255,255,20),
		name = "Engineering Corps",
	},
	["*156"] = {
		color = Color(0,0,255),
		name = "5th Fleet Security",
	},
	["*221"] = {
		color = Color(0,255,0),
		name = "Medical Brigade",
	},
	["*251"] = {
		color = Color(0,0,0),
		name = "Forbidden",
	},
	["*171"] = {
		color = Color(0,255,0),
		name = "Medbay",
	},
	["*94"] = {
		color = Color(0,0,0),
		name = "Activity Room",
	},
	["*90"] = {
		color = Color(0,0,0),
		name = "Activity Room",
	},
	["*234"] = {
		color = Color(0,0,0),
		name = "404",
	},
	["*286"] = {
		color = Color(0,0,0),
		name = "Breifing",
	},
	["*270"] = {
		color = Color(0,0,0),
		name = "Brig",
	},
	["*76"] = {
		color = Color(0,0,0),
		name = "Hangar 2",
	},
	["*161"] = {
		color = Color(0,0,0),
		name = "Hangar 1",
	},
	["*165"] = {
		color = Color(255,255,20),
		name = "Pilots",
	},
	/* rp_venator_extended
	["*161"] = {
		color = Color(0,0,0),
		name = "Clone Troopers",
	},
	["*8"] = {
		color = Color(0,0,0),
		name = "41st Elite Corps",
	},
	["*1"] = {
		color = Color(0,0,0),
		name = "327th Star Corps",
	},
	["*232"] = {
		color = Color(0,0,0),
		name = "Armoury",
	},
	["*31"] = {
		color = Color(0,0,0),
		name = "Imperial Fleet",
	},
	["*29"] = {
		color = Color(0,0,0),
		name = "Imperial High Command",
	},
	["*28"] = {
		color = Color(255,0,0),
		name = "Sith",
	},
	["*9"] = {
		color = Color(0,0,0),
		name = "212th Attack Battalion",
	},
	["*2"] = {
		color = Color(0,0,0),
		name = "501st Legion",
	},
	["*10"] = {
		color = Color(0,0,0),
		name = "21st Nova Corps",
	},
	["*3"] = {
		color = Color(0,0,0),
		name = "Shadow Company",
	},
	["*11"] = {
		color = Color(0,0,0),
		name = "Imperial Commandos",
	},
	["*4"] = {
		color = Color(0,0,0),
		name = "Rancor",
	},
	["*5"] = {
		color = Color(0,0,0),
		name = "Coruscant Guard",
	},
	["*15"] = {
		color = Color(0,0,0),
		name = "Engineering Corps",
	},
	["*14"] = {
		color = Color(0,0,0),
		name = "5th Fleet Security",
	},
	["*6"] = {
		color = Color(0,0,0, 50),
		name = "Internal Security Bureau",
	},
	["*247"] = {
		color = Color(0,0,0),
		name = "Forbidden",
	},
	["*183"] = {
		color = Color(0,255,0),
		name = "Medbay",
	},
	["*22"] = {
		color = Color(0,0,0),
		name = "Activity Room",
	},*/
}

   
 local angtbl  = { -- left
	["*232"] = true,
	["*31"] = true,
	["*29"] = true,
	["*28"] = true,
	["*247"] = true,
 }
 
 local strpos = { -- notsure anymore
	["*28"] = true,
	["*29"] = true,
	["*251"] = true,

 }
 
 local postbl = { -- left big
	["*232"] = true,
	["*247"] = true,
	
 }
 local postb = { -- forward big
	["*183"] = true,
 }

 local postbv = { -- left
	["*231"] = true,
	["*234"] = true,
	["*228"] = true,
	["*225"] = true,
	["*221"] = true,

 }

local semitbl = { -- left rotation
	["*286"] = true,
	["*165"] = true,
}

local semitb = { -- forward
	["*22"] = true,

}
   

local mat = Material("star/cw/headerv2.png")

local dif = math.AngleDifference
hook.Add("PostDrawTranslucentRenderables", "presspad", function()
	

	if game.GetMap() != OGCCW.Config.Map then return end
	local ply = LocalPlayer()
    if entstable == {} then return end
	for index, self in pairs(ents.FindInSphere(LocalPlayer():GetPos(), 1200)) do
		if counttable[self:GetModel()] then
			
          local tbl = counttable[self:GetModel()]
          local ang = self:GetAngles()
		  local scale = 5
		  local pos = self:GetPos() - ( self:GetUp() * 1.7 )	
			if angtbl[self:GetModel()] then
				ang = ang + Angle(0,90,0)
			end
			
			if semitb[self:GetModel()] then
				scale = 6.5
			end
			
			if semitbl[self:GetModel()] then
				scale = 6.5
				ang = ang + Angle(0,90,0)
			end
			
			if postbl[self:GetModel()] then
				scale = 30
				pos = pos + self:GetAngles():Right() * 20
			end
			if postb[self:GetModel()] then
				scale = 30
				pos = pos - self:GetAngles():Forward() * 20
			end
			if postbv[self:GetModel()] then
				scale = 30
				pos = pos - self:GetAngles():Right() * -10
			end
			
			if strpos[self:GetModel()] then
				pos = pos + self:GetAngles():Right() * 15
			end
			
		  cam.Start3D2D(pos +(ang):Right() * scale, ang + Angle(0,0,90), 0.1)
		  	surface.SetDrawColor(255,255,255,255)
              surface.SetMaterial(mat)
			 -- surface.DrawTexturedRect(-125/4 *10,-7.5/2*10, 125/2*10,15/2*10)
			draw.SimpleText( tbl.name, "TextScreens", -1, -1, MixColor(tbl.color, color_white, 0.5),1, 1)
			draw.SimpleText( tbl.name, "TextScreens", 1, 1, MixColor(tbl.color, color_black, 0.9),1, 1)
			--draw.SimpleText( tbl.name, "TextScreens", 0, 0, tbl.color,1, 1)
          cam.End3D2D()
		  
		  cam.Start3D2D(pos -(ang):Right() * scale, ang + Angle(0,180,90), 0.1)
		  surface.SetDrawColor(255,255,255,255)
                surface.SetMaterial(mat)
			--  surface.DrawTexturedRect(-125/4 *10,-7.5/2*10, 125/2*10,15/2*10)
			draw.SimpleText( tbl.name, "TextScreens", -1,-1, MixColor(tbl.color, color_white, 0.5),1, 1)
			draw.SimpleText( tbl.name, "TextScreens", 1, 1, MixColor(tbl.color, color_black, 0.9),1, 1)
			--draw.SimpleText( tbl.name, "TextScreens", 0, 0, tbl.color,1, 1)
          cam.End3D2D()
		 
      end
    end
end)

    
else
--[[
    SV
]]--
util.AddNetworkString("entityupdate")
entswithtbl = {

}

local counttable = {
}
HitFuncs = {
	["func_button"] = true,
	["func_button"]           = true,
	["func_door"]             = true, --Draws Hand over Doors
	["func_door_rotating"]    = true, --Draws Hand over Doors
	["prop_door_rotating"]    = true, --Draws Hand over Doors
	["button_keypad"]     = true,  --Draws Hand over Doors
	["Buttons"]     = true,
	["class C_BaseEntity"]     = true,
	["Pods"] = true,
	["prop_vehicle_prisoner_pod"] = true,
}



local DoorIDs = {
	[49] = {
		ID = 3,
	},
	[39] = {
		ID = 3,
	},
	[22] = {
		ID = 2,
	},
	[115] = {
		ID = 2,
	},
	[23] = {
		ID = 2,
	},
	[114] = {
		ID = 2,
	},
	[209] = {
		ID = 3,
	},
	[208] = {
		ID = 3,
	},
	[15] = {
		ID = 3,
	},
	[266] = {
		ID = 5,
	},
	[109] = {
		ID = 3,
	},
	[227] = {
		ID = 4,
	},
	[118] = {
		ID = 4,
	},
	[137] = {
		ID = 4,
	},
	[152] = {
		ID = 6,
	},
	[153] = {
		ID = 6,
	},
	[150] = {
		ID = 6,
	},
	/*rp_venator_extensive
	[56] = {
		ID = 5,
	},
	[20] = {
		ID = 5,
	},
	[19] = {
		ID = 5,
	},
	[77] = {
		ID = 5,
	},
	[18] = {
		ID = 5,
	},
	[17] = {
		ID = 5,
	},
	[149] = {
		ID = 5,
	},
	[159] = {
		ID = 5,
	},
	[136] = {
		ID = 5,
	},
	[135] = {
		ID = 5,
	},
	[162] = {
		ID = 5,
	},
	[150] = {
		ID = 5,
	},
	[151] = {
		ID = 5,
	},
	[126] = {
		ID = 5,
	},
	
	[300] = {
		ID = 4,
	},
	[299] = {
		ID = 4,
	},
	[169] = {
		ID = 4,
	},
	[163] = {
		ID = 4,
	},
	[162] = {
		ID = 4,
	},
	[164] = {
		ID = 4,
	},
	[168] = {
		ID = 4,
	},
	[337] = {
		ID = 4,
	},
	[328] = {
		ID = 4,
	},
	[339] = {
		ID = 4,
	},
	[338] = {
		ID = 4,
	},
	[167] = {
		ID = 4,
	},
	
	[134] = {
		ID = 3,
	},
	[148] = {
		ID = 3,
	},
	[322] = {
		ID = 3,
	},
	[125] = {
		ID = 3,
	},
	[146] = {
		ID = 2,
	},
	[132] = {
		ID = 2,
	},
	[130] = {
		ID = 2,
	},
	[144] = {
		ID = 2,
	},
	[145] = {
		ID = 2,
	},
	[131] = {
		ID = 2,
	},
	[155] = {
		ID = 2,
	},
	[153] = {
		ID = 2,
	},
	[154] = {
		ID = 2,
	},
	[152] = {
		ID = 2,
	},
	[133] = {
		ID = 2,
	},
	[147] = {
		ID = 2,
	},
	[127] = {
		ID = 2,
	},
	[128] = {
		ID = 2,
	},
	[129] = {
		ID = 2,
	},*/
}



function GiveButtonIDs()
  local count = 1

  if game.GetMap() == OGCCW.Config.Map then 
      print("Loading ids")
  	for k, v in pairs(ents.GetAll()) do
  		if v:GetClass() == "trigger_physics_trap" then
				v:Remove()
			end
  	  	if HitFuncs[v:GetClass()] then
  	 		v.ID = count
			if DoorIDs[count] then
				v.Perm = DoorIDs[count].ID
				if DoorIDs[count].CustomFunction then
					v.CustomFunction = DoorIDs[count].CustomFunction
				end
			else
				v.Perm = 1
			end
			v.Healt = 100
			v.Engineering = true
			function v:OnRepair(dmg)
				v.Healt = math.Clamp(v.Healt + dmg, 0, 100)
			end

			if count == 210 then
				v:Fire("Lock")
			end
			
  	  		print("Found a entity and gave it ID: "..count)
  	      	count = count +1
    	end
	end
end


	local map = game.GetMap()

    local ent = GetEventEntity(map)
    for index, tbl in pairs(ent) do
    	local en = ents.Create(tbl.ent)
    	en:SetModel(tbl.mdl)
    	en:SetPos(Vector(tbl.x .. " " .. tbl.y .. " " .. tbl.z))
    	en:SetAngles(Angle(tbl.ax .. " " .. tbl.ay .. " " .. tbl.az))
    	en:Spawn()
    	en:Activate()
    	en:SetModel(tbl.mdl)
    	if event_ents[tbl.ent].SpawnFunction then
    		event_ents[tbl.ent].SpawnFunction(en)
    	end
    	local temp = OGC
    	OGC = en
    	RunString(tbl.lua)
    	OGC = temp
    end
    SPAWNPOINTS[map] = {}
    for index, ent in pairs(ents.FindByClass("spawn_point")) do
    	local fac = ent.Faction || "base"
    	if !SPAWNPOINTS[map][fac] then
    		SPAWNPOINTS[map][fac] = {}
    	end
    	SPAWNPOINTS[map][fac][#SPAWNPOINTS[map][fac] + 1] = ent:GetPos()
    end


end
hook.Add( "InitPostEntity", "this give button IDs", GiveButtonIDs )


function GiveButtonstables()
	for index, ent in pairs(ents.GetAll()) do
		if ent.ID then
			if counttable[ent.ID] then
				entswithtbl[ent] = counttable[ent.ID]
			end
		end
	end
end

hook.Add("PlayerSpawn", "ahh", function(ply)
	timer.Simple(0.8, function()
		GiveButtonstables()
		local count = 0
		
		for x = 1, 5 do	
			timer.Simple(x * 2, function()
				for ent, tbl in pairs(entswithtbl) do
					count = count + 1
					timer.Simple(count/10, function()
						net.Start("entityupdate")
							net.WriteEntity(ent)
							net.WriteTable(tbl)
						net.Send(ply)
					end)
				end
			end)
		end
	end)
end)
-- Things you want to be called by this


hook.Add("PlayerUse", "entusetable", function(ply, ent)
if ply.OutofRP then return false end
    if ent:GetClass() == "env_headcrabcanister" then
        if !ent.count then
            ent.count = 10
        end
        if (ply.Cooldowncrab || 0 ) < CurTime() then
           ent.count = ent.count - 1
           ply:GiveItem("Scrap Metal")
           ply.Cooldowncrab = CurTime() + 5
           if ent.count <= 0 then
                ent:Remove()
            end
        end
    end

    if ent.ID then
       -- ply:ChatPrint(ent.ID .. "    " .. ent:GetModel())
		local fac = FACTIONS[ply.Char.faction]
		if ent.Perm >  fac.Ranks[fac.RankID[ply.Char.rank]].Permission then
			if (ply.doorcool || 0 ) < CurTime() then
				ply:SLChatMessage({Color(0,200,255), "[Perm] ", color_white, "You have permission rank " ..fac.Ranks[fac.RankID[ply.Char.rank]].Permission ..  " but this needs a permission rank of " .. ent.Perm })
				ply.doorcool = CurTime() + 2
			end
			return false
		else
			if ent.Healt == 0 then
				if (ply.doorcool || 0 ) < CurTime() then
					ply:SLChatMessage({Color(200,100,100), "[System] ", color_white, "This device has taken too much damage, call an engineer out to id " .. ent.ID })
					ply.doorcool = CurTime() + 2
				end
				return false
			end
			if (ply.doorcool || 0 ) < CurTime() then
				ent.Healt = math.Clamp(ent.Healt - 1, 0, 100)
				ply.doorcool = CurTime() + 2
			end
		end
	end
end)
  
	function updateusetable(ent)
		net.Start("entityupdate")
			net.WriteEntity(ent)
			net.WriteTable(entswithtbl[ent])
		net.Broadcast()
	end
	  
end