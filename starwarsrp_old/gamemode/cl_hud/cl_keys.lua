--

local slotsbind = {
	["slot1"] = true,
	["slot2"] = true,
	["slot3"] = true,
	["slot4"] = true,
}
SLOT = 4
hook.Add( "PlayerBindPress", "ogc_bind_press", function( ply, bind, pressed )
	if !ply:Alive() or  ply != LocalPlayer() then return end
	if pressed then
	if bind == "gm_showteam" then
		f2Menu()
	elseif bind == "gm_showhelp" then
		PartyMenu()
	elseif bind == "gm_showspare2"then
		landing_page()
	elseif bind == "gm_showspare1" then
		f3Menu()
	elseif bind == "+menu"then
		InventoryMenu()
	elseif bind == "impulse 201" then
		if !IsValid(Base) then
			InviteDerma()
		end
		return true
	elseif bind == "undo" or bind == "gmod_undo" then
		local tbl = GetGrenades()
		local tb = {}
		for index, val in pairs(tbl) do
			tb[#tb+1] = val
		end
		local self = ply:GetActiveWeapon()
		if IsValid(self) then
			if WEAPONS[self:GetMainType()][self:GetSubType()].SpawnAbles then
				table.Add(tb, WEAPONS[self:GetMainType()][self:GetSubType()].SpawnAbles)
			end
			ZMenu(tb)
		end
		return true
	elseif slotsbind[bind] then
		huddietime = CurTime() + 4
		local num = string.sub(bind, #bind)
		SLOT = tonumber(num)
		net.Start("weapon_select")
			net.WriteDouble(tonumber(num))
		net.SendToServer()
		return true
	end
	if bind == "invprev" then
	    SLOT = SLOT + 1
	    if SLOT > 4 then
	      SLOT = 1
	   end
	   net.Start("weapon_select")
			net.WriteDouble(SLOT)
		net.SendToServer()

	   return true
	elseif bind == "invnext" then
	    SLOT = SLOT - 1
	    if SLOT < 1 then
	      SLOT = 4
	   end
	   net.Start("weapon_select")
			net.WriteDouble(SLOT)
		net.SendToServer()
	   return true
	end


    end


end)



function ZMenu(tbl)
	gui.EnableScreenClicker(true)
	local pnl = vgui.Create("DButton")

	pnl:SetText("")
	pnl:SetSize(512, 512)
	pnl:Center()
	pnl.size = 0
	pnl.Paint = function(self, w, h)
		if !input.IsKeyDown(input.GetKeyCode(input.LookupBinding( "undo" ) || "") || "" ) and !input.IsKeyDown(input.GetKeyCode(input.LookupBinding( "gmod_undo" ) || "") || "" ) then
			self:Remove()
			gui.EnableScreenClicker(false)
		end
		surface.SetDrawColor(200,200,200, 200)
		draw.bar2(w/2,h/2, -100, 200, self.size, 10,  0, 360)
		draw.bar2(w/2,h/2, -3, 360, self.size, 10,  0, 360)

		local ang = 0
		local x,y = gui.MousePos()

		x,y = x - (ScrW()/2),  y - (ScrH()/2)
		local ang = 90-math.deg(math.atan2(x,y))
		self.hover = math.floor(math.Remap(ang, -90, 360-90, 1, #tbl + 1 || 1))

		-- Thats the end of some maths shit, was actually quite fun to do
		-- Remap is basically a ratio function

		surface.SetDrawColor(255,5,255)
		draw.bar2(w/2,h/2, -90, ang, self.size/2, 10,  0, 360)

		local ang = -90
		angg = 360 / #tbl
		for index, info in pairs(tbl) do
			surface.SetDrawColor((index/#tbl) *255,(index/#tbl) *255,(index/#tbl) *255)
			if self.hover == index then
				draw.bar2(w/2,h/2, ang, ang + angg, self.size/1.25, 10,  0, 360)
				draw.SimpleText(info.Name, "Trebuchet24", w/2,  h/2, Color(255,255,255), 1 , 1)
			end
			draw.bar2(w/2,h/2, ang, ang + angg, self.size/2, 10,  0, 360)
			ang = ang + angg
		end
	end
	pnl.DoClick = function()
		local val = pnl.hover || 1
		net.Start("z_place")
			net.WriteDouble(val)
		net.SendToServer()

	end

	for x = 1, 50 do
		timer.Simple(x/200, function()
			if IsValid(pnl) then
				pnl.size = math.Clamp(pnl.size + 12.1904762, 0, 512/2.1)
			end
		end)
	end


end
