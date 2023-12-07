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
local Util = require(_Package:WaitForChild("Util"))
local Base = require(script.Parent:WaitForChild("Base"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type TextStyle = Types.Style
type ImageData = Types.ImageData
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

function Interface.cfusion(
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	styles: CanBeState<{ [Enums.ButtonStateType]: Style }>,
	icon: CanBeState<ImageData>?,
	isEnabled: CanBeState<boolean>?
): ImageLabel
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

	local styles = _Computed(function(thm: ThemeData): { [Enums.ButtonStateType]: TextStyle }
		local textColor: Color3?
		if thm.IsDarkMode then
			textColor = Util.getReadableColor(
				thm.Color3,
				if thm.BackgroundColor3 then thm.BackgroundColor3 else Util.DARK_SURFACE
			)
		else
			textColor = Util.getReadableColor(
				thm.Color3,
				if thm.BackgroundColor3 then thm.BackgroundColor3 else Util.LIGHT_SURFACE
			)
		end
		assert(textColor)
		textColor = Util.getElevatedColor(textColor, thm.Elevation, thm.IsDarkMode)
		local data = {
			[Enums.ButtonStateType.Enabled] = Types.newTextStyle(textColor, 0, textColor, 1, textColor, 1),
			[Enums.ButtonStateType.Disabled] = Types.newTextStyle(
				(function(): Color3
					if thm.IsDarkMode then
						local h, _s, v = textColor:ToHSV()
						return Util.getReadableColor(
							Color3.fromHSV(h, 0, v),
							if thm.BackgroundColor3 then thm.BackgroundColor3 else Color3.new(0.15, 0.15, 0.15)
						)
					else
						local h, _s, v = textColor:ToHSV()
						return Util.getReadableColor(
							Color3.fromHSV(h, 0, v),
							if thm.BackgroundColor3 then thm.BackgroundColor3 else Color3.new(0.85, 0.85, 0.85)
						)
					end
				end)(),
				DISABLE_TRANSPARENCY,
				textColor,
				1,
				textColor,
				1
			),
			[Enums.ButtonStateType.Focused] = Types.newTextStyle(
				textColor,
				0,
				textColor,
				FOCUS_TRANSPARENCY,
				textColor,
				1
			),
			[Enums.ButtonStateType.Hovered] = Types.newTextStyle(
				textColor,
				0,
				textColor,
				HOVER_TRANSPARENCY,
				textColor,
				1
			),
			[Enums.ButtonStateType.Pressed] = Types.newTextStyle(
				textColor,
				0,
				textColor,
				PRESS_TRANSPARENCY,
				textColor,
				1
			),
		}
		return data
	end, themeState)

	local button = Base(
		maid,
		onClickState,
		textState,
		_Computed(function(t: ThemeData): Font
			return t.Font
		end, themeState),
		styles,
		icon,
		if isEnabled == nil then true else isEnabled,
		false,
		_Computed(function(t: ThemeData): number
			return t.Scale
		end, themeState),
		sound
	)
	maid.bind(button)
	return button
end

return Interface