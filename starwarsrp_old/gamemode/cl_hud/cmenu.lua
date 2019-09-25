local w,h = 500, 600

rpcommandpanel = {}
mat = Material("star/cw/player.png")
function GM:OnContextMenuOpen()
	CommandDerma = vgui.Create("DFrame")
	CommandDerma:SetPos(ScrW() / 2 - w/2, ScrH() - 10)
	CommandDerma:SetSize(w,h)
	CommandDerma:MakePopup()
	CommandDerma:SetDraggable(false)
	CommandDerma:SetTitle("")
	CommandDerma:ShowCloseButton(false)
	CommandDerma.lerp = 0
	CommandDerma.Paint = function(self, w,h)
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/headerv2.png"))
		surface.DrawTexturedRect(0,0,w,60)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawOutlinedRect( 0, 0, w, 60)
		draw.SimpleText( "List of RP Commands", "ServerFont", w/2, 30 , Color( 0, 0, 0, 255 ), 1, 1 )
		
		local c, b = self:GetPos()
		if !self.back then
			self:SetPos(c, Lerp(self.lerp, b, (ScrH() /2) - (h/2 )))
			self.lerp = math.Clamp(self.lerp + 0.01, 0, 1)
		else
			self:SetPos(c, Lerp(self.lerp,(ScrH() /2) - (h/2 ), ScrH() + 10))
			self.lerp = math.Clamp(self.lerp +0.05 , 0, 1)
			if self.lerp == 1 then
				gui.EnableScreenClicker(false)
				for x = 1, #rpcommandpanel do
					if rpcommandpanel and IsValid(rpcommandpanel) then
						rpcommandpanel[x]:Remove()
						rpcommandpanel[x] = nil
					end
				end
				self:Remove()
			end
		end
		
	end
	
	
	local basey = 65
	timer.Simple(0.1, function()
		rpcommandlist = vgui.Create("DScrollPanel", CommandDerma )
		rpcommandlist:SetPos( 0, 65 )
		rpcommandlist:SetSize( w + 30, h-60 )
		rpcommandlist.Paint = function( self, w, h )
			--surface.SetDrawColor(255,5,255,255)
			--surface.DrawRect(0,0,w,h)
		end
		rpcommandlist.VBar.Paint = function() end
		rpcommandlist.VBar.btnUp.Paint = function() end
		rpcommandlist.VBar.btnDown.Paint = function() end
		rpcommandlist.VBar.btnGrip.Paint = function() end
	end)
	local xx = 1
	for _,tbl in pairs(LocalPlayer():GetCommands()) do
		local x = xx
		xx = xx + 1
		timer.Simple( 0.5 + ( x / 50), function()
		rpcommandpanel[x] = rpcommandlist:Add("DButton")
		rpcommandpanel[x]:SetPos(0, 45 * (x-1))
		rpcommandpanel[x]:SetSize(w + 30, 40)
		rpcommandpanel[x]:SetText("")
		rpcommandpanel[x].Paint = function(self,c,h)
			surface.SetDrawColor( 255,255,255,255)
			surface.SetMaterial(mat)
			surface.DrawTexturedRect(0,0,w,h)
			surface.SetDrawColor(0,0,0,255)
			surface.DrawOutlinedRect( 0, 0, w, h)
			draw.SimpleText( tbl.name .. " (" .. tbl.cmd ..")", "PlayerFont", w/2, h/2 , Color( 0, 0, 0, 255 ), 1, 1 )
		end
		rpcommandpanel[x].DoClick = function()
			if cooldown || 0 < CurTime() then
				tbl.clfunction(LocalPlayer())
				RunConsoleCommand("say", tbl.cmd)
				cooldown = CurTime() + 0.5
			end
		end
		end)
	end
end

function GM:OnContextMenuClose()
	CommandDerma.back = true
	CommandDerma.lerp = 0
end


net.Receive("Country", function(len,pl)
end)



print("CommandDermaLoaded!")