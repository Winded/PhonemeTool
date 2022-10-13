
local PANEL = {};

function PANEL:Init()
	self.Categories = {};
	self.Presets = {};
	self:EnableHorizontal(false);
	self:SetAutoSize(true);
	self:SetSpacing(3);
end

function PANEL:HasCategory(name)
	return self:GetCategory(name) ~= nil;
end

function PANEL:GetCategory(name)
	for _, c in pairs(self.Categories) do
		if c.Name == name then
			return c;
		end
	end
	return nil;
end

function PANEL:AddCategory(name)

	local item = vgui.Create("DCollapsibleCategory", self);
	item.Name = name;
	item:SetLabel(name);
	item:SetExpanded(0);
	local plist = vgui.Create("DPanelList");
	plist:EnableHorizontal(false);
	plist:SetAutoSize(true);
	plist:SetSpacing(5);
	item.List = plist;

	item:SetContents(plist);
	self:AddItem(item);
	table.insert(self.Categories, item);

	return item;

end

function PANEL:AddPreset(name, category)

	local c = self:GetCategory(category);
	if not c then
		c = self:AddCategory(category);
	end

	local itemLabel = vgui.Create("DLabel", c.List);
	itemLabel:SetText(name);
	itemLabel:SetColor(Color( 20, 20, 20, 255 ))
	itemLabel:SizeToContents();
	local item = vgui.Create("Slider", c.List);
	item:SetMinMax(-1, 1);
	item:SetDecimals(2);
	item:SetDark(true);
	item.DLabel = itemLabel;
	item.Category = c;

	c.List:AddItem(itemLabel);
	c.List:AddItem(item);
	table.insert(self.Presets, item);

	return item;

end

function PANEL:Clear()
	for _, item in pairs(self.Presets) do
		item.Category.List:RemoveItem(item.DLabel);
		item.DLabel:Remove();
		item.Category.List:RemoveItem(item);
		item:Remove();
	end
	table.Empty(self.Presets);
	for _, item in pairs(self.Categories) do
		self:RemoveItem(item);
		item:Remove();
	end
	table.Empty(self.Categories);
end

vgui.Register("PHTMenu", PANEL, "DPanelList");

local MENUBIND = {};
function MENUBIND:Init()
end
function MENUBIND:Remove()
end
function MENUBIND:SetValue(value)
	local menu = self.Entity;
	for _, item in pairs(menu.Presets) do
		item:UnBind(self.Container, "TweenValue");
	end
	menu:Clear();
	if not value or not value.PresetGroups then
		return;
	end
	for _, pg in pairs(value.PresetGroups) do
		menu:AddCategory(pg.Name);
		for _, preset in pairs(pg.Presets) do
			local p = menu:AddPreset(preset.Name, pg.Name);
			p:Bind(self.Container, "TweenValue", "PHTPreset", {Preset = preset});
		end
	end
end
PHT.BiValues.RegisterBindType("PHTMenu", MENUBIND);

local PRESETBIND = {};
function PRESETBIND:Init()

	local container = self.Container;
	local slider = self.Entity;
	local manipulateKey = self.Settings.ManipulateKey or "Manipulating";
	local targetPresetKey = self.Settings.TargetPresetKey or "TargetPreset";
	local preset = self.Settings.Preset;
	if not preset then
		error("No preset specified!");
	end

	slider.Slider.OldMousePressed = slider.Slider.OnMousePressed;
	slider.Slider.OldMouseReleased = slider.Slider.OnMouseReleased;
	slider.Slider.OnMousePressed = function(s, mc)
		--print("Press");
		container.TargetPreset = preset;
		container.Manipulating = true;
		self.Manipulating = true;
		s:OldMousePressed(mc);
	end
	slider.Slider.OnMouseReleased = function(s, mc)
		--print("Release");
		if self.Manipulating then
			container.Manipulating = false;
			self.Manipulating = false;
			container.TweenValue = 0;
		end
		s:OldMouseReleased(mc);
	end
	slider.Slider.Knob.OldMousePressed = slider.Slider.Knob.OnMousePressed;
	slider.Slider.Knob.OldMouseReleased = slider.Slider.Knob.OnMouseReleased;
	slider.Slider.Knob.OnMousePressed = function(s, mc)
		container.TargetPreset = preset;
		container.Manipulating = true;
		self.Manipulating = true;
		s:OldMousePressed(mc);
	end
	slider.Slider.Knob.OnMouseReleased = function(s, mc)
		if self.Manipulating then
			container.Manipulating = false;
			self.Manipulating = false;
			container.TweenValue = 0;
		end
		s:OldMouseReleased(mc);
	end

	slider.OnValueChanged = function(s, value)
		if not self.Manipulating then
			local vc = s.OnValueChanged;
			s.OnValueChanged = function() end
			s:SetValue(0);
			s.OnValueChanged = vc;
			return;
		end
		local container = self.Container;
		local key = self.Key;
		container:_ApplyFromBind(self, key, value);
	end

end
function PRESETBIND:Remove()
	local slider = self.Entity;
	slider.Slider.OnMousePressed = slider.Slider.OldMousePressed;
	slider.Slider.OnMouseReleased = slider.Slider.OldMousePressed;
	slider.Slider.Knob.OnMousePressed = slider.Slider.Knob.OldMousePressed;
	slider.Slider.Knob.OnMouseReleased = slider.Slider.Knob.OldMousePressed;
	slider.OnValueChanged = function() end
end
function PRESETBIND:SetValue(value)
	local slider = self.Entity;
	local vc = slider.OnValueChanged;
	slider.OnValueChanged = function() end
	if self.Manipulating then
		slider:SetValue(value);
	else
		slider:SetValue(0);
	end
	slider.OnValueChanged = vc;
end
PHT.BiValues.RegisterBindType("PHTPreset", PRESETBIND);
