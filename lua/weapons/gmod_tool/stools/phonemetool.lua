
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
	if PHT.FlexMenu then
		PHT.FlexMenu:SetVisible(true);
		PHT.FlexMenu:SetParent(cpanel);
		cpanel:AddItem(PHT.FlexMenu);
	end
	if PHT.Menu then
		PHT.Menu:SetVisible(true);
		PHT.Menu:SetParent(cpanel);
		cpanel:AddItem(PHT.Menu);
	end
end

local Rectangle = surface.GetTextureID("gui/faceposer_indicator");
function TOOL:DrawHUD()

	local entity = PHT.Data.Entity;
	if not IsValid(entity) then return; end
	
	local eyeattachment = entity:LookupAttachment( "eyes" )
	if eyeattachment == 0 then return; end
	
	local att = entity:GetAttachment(eyeattachment);
	local screenPos = att.Pos:ToScreen();
	if not screenPos.visible then return; end
	
	local playerEyes = LocalPlayer():EyeAngles();
	local side = (att.Pos + playerEyes:Right() * 20):ToScreen();
	local size = math.abs(side.x - screenPos.x);
	
	surface.SetDrawColor(255, 255, 255, 255);
	surface.SetTexture(Rectangle);
	surface.DrawTexturedRect(screenPos.x - size, screenPos.y - size, size * 2, size * 2);

end

end
