
local function EntityChanged(container, key, value)

	if not IsValid(value) then
		container.PresetGroups = {};
		container.Manipulating = false;
		return;
	end
	local entity = value;

	container.Manipulating = false;

	container.PresetGroups = PHT.GetPresetGroups(entity);

end

function PHT.SetupData()

	local defaults = table.Copy(PHT.DefaultValues);

	local data = BiValues021.New("PHTData", defaults, {IsPrivate = true, UseSync = true, AutoApply = true});

	data:_Listen("Entity", EntityChanged);

	PTH.Data = data;

end