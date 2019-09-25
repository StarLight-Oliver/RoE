local matc = {}
local iconum = 1
local iconmax = 5
local alpha = 255
for x = 1, 5 do
    matc[x] = Material("cw/wallpaper/" .. x .. ".jpg" )
end


local mat = Material("cw/obut.png")
local mmat = Material("cw/mbut.png")
local back = Material("cw/box.png")

local butpaint = function(self , w,h)
	surface.SetMaterial(mat)
	if self.Hovered then
		if !self.oldhover then
			surface.PlaySound("wos/swbf2/ui_menumove.wav")
		end
		local col = 150 + 100*math.abs(math.sin(CurTime() * 5))
		surface.SetDrawColor(col, col, col)
	else
		surface.SetDrawColor(255,255,255)
	end
	surface.DrawTexturedRect(0,0, w, h)
	if self.Hovered then
		draw.SimpleText(self.text, "PlayerFont", w/2, h/2, Color(255,255,0), 1, 1)
	else
		draw.SimpleText(self.text, "PlayerFont", w/2, h/2, color_white, 1, 1)
	end
	self.oldhover = self.Hovered
end

buts = {
	[1] = {
		text = "Character Menu",
		paint = butpaint,
		click = function()
			LandingPage:Remove()
			CharacterMenu()
		end,
	},
	[2] = {
		text = "Steam Group",
		paint = butpaint,
		click = function()
			gui.OpenURL("http://steamcommunity.com/groups/osirisgamingcommunity")
		end,
	},
	[3] = {
		text = "Website",
		paint = butpaint,
		click = function()
			gui.OpenURL("https://www.osirisgaming.co.uk/")
		end,
	},
	[4] = {
		text = "Information Panel",
		paint = butpaint,
		click = function()
			InfoPanel()
		end,
	},
	[5] = {
		text = "Close Menu",
		paint = butpaint,
		click = function()
			LandingPage:Remove()
		end,
	},

}


local size_w, size_h = 350, 40

function landing_page()
	if IsValid(LandingPage) then return end
	local w = ScrW()
	local h = ScrH()
    LandingPage = vgui.Create("DFrame")
	LandingPage:SetSize( w, h)
	LandingPage:SetPos( (ScrW()/2) - (w/2), (ScrH()/2) - (h/2) - (h/4) )
	LandingPage:SetTitle("")
	LandingPage:SetDraggable(false)
	--LandingPage:ShowCloseButton(false)
	LandingPage:MakePopup()
	LandingPage.Paint = function(self, c,b)
		surface.SetDrawColor(Color(255,255,255,255))
        surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(matc[iconum])
		surface.DrawTexturedRect(0,0, w, w*548/974)
		if (iconchange || 0) < CurTime() then
		    surface.SetDrawColor(255,255,255, 255 - (alpha))
		     local temp = iconum + 1
		        if temp > iconmax then
		           temp = 1
		        end
		        surface.SetMaterial(matc[temp])
		        surface.DrawTexturedRect(0,0, w, w*548/974)
		        alpha = math.Clamp(alpha - (255 * FrameTime()), 0, 255)
		        if alpha <= 0 then
		            iconchange = CurTime() + 4
		            alpha = 255
		            iconum = iconum + 1
		            if iconum > iconmax then
		                iconum = 1
		            end
		        end
		end

		surface.SetMaterial(Material("sponsors/eh.png", "smooth"))

		surface.SetDrawColor(Color(255,255,255,255))
		surface.DrawTexturedRect( 0, 10, 284/2, 55/2 )

		surface.SetMaterial(Material("cw/logo.png", "smooth"))

		local xx = w/2
		local yy = 125
		surface.SetDrawColor(200,200,200)

		surface.DrawTexturedRectRotated(xx, yy, 200,  200, (CurTime() * 10) % 360)
		surface.SetDrawColor(255,255,255,255)

		surface.SetMaterial(back)
		surface.DrawTexturedRect(w/2 - 341.5, h/2 -  192 + 2, 683, 384)

		surface.SetMaterial(mmat)
		surface.DrawTexturedRect(ScrW()/2 - size_w/2, ScrH()/2 + CenterBar(0,5, 40) - size_h/2,  size_w, size_h)
        draw.SimpleText("Osiris Clone Wars", "PlayerFont",ScrW()/2, ScrH()/2 + CenterBar(0,5, 40), Color(255,255,0), 1, 1)
    end

	local count = 3
	local max = 5
	if LocalPlayer().Char then count = 5 end

	for x = 1, count do
		local butt = vgui.Create("DButton", LandingPage)
		butt:SetPos((w/2) - size_w/2, (h/ 2) + CenterBar(x, max, 40) )
		butt:SetSize(size_w, size_h)
		butt:SetFont("PlayerFont")
		butt:SetText("")
		butt.text = buts[x].text
		butt.Paint =  butpaint
		butt.DoClick =  function()
            surface.PlaySound("wos/swbf2/ui_planetzoom.wav")
            buts[x].click()
        end
	end
end
