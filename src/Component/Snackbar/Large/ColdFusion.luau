--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local IconButton =
	require(_Package:WaitForChild("Component"):WaitForChild("Button"):WaitForChild("IconButton"))
local TextButton =
	require(_Package:WaitForChild("Component"):WaitForChild("Button"):WaitForChild("TextButton"))
local Util = require(_Package:WaitForChild("Util"))
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Typography = require(_Package:WaitForChild("Typography"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type Style = Style.Style
type Method = () -> ()
type FontData = Types.FontData

-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
local PADDING_DP = 8
local CORNER_DP = 4
-- Variables
-- References
local Icons = MaterialIcons.default.dp_48.scale_1

-- Private Functions

-- Class
local Interface = {}

function Interface.surfaceContainer(
	style: CanBeState<Style>,
	text: CanBeState<string>,
	buttonText: CanBeState<string?>,
	onButtonClick: CanBeState<Method?>,
	onCloseClick: CanBeState<Method?>,
	elevation: CanBeState<number?>
)
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, DEFAULTS.SURFACE_CONTAINER.STYLE)
	local elevationState: State<number> = _import(elevation, DEFAULTS.SURFACE_CONTAINER.ELEVATION)

	local inst = Interface.new(
		_import(text, DEFAULTS.SURFACE_CONTAINER.TEXT),
		_import(buttonText, DEFAULTS.SURFACE_CONTAINER.BUTTON_TEXT),
		_import(onButtonClick, DEFAULTS.SURFACE_CONTAINER.ON_BUTTON_CLICK),
		_import(onCloseClick, DEFAULTS.SURFACE_CONTAINER.ON_CLOSE_CLICK),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.OnSurface, e)
		end, styleState, elevationState),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.Primary, e)
		end, styleState, elevationState),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.SurfaceContainer, e)
		end, styleState, elevationState),
		1,
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

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

function Interface.primaryContainer(
	style: CanBeState<Style>,
	text: CanBeState<string>,
	buttonText: CanBeState<string?>,
	onButtonClick: CanBeState<Method?>,
	onCloseClick: CanBeState<Method?>,
	elevation: CanBeState<number?>
)
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, DEFAULTS.PRIMARY_CONTAINER.STYLE)
	local elevationState: State<number> = _import(elevation, DEFAULTS.PRIMARY_CONTAINER.ELEVATION)

	local inst = Interface.new(
		_import(text, DEFAULTS.PRIMARY_CONTAINER.TEXT),
		_import(buttonText, DEFAULTS.PRIMARY_CONTAINER.BUTTON_TEXT),
		_import(onButtonClick, DEFAULTS.PRIMARY_CONTAINER.ON_BUTTON_CLICK),
		_import(onCloseClick, DEFAULTS.PRIMARY_CONTAINER.ON_CLOSE_CLICK),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.OnPrimaryContainer, e)
		end, styleState, elevationState),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.Primary, e)
		end, styleState, elevationState),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.PrimaryContainer, e)
		end, styleState, elevationState),
		1,
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

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

function Interface.secondaryContainer(
	style: CanBeState<Style>,
	text: CanBeState<string>,
	buttonText: CanBeState<string?>,
	onButtonClick: CanBeState<Method?>,
	onCloseClick: CanBeState<Method?>,
	elevation: CanBeState<number?>
)
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, DEFAULTS.SECONDARY_CONTAINER.STYLE)
	local elevationState: State<number> = _import(elevation, DEFAULTS.SECONDARY_CONTAINER.ELEVATION)

	local inst = Interface.new(
		_import(text, DEFAULTS.SECONDARY_CONTAINER.TEXT),
		_import(buttonText, DEFAULTS.SECONDARY_CONTAINER.BUTTON_TEXT),
		_import(onButtonClick, DEFAULTS.SECONDARY_CONTAINER.ON_BUTTON_CLICK),
		_import(onCloseClick, DEFAULTS.SECONDARY_CONTAINER.ON_CLOSE_CLICK),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.OnSecondaryContainer, e)
		end, styleState, elevationState),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.Secondary, e)
		end, styleState, elevationState),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.SecondaryContainer, e)
		end, styleState, elevationState),
		1,
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

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

function Interface.tertiaryContainer(
	style: CanBeState<Style>,
	text: CanBeState<string>,
	buttonText: CanBeState<string?>,
	onButtonClick: CanBeState<Method?>,
	onCloseClick: CanBeState<Method?>,
	elevation: CanBeState<number?>
)
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, DEFAULTS.TERTIARY_CONTAINER.STYLE)
	local elevationState: State<number> = _import(elevation, DEFAULTS.TERTIARY_CONTAINER.ELEVATION)

	local inst = Interface.new(
		_import(text, DEFAULTS.TERTIARY_CONTAINER.TEXT),
		_import(buttonText, DEFAULTS.TERTIARY_CONTAINER.BUTTON_TEXT),
		_import(onButtonClick, DEFAULTS.TERTIARY_CONTAINER.ON_BUTTON_CLICK),
		_import(onCloseClick, DEFAULTS.TERTIARY_CONTAINER.ON_CLOSE_CLICK),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.OnTertiaryContainer, e)
		end, styleState, elevationState),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.Tertiary, e)
		end, styleState, elevationState),
		_Computed(function(s: Style, e: number?): Color3
			return s:GetColor(Enums.ColorRoleType.TertiaryContainer, e)
		end, styleState, elevationState),
		1,
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

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

function Interface.new(
	text: CanBeState<string>,
	buttonText: CanBeState<string?>,
	onButtonClick: CanBeState<Method?>,
	onCloseClick: CanBeState<Method?>,
	textColor: CanBeState<Color3>,
	buttonTextColor: CanBeState<Color3>,
	backgroundColor: CanBeState<Color3>,
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

	local buttonTextState: State<string> = _import(buttonText, DEFAULTS.NEW.BUTTON_TEXT)

	local textState: State<string> = _import(text, DEFAULTS.NEW.TEXT)
	local elevationState: State<number> = _import(elevation, DEFAULTS.NEW.ELEVATION)

	local onButtonClickState = _import(onButtonClick, DEFAULTS.NEW.ON_BUTTON_CLICK)
	local onCloseClickState = _import(onCloseClick, DEFAULTS.NEW.ON_CLOSE_CLICK)

	local backgroundColorState = _import(backgroundColor, DEFAULTS.NEW.BACKGROUND_COLOR)
	local textColorState = _import(textColor, DEFAULTS.NEW.TEXT_COLOR)
	local buttonTextColorState = _import(buttonTextColor, DEFAULTS.NEW.BUTTON_TEXT_COLOR)

	local inst: Frame = _new("Frame")({
		Name = "Snackbar",
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = backgroundColorState,
		Children = {
			maid:GiveTask(Util.Padding.ColdFusion.new(
				_Computed(function(sc: number): UDim
					return UDim.new(0, sc * PADDING_DP)
				end, scaleState),
				_Computed(function(sc: number): UDim
					return UDim.new(0, sc * PADDING_DP)
				end, scaleState)
			)) :: Instance,
			maid:GiveTask(_new("UICorner")({
				CornerRadius = _Computed(function(sc: number): UDim
					return UDim.new(0, sc * CORNER_DP)
				end, scaleState),
			})),
			maid:GiveTask(
				Util.List.ColdFusion.new(
					Enum.VerticalAlignment.Center,
					Enum.HorizontalAlignment.Right,
					Enum.FillDirection.Vertical,
					_Computed(function(sc: number): UDim
						return UDim.new(0, sc * PADDING_DP)
					end, scaleState),
					Enum.UIFlexAlignment.None,
					Enum.UIFlexAlignment.Fill,
					Enum.ItemLineAlignment.Stretch,
					false
				)
			),
			_new("TextLabel")({
				Name = "Text",
				Text = textState,
				RichText = true,
				TextWrapped = true,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextXAlignment = Enum.TextXAlignment.Left,
				LayoutOrder = 1,
				Visible = _Computed(function(h: string): boolean
					return h:len() > 0
				end, textState),
				TextColor3 = textColorState,
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
				Children = {
					_new("UIFlexItem")({
						FlexMode = Enum.UIFlexMode.Shrink,
						ItemLineAlignment = Enum.ItemLineAlignment.Center,
					}),
				},
			}) :: Instance,
			_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
				LayoutOrder = 3,
				Name = "Buttons",
				Children = {
					maid:GiveTask(
						Util.List.ColdFusion.new(
							Enum.VerticalAlignment.Center,
							Enum.HorizontalAlignment.Right,
							Enum.FillDirection.Horizontal,
							UDim.new(0, 0),
							Enum.UIFlexAlignment.None,
							Enum.UIFlexAlignment.None,
							Enum.ItemLineAlignment.Stretch,
							false
						)
					) :: Instance,
					_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
						LayoutOrder = 2,
						Name = "Button",
						Visible = _Computed(function(onClick: Method?): boolean
							return onClick ~= nil
						end, onButtonClickState),
						Children = {
							maid:GiveTask(Util.List.ColdFusion.center()) :: Instance,
							maid:GiveTask(
								TextButton.ColdFusion.new(
									_Computed(function(onClick: Method?): Method
										return onClick or function() end
									end, onButtonClickState),
									buttonTextState,
									nil,
									buttonTextColorState,
									textColorState,
									_Computed(function(onClick: Method?): boolean
										return onClick ~= nil
									end, onButtonClickState),
									elevationState,
									schemeTypeState,
									fontDataState,
									scaleState
								)
							) :: Instance,
						},
					}),
					_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
						LayoutOrder = 3,
						Name = "ExitButton",
						Visible = _Computed(function(onClick: Method?): boolean
							return onClick ~= nil
						end, onCloseClickState),
						Children = {
							maid:GiveTask(Util.List.ColdFusion.center()) :: Instance,
							maid:GiveTask(
								IconButton.ColdFusion.new(
									_Computed(function(onClick: Method?): Method
										return onClick or function() end
									end, onCloseClickState),
									Icons.close,
									textColorState,
									textColorState,
									_Computed(function(onClick: Method?): boolean
										return onClick ~= nil
									end, onCloseClickState),
									elevationState,
									schemeTypeState,
									fontDataState,
									scaleState
								)
							) :: Instance,
						},
					}),
				},
			}),
		},
	}) :: Frame

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

return Interface
