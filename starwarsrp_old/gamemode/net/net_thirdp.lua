


if SERVER then
	util.AddNetworkString("ogc_ptog")
	util.AddNetworkString("gravity_fuck")
	function net_SendPToggle(ply)
		net.Start("ogc_ptog")
		net.Send(ply)
	end
else

	pos = {x = 0, y = 0},
	net.Receive("ogc_ptog", function(len, pl)

			local pnl = vgui.Create("DFrame")
			pnl:SetSize(400, 256)
			pnl:Center()
			pnl:SetTitle("")
			pnl:MakePopup()


			but = vgui.Create("DButton", pnl)
			but:SetSize(256, 256)
			but.Paint = function(self, w, h)
				surface.SetDrawColor(255,255,255)
				surface.DrawOutlinedRect( 0, 0, w, h )
				surface.DrawRect(128 + pos.x-5, 128+ pos.y-5, 10, 10)
			end
			but.DoClick = function()
				local x = gui.MouseX()
				local y = gui.MouseY()
				xx, yy = pnl:GetPos()
				xx = xx + 128
				yy = yy + 128
				local z = 0
				print(x,y, xx, yy)
				pos.x = x - xx
				pos.y = y - yy

				FORWARD = pos.y
				RIGHT = pos.x
			end
			butt = vgui.Create("DButton", pnl)
			butt:SetSize(400-256, 128)
			butt:SetPos(256, 128)
			butt:SetText("Toggle View Mode")
			butt.DoClick = function( ... )
				LocalPlayer().FirstPerson = !LocalPlayer().FirstPerson
			end

		--LocalPlayer().FirstPerson = !LocalPlayer().FirstPerson
	end)
	net.Receive("gravity_fuck", function()
		local ent = net.ReadEntity()
		local num = net.ReadDouble()
		ent:SetGravity(num)
	end)
end
