
include("bivalues/bivalues.lua");

include("phonemetool/shared.lua");

if SERVER then
	include("phonemetool/server.lua");
	AddCSLuaFile();
else
	include("phonemetool/client.lua");
end