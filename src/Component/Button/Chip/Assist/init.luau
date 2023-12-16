--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Base = require(script.Parent:WaitForChild("Base"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

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

-- Private Functions

-- Class
local Interface = {}

Interface.ColdFusion = {}

function newThemedComponent(
	style: CanBeState<Style>,
	textColor: Enums.ColorRoleType,
	disabledTextColor: Enums.ColorRoleType,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, nil :: any)

	local out = Interface.ColdFusion.new(
		onClick,
		text,
		icon,
		style,
		_Computed(function(s: Style): Color3
			return s:GetColor(textColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledTextColor)
		end, styleState),
		_import(isEnabled, true),
		_import(elevation, 0)
	)

	maid.bind(out)

	return out
end

function Interface.ColdFusion.primary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.Surface,
		onClick,
		text,
		icon,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.secondary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.Surface,
		onClick,
		text,
		icon,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.tertiary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
	elevation: CanBeState<number?>,
	isEnabled: CanBeState<boolean?>
): GuiObject
	return newThemedComponent(
		style,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.Surface,
		onClick,
		text,
		icon,
		elevation,
		isEnabled
	)
end

function Interface.ColdFusion.new(
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	icon: CanBeState<ImageData?>,
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

	local onClickState = _import(onClick, function() end)
	local button = Base.new(
		function(isSelected: boolean)
			local click = onClickState:Get()
			click()
		end,
		false,
		text,
		icon,
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
