
local function EntityChanged(container, key, value)

	if not IsValid(value) then
		container.PresetGroups = {};
		container.Manipulating = false;
		return;
	end
	local entity = value;

	local flexes = {};
	for i = 0, entity:GetFlexNum() - 1 do
		local name = entity:GetFlexName(i);
		table.insert(flexes, name);
	end
	container.FlexList = flexes;

	container.Manipulating = false;

	container.PresetGroups = PHT.GetPresetGroups(entity);
	container.HasPresetGroups = container.PresetGroups ~= nil;

end

function PHT.SetupData()

	local defaults = table.Copy(PHT.DefaultValues);

	defaults.IgnoreAll = function(container, key)
		container.IgnoredFlexes = table.Copy(container.FlexList);
	end
	defaults.IgnoreNone = function(container, key)
		container.IgnoredFlexes = {};
	end

	local data = PHT.BiValues.New("PHTData", {IsPrivate = true, UseSync = true, AutoApply = true, SyncIgnore = {"PresetGroups"}}, defaults);

	data:_Listen("Entity", EntityChanged);

	PHT.Data = data;

end