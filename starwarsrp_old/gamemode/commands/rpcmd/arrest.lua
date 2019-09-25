local jail = {
    [1] = {
        top = Vector( "539 -2388 -2356" ),
        bottom = Vector( "727 -2033 -2465" ),
        pos1 = Vector( "573 -2325 -2450" ),
        ang1 = Angle( "15 -3 0" ),
        pos2 = Vector( "568 -2205 -2462" ),
        ang2 = Angle( "1 -0 0" ),
        pos3 = Vector( "562 -2081 -2461" ),
        ang3 = Angle( "2 -0 0" ),
    },
    [2] = {
        top = Vector( "527 -2003 -2356" ),
        bottom = Vector( "717 -1925 -2474" ),
        pos = Vector( "562 -1953 -2463" ),
        ang = Angle( "0 -0 0" ),
    },
    [3] = {
        top = Vector( "544 -1861 -2356" ),
        bottom = Vector( "689 -1801 -2443" ),
        pos = Vector( "560 -1826 -2461" ),
        ang = Angle( "2 1 0" ),
    },
    [4] = {
        top = Vector( "534 -1746 -2356" ),
        bottom = Vector( "700 -1666 -2473" ),
        pos = Vector( "568 -1697 -2461" ),
        ang = Angle( "3 0 0" ),
    },
    [5] = {
        top = Vector( "529 -1618 -2356" ),
        bottom = Vector( "712 -1536 -2462" ),
        pos = Vector( "565 -1563 -2461" ),
        ang = Angle( "565 -1563 -2461" ),
    },
    [6] = {
        top = Vector( "524 -1487 -2356" ),
        bottom = Vector( "697 -1416 -2484" ),
        pos = Vector( "567 -1443 -2461" ),
        ang = Angle( "2 0 0" ),
    },
}

local tbl = {}

tbl.name = "Arrest"
tbl.args = false
tbl.panel = false
tbl.cmd = "!arrest"
tbl.svfunction = function(ply)
    local ent = ply:GetEyeTrace().Entity
    if IsValid(ent) and ent:IsPlayer() and ent:GetActiveWeapon():GetStripped() and !ent.arrested then

       /* local jailindex = math.random( 1, 6 )

        if jailindex == 1 then
            local index1 = tostring(math.random( 1, 3 ))
            ent:SetPos( jail[1]["pos" .. index1] )
            ent:SetEyeAngles( jail[1]["ang" .. index1] )
        else
            ent:SetPos( jail[jailindex].pos )
            ent:SetEyeAngles( jail[jailindex].ang )
        end
		ent.arrested = true*/

       ent.arrested = ply
	elseif ent.arrested then
        ent.arrested = false
    end
end
tbl.clfunction = function(ply)

end
RegisterRPCommands(tbl)
