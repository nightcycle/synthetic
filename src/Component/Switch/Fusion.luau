--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Translators = require(_Package:WaitForChild("Translators"))
local Source = require(script.Parent:WaitForChild("ColdFusion"))

-- Types
type Maid = Maid.Maid
type Style = Style.Style
type FontData = Types.FontData
type CanBeState<V> = ColdFusion.CanBeState<V>
type FusionCanBeState<V> = Translators.FusionCanBeState<V>

-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Interface = {}

function Interface.primary(
	style: FusionCanBeState<Style>,
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	includeIconOnSelected: FusionCanBeState<boolean?>,
	includeIconOnDeselected: FusionCanBeState<boolean?>,
	elevation: FusionCanBeState<number?>,
	isEnabled: FusionCanBeState<boolean?>
)
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value)
	end

	local inst = Source.primary(
		convert(style),
		convert(onSelect),
		convert(initialSelection),
		convert(includeIconOnSelected),
		convert(includeIconOnDeselected),
		convert(elevation),
		convert(isEnabled)
	)

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

function Interface.secondary(
	style: FusionCanBeState<Style>,
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	includeIconOnSelected: FusionCanBeState<boolean?>,
	includeIconOnDeselected: FusionCanBeState<boolean?>,
	elevation: FusionCanBeState<number?>,
	isEnabled: FusionCanBeState<boolean?>
)
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value)
	end

	local inst = Source.secondary(
		convert(style),
		convert(onSelect),
		convert(initialSelection),
		convert(includeIconOnSelected),
		convert(includeIconOnDeselected),
		convert(elevation),
		convert(isEnabled)
	)

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

function Interface.tertiary(
	style: FusionCanBeState<Style>,
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	includeIconOnSelected: FusionCanBeState<boolean?>,
	includeIconOnDeselected: FusionCanBeState<boolean?>,
	elevation: FusionCanBeState<number?>,
	isEnabled: FusionCanBeState<boolean?>
)
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value)
	end

	local inst = Source.tertiary(
		convert(style),
		convert(onSelect),
		convert(initialSelection),
		convert(includeIconOnSelected),
		convert(includeIconOnDeselected),
		convert(elevation),
		convert(isEnabled)
	)

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

function Interface.new(
	onSelect: FusionCanBeState<(isSelected: boolean) -> ()>,
	initialSelection: FusionCanBeState<boolean>,
	isEnabled: FusionCanBeState<boolean>,
	includeIconOnSelected: FusionCanBeState<boolean>,
	includeIconOnDeselected: FusionCanBeState<boolean>,
	backgroundColor: FusionCanBeState<Color3>,
	onBackgroundColor: FusionCanBeState<Color3>,
	fillColor: FusionCanBeState<Color3>,
	buttonColor: FusionCanBeState<Color3>,
	onButtonColor: FusionCanBeState<Color3>,
	disabledColor: FusionCanBeState<Color3>,
	onDisabledColor: FusionCanBeState<Color3>,
	elevation: FusionCanBeState<number>,
	schemeType: FusionCanBeState<Enums.SchemeType>,
	fontData: FusionCanBeState<FontData>,
	scale: FusionCanBeState<number>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local function convert<V>(value: FusionCanBeState<V>): CanBeState<V>
		return Translators.Fusion.toColdFusion(maid, _fuse, value)
	end
	local inst = Source.new(
		convert(onSelect),
		convert(initialSelection),
		convert(isEnabled),
		convert(includeIconOnSelected),
		convert(includeIconOnDeselected),
		convert(backgroundColor),
		convert(onBackgroundColor),
		convert(fillColor),
		convert(buttonColor),
		convert(onButtonColor),
		convert(disabledColor),
		convert(onDisabledColor),
		convert(elevation),
		convert(schemeType),
		convert(fontData),
		convert(scale)
	)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))
	return inst
end

return Interface
