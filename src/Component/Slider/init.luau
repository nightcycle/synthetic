--!strict
local _Package = script.Parent.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Sounds = require(_Package:WaitForChild("Sounds"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type AppearanceData = Types.AppearanceData
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type Style = Style.Style
type SwitchRenderData = {
	Text: AppearanceData,
	Button: AppearanceData,
	Background: AppearanceData,
	Outline: AppearanceData,
}

-- Constants
local ICONS = MaterialIcons.default.dp_48.scale_1
local SWITCH_HEIGHT_DP = 32
local SWITCH_WIDTH_DP = 52
local INNER_BUTTON_YES_ICON_SIZE_DP = 28
local INNER_BUTTON_NO_ICON_SELECTED_SIZE_DP = 24
local INNER_BUTTON_NO_ICON_UNSELECTED_SIZE_DP = 16
local ICON_SIZE_DP = 16
local OUTLINE_WIDTH_DP = 2
-- Variables
-- References
-- Private Functions
local Interface = {}

Interface.ColdFusion = {}


function Interface.ColdFusion.new(
	input: CanBeState<number>,
	minimum: CanBeState<number?>,
	maximum: CanBeState<number?>,
	increment: CanBeState<number?>,
	includeTab: CanBeState<boolean>,

	backgroundColor: CanBeState<Color3>,
	onBackgroundColor: CanBeState<Color3>,
	fillColor: CanBeState<Color3>,
	onFillColor: CanBeState<Color3>,

	elevation: CanBeState<number>,
	style: CanBeState<Style>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local inst = _new("Frame")({

	}) :: Frame

	return inst
end

return Interface
