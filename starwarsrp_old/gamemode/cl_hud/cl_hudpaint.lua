local hide = {
	CHudHealth = true,
	CHudBattery = true,
	CHudAmmo = true,
}

hook.Add( "HUDShouldDraw", "ogc_HideHUD", function( name )
	if ( hide[ name ] ) then return false end
end )

function GenerateView(Panel)
	 pcall( function()
		local PrevMins, PrevMaxs = Panel.Entity:GetRenderBounds()
		Panel:SetCamPos(PrevMins:Distance(PrevMaxs)*Vector(0.75, 0.75, 0.5))
		Panel:SetLookAt((PrevMaxs + PrevMins)/2)
		end, Panel)
	end

timer.Create( "removeRagdolls", 15, 0, function()
	game.RemoveRagdolls()
	RunConsoleCommand("r_cleardecals")
end )


local randomcolorid = {}
local randomcolortime = {}
local othercol = Color(100,255,0)
function draw.ColorText(str, font, x, y, col, id)
	if !randomcolorid[id] then randomcolorid[id] = 1
	randomcolortime[id] = CurTime() + 1
	end
  	if randomcolorid[id] > #str then randomcolorid[id] = 1 end
  	local i = randomcolorid[id]
  	local strone, strtwo, strthree = string.sub(str, 1, i-1), string.sub(str, i, i), string.sub(str, i+1)
  	-- We now have three different strings which we can now use different functions to draw them. But now is the hard part
  	surface.SetFont(font)
  	draw.SimpleText(strone, font, x, y, col)
  	local wid, hig = surface.GetTextSize(strone)
  	local offest = wid

  	draw.SimpleText(strtwo, font, x + offest, y, othercol)
  	wid, hig = surface.GetTextSize(strtwo)
  	offest = offest + wid
  	draw.SimpleText(strthree, font, x + offest, y, col)
	if (randomcolortime[id] || 0) < CurTime() then
		randomcolorid[id] = randomcolorid[id] + 1
		randomcolortime[id] = CurTime() + 1
	end
end

function GM:HUDPaint()

	--draw.ColorText("Hi There","DermaDefault",  100,20,Color(255,255,255), 1)

	if CharDerma then
		if CharDerma.back then
			char_backtime = CurTime() + 3
		end
	end

	if (char_backtime || 0) > CurTime() then
		surface.SetDrawColor(0,0,0, char_lerp)
		surface.DrawRect(0,0, ScrW(), ScrH())
		char_lerp = math.Clamp(char_lerp + 3,0,255)
		if char_backtime - CurTime() < 2 then
			if LocalPlayer().CharModel then
				LocalPlayer().CharModel:Remove()
				LocalPlayer().CharModel = false
				LocalPlayer().Ship:Remove()
				LocalPlayer().Ship = false
				Char_Net_Loadout(LocalPlayer().tempcharnum)
			end
		else
			char_notgone = true
		end
		return
	end






	PaintHealth()
--	PaintWeapon()


	local evtbl = {}

	for index, ent in pairs(ents.FindByClass("control_point")) do
		evtbl[#evtbl+1] = ent
	end

	for index, ent in pairs(ents.FindByClass("item_crate")) do
		evtbl[#evtbl+1] = ent
	end



	if #evtbl > 0 then
		local size = #evtbl
		local y = ScrH() - 55
		local pos = LocalPlayer():GetPos()
		for index, ent in pairs(evtbl) do
			local x = ScrW()/2 + CenterBar(index,size,70) - 25


				surface.SetDrawColor(150, 150, 150, 150)
				draw.bar(x,y, 0, 360, 25, 5,  -0.5, 360)



				surface.SetDrawColor(255, 255, 255, 255)
				if ent:GetClass() == "control_point" then
				draw.bar(x,y, 0, (ent:GetProgress() / ent:GetMaxProgress()) * 360, 25, 5,  -0.5, 360)
				else
					surface.SetDrawColor(100, 100, 200, 255)
					draw.bar(x,y, 0, 360, 25, 5,  -0.5, 360)
				end
				draw.SimpleText( math.floor(ent:GetPos():Distance(pos)),"DermaDefault" , x, y, color_white, 1 , 1 )
		end
	end
	if LocalPlayer().Char and LocalPlayer().Char.faction == "Staff" then
		local pos = LocalPlayer():GetPos():ToScreen()
		if !pos.visible then
			pos = {x = ScrW() /2, y = ScrH()/2}
		end
		--cam.Start3D()
			for id, ply in pairs( player.GetAll() ) do
				if ply == LocalPlayer() then continue end
				if !ply.Char then continue end
				local fac = FACTIONS[ply.Char.faction]
				surface.SetDrawColor(fac.Color.r, fac.Color.g, fac.Color.b, fac.Color.a)
				local pos2 = ply:GetPos():ToScreen()
				surface.DrawLine( pos2.x, pos2.y, pos.x, pos.y )
				surface.DrawRect(pos2.x-15,pos2.y -15, 30, 30)
				draw.SimpleText(ply:Name(), "PlayerFont", pos2.x, pos2.y+25, fac.Color, 1,1 )
			end
		--cam.End3D()
	end

end


function PaintHealth()
	if !LocalPlayer().Char then return end



		if LocalPlayer().Char.faction == "Staff" then
		local tr = {
			start =		LocalPlayer():EyePos(),
			endpos =LocalPlayer():EyePos() + LocalPlayer():EyeAngles():Forward() * 10000,
		}

		local trace = util.TraceLine( tr )

	local coords = trace.HitPos:ToScreen()
	x, y = coords.x, coords.y

	surface.DrawCircle( x, y, 10, 100, 100, 200)		end

	if CharDerma then
		if LocalPlayer().modelPanel then
			LocalPlayer().modelPanel:Remove()
			LocalPlayer().modelPanel = false
		end
		return
	end

	if !LocalPlayer():Alive() then
		LocalPlayer().broadcastingvoice = false
		if LocalPlayer().modelPanel then
			LocalPlayer().modelPanel:Remove()
			LocalPlayer().modelPanel = false
		end
	return end
	--  Armor / Force
	local left = ScrW() - 210
	local right = ScrW() - 200
	surface.SetDrawColor(75, 75, 255, 255)
	draw.bar(right,ScrH()- 200, 0, 90 - math.Clamp( 90 - (LocalPlayer():Armor() / LocalPlayer().MaxArmor) * 90, 0, 90), 100, 10,  -0.5, 90)

	-- Health
	surface.SetDrawColor(255, 0, 0, 255)
    draw.bar(left,ScrH()- 200, 90, 179 - math.Clamp( 89 - (LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) * 89, 0, 89 ), 100, 10, 90, 180, -1)
	-- Primary Ammo
	surface.SetDrawColor(0, 255, 0, 255)
	local wep = LocalPlayer():GetActiveWeapon()
	if !IsValid(wep) then return end
	draw.bar(left,ScrH()- 210, 180, 270 - ( 90 - (wep:Clip1() / wep:GetMaxClip1()) * 90 ), 100, 10, 180, 271, -1)
	-- Store Ammo
	local ply =LocalPlayer()
	surface.SetDrawColor(255, 150, 0, 255)
	draw.bar(right,ScrH()- 210, 270, 360 - ( 90 -  (math.Clamp( (ply:GetAmmoCount( wep:GetPrimaryAmmoType() ) / wep.Primary.DefaultClip ) * 90, 0, 90) ) ), 100, 10, 270, 361, -1)
	PaintWeaponSelect()
	PaintWeapon()
	PaintCompass()
	PaintDefcon()
	PaintWeaponHud()
end

local number = {}

for x = -360, 360 do
	if x % 45 == 1 then
		number[x] = ""
	end

end

number[0] = "W"
number[360] = "W"
number[180] = "E"
number[270] = "S"
number[90] = "N"
number[-90] = "S"
number[-180] = "E"
number[-270] = "N"
number[-360] = "W"

function PaintCompass()

	local w,h = 360, 50

	offset = ( (LocalPlayer():EyeAngles().y % 360) / 360) * 360
	render.SetScissorRect(ScrW() /2 - w/2 , 20, ScrW() /2 + w/2, 100, true )
	surface.SetDrawColor(200,200,200,255)
	surface.SetMaterial(Material("star/cw/basehexagons.png") )
	surface.DrawTexturedRectUV(ScrW() / 2 - w/2,50,w,40,0,0,w/w,h/w)

	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect( ScrW() / 2 - w/2,50, w,40 )
	surface.SetDrawColor(255,255,255,255)
	for x = -360, 360 do
		local val = x
		if number[val] then
			draw.LinearGradient(ScrW() / 2 - w/2 + offset + x - 20,60,40,20,Color(200, 200,200),Color(255, 255, 255),1,40)
		end
	end
	surface.SetDrawColor(255,255,255,255)
	surface.DrawRect( ScrW() / 2 - 1,50, 2,40 )
	for x = -360, 360 do
		local val = x
		if number[val] then
			draw.SimpleText(number[val], "DermaDefault" , ScrW() / 2 - w/2 + offset + x, 50 + 20, Color(0,0,0), 1, 1)
		end
	end


		surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect( ScrW() / 2 - w/2,50, w,40 )
	render.SetScissorRect( 0, 0, 0, 0, false )
	off = offset - 90
	if off < 0 then off = 360 + off end


	surface.SetDrawColor(200,200,200,255)
	surface.SetMaterial(Material("star/cw/basehexagons.png") )
	surface.DrawTexturedRectUV(ScrW() / 2 - 20,10,40,40,0,0,64/1024,64/1024)


	surface.SetDrawColor(0,0,0,255)
	surface.DrawOutlinedRect( ScrW() / 2 - 20,10, 40,41 )

	draw.SimpleText(math.floor(off), "DermaDefault" , ScrW() / 2, 30, Color(0,0,0), 1, 1)

end


DefconColors = {
	[1] = {255,0,0},
	[2]= {255,100,0},
	[3] = {255,200,0},
	[4] = {0,100,200},
	[5] = {100,255,100},
}


function PaintDefcon()
	surface.SetDrawColor(unpack(DefconColors[defconget()]))
	local size = 50
	local offset = 10
	surface.SetMaterial(Material("star/cw/defcon/".. tostring(defconget()) ..".png") )
	surface.DrawTexturedRect( offset,ScrH() - size - offset, size, size )
end
local cable = Material("cable/cable2")
hook.Add( "PostPlayerDraw", "EntNames", function( ent )
	if ent.hooked then
		local vects = {
			ent.hookedpos,
			LerpVector(0.9, ent:GetPos()+ Vector(0,0,45), ent.hookedpos),
			LerpVector(0.1, ent:GetPos() + Vector(0,0,45), ent.hookedpos),
			ent:GetPos() + Vector(0,0, 45),
		}
		local Curve = BezierCurve_Point_Build(vects,5)
		render.SetMaterial(cable)
		CurveToMesh(Curve,4,8)
	end
	if ent == LocalPlayer() then return end
	if !ent.Char then ent:SetNoDraw(true) return end


	if player.GetCount() > 4 then
		if LocalPlayer():GetEyeTrace().Entity != ent then return end
	end
	local ahAngle = ent:GetAngles()
	local AhEyes = LocalPlayer():EyeAngles()

	ahAngle:RotateAroundAxis(ahAngle:Forward(), 90)
	ahAngle:RotateAroundAxis(ahAngle:Right(), -90)
		if ent:GetPos():Distance(LocalPlayer():GetPos()) > 2048 then return end
	cam.Start3D2D(ent:GetPos()+ent:GetUp() * 80, Angle(0, AhEyes.y-90, 90), 0.175)
		draw.SimpleText(ent:Nick(), "PlayerFont", 0, -50, color, 1)
			h = 10
			local pos2 = 7.5
			surface.SetDrawColor(255, 0, 0, 255)
			draw.bar2(-5,0, 180, 270 - ( 90 -  math.Clamp( (ent:Health() / ent:GetMaxHealth() ) * 90, 0, 90 )), 100, 10, 180, 271, -1)
			surface.SetDrawColor(255, 0, 0, 255)
			draw.bar2(5,0, 270 + ( 90 - (math.Clamp( (ent:Health() / ent:GetMaxHealth() ) * 90, 0, 90) ) ) , 360, 100, 10, 270, 361, -1)

	cam.End3D2D()
end)


function PaintWeaponHud()

    if !weaponhudselected then
        weaponhudselected = {}
        local xx = 20
	    for xxx  = 1, 4 do
	    	local y = CenterBar(xxx-1,3,64)
	    	weaponhudselected[xxx] = vgui.Create("SLHudSelect")
		    weaponhudselected[xxx]:SetSize(52, 52)
		    weaponhudselected[xxx]:SetPos(xx, ScrH()/2 + y)
	    end
    end

	local xx = 20
		for x  = 1, 4 do

			if LocalPlayer().weaponselection and LocalPlayer().weaponselection[x] then
				weaponhudselected[x]:SetModel(wep_key[x], LocalPlayer().weaponselection[x])
			else
				weaponhudselected[x]:SetModel(nil, nil)
			end
		end
		weaponhudselected[4]:SetModel("Fists", "Fists")
end


local pos = {
	["models/weapons/w_DC15S.mdl"] = {0, 40},
	["models/weapons/w_DC15S.mdl"] = {0, 40},
}

function PaintWeaponSelect()
	local modelPanel = LocalPlayer().modelPanel

	if not modelPanel then
		modelPanel = vgui.Create( "DModelPanel" )
		LocalPlayer().modelPanel = modelPanel
	end

	local x,y = ScrW() - 205 - (150 / 2),ScrH()- 205 - (150 / 2)

	modelPanel:SetSize( 150, 150 )
	modelPanel:SetFOV( 100 )
	modelPanel:SetPos( x, y )
	modelPanel:SetModel( LocalPlayer():GetActiveWeapon():GetWorldModel() )
	modelPanel:GetEntity()
	function modelPanel:LayoutEntity(ent)
		ent:SetAngles(Angle(0, (CurTime() *0.5 ) % 360, 0))
		ent:SetModelScale(1.5)
		return
	end
	GenerateView(modelPanel)
	--modelPanel:GetEntity():SetModelScale(1.5)
end

function PaintWeapon()
	local self = LocalPlayer():GetActiveWeapon()
		--if ( self.Weapon:GetNetworkedBool( "Ironsights" ) ) then return end

	local x, y 	local vect,ang = self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand"))


	local tr = {
	start = vect,
	endpos =vect + self.Owner:EyeAngles():Forward() * 10000,
}








--		tr.mask = ( CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE|CONTENTS_AUX )
	local trace = util.TraceLine( tr )

	local coords = trace.HitPos:ToScreen()
	x, y = coords.x, coords.y

	local scale = 10 * (self.Primary.Spread * 2)
	local LastShootTime = self.Weapon:GetNetworkedFloat( "LastShootTime", 0 )
	scale = scale * (2 - math.Clamp( (CurTime() - LastShootTime) * 5, 0.0, 1.0 ))

	--surface.SetDrawColor( 255, 0, 0, 255 )
	local gap = 40 * scale
	local length = (gap + 20) * scale
	--surface.DrawLine( x - length, y, x - gap, y )
	--surface.DrawLine( x + length, y, x + gap, y )
	--surface.DrawLine( x, y - length, x, y - gap )
	--surface.DrawLine( x, y + length, x, y + gap )








		local tr = util.GetPlayerTrace(LocalPlayer())

--		tr.mask = ( CONTENTS_SOLID|CONTENTS_MOVEABLE|CONTENTS_MONSTER|CONTENTS_WINDOW|CONTENTS_DEBRIS|CONTENTS_GRATE|CONTENTS_AUX )
	local trace = util.TraceLine( tr )

	local coords = trace.HitPos:ToScreen()
	x, y = coords.x, coords.y

	surface.DrawCircle( x, y, 10, 100, 100, 200)


end