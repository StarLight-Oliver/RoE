ENT.Base = "base_ai"
ENT.Type = "ai"
ENT.AutomaticFrameAdvance = true
ENT.Spawnable 			  = true
ENT.AdminSpawnable        = true
ENT.PrintName             = "Store NPC"
ENT.Category 			  = "OGC"
 
function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end