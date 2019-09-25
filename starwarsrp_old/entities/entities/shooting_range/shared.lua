ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "item"
ENT.Author = "StarLight"

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"Target")
end

hook.Add("ShouldCollide", "shooting_range", function(ent1, ent2)
	if ent1:GetClass() == "shooting_range" then
		if ent2:GetOwner() != ent1:GetTarget() then
			return false
		elseif ent1:GetTarget() != ent2 then
			return false
		else
			return true
		end
	elseif ent2:GetClass() == "shooting_range" then
		if ent1:GetTarget() != ent2:GetOwner() then
			return false
		elseif ent2:GetTarget() != ent1 then
			return false
		else
			return true
		end
	end
end)