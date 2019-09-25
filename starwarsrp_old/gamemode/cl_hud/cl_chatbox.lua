


function CleanUp(txt)
	txt = string.Replace( txt, ";", "/59" )
		print(txt)
	return txt
end
local MESSAGES = {
	[1] = "Press F1 for party menu!",
	[2] = "Join our Discord! \nLink: https://discord.gg/ptHEHgG",
	[3] = "Content pack: https://steamcommunity.com/sharedfiles/filedetails/?id=1576500635",
}
local count = 1
timer.Create("Chat_Advert", 300, 0, function()
	chat.AddText(Color(0,100,200), MESSAGES[count])
	count = count + 1
	if count > #MESSAGES then
		count = 1
	end
end)

if OGCChat then return end

history = 0
HISTORY = {}
OGCChat = {}

OGCChat.config = {
	timeStamps = false,
	position = 1,	
	fadeTime = 24,
}

local types = {
	{ 
		Name = "",
		ChatFunction = function(text)
			LocalPlayer():ConCommand("say \"" .. text .. "\"")
		end,
		ChatTag = "Say: ",
	},
	{
		Name = "Comms",
		ChatFunction = function(text)
			LocalPlayer():ConCommand('comms "' .. text .. '"')
		end,
		ChatTag = "Comms: ",
	},
	{
		Name = "OOC",
		ChatFunction = function(text)
			LocalPlayer():ConCommand('ooc "' .. text .. '"')
		end,
		ChatTag = "OOC: ",
	},
	{
		Name = "LOOC",
		ChatFunction = function(text)
			LocalPlayer():ConCommand('looc "' .. text .. '"')
		end,
		ChatTag = "LOOC: ",
	},
	{
		Name = "Faction",
		ChatFunction = function(text)
			LocalPlayer():ConCommand('faction "' .. text .. '"')
		end,
		ChatTag = "Faction: ",
	},
}



local gray = Color( 10, 10, 10, 150 )

--// Prevents errors if the script runs too early, which it will
hook.Add("Initialize", "OGCChat_init", function()
	OGCChat.buildBox()
end)

--// Builds the chatbox but doesn't display it
function OGCChat.buildBox()
	OGCChat.frame = vgui.Create("DFrame")
	OGCChat.frame:SetSize( ScrW()*0.375, ScrH()*0.4 )
	OGCChat.frame:SetTitle("")
	OGCChat.frame:ShowCloseButton( false )
	OGCChat.frame:SetDraggable( true )
	OGCChat.frame:SetSizable( true )
	OGCChat.frame:SetPos( 10, 10)
	OGCChat.frame:SetMinWidth( 300 )
	OGCChat.frame:SetMinHeight( 100 )
	OGCChat.frame.Paint = function( self, w, h )
		local b = ScrH()*0.4
		if ScrH()*0.4 <ScrW()*0.375 then b = ScrW()*0.375 end
		--OGCChat.blur( self, 10, 20, 255 )
		--draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 255, 255, 200 ) )
		surface.SetDrawColor(255,255,255,255)
		surface.SetMaterial(Material("star/cw/basehexagons.png") )
		surface.DrawTexturedRectUV(0,0,w,h,0,0,w/b,h/b)
		draw.RoundedBox( 0, 0, 0, w, 25, gray )
	end
	OGCChat.oldPaint = OGCChat.frame.Paint
	OGCChat.frame.Think = function()
		if input.IsKeyDown( KEY_ESCAPE ) then
			OGCChat.hideBox()
		end
	end
	
	local serverName = vgui.Create("DLabel", OGCChat.frame)
	serverName:SetText( GetHostName() )
	serverName:SetFont( "OGCChat_18")
	serverName:SizeToContents()
	serverName:SetTextColor(Color(255,255,255))
	serverName:SetPos( 5, 4 )

	OGCChat.entry = vgui.Create("DTextEntry", OGCChat.frame) 
	OGCChat.entry:SetSize( OGCChat.frame:GetWide() - 50, 20 )
	OGCChat.entry:SetTextColor( color_white )
	OGCChat.entry:SetFont("OGCChat_18")
	OGCChat.entry:SetDrawBorder( false )
	OGCChat.entry:SetDrawBackground( false )
	OGCChat.entry:SetCursorColor( color_white )
	OGCChat.entry:SetHighlightColor( Color(52, 152, 219) )
	OGCChat.entry:SetPos( 45, OGCChat.frame:GetTall() - OGCChat.entry:GetTall() - 5 )
	OGCChat.entry.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, gray)
		derma.SkinHook( "Paint", "TextEntry", self, w, h )
	end

	OGCChat.entry.OnTextChanged = function( self )
		if self and self.GetText then 
			gamemode.Call( "ChatTextChanged", self:GetText() or "" )
		end
	end

	OGCChat.entry.OnKeyCodeTyped = function( self, code )

		if code == KEY_ESCAPE then

			OGCChat.hideBox()
			gui.HideGameUI()

		elseif code == KEY_TAB then
			
			OGCChat.TypeSelector = (OGCChat.TypeSelector and OGCChat.TypeSelector + 1) or 1
			
			if OGCChat.TypeSelector > #types then OGCChat.TypeSelector = 1 end
			if OGCChat.TypeSelector < 1 then OGCChat.TypeSelector = #types end
			
			OGCChat.ChatType = types[OGCChat.TypeSelector].Name

			timer.Simple(0.001, function() OGCChat.entry:RequestFocus() end)

		elseif code == KEY_ENTER then
			-- Replicate the client pressing enter
			
			if string.Trim( self:GetText() ) != "" then
				for x,y in pairs(types) do
					if types[x].Name == OGCChat.ChatType then

						txt = self:GetText() or ""
						txt = CleanUp(txt)
						table.insert(HISTORY, 1, txt)

						types[x].ChatFunction( txt)
					end
				end
			end

			OGCChat.TypeSelector = 1
			OGCChat.hideBox()
		elseif code == KEY_UP then
			history = history + 1
			if history > #HISTORY then return end
			self:SetText(HISTORY[history])
		end
	end

	OGCChat.chatLog = vgui.Create("RichText", OGCChat.frame) 
	OGCChat.chatLog:SetSize( OGCChat.frame:GetWide() - 10, OGCChat.frame:GetTall() - 60 )
	OGCChat.chatLog:SetPos( 5, 30 )
	OGCChat.chatLog.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, gray )
	end
	OGCChat.chatLog.Think = function( self )
		if OGCChat.lastMessage then
			if CurTime() - OGCChat.lastMessage > OGCChat.config.fadeTime then
				self:SetVisible( false )
			else
				self:SetVisible( true )
			end
		end
		self:SetSize( OGCChat.frame:GetWide() - 10, OGCChat.frame:GetTall() - OGCChat.entry:GetTall() - serverName:GetTall() - 20 )
	end
	OGCChat.chatLog.PerformLayout = function( self )
		self:SetFontInternal("OGCChat_18")
		self:SetFGColor( color_white )
	end
	OGCChat.oldPaint2 = OGCChat.chatLog.Paint
	
	local text = "Say :"

	local say = vgui.Create("DLabel", OGCChat.frame)
	say:SetText("")
	surface.SetFont( "OGCChat_18")
	local w, h = surface.GetTextSize( text )
	say:SetSize( w + 5, 20 )
	say:SetPos( 5, OGCChat.frame:GetTall() - OGCChat.entry:GetTall() - 5 )
	
	say.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, gray )
		draw.DrawText( text, "OGCChat_18", 2, 1, color_white )
	end

	say.Think = function( self )
		
		local s = {}
		
		for x,y in pairs(types) do
			if y.Name == OGCChat.ChatType then
				text = y.ChatTag
			end
		end
		

		if s then
			if not s.pw then s.pw = self:GetWide() + 10 end
			if not s.sw then s.sw = OGCChat.frame:GetWide() - self:GetWide() - 15 end
		end

		local w, h = surface.GetTextSize( text )
		self:SetSize( w + 5, 20 )
		self:SetPos( 5, OGCChat.frame:GetTall() - OGCChat.entry:GetTall() - 5 )

		OGCChat.entry:SetSize( s.sw, 20 )
		OGCChat.entry:SetPos( s.pw, OGCChat.frame:GetTall() - OGCChat.entry:GetTall() - 5 )
	end	
	
	OGCChat.hideBox()
end

--// Hides the chat box but not the messages
function OGCChat.hideBox()
	OGCChat.frame.Paint = function() end
	OGCChat.chatLog.Paint = function() end
	history = 0
	OGCChat.chatLog:SetVerticalScrollbarEnabled( false )
	OGCChat.chatLog:GotoTextEnd()
	
	OGCChat.lastMessage = OGCChat.lastMessage or CurTime() - OGCChat.config.fadeTime
	
	-- Hide the chatbox except the log
	local children = OGCChat.frame:GetChildren()
	for _, pnl in pairs( children ) do
		if pnl == OGCChat.frame.btnMaxim or pnl == OGCChat.frame.btnClose or pnl == OGCChat.frame.btnMinim then continue end
		
		if pnl != OGCChat.chatLog then
			pnl:SetVisible( false )
		end
	end
	
	-- Give the player control again
	OGCChat.frame:SetMouseInputEnabled( false )
	OGCChat.frame:SetKeyboardInputEnabled( false )
	gui.EnableScreenClicker( false )
	
	-- We are done chatting
	gamemode.Call("FinishChat")
	
	-- Clear the text entry
	OGCChat.entry:SetText( "" )
	gamemode.Call( "ChatTextChanged", "" )
end

--// Shows the chat box
function OGCChat.showBox()
	-- Draw the chat box again
	OGCChat.frame.Paint = OGCChat.oldPaint
	OGCChat.chatLog.Paint = OGCChat.oldPaint2
	
	OGCChat.chatLog:SetVerticalScrollbarEnabled( true )
	OGCChat.lastMessage = nil
	
	-- Show any hidden children
	local children = OGCChat.frame:GetChildren()
	for _, pnl in pairs( children ) do
		if pnl == OGCChat.frame.btnMaxim or pnl == OGCChat.frame.btnClose or pnl == OGCChat.frame.btnMinim then continue end
		
		pnl:SetVisible( true )
	end
	
	-- MakePopup calls the input functions so we don't need to call those
	OGCChat.frame:MakePopup()
	OGCChat.entry:RequestFocus()
	
	-- Make sure other addons know we are chatting
	gamemode.Call("StartChat")
end

--// Opens the settings panel
function OGCChat.openSettings()
	
end

--// Panel based blur function by Chessnut from NutScript
local blur = Material( "pp/blurscreen" )
function OGCChat.blur( panel, layers, density, alpha )
	-- Its a scientifically proven fact that blur improves a script
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

local oldAddText = chat.AddText

--// Overwrite chat.AddText to detour it into my chatbox
function chat.AddText(...)
	
	if not OGCChat.chatLog then
		OGCChat.buildBox()
	end
	
	local msg = {}
	
	-- Iterate through the strings and colors
	for _, obj in pairs( {...} ) do
		if type(obj) == "table" then
			OGCChat.chatLog:InsertColorChange( obj.r, obj.g, obj.b, obj.a )
			table.insert( msg, Color(obj.r, obj.g, obj.b) )
		elseif type(obj) == "string"  then
			OGCChat.chatLog:AppendText( obj ) 
			table.insert( msg, obj )
		elseif obj:IsPlayer() then
			local ply = obj
			
			if OGCChat.config.timeStamps then
				OGCChat.chatLog:InsertColorChange( 130, 130, 130, 255 )
				OGCChat.chatLog:AppendText( "["..os.date("%X").."] ")
			end
			/*
			if OGCChat.config.seOGCChatTags and ply:GetNWBool("OGCChat_tagEnabled", false) then
				local col = ply:GetNWString("OGCChat_tagCol", "255 255 255")
				local tbl = string.Explode(" ", col )
				OGCChat.chatLog:InsertColorChange( tbl[1], tbl[2], tbl[3], 255 )
				OGCChat.chatLog:AppendText( "["..ply:GetNWString("OGCChat_tag", "N/A").."] ")
			end
			*/
			local col = Color(255,255,255)
			if ply.Char.faction then
				col = FACTIONS[ply.Char.faction].Color
				table.insert(msg, Color(col.r, col.g, col.b, 255))
			end
			OGCChat.chatLog:InsertColorChange( col.r, col.g, col.b, 255 )
			OGCChat.chatLog:AppendText( ply:Nick() )
			table.insert( msg, ply:Nick() )
		end
	end
	OGCChat.chatLog:AppendText("\n")
	
	OGCChat.chatLog:SetVisible( true )
	OGCChat.lastMessage = CurTime()
	OGCChat.chatLog:InsertColorChange( 255, 255, 255, 255 )
	--surface.PlaySound(Sound("text.mp3"))
	chat.PlaySound()
	MsgC("[LOG] ")
	MsgC(unpack(msg))
	MsgC("\n")
end

--// Write any server notifications
hook.Remove( "ChatText", "OGCChat_joinleave")

ChatTags = {
	["none"] = "[Dev Print] ",
	["joinleave"] = "[Leave] ",
	["servermsg"] = "[CVAR]",
}

ChatTagsCol = {
	["none"] = { 255, 105, 180, 255},
	["joinleave"] = { 0, 128, 255, 255},
	["servermsg"] = {0,0,0,0},
}
hook.Add( "ChatText", "OGCChat_joinleave", function( index, name, text, type )
	if not OGCChat.chatLog then
		OGCChat.buildBox()
	end
	if type != "chat" then
	    if type == none and !OGCCW.dev then return end
		local text = ChatTags[type] .. player:DisplayName(text)
		OGCChat.chatLog:InsertColorChange( unpack(ChatTagsCol[type]) )
		OGCChat.chatLog:AppendText( text.."\n" )
		OGCChat.chatLog:SetVisible( true )
		OGCChat.lastMessage = CurTime()
		return true
	end
end)

--// Stops the default chat box from being opened
hook.Remove("PlayerBindPress", "OGCChat_hijackbind")
hook.Add("PlayerBindPress", "OGCChat_hijackbind", function(ply, bind, pressed)
	if string.sub( bind, 1, 11 ) == "messagemode" then
		if bind == "messagemode2" then 
			return true
		else
			if !OGCChat.ChatType then
				OGCChat.ChatType = ""
			end
		end
		
		if IsValid( OGCChat.frame ) then
			OGCChat.showBox()
		else
			OGCChat.buildBox()
			OGCChat.showBox()
		end
		return true
	end
end)

--// Hide the default chat too in case that pops up
hook.Remove("HUDShouldDraw", "OGCChat_hidedefault")
hook.Add("HUDShouldDraw", "OGCChat_hidedefault", function( name )
	if name == "CHudChat" then
		return false
	end
end)

 --// Modify the Chatbox for align.
local oldGetChatBoxPos = chat.GetChatBoxPos
function chat.GetChatBoxPos()
	return OGCChat.frame:GetPos()
end

function chat.GetChatBoxSize()
	return OGCChat.frame:GetSize()
end

chat.Open = OGCChat.showBox
function chat.Close(...) 
	if IsValid( OGCChat.frame ) then 
		OGCChat.hideBox(...)
	else
		OGCChat.buildBox()
		OGCChat.showBox()
	end
end