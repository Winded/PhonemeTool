
include("derma/phtmenu.lua");

function PHT.SetupMenu()
	PHT.Menu = vgui.Create("PHTMenu");
	PHT.Menu:Bind(PHT.Data, "PresetGroups", "PHTMenu");
end