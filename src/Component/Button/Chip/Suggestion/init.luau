--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Base = require(script.Parent:WaitForChild("Base"))
local Style = require(_Package:WaitForChild("Style"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type Style = Style.Style
type ImageData = Types.ImageData

-- Constants
-- Variables
-- References
local Icons = MaterialIcons.default.dp_48.scale_1

-- Private Functions

-- Class
local Interface = {}

Interface.ColdFusion = {}

function Interface.ColdFusion.new(
	onClick: CanBeState<() -> ()>,
	isInitiallySelected: CanBeState<boolean>,
	text: CanBeState<string>,
	style: CanBeState<Style>,
	textColor: CanBeState<Color3>,
	disabledTextColor: CanBeState<Color3>,
	isEnabled: CanBeState<boolean>,
	elevation: CanBeState<number>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local isInitiallySelectedState = _import(isInitiallySelected, true)
	local isSelectedState = _Value(isInitiallySelectedState:Get())
	local onClickState = _import(onClick, function() end)
	local button = Base.new(
		function(isSelected: boolean)
			local click = onClickState:Get()
			isSelectedState:Set(isSelected)
			click()
		end,
		isInitiallySelectedState,
		text,
		nil,
		style,
		textColor,
		disabledTextColor,
		textColor,
		disabledTextColor,
		textColor,
		disabledTextColor,
		isEnabled,
		elevation,
		true
	)

	return button
end

return Interface
