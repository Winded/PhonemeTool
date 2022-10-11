
include("client/data.lua");
include("client/default_presets.lua");
include("client/loader.lua");
include("client/menu.lua");

hook.Add("InitPostEntity", "PHTSetup", function()
	PHT.LoadPresets();
	PHT.SetupData();
	PHT.SetupMenu();
end);
