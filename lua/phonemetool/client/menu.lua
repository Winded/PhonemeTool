
include("derma/flexlist.lua");
include("derma/phtmenu.lua");

function PHT.SetupMenu()
	PHT.Menu = vgui.Create("PHTMenu");
	PHT.Menu:Bind(PHT.Data, "PresetGroups", "PHTMenu");
	PHT.Menu:SetVisible(false);
	PHT.FlexMenu = vgui.Create("PHTFlexMenu");
	PHT.FlexMenu:Bind(PHT.Data, "FlexList", "PHTFlexMenu");
	PHT.FlexMenu:SetVisible(false);
end
