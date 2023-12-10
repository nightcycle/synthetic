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
local Sounds = require(_Package:WaitForChild("Sounds"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type ImageData = Types.ImageData
type ButtonData = Types.ButtonData
type Style = Style.Style

-- Constants
local ICONS = MaterialIcons.default.dp_48.scale_1
local ELEVATION = 6
-- Variables
-- References
-- Private Functions
-- Class
local Interface = {}

Interface.ColdFusion = {}

function Interface.ColdFusion.new(
	isFullScreen: CanBeState<boolean>,
	icon: CanBeState<ImageData?>,
	headline: CanBeState<string?>,
	description: CanBeState<string?>,

	buttons: CanBeState<{[number]: ButtonData}>,

	surfaceColor: CanBeState<Color3>,
	buttonTextColor: CanBeState<Color3>,
	headlineColor: CanBeState<Color3>,
	descriptionColor: CanBeState<Color3>,
	dividerColor: CanBeState<Color3>,
	scrimColor: CanBeState<Color3>,

	style: CanBeState<Style>
)

	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local isFullScreenState = _import(isFullScreen, true)
	local iconState = _import(icon, nil :: ImageData?)

	local headlineState: State<string?> = _import(headline, nil :: string?)
	local descriptionState: State<string?> = _import(description, nil :: string?)

	local buttonsState: State<{[number]: ButtonData}> = _import(buttons, {})

	local surfaceColorState: State<Color3> = _import(surfaceColor, Color3.new())
	local buttonTextColorState: State<Color3> = _import(buttonTextColor, Color3.new())
	local headlineColorState: State<Color3> = _import(headlineColor, Color3.new())
	local descriptionColorState: State<Color3> = _import(descriptionColor, Color3.new())
	local dividerColorState: State<Color3> = _import(dividerColor, Color3.new())
	local scrimColorState: State<Color3> = _import(scrimColor, Color3.new())

	local inst = _new("Frame")({
		Size = _Computed(function(isFull: boolean): UDim2
			return if isFull then UDim2.fromScale(1,1) else UDim2.fromScale(0,0)
		end, isFullScreenState),
	}) :: GuiObject

	maid.bind(inst)

	return inst
end

return Interface