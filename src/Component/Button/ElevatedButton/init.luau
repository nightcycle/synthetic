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
type TextStyle = Types.TextStyle
type ImageData = Types.ImageData
type ThemeData = Types.ThemeData
-- Constants
local DEFAULT_VOLUME = Config.Sound.Volume
local DISABLE_TRANSPARENCY = Config.Transparency.Text.Disabled
local DISABLE_BACK_TRANS = Config.Transparency.Background.Disabled

-- Variables
-- References
-- Private Functions


-- Class
local Interface = {}

function Interface.cfusion(
		onClick: CanBeState<() -> ()>,
		text: CanBeState<string>,
		theme: CanBeState<ThemeData>,
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
	local themeState = _import(theme, Types.newThemeData(
		1,
		false,
		1,
		Font.fromEnum(Enum.Font.SourceSansSemibold),
		Color3.fromHSV(0.8, 0.4, 0.8)
	))

	local sound = maid:GiveTask(Instance.new("Sound"))
	sound.Volume = DEFAULT_VOLUME
	sound.SoundId = Sounds.ui_tap_variant_01

	local styles = _Computed(function(thm: ThemeData): {[Enums.ButtonStateType]: TextStyle}
		local backColor: Color3?
		local textColor: Color3?

		if thm.IsDarkMode then
			backColor = Util.getReadableColor(
				thm.Color3,
				if thm.BackgroundColor3 then thm.BackgroundColor3 else Util.DARK_SURFACE
			)
			assert(backColor)

			textColor = Util.DARK_SURFACE
		else
			backColor = Util.getReadableColor(
				thm.Color3,
				if thm.BackgroundColor3 then thm.BackgroundColor3 else Util.LIGHT_SURFACE
			)
			assert(backColor)

			textColor = Util.LIGHT_SURFACE
		end
		assert(backColor)
		assert(textColor)

		backColor = Util.getElevatedColor(
			backColor,
			thm.Elevation,
			thm.IsDarkMode
		)

		textColor = Util.getElevatedColor(
			textColor,
			thm.Elevation,
			thm.IsDarkMode
		)

		local disableBackColor = (function(): Color3
			local h,s,v = backColor:ToHSV()
			return Color3.fromHSV(h,s*0,v)
		end)()

		local data = {
			[Enums.ButtonStateType.Enabled] = Types.newTextStyle(
				textColor,
				0,
				backColor,
				0,
				textColor,
				1
			),
			[Enums.ButtonStateType.Disabled] = Types.newTextStyle(
				(function(): Color3
					if thm.IsDarkMode then
						return Util.LIGHT_SURFACE
					else
						return Util.DARK_SURFACE
					end
				end)(),
				DISABLE_TRANSPARENCY,
				disableBackColor,
				DISABLE_BACK_TRANS,
				textColor,
				1
			),
			[Enums.ButtonStateType.Focused] = Types.newTextStyle(
				textColor,
				0,
				backColor,
				0,
				textColor,
				1
			),
			[Enums.ButtonStateType.Hovered] = Types.newTextStyle(
				textColor,
				0,
				backColor,
				0,
				textColor,
				1
			),
			[Enums.ButtonStateType.Pressed] = Types.newTextStyle(
				textColor,
				0,
				backColor,
				0,
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
		true,
		_Computed(function(t: ThemeData): number
			return t.Scale
		end, themeState),
		sound
	)
	maid.bind(button)
	return button
end

return Interface