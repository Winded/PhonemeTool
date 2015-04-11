
local function ManipulatingToggled(container, key, value)

	local entity = container.Entity;
	if not value or not IsValid(entity) then
		return;
	end

	local startState = {};
	for i = 0, entity:GetFlexNum() - 1 do
		startState[i] = entity:GetFlexWeight(i);
	end
	container.StartState = startState;

end

local function TweenValueChanged(container, key, value)

	local entity = container.Entity;
	local tween = value;
	local start = container.StartState;
	local target = container.TargetPreset;
	if not container.Manipulating or not IsValid(entity) or not start or not target then
		return;
	end

	for i = 0, entity:GetFlexNum() - 1 do
		
		local name = entity:GetFlexName(i);
		local targetValue = start[i];

		for _, flexPreset in pairs(target.ControlValues) do
			if name == flexPreset.Name and flexPreset.Value ~= nil then
				targetValue = flexPreset.Value;
				break;
			elseif flexPreset.LeftValue ~= nil and name == "left_" .. flexPreset.Name then
				targetValue = flexPreset.LeftValue;
				break;
			elseif flexPreset.RightValue ~= nil and name == "right_" .. flexPreset.Name then
				targetValue = flexPreset.RightValue;
				break;
			end
		end

		local value = start[i] + (targetValue - start[i]) * tween;
		entity:SetFlexWeight(i, value);

	end

end

function PHT.SetupData(player)

	local defaults = table.Copy(PHT.DefaultValues);

	local data = BiValuesV021.New(player, "PHTData", {IsPrivate = true, UseSync = true, AutoApply = true}, defaults);

	data:_Listen("Manipulating", ManipulatingToggled);
	data:_Listen("TweenValue", TweenValueChanged);

	player.PHTData = data;

end