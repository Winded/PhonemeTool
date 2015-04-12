
local function EntityChanged(container, key, value)

	if not IsValid(value) then
		container.PresetGroups = {};
		container.Manipulating = false;
		return;
	end
	local entity = value;

	container.Manipulating = false;

	PHT.CurrentPresetGroups = PHT.GetPresetGroups(entity);
	container.HasPresetGroups = container.PresetGroups ~= nil;

end

function PHT.SetupData()

	local defaults = table.Copy(PHT.DefaultValues);

	local data = PHT.BiValues.New("PHTData", {IsPrivate = true, UseSync = true, AutoApply = true, SyncIgnore = {"PresetGroups"}}, defaults);

	data:_Listen("Entity", EntityChanged);

	PHT.Data = data;

end