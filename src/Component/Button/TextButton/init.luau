--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Sounds = require(_Package:WaitForChild("Sounds"))
local Enums = require(_Package:WaitForChild("Enums"))
local Types = require(_Package:WaitForChild("Types"))
local Config = require(_Package:WaitForChild("Config"))
local Base = require(script.Parent:WaitForChild("Base"))
local StyleUtil = require(_Package:WaitForChild("StyleUtil"))
local Typography = require(_Package:WaitForChild("Typography"))
local Theme = require(_Package:WaitForChild("Theme"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type Typography = Typography.Typography
type Theme = Theme.Theme

-- Constants
local DEFAULT_VOLUME = Config.Sound.Volume
local HOVER_TRANSPARENCY = Config.Transparency.Background.Hovered
local FOCUS_TRANSPARENCY = Config.Transparency.Background.Focused
local PRESS_TRANSPARENCY = Config.Transparency.Background.Pressed
local DISABLE_TRANSPARENCY = Config.Transparency.Text.Disabled

-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

Interface.ColdFusion = {}

function Interface.ColdFusion._new(
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	isEnabled: CanBeState<boolean>,
	renderStates: CanBeState<{[Enums.ButtonStateType]: RenderData}>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local button = Base.component(
		maid,
		onClick,
		text,
		isEnabled,
		renderStates,
		nil,
		nil,
		nil
	)
	maid.bind(button)

	return button
end


function Interface.ColdFusion.new(
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	elevation: CanBeState<number>,
	theme: CanBeState<Typography>,
	typography: CanBeState<Typography>
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
	local textState = _import(text, "")

	local enabledStyleState = StyleUtil.newRenderData(
		_fuse,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	) 

	maid.bind(button)

	return button
end


return Interface
