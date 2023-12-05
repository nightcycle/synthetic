--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local CurveUtil = require(_Packages:WaitForChild("CurveUtil"))

-- Modules
local Sounds = require(_Package:WaitForChild("Sounds"))
local Enums = require(_Package:WaitForChild("Enums"))
local Types = require(_Package:WaitForChild("Types"))
local Config = require(_Package:WaitForChild("Config"))
local Util = require(_Package:WaitForChild("Util"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type TextStyle = Types.TextStyle
type ImageData = Types.ImageData
type ThemeData = Types.ThemeData
-- Constants
local HEIGHT_DP = 40
local SHAPE_DP = 20
local ICON_SIZE_DP = 18
local CONTAINER_WIDTH_MIN_DP = 48
local LEFT_RIGHT_PADDING_DP = 12
local LEFT_PADDING_WITH_ICON_DP = 12
local RIGHT_PADDING_WITH_ICON_DP = 16
local PADDING_BETWEEN_ELEMENTS_DP = 8
local DEFAULT_VOLUME = Config.Sound.Volume
local LABEL_TEXT_ALIGNMENT = Enum.TextXAlignment.Center

-- Variables
-- References
-- Private Functions


-- Class
local Interface = {}

function Interface._new(
	maid: Maid,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,		
	font: CanBeState<Font>,
	styles: CanBeState<{[Enums.ButtonStateType]: TextStyle}>,
	textIcon: CanBeState<ImageData?>,
	isEnabled: CanBeState<boolean>,
	scale: CanBeState<number>,
	sound: CanBeState<Sound>
): TextButton

	local _fuse = ColdFusion.fuse(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed
	local isEnabledState = _import(isEnabled, true)
	local isFocusedState = _Value(false)
	local isPressedState = _Value(false)
	local isHoveredState = _Value(false)
	local currentStateState = _Computed(function(isEnabled: boolean, isFocused: boolean, isPressed: boolean, isHovered: boolean): Enums.ButtonStateType
		if isEnabled then
			if isPressed then
				return Enums.ButtonStateType.Pressed
			else
				if isHovered then
					return Enums.ButtonStateType.Hovered
				else
					if isFocused then
						return Enums.ButtonStateType.Focused
					else
						return Enums.ButtonStateType.Enabled
					end
				end
			end
		else
			return Enums.ButtonStateType.Disabled
		end
	end, isEnabledState, isFocusedState, isPressedState, isHoveredState) :: State<any>

	local stylesState = _import(styles, {}) :: any
	local currentStyleState = _Computed(function(state: Enums.ButtonStateType, styles: {[Enums.ButtonStateType]: TextStyle}): TextStyle
		local style = styles[state]
		assert(style ~= nil, `no style for {state}`)
		return style
	end, currentStateState, stylesState)

	local onClickState = _import(onClick, function() end)
	local textState = _import(text, "")
	local fontState = _import(font, Font.fromEnum(Enum.Font.SourceSansSemibold))
	local scaleState = _import(scale, 1)
	local iconState = _import(textIcon, nil :: ImageData?) :: any
	local soundState = _import(sound, nil :: Sound?)
	local inst: TextButton = _new("TextButton")({
		Name = "TextButton",
		Text = "",
		BackgroundTransparency = _Computed(function(style: TextStyle): number
			return style.BackgroundTransparency
		end, currentStyleState),
		BackgroundColor3 = _Computed(function(style: TextStyle): Color3
			return style.BackgroundColor3
		end, currentStyleState),
		Active = isEnabledState,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = _Computed(function(s: number): UDim2
			return UDim2.fromOffset(0, s * HEIGHT_DP)
		end, scaleState),
		Events = {
			Activated = function()
				if isEnabledState:Get() == false then return end
				local click = onClickState:Get()
				local s = soundState:Get()
				if s then
					SoundService:PlayLocalSound(s)
				end
				click()
			end,
			MouseButton1Down = function(inputObject: InputObject)
				isPressedState:Set(true)
			end,
			MouseButton1Up = function(inputObject: InputObject)
				isPressedState:Set(false)
			end,
			MouseEnter = function()
				isHoveredState:Set(true)
			end,
			MouseLeave = function()
				isHoveredState:Set(false)
			end,
			SelectionGained = function()
				isFocusedState:Set(true)
			end,
			SelectionLost = function()
				isFocusedState:Set(false)
			end,
		},
		Children = {
			_new("UICorner")({
				CornerRadius = _Computed(function(s: number): UDim
					return UDim.new(0, s * SHAPE_DP)
				end, scaleState),
			}),
			_new("UIListLayout")({
				Padding = _Computed(function(s: number): UDim
					return UDim.new(0, s * PADDING_BETWEEN_ELEMENTS_DP)
				end, scaleState),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			_new("TextLabel")({
				Text = textState,
				TextScaled = true,
				TextXAlignment = LABEL_TEXT_ALIGNMENT,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				FontFace = fontState,
				LayoutOrder = 2,
				TextColor3 = _Computed(function(style: TextStyle): Color3
					return style.TextColor3
				end, currentStyleState),
				TextTransparency = _Computed(function(style: TextStyle): number
					return style.TextTransparency
				end, currentStyleState),
				Size = _Computed(function(s: number): UDim2
					return UDim2.fromOffset(0, s * ICON_SIZE_DP)
				end, scaleState),
			}),
			_new("ImageLabel")({
				Name = "Icon",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Visible = _Computed(function(icon: ImageData?): boolean
					return icon ~= nil
				end, iconState),
				Image = _Computed(function(icon: ImageData?): string
					return if icon then icon.Image else ""
				end, iconState),
				ImageColor3 = _Computed(function(icon: ImageData?, style: TextStyle?): Color3
					return if icon and style then style.TextColor3 else Color3.new(1,1,1)
				end, iconState, currentStyleState),
				ImageRectOffset = _Computed(function(icon: ImageData?): Vector2
					return if icon then icon.RectOffset else Vector2.zero
				end, iconState),
				ImageRectSize = _Computed(function(icon: ImageData?): Vector2
					return if icon then icon.RectSize else Vector2.zero
				end, iconState),
				ImageTransparency = _Computed(function(icon: ImageData?, style: TextStyle?): number
					return if icon and style then style.TextTransparency else 1
				end, iconState, currentStyleState),
				Size = _Computed(function(s: number): UDim2
					return UDim2.fromOffset(s * ICON_SIZE_DP, s * ICON_SIZE_DP)
				end, scaleState),
			}),
			_new("UIPadding")({
				PaddingLeft = _Computed(function(s: number, icon: ImageData?): UDim
					if icon then
						return UDim.new(0, LEFT_PADDING_WITH_ICON_DP * s)
					else
						return UDim.new(0, LEFT_RIGHT_PADDING_DP * s)
					end
				end, scaleState, iconState),
				PaddingRight = _Computed(function(s: number, icon: ImageData?): UDim
					if icon then
						return UDim.new(0, RIGHT_PADDING_WITH_ICON_DP * s)
					else
						return UDim.new(0, LEFT_RIGHT_PADDING_DP * s)
					end
				end, scaleState, iconState),
				PaddingTop = _Computed(function(s: number): UDim
					return UDim.new(0, s * (HEIGHT_DP-ICON_SIZE_DP) / 2)
				end, scaleState),
				PaddingBottom = _Computed(function(s: number): UDim
					return UDim.new(0, s * (HEIGHT_DP-ICON_SIZE_DP) / 2)
				end, scaleState),
			}),
			_new("UISizeConstraint")({
				MaxSize = Vector2.new(math.huge, math.huge),
				MinSize = _Computed(function(s: number): Vector2
					return Vector2.new(s * CONTAINER_WIDTH_MIN_DP, 0)
				end, scaleState),
			}),
		},
	}) :: TextButton

	return inst
end

function Interface.cfusion(
		onClick: CanBeState<() -> ()>,
		text: CanBeState<string>,
		theme: CanBeState<ThemeData>,
		icon: CanBeState<ImageData>?,
		isEnabled: CanBeState<boolean>?
): TextButton
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
		local textColor: Color3?
		if thm.IsDarkMode then
			textColor = Util.getReadableColor(
				thm.Color3,
				if thm.BackgroundColor3 then thm.BackgroundColor3 else Util.DARK_SURFACE,
				12
			)
		else
			textColor = Util.getReadableColor(
				thm.Color3,
				if thm.BackgroundColor3 then thm.BackgroundColor3 else Util.LIGHT_SURFACE,
				5
			)
		end
		assert(textColor)
		textColor = Util.getElevatedColor(
			textColor,
			thm.Elevation,
			thm.IsDarkMode
		)
		local data = {
			[Enums.ButtonStateType.Enabled] = Types.newTextStyle(
				textColor,
				0,
				textColor,
				1,
				textColor,
				1
			),
			[Enums.ButtonStateType.Disabled] = Types.newTextStyle(
				(function(): Color3
					if thm.IsDarkMode then
						local h,_s,v = textColor:ToHSV()
						return Util.getReadableColor(
							Color3.fromHSV(h,0,v),
							if thm.BackgroundColor3 then thm.BackgroundColor3 else Color3.new(0.15,0.15,0.15)
						)
					else
						local h,_s,v = textColor:ToHSV()
						return Util.getReadableColor(
							Color3.fromHSV(h,0,v),
							if thm.BackgroundColor3 then thm.BackgroundColor3 else Color3.new(0.85,0.85,0.85)
						)
					end
				end)(),
				0.4,
				textColor,
				1,
				textColor,
				1
			),
			[Enums.ButtonStateType.Focused] = Types.newTextStyle(
				textColor,
				0,
				textColor,
				0.45,
				textColor,
				1
			),
			[Enums.ButtonStateType.Hovered] = Types.newTextStyle(
				textColor,
				0,
				textColor,
				0.85,
				textColor,
				1
			),
			[Enums.ButtonStateType.Pressed] = Types.newTextStyle(
				textColor,
				0,
				textColor,
				0.6,
				textColor,
				1
			),
		}
		return data
	end, themeState)

	local button = Interface._new(
		maid,
		onClickState,
		textState,		
		_Computed(function(t: ThemeData): Font
			return t.Font
		end, themeState),
		styles,
		icon,
		if isEnabled == nil then true else isEnabled,
		_Computed(function(t: ThemeData): number
			return t.Scale
		end, themeState),
		sound
	)
	maid.bind(button)
	return button
end

return Interface