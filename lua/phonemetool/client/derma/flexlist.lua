
local PANEL = {};

function PANEL:Init()
	self.FlexItems = {};

	self.List = vgui.Create("DPanelList", self);
	self.List:EnableHorizontal(false);
	self.List:SetAutoSize(true);
	self.List:SetSpacing(3);
	self:SetContents(self.List);

	self.SelectAllBtn = vgui.Create("DButton", self.List);
	self.SelectAllBtn:SetText("Select All");
	self.SelectAllBtn:SizeToContents();
	self.List:AddItem(self.SelectAllBtn);
	self.SelectNoneBtn = vgui.Create("DButton", self.List);
	self.SelectNoneBtn:SetText("Deselect All");
	self.SelectNoneBtn:SizeToContents();
	self.List:AddItem(self.SelectNoneBtn);

	self:SetLabel("Ignored flexes");
	self:SetExpanded(0);
end

function PANEL:AddCheckBox(name)
	local cb = vgui.Create("DCheckBoxLabel", self);
	cb:SetText(name);
	self.List:AddItem(cb);
	table.insert(self.FlexItems, cb);
	return cb;
end

function PANEL:Clear()
	for _, item in pairs(self.FlexItems) do
		self.List:RemoveItem(item);
		item:Remove();
	end
	table.Empty(self.FlexItems);
end

vgui.Register("PHTFlexMenu", PANEL, "DCollapsibleCategory");


local MENUBIND = {};
function MENUBIND:Init()
	local menu = self.Entity;
	menu.SelectAllBtn:Bind(self.Container, "IgnoreAll", "Button");
	menu.SelectNoneBtn:Bind(self.Container, "IgnoreNone", "Button");
end
function MENUBIND:Remove()
	local menu = self.Entity;
	menu.SelectAllBtn:UnBind(self.Container, "IgnoreAll");
	menu.SelectNoneBtn:UnBind(self.Container, "IgnoreNone");
end
function MENUBIND:SetValue(value)
	local menu = self.Entity;
	for _, item in pairs(menu.FlexItems) do
		item:UnBind(self.Container, "IgnoredFlexes");
	end
	menu:Clear();
	for _, flex in pairs(value) do
		local cb = menu:AddCheckBox(flex);
		cb:Bind(self.Container, "IgnoredFlexes", "PHTFlexToggle", {Flex = flex});
	end
end
PHT.BiValues.RegisterBindType("PHTFlexMenu", MENUBIND);

local FLEXTOGGLE = {};
function FLEXTOGGLE:Init()
	local flex = self.Settings.Flex;
	local cb = self.Entity;

	cb.OnChange = function(s, value)
		local t = self.Container[self.Key];
		if type(t) ~= "table" then
			t = {};
		end
		if value then
			table.insert(t, flex);
		elseif table.HasValue(t, flex) then
			table.RemoveByValue(t, flex);
		end
		self.Container:_ApplyFromBind(self, self.Key, t);
	end
end
function FLEXTOGGLE:Remove()
	local cb =self.Entity;
	cb.OnChange = function() end
end
function FLEXTOGGLE:SetValue(value)
	local cb = self.Entity;
	local flex = self.Settings.Flex;
	if type(value) ~= "table" then
		return;
	end
	local onChange = cb.OnChange;
	cb.OnChange = function() end
	if table.HasValue(value, flex) then
		cb:SetValue(true);
	else
		cb:SetValue(false);
	end
	cb.OnChange = onChange;
end
PHT.BiValues.RegisterBindType("PHTFlexToggle", FLEXTOGGLE);