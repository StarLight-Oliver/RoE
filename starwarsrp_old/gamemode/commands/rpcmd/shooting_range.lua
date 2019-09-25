local tbl = {}
tbl.name = "Start Shooting Range"
tbl.args = false
tbl.panel = false
tbl.cmd = "!range"
tbl.svfunction = function(ply)
	if defconget() != 5 then return end
	if ply.ShootingRange then return end
    if ply.WaitingShootingRange then return end
    ply.WaitingShootingRange = true
   ply:SLChatMessage(


        {Color(100,210, 141),
         "[Shooting-System] ", 
         color_white, 
        "You have 10 seconds to choose a gun. Once the ten seconds are up you will have to shoot as many of the targets as you can! The aim is to get the highest score in 1 minute"
        })


    timer.Simple(7, function()
        ply:SLChatMessage(
        {Color(100,210, 141),
         "[Shooting-System] ", 
         color_white, 
        "Three"
        })
        timer.Simple(1, function()
             ply:SLChatMessage(
                {Color(100,210, 141),
                 "[Shooting-System] ", 
                 color_white, 
                "Two"
                 })
             timer.Simple(1, function()
                  ply:SLChatMessage(
                    {Color(100,210, 141),
                     "[Shooting-System] ", 
                     color_white, 
                    "One"
                    })
             end)
        end)
    end)

    timer.Simple(10, function() 
        -- body -7857.368164 -11219.872070 -15799.968750

        local pos2 = ply:GetPos()
        local move = ply:GetMoveType()
        ply:SetMoveType(MOVETYPE_NONE)
        ply:SetPos(Vector(math.Rand(-7857.368164, 5913.692871 ), math.Rand( -11219.872070, 10976.165039),-15799.968750 ))
        local pos = ply:GetPos()
        ply.ShootingRange = true
        ply.WaitingShootingRange = nil
        local ent = "shooting_range"  
    
        ply.score = 0
        local ent_tbl = {}
        for x = 1 , math.random(10, 30) do
            local en = ents.Create(ent)
            en:SetPos(pos + Vector(math.Rand(-1,1), math.Rand(-1,1), math.Rand(0, 0.5)) * 1024 )
            en:SetAngles(AngleRand())
            en:Spawn()
            en:SetTarget(ply)
            en:Activate()
            ent_tbl[x] = en
        end
    
        timer.Simple(60, function()
            local wepaci = ply:GetActiveWeapon()
            local wep = WEAPONS[wepaci:GetMainType()][wepaci:GetSubType()].name
            ply.ShootingRange = false
            local score = ply.score
            for index, en in pairs(ent_tbl) do
                en:Remove()
            end
             ply:SLChatMessage(


        {Color(100,210, 141),
         "[Shooting-System] ", 
         color_white, 
        "You got a score of " .. math.floor(score)
        })
            if score > ply:GetShootingScores(SQLStr(wep) ) then
                ply:SetShootingScore(score, wep)
            end

 
            timer.Simple(5, function()
                ply:SetMoveType(move)
                ply:SetPos(pos2)
            end)
        end)
    end)
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)