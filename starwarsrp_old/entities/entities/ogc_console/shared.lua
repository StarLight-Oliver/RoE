ENT.Type 		= "anim"
ENT.PrintName	= "Console"
ENT.Author		= "StarLight"
ENT.Contact		= ""
ENT.Category = "OGC CW"
ENT.Spawnable			= true
ENT.AdminSpawnable		= true

function ENT:Think()
	/*if not self.BuildingSound then
		self.BuildingSound = CreateSound( self.Entity, "ambient/levels/citadel/citadel_hub_ambience1.mp3" )
		self.BuildingSound:Play()
	end*/
end

function ENT:OnRemove()
	--self.BuildingSound:Stop()
end

OGBUNTU_COMMANDS = {
	["logout"] = { 
		["cl"] = function(pnl, args)
			pnl:Remove()
			net.Start("ogbuntu_command")
				net.WriteString("logout")
			net.SendToServer()
		end,
		["sv"] = function(args)
		
		end,
	},
	["status"] ={ 
		["cl"] = function(pnl, args)
			richtext:InsertColorChange( 255, 210, 0, 255 )
			richtext:AppendText( args[1] .. " is at 100%\n" )
			richtext:InsertColorChange( 255, 255, 255, 255 )
		end,
	},
}