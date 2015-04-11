
include("client/data.lua");

hook.Add("InitPostEntity", "PHTSetup", function()
	PHT.SetupData();
	PHT.SetupMenu();
end);