
local EntityPresets = {};

function PHT.HasPresetGroups(modelOrEntity)
	return PHT.GetPresetGroups(modelOrEntity) ~= nil;
end

function PHT.GetPresetGroups(modelOrEntity)

	local model = modelOrEntity;
	if type(modelOrEntity) == "Entity" and IsValid(modelOrEntity) then
		model = modelOrEntity:GetModel();
	end

	for _, ePresets in pairs(EntityPresets) do
		if ePresets.Model == model then
			return ePresets;
		end
	end

	return nil;

end

function PHT.AddPresetGroups(data)

	if PHT.HasPresetGroups(data.Model) then
		return;
	end
	
	-- Convert values to numbers
	for _, pg in pairs(data.PresetGroups) do
		for _, preset in pairs(pg.Presets) do
			for _, cv in pairs(preset.ControlValues) do
				cv.Value = tonumber(cv.Value);
				cv.LeftValue = tonumber(cv.LeftValue);
				cv.RightValue = tonumber(cv.RightValue);
			end
		end
	end

	table.insert(EntityPresets, data);

end

function PHT.LoadPresets()

	-- Load defaults first
	for key, jdata in pairs(PHT.DefaultPresets) do
		local data = util.JSONToTable(jdata);
		if data then
			PHT.AddPresetGroups(data);
		end
	end

	-- Load all files in data/phonemetool
	local files = file.Find("phonemetool/*.txt", "DATA");
	for _, file in pairs(files) do
		local jdata = file.Read(file, "DATA");
		local data = util.JSONToTable(jdata);
		if data then
			PHT.AddPresetGroups(data);
		end
	end

end