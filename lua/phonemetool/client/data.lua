
local function EntityChanged(container, key, value)

	if not IsValid(value) then
		print("Shit");
		container.PresetGroups = {};
		container.Manipulating = false;
		return;
	end
	local entity = value;

	container.Manipulating = false;

	container.PresetGroups = PHT.GetPresetGroups(entity);
	container.HasPresetGroups = container.PresetGroups ~= nil;

end

function PHT.SetupData()

	local defaults = table.Copy(PHT.DefaultValues);

	local data = BiValuesV021.New("PHTData", {IsPrivate = true, UseSync = true, AutoApply = true}, defaults);

	data:_Listen("Entity", EntityChanged);

	PHT.Data = data;

end