--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
local RunService = game:GetService("RunService")
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Util = require(_Package:WaitForChild("Util"))
local Enums = require(_Package:WaitForChild("Enums"))
local Theme = require(_Package:WaitForChild("Theme"))
local Typography = require(_Package:WaitForChild("Typography"))

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
type FontData = Types.FontData

-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
local ICON_WIDTH_DP = 20
local BAR_HEIGHT_DP = 16
local CURSOR_HEIGHT_DP = 44
local CURSOR_WIDTH_PADDING_DP = 6
local CURSOR_WIDTH_DP = 4
local CURSOR_SELECTED_WIDTH_DP = 2

local BAR_LEFT_RIGHT_INNER_PADDING_DP = 4
local BAR_UP_DOWN_INNER_PADDING_DP = 6
local BUBBLE_GAP_DP = 4
local BUBBLE_UP_DOWN_PADDING = 12
local BUBBLE_LEFT_RIGHT_PADDING = 16
local ICON_PADDING_DP = 16
local MIN_WIDTH_DP = CURSOR_HEIGHT_DP * 4
local RIGHT_CIRCLE_IMAGE = "rbxassetid://15562060748"
local LEFT_CIRCLE_IMAGE = "rbxassetid://15562057345"
local CIRCLE_IMAGE_RECT = Rect.new(256, 256, 256, 256)
local DOT_DIAMETER_DP = BAR_HEIGHT_DP - (2 * BAR_UP_DOWN_INNER_PADDING_DP)

-- Variables
-- References
-- Private Functions
function newDot(colorState: State<Color3>, scaleState: State<number>): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed
	local out = _new("Frame")({
		BorderSizePixel = 0,
		BackgroundColor3 = colorState,
		Size = _Computed(function(sc: number): UDim2
			return UDim2.fromOffset(DOT_DIAMETER_DP * sc, DOT_DIAMETER_DP * sc)
		end, scaleState),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Children = {
			_new("UICorner")({
				CornerRadius = UDim.new(0.5, 0),
			}),
		},
	}) :: GuiObject
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))
	return out
end

local Interface = {}

Interface = {}

function Interface.onTertiary(
	style: CanBeState<Style>,
	onChange: CanBeState<(onChange: number) -> ()>,
	initialValue: CanBeState<number>,
	minimum: CanBeState<number?>,
	maximum: CanBeState<number?>,
	increment: CanBeState<number?>,
	leftTextOrIcon: CanBeState<string | ImageData | nil>,
	rightTextOrIcon: CanBeState<string | ImageData | nil>,
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

	local styleState: State<Style> = _import(style, DEFAULTS.ON_TERTIARY.STYLE)

	local out = Interface.new(
		_import(elevation, DEFAULTS.ON_TERTIARY.ON_CHANGE),
		_import(elevation, DEFAULTS.ON_TERTIARY.INITIAL_VALUE),
		_import(elevation, DEFAULTS.ON_TERTIARY.MINIMUM),
		_import(elevation, DEFAULTS.ON_TERTIARY.MAXIMUM),
		_import(elevation, DEFAULTS.ON_TERTIARY.INCREMENT),
		_import(leftTextOrIcon, DEFAULTS.ON_TERTIARY.LEFT_TEXT_OR_ICON),
		_import(rightTextOrIcon, DEFAULTS.ON_TERTIARY.RIGHT_TEXT_OR_ICON),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnTertiary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Tertiary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.TertiaryContainer)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnTertiaryContainer)
		end, styleState),
		_import(elevation, DEFAULTS.ON_TERTIARY.ELEVATION),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.onSecondary(
	style: CanBeState<Style>,
	onChange: CanBeState<(onChange: number) -> ()>,
	initialValue: CanBeState<number>,
	minimum: CanBeState<number?>,
	maximum: CanBeState<number?>,
	increment: CanBeState<number?>,
	leftTextOrIcon: CanBeState<string | ImageData | nil>,
	rightTextOrIcon: CanBeState<string | ImageData | nil>,
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

	local styleState: State<Style> = _import(style, DEFAULTS.SECONDARY.STYLE)

	local out = Interface.new(
		_import(elevation, DEFAULTS.ON_SECONDARY.ON_CHANGE),
		_import(elevation, DEFAULTS.ON_SECONDARY.INITIAL_VALUE),
		_import(elevation, DEFAULTS.ON_SECONDARY.MINIMUM),
		_import(elevation, DEFAULTS.ON_SECONDARY.MAXIMUM),
		_import(elevation, DEFAULTS.ON_SECONDARY.INCREMENT),
		_import(leftTextOrIcon, DEFAULTS.ON_SECONDARY.LEFT_TEXT_OR_ICON),
		_import(rightTextOrIcon, DEFAULTS.ON_SECONDARY.RIGHT_TEXT_OR_ICON),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnSecondary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Secondary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.SecondaryContainer)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnSecondaryContainer)
		end, styleState),
		_import(elevation, DEFAULTS.ON_SECONDARY.ELEVATION),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.onPrimary(
	style: CanBeState<Style>,
	onChange: CanBeState<(onChange: number) -> ()>,
	initialValue: CanBeState<number>,
	minimum: CanBeState<number?>,
	maximum: CanBeState<number?>,
	increment: CanBeState<number?>,
	leftTextOrIcon: CanBeState<string | ImageData | nil>,
	rightTextOrIcon: CanBeState<string | ImageData | nil>,
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

	local styleState: State<Style> = _import(style, DEFAULTS.ON_PRIMARY.STYLE)

	local out = Interface.new(
		_import(elevation, DEFAULTS.ON_PRIMARY.ON_CHANGE),
		_import(elevation, DEFAULTS.ON_PRIMARY.INITIAL_VALUE),
		_import(elevation, DEFAULTS.ON_PRIMARY.MINIMUM),
		_import(elevation, DEFAULTS.ON_PRIMARY.MAXIMUM),
		_import(elevation, DEFAULTS.ON_PRIMARY.INCREMENT),
		_import(leftTextOrIcon, DEFAULTS.ON_PRIMARY.LEFT_TEXT_OR_ICON),
		_import(rightTextOrIcon, DEFAULTS.ON_PRIMARY.RIGHT_TEXT_OR_ICON),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnPrimary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Primary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.PrimaryContainer)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnPrimaryContainer)
		end, styleState),
		_import(elevation, DEFAULTS.ON_PRIMARY.ELEVATION),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.tertiary(
	style: CanBeState<Style>,
	onChange: CanBeState<(onChange: number) -> ()>,
	initialValue: CanBeState<number>,
	minimum: CanBeState<number?>,
	maximum: CanBeState<number?>,
	increment: CanBeState<number?>,
	leftTextOrIcon: CanBeState<string | ImageData | nil>,
	rightTextOrIcon: CanBeState<string | ImageData | nil>,
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

	local styleState: State<Style> = _import(style, DEFAULTS.TERTIARY.STYLE)

	local out = Interface.new(
		_import(elevation, DEFAULTS.TERTIARY.ON_CHANGE),
		_import(elevation, DEFAULTS.TERTIARY.INITIAL_VALUE),
		_import(elevation, DEFAULTS.TERTIARY.MINIMUM),
		_import(elevation, DEFAULTS.TERTIARY.MAXIMUM),
		_import(elevation, DEFAULTS.TERTIARY.INCREMENT),
		_import(leftTextOrIcon, DEFAULTS.TERTIARY.LEFT_TEXT_OR_ICON),
		_import(rightTextOrIcon, DEFAULTS.TERTIARY.RIGHT_TEXT_OR_ICON),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnSurface)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Surface)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Tertiary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.TertiaryContainer)
		end, styleState),
		_import(elevation, DEFAULTS.TERTIARY.ELEVATION),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.secondary(
	style: CanBeState<Style>,
	onChange: CanBeState<(onChange: number) -> ()>,
	initialValue: CanBeState<number>,
	minimum: CanBeState<number?>,
	maximum: CanBeState<number?>,
	increment: CanBeState<number?>,
	leftTextOrIcon: CanBeState<string | ImageData | nil>,
	rightTextOrIcon: CanBeState<string | ImageData | nil>,
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

	local styleState: State<Style> = _import(style, DEFAULTS.SECONDARY.STYLE)

	local out = Interface.new(
		_import(elevation, DEFAULTS.SECONDARY.ON_CHANGE),
		_import(elevation, DEFAULTS.SECONDARY.INITIAL_VALUE),
		_import(elevation, DEFAULTS.SECONDARY.MINIMUM),
		_import(elevation, DEFAULTS.SECONDARY.MAXIMUM),
		_import(elevation, DEFAULTS.SECONDARY.INCREMENT),
		_import(leftTextOrIcon, DEFAULTS.SECONDARY.LEFT_TEXT_OR_ICON),
		_import(rightTextOrIcon, DEFAULTS.SECONDARY.RIGHT_TEXT_OR_ICON),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnSurface)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Surface)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Secondary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.SecondaryContainer)
		end, styleState),
		_import(elevation, DEFAULTS.SECONDARY.ELEVATION),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.primary(
	style: CanBeState<Style>,
	onChange: CanBeState<(onChange: number) -> ()>,
	initialValue: CanBeState<number>,
	minimum: CanBeState<number?>,
	maximum: CanBeState<number?>,
	increment: CanBeState<number?>,
	leftTextOrIcon: CanBeState<string | ImageData | nil>,
	rightTextOrIcon: CanBeState<string | ImageData | nil>,
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

	local styleState: State<Style> = _import(style, DEFAULTS.PRIMARY.STYLE)

	local out = Interface.new(
		_import(elevation, DEFAULTS.PRIMARY.ON_CHANGE),
		_import(elevation, DEFAULTS.PRIMARY.INITIAL_VALUE),
		_import(elevation, DEFAULTS.PRIMARY.MINIMUM),
		_import(elevation, DEFAULTS.PRIMARY.MAXIMUM),
		_import(elevation, DEFAULTS.PRIMARY.INCREMENT),
		_import(leftTextOrIcon, DEFAULTS.PRIMARY.LEFT_TEXT_OR_ICON),
		_import(rightTextOrIcon, DEFAULTS.PRIMARY.RIGHT_TEXT_OR_ICON),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.OnSurface)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Surface)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Primary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.PrimaryContainer)
		end, styleState),
		_import(elevation, DEFAULTS.PRIMARY.ELEVATION),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.LabelLarge)
		end, styleState),
		_Computed(function(s: Style): number
			return s.Scale
		end, styleState)
	)
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.new(
	onChange: CanBeState<(onChange: number) -> ()>,
	initialValue: CanBeState<number>,
	minimum: CanBeState<number?>,
	maximum: CanBeState<number?>,
	increment: CanBeState<number?>,
	leftTextOrIcon: CanBeState<string | ImageData | nil>,
	rightTextOrIcon: CanBeState<string | ImageData | nil>,
	onBackgroundColor: CanBeState<Color3>,
	onBackgroundTextColor: CanBeState<Color3>,
	fillColor: CanBeState<Color3>,
	fillContainerColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	schemeType: CanBeState<Enums.SchemeType>,
	fontData: CanBeState<FontData>,
	scale: CanBeState<number>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local scaleState: State<number> = _import(scale, DEFAULTS.NEW.SCALE)
	local schemeTypeState: State<Enums.SchemeType> = _import(schemeType, DEFAULTS.NEW.SCHEME_TYPE)
	local fontDataState: State<FontData> = _import(fontData, DEFAULTS.NEW.FONT_DATA)

	local onChangeState: State<(val: number) -> ()> = _import(onChange, DEFAULTS.NEW.ON_CHANGE)
	local leftLabelState: State<string | ImageData | nil> = _import(leftTextOrIcon, nil :: ImageData?)
	local rightLabelState: State<string | ImageData | nil> = _import(rightTextOrIcon, nil :: ImageData?)
	local initialValueState: State<number> = _import(initialValue, DEFAULTS.NEW.INITIAL_VALUE)

	local minState: State<number> = _import(minimum, DEFAULTS.NEW.MINIMUM)
	local maxState: State<number> = _import(maximum, DEFAULTS.NEW.MAXIMUM)
	local incrementState: State<number?> = _import(increment, DEFAULTS.NEW.INCREMENT)

	local elevationState = _import(elevation, DEFAULTS.NEW.ELEVATION)

	local onBackgroundColorState = _Computed(function(c: Color3, e: number, st: Enums.SchemeType): Color3
		return Theme.getElevatedColor(c, e, st)
	end, _import(onBackgroundColor, DEFAULTS.NEW.ON_BACKGROUND_COLOR), elevationState, schemeTypeState)

	local onBackgroundTextColorState = _Computed(
		function(c: Color3, e: number, st: Enums.SchemeType): Color3
			return Theme.getElevatedColor(c, e, st)
		end,
		_import(onBackgroundTextColor, DEFAULTS.NEW.ON_BACKGROUND_TEXT_COLOR),
		elevationState,
		schemeTypeState
	)

	local fillColorState = _Computed(function(c: Color3, e: number, st: Enums.SchemeType): Color3
		return Theme.getElevatedColor(c, e, st)
	end, _import(fillColor, DEFAULTS.NEW.FILL_COLOR), elevationState, schemeTypeState)

	local fillContainerColorState = _Computed(function(c: Color3, e: number, st: Enums.SchemeType): Color3
		return Theme.getElevatedColor(c, e, st)
	end, _import(fillContainerColor, DEFAULTS.NEW.FILL_CONTAINER_COLOR), elevationState, schemeTypeState)

	local isSelectedState = _Value(false)

	local iconSizeState = _Computed(function(sc: number): UDim2
		return UDim2.fromOffset(sc * ICON_WIDTH_DP, sc * ICON_WIDTH_DP)
	end, scaleState)

	local cursorFullWidthState = _Computed(function(sc: number, isSel: boolean): UDim
		return UDim.new(
			0,
			sc * ((if isSel then CURSOR_SELECTED_WIDTH_DP else CURSOR_WIDTH_DP) + CURSOR_WIDTH_PADDING_DP * 2)
		)
	end, scaleState, isSelectedState)

	local inputState: ValueState<number?> = _Value(nil :: number?)

	local pointFillState = _Computed(
		function(initial: number, input: number?, min: number, max: number, inc: number?): number
			local rawVal = math.clamp(input or initial, min, max)
			if inc then
				return math.round(rawVal / inc) * inc
			else
				return rawVal
			end
		end,
		initialValueState,
		inputState,
		minState,
		maxState,
		incrementState
	)

	local fillState = _Computed(function(point: number, min: number, max: number, inc: number?): number
		local rawVal = math.clamp(point, min, max) / math.max(max - min, 1)
		if inc then
			return math.round(rawVal * inc) / inc
		else
			return rawVal
		end
	end, pointFillState, minState, maxState, incrementState)

	local incrementMaid = maid:GiveTask(Maid.new())

	local leftBar = _new("ImageLabel")({
		LayoutOrder = 1,
		Position = UDim2.fromScale(0, 0.5),
		AnchorPoint = Vector2.new(0, 0.5),
		AutomaticSize = Enum.AutomaticSize.None,
		Image = LEFT_CIRCLE_IMAGE,
		BackgroundTransparency = 1,
		ImageColor3 = fillColor,
		SliceCenter = CIRCLE_IMAGE_RECT,
		SliceScale = 1,
		ScaleType = Enum.ScaleType.Slice,
		Size = _Computed(function(sc: number, fill: number, fullWidth: UDim): UDim2
			return UDim2.new(math.max(fill - sc * 0.5, 0), -fullWidth.Offset * 0.5, 0, sc * BAR_HEIGHT_DP)
		end, scaleState, fillState, cursorFullWidthState),
	}) :: ImageLabel

	local rightBar = _new("ImageLabel")({
		LayoutOrder = 2,
		Position = UDim2.fromScale(1, 0.5),
		AnchorPoint = Vector2.new(1, 0.5),
		AutomaticSize = Enum.AutomaticSize.None,
		Image = RIGHT_CIRCLE_IMAGE,
		BackgroundTransparency = 1,
		ImageColor3 = fillContainerColor,
		SliceCenter = CIRCLE_IMAGE_RECT,
		SliceScale = 1,
		ScaleType = Enum.ScaleType.Slice,
		Size = _Computed(function(sc: number, fill: number, fullWidth: UDim): UDim2
			return UDim2.new(
				math.max((1 - fill) - fullWidth.Scale * 0.5, 0),
				-fullWidth.Offset * 0.5,
				0,
				sc * BAR_HEIGHT_DP
			)
		end, scaleState, fillState, cursorFullWidthState),
	}) :: ImageLabel

	local cursor = _new("Frame")({
		LayoutOrder = 1,
		ZIndex = 10,
		Position = _Computed(function(fill: number): UDim2
			return UDim2.fromScale(fill, 0.5)
		end, fillState),
		BackgroundColor3 = fillColor,
		AnchorPoint = _Computed(function(fill: number): Vector2
			return Vector2.new(if fill == 1 then 1 elseif fill == 0 then 0 else 0.5, 0.5)
		end, fillState),
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundTransparency = 0,
		Size = _Computed(function(sc: number, fullWidth: UDim, isSel: boolean): UDim2
			return UDim2.fromOffset(
				sc * (if isSel then CURSOR_SELECTED_WIDTH_DP else CURSOR_WIDTH_DP),
				sc * CURSOR_HEIGHT_DP
			)
		end, scaleState, cursorFullWidthState, isSelectedState),
		Children = {
			_new("UICorner")({
				CornerRadius = UDim.new(0.5, 0),
			}),
		},
	}) :: Frame
	local dotContainer = _new("Frame")({
		ZIndex = 5,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundTransparency = 1,
		Size = _Computed(function(sc: number): UDim2
			return UDim2.new(1, 0, sc * CURSOR_HEIGHT_DP, 0)
		end, scaleState),
		Children = {
			maid:GiveTask(Util.Padding.ColdFusion.new(
				_Computed(function(sc: number): UDim
					return UDim.new(0, sc * BAR_LEFT_RIGHT_INNER_PADDING_DP)
				end, scaleState),
				_Computed(function(sc: number): UDim
					return UDim.new(0, sc * BAR_UP_DOWN_INNER_PADDING_DP)
				end, scaleState)
			)) :: Instance,
			_new("UICorner")({
				CornerRadius = UDim.new(0.5, 0),
			}),
		},
	}) :: Frame

	local function updateIncrementMarks()
		incrementMaid:DoCleaning()

		local inc = incrementState:Get()
		if inc then
			local val = pointFillState:Get()
			local min = minState:Get()
			local max = maxState:Get()
			local count = (max - min) / inc
			local limit = math.ceil(count)
			for i = 0, limit do
				local alpha = (i / limit)

				local v = i * inc + min
				if v < val then
					local dot = incrementMaid:GiveTask(newDot(fillContainerColorState, scaleState))
					dot.Position = UDim2.fromScale(alpha, 0.5)
					dot.Parent = dotContainer
				elseif v > val then
					local dot = incrementMaid:GiveTask(newDot(fillColorState, scaleState))
					dot.Position = UDim2.fromScale(alpha, 0.5)
					dot.Parent = dotContainer
				end
			end
		end
	end
	maid:GiveTask(incrementState:Connect(function()
		updateIncrementMarks()
	end))
	updateIncrementMarks()
	maid:GiveTask(fillState:Connect(function()
		updateIncrementMarks()
		onChangeState:Get()(pointFillState:Get())
	end))
	_bind(
		maid:GiveTask(
			Util.PopUp.ColdFusion.fromGuiObject(
				cursor,
				Vector2.new(0.5, -(BUBBLE_GAP_DP / BAR_HEIGHT_DP)),
				Vector2.new(0.5, 1)
			)
		)
	)({
		Visible = isSelectedState,
		BackgroundTransparency = 0,
		BackgroundColor3 = onBackgroundColorState,
		AutomaticSize = Enum.AutomaticSize.XY,
		Children = {
			maid:GiveTask(Util.List.ColdFusion.center()) :: Instance,
			maid:GiveTask(Util.Padding.ColdFusion.new(
				_Computed(function(sc: number): UDim
					return UDim.new(0, sc * BUBBLE_LEFT_RIGHT_PADDING)
				end, scaleState),
				_Computed(function(sc: number): UDim
					return UDim.new(0, sc * BUBBLE_UP_DOWN_PADDING)
				end, scaleState)
			)),
			_new("UICorner")({
				CornerRadius = _Computed(function(sc: number, isSel: boolean): UDim
					return UDim.new(0, sc * BUBBLE_LEFT_RIGHT_PADDING)
				end, scaleState, isSelectedState),
			}),
			_new("TextLabel")({
				Text = _Computed(function(fill: number): string
					return tostring(math.round(fill))
				end, pointFillState),
				RichText = true,
				TextColor3 = onBackgroundTextColorState,
				TextTransparency = 0,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = _Computed(function(f: FontData, sc: number): number
					return Typography.getTextSize(f.Size, sc)
				end, fontDataState, scaleState),
				LineHeight = _Computed(function(f: FontData, sc: number): number
					return Typography.getGuiLineHeight(f.LineHeight, f.Size)
				end, fontDataState, scaleState),
				FontFace = _Computed(function(f: FontData): Font
					return f.Font
				end, fontDataState),
				Size = UDim2.fromOffset(0, 0),
			}),
		},
	})

	maid:GiveTask(RunService.RenderStepped:Connect(function()
		rightBar.Visible = rightBar.AbsoluteSize.X >= 0
		leftBar.Visible = leftBar.AbsoluteSize.X >= 0
	end))

	local button = _new("TextButton")({
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = "",
		Events = {
			MouseButton1Down = function()
				isSelectedState:Set(true)
			end,
			MouseButton1Up = function()
				isSelectedState:Set(false)
			end,
		},
		Children = {

			_new("UIFlexItem")({
				FlexMode = Enum.UIFlexMode.Fill,
				ItemLineAlignment = Enum.ItemLineAlignment.Automatic,
			}),
			_new("UISizeConstraint")({
				MaxSize = Vector2.new(math.huge, math.huge),
				MinSize = _Computed(function(sc: number): Vector2
					return Vector2.new(sc * MIN_WIDTH_DP, 0)
				end, scaleState),
			}),
			cursor,
			dotContainer,
			leftBar,
			rightBar,
		},
	}) :: TextButton
	maid:GiveTask(button.MouseLeave:Connect(function()
		isSelectedState:Set(false)
	end))
	maid:GiveTask(button.InputBegan:Connect(function(inputObject: InputObject)
		if
			inputObject.UserInputType == Enum.UserInputType.MouseButton1
			or inputObject.UserInputType == Enum.UserInputType.Touch
		then
			inputState:Set(100 * (inputObject.Position.X - button.AbsolutePosition.X) / button.AbsoluteSize.X)
		end
	end))
	maid:GiveTask(button.InputChanged:Connect(function(inputObject: InputObject)
		if inputObject.UserInputType == Enum.UserInputType.MouseMovement and isSelectedState:Get() then
			inputState:Set(100 * (inputObject.Position.X - button.AbsolutePosition.X) / button.AbsoluteSize.X)
		end
	end))
	local inst = _new("Frame")({
		AutomaticSize = Enum.AutomaticSize.None,
		BackgroundTransparency = 1,
		Size = _Computed(function(sc: number): UDim2
			return UDim2.fromOffset(0, sc * CURSOR_HEIGHT_DP)
		end, scaleState),
		Children = {
			_new("TextLabel")({
				Text = _Computed(function(icon: ImageData | string | nil): string | nil
					return if type(icon) == "string" then icon else ""
				end, leftLabelState),
				RichText = true,
				LayoutOrder = 1,
				Visible = _Computed(function(icon: ImageData | string | nil): boolean
					return type(icon) == "string"
				end, leftLabelState),
				TextColor3 = onBackgroundColorState,
				TextTransparency = 0,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = _Computed(function(f: FontData, sc: number): number
					return Typography.getTextSize(f.Size, sc)
				end, fontDataState, scaleState),
				LineHeight = _Computed(function(f: FontData, sc: number): number
					return Typography.getGuiLineHeight(f.LineHeight, f.Size)
				end, fontDataState, scaleState),
				FontFace = _Computed(function(f: FontData): Font
					return f.Font
				end, fontDataState),
				Size = UDim2.fromOffset(0, 0),
			}),
			_new("TextLabel")({
				Text = _Computed(function(icon: ImageData | string | nil): string | nil
					return if type(icon) == "string" then icon else ""
				end, rightLabelState),
				RichText = true,
				LayoutOrder = 4,
				Visible = _Computed(function(icon: ImageData | string | nil): boolean
					return type(icon) == "string"
				end, rightLabelState),
				TextColor3 = onBackgroundColorState,
				TextTransparency = 0,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = _Computed(function(f: FontData, sc: number): number
					return Typography.getTextSize(f.Size, sc)
				end, fontDataState, scaleState),
				LineHeight = _Computed(function(f: FontData, sc: number): number
					return Typography.getGuiLineHeight(f.LineHeight, f.Size)
				end, fontDataState, scaleState),
				FontFace = _Computed(function(f: FontData): Font
					return f.Font
				end, fontDataState),
				Size = UDim2.fromOffset(0, 0),
			}),
			_bind(
				maid:GiveTask(
					Util.ImageLabel.ColdFusion.new(
						_Computed(function(icon: ImageData | string | nil): ImageData | nil
							return if type(icon) == "table" then icon else nil
						end, leftLabelState),
						onBackgroundColorState,
						nil
					)
				)
			)({
				Visible = _Computed(function(icon: ImageData | string | nil): boolean
					return type(icon) == "table"
				end, leftLabelState),
				LayoutOrder = 1,
				Size = iconSizeState,
			}) :: Instance,
			_bind(
				maid:GiveTask(
					Util.ImageLabel.ColdFusion.new(
						_Computed(function(icon: ImageData | string | nil): ImageData | nil
							return if type(icon) == "table" then icon else nil
						end, rightLabelState),
						onBackgroundColorState,
						nil
					)
				)
			)({
				Visible = _Computed(function(icon: ImageData | string | nil): boolean
					return type(icon) == "table"
				end, rightLabelState),
				LayoutOrder = 3,
				Size = iconSizeState,
			}) :: Instance,
			button,
			maid:GiveTask(
				Util.List.ColdFusion.new(
					Enum.VerticalAlignment.Center,
					Enum.HorizontalAlignment.Center,
					Enum.FillDirection.Horizontal,
					_Computed(function(sc: number): UDim
						return UDim.new(0, sc * ICON_PADDING_DP)
					end, scaleState),
					Enum.UIFlexAlignment.Fill,
					Enum.UIFlexAlignment.None,
					Enum.ItemLineAlignment.Center,
					false
				)
			),
		},
	}) :: Frame

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

return Interface
