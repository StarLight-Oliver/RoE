local loggedon = false
local COMMANDS = {
	["logout"] = function()
		frame:Remove()
		net.Start("ogbuntu_command")
			net.WriteString("logout")
		net.SendToServer()
	end,
	["status"] = function(args)
		richtext:InsertColorChange( 255, 210, 0, 255 )
		richtext:AppendText( args[1] .. " is at 100%\n" )
		richtext:InsertColorChange( 255, 255, 255, 255 )
	end,
}


function OGBuntu()
	local frame = vgui.Create( "DFrame" )
	frame:SetSize( ScrW(), ScrH() )
	frame:Center()
	frame:MakePopup()
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame.Paint = function(self, w,h)
		surface.SetDrawColor(0,0,0)
		surface.DrawRect(0,0,w,h)
		draw.DrawText( ">", "DermaDefault", 20, ScrH() - 90 + 30 )
	end

	-- Rich Text panel
	local richtext = vgui.Create( "RichText", frame )
	richtext:SetSize(ScrW() - 20, ScrH() - 90 - 45)
	richtext:SetPos(20, 45)

	local denied = function()
		richtext:InsertColorChange( 255, 0, 0, 255 )
		richtext:AppendText("Access Denied!\n" )
		richtext:InsertColorChange( 255, 255, 255, 255 )
	end

	richtext:InsertColorChange( 255, 255, 255, 255 )
	richtext:AppendText("Welcome to the Venator Console\n Please login before continuing!\n\n" )
	local TextEntry = vgui.Create( "DTextEntry", frame ) -- create the form as a child of frame
	TextEntry:SetPos( 20, ScrH() - 90 )
	TextEntry.m_bLoseFocusOnClickAway = false
	TextEntry:SetSize( ScrW() - 40, 60 )
	TextEntry:SetText( "" )
	TextEntry.Paint = function(self, w, h)
		draw.DrawText( self:GetText(), "DermaDefault", 20, 30)
	end
	TextEntry:RequestFocus()
	TextEntry.OnEnter = function( self )
			if !IsValid(self) then return end
			self:RequestFocus()
		if !loggedon then
			local val = self:GetValue()
			self:SetText("")
			if val == "login" then
				richtext:AppendText(val .. "\n" )
				loggedon = true
				timer.Simple(0.1, function()
					richtext:InsertColorChange( 0, 255, 0, 255 )
					richtext:AppendText("Access Granted!\nHello, Engineer Jeff!\n" )
					richtext:InsertColorChange( 255, 255, 255, 255 )
				end)
				return
			else
				denied()
				return
			end
			
		end
		local val = self:GetValue()
		richtext:AppendText("1234@ventorms: "..val .. "\n" )
		local tbl = string.Explode(" ", val)
		if OGBUNTU_COMMANDS[tbl[1]] then
			local temp = tbl[1]
			table.remove(tbl, 1)
			OGBUNTU_COMMANDS[temp]["cl"](pnl, tbl)
		end
		self:SetText("") 
		
	end 
end