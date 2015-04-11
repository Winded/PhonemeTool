
TOOL.Name = "Phoneme Tool";
TOOL.Category = "Poser";
TOOL.Command = nil;
TOOL.ConfigName = "";

function TOOL:LeftClick(tr)

	if not IsValid(tr.Entity) or tr.Entity:GetClass() ~= "prop_ragdoll" then
		return false;
	end

	if CLIENT then
		return true;
	end

	local player = self:GetOwner();
	player.PHTData.Entity = tr.Entity;
	return true;

end

if CLIENT then
	
language.Add("tool.phonemetool.name", TOOL.Name);
language.Add("tool.phonemetool.desc", "Allows you to facepose ragdolls with preset phonemes and expressions.");
language.Add("tool.phonemetool.0", "Left click a ragdoll to select it, and start faceposing using the context menu.");

function TOOL.BuildCPanel(cpanel)
	if PHT.Menu then
		PHT.Menu:SetParent(cpanel);
		cpanel:AddItem(PHT.Menu);
	end
end

end