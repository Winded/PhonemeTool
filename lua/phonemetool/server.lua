
include("server/data.lua");

AddCSLuaFile("client.lua");
AddCSLuaFile("client/data.lua");
AddCSLuaFile("client/default_presets.lua");
AddCSLuaFile("client/loader.lua");
AddCSLuaFile("client/menu.lua");
AddCSLuaFile("client/derma/flexlist.lua");
AddCSLuaFile("client/derma/phtmenu.lua");

hook.Add("PlayerInitialSpawn", "PHTSetup", function(player)
	PHT.SetupData(player);
end);
