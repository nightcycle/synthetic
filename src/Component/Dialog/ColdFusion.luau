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
local Button = require(_Package:WaitForChild("Component"):WaitForChild("Button"):WaitForChild("TextButton"))
local Util = require(_Package:WaitForChild("Util"))
local Typography = require(_Package:WaitForChild("Typography"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type ImageData = Types.ImageData
type ButtonData = Types.ButtonData
type Style = Style.Style
type FontData = Types.FontData
-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
local ELEVATION = 6
local LIST_PAD_DP = 16
local ICON_SIZE_DP = 24
local SHAPE_DP = 28
local PADDING_DP = 24
local BUTTON_LIST_PAD_DP = 8
local MAX_BUTTON_COUNT = 2
local MIN_DESC_WIDTH_DP = 225
-- Variables
-- References
-- Private Functions
-- Class
local Interface = {}

function newThemedComponent(
	themeDefaults: typeof(DEFAULTS.PRIMARY),
	style: CanBeState<Style>,

	surfaceColor: Enums.ColorRoleType,
	buttonTextColor: Enums.ColorRoleType,
	disabledTextColor: Enums.ColorRoleType,
	headlineColor: Enums.ColorRoleType,
	descriptionColor: Enums.ColorRoleType,
	scrimColor: Enums.ColorRoleType,

	buttons: CanBeState<{ ButtonData }>,
	icon: CanBeState<ImageData?>,
	headline: CanBeState<string?>,
	description: CanBeState<string?>
): GuiObject
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, themeDefaults.STYLE)

	local out = Interface.new(
		_import(buttons, themeDefaults.BUTTONS),
		_import(icon, themeDefaults.ICON),
		_import(headline, themeDefaults.HEADLINE),
		_import(description, themeDefaults.DESCRIPTION),
		_Computed(function(s: Style): Color3
			return s:GetColor(surfaceColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(buttonTextColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(disabledTextColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(headlineColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(descriptionColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(scrimColor)
		end, styleState),
		_Computed(function(s: Style): any
			return s.SchemeType
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.HeadlineSmall)
		end, styleState),
		_Computed(function(s: Style): FontData
			return s:GetFontData(Enums.FontType.BodyMedium)
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

Interface = {}

function Interface.primary(
	style: CanBeState<Style>,
	buttons: CanBeState<{ ButtonData }>,
	icon: CanBeState<ImageData?>,
	headline: CanBeState<string?>,
	description: CanBeState<string?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.PRIMARY,
		style,
		Enums.ColorRoleType.SurfaceContainerHigh,
		Enums.ColorRoleType.Primary,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceTint,
		buttons,
		icon,
		headline,
		description
	)
end

function Interface.secondary(
	style: CanBeState<Style>,
	buttons: CanBeState<{ ButtonData }>,
	icon: CanBeState<ImageData?>,
	headline: CanBeState<string?>,
	description: CanBeState<string?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.SECONDARY,
		style,
		Enums.ColorRoleType.SurfaceContainerHigh,
		Enums.ColorRoleType.Secondary,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceTint,
		buttons,
		icon,
		headline,
		description
	)
end

function Interface.tertiary(
	style: CanBeState<Style>,
	buttons: CanBeState<{ ButtonData }>,
	icon: CanBeState<ImageData?>,
	headline: CanBeState<string?>,
	description: CanBeState<string?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.TERTIARY,
		style,
		Enums.ColorRoleType.SurfaceContainerHigh,
		Enums.ColorRoleType.Tertiary,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.OnSurfaceVariant,
		Enums.ColorRoleType.SurfaceTint,
		buttons,
		icon,
		headline,
		description
	)
end

function Interface.new(

	buttons: CanBeState<{ ButtonData }>,

	icon: CanBeState<ImageData?>,
	headline: CanBeState<string?>,
	description: CanBeState<string?>,

	surfaceColor: CanBeState<Color3>,
	buttonTextColor: CanBeState<Color3>,
	disabledTextColor: CanBeState<Color3>,
	headlineColor: CanBeState<Color3>,
	descriptionColor: CanBeState<Color3>,
	scrimColor: CanBeState<Color3>,
	schemeType: CanBeState<Enums.SchemeType>,
	headlineFontData: CanBeState<FontData>,
	bodyFontData: CanBeState<FontData>,
	buttonFontData: CanBeState<FontData>,
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
	local headlineFontDataState: State<FontData> = _import(headlineFontData, DEFAULTS.NEW.HEADLINE_FONT_DATA)
	local bodyFontDataState: State<FontData> = _import(bodyFontData, DEFAULTS.NEW.BODY_FONT_DATA)
	local buttonFontDataState: State<FontData> = _import(buttonFontData, DEFAULTS.NEW.BUTTON_FONT_DATA)

	local iconState = _import(icon, DEFAULTS.NEW.ICON)

	local headlineState: State<string?> = _import(headline, DEFAULTS.NEW.HEADLINE)
	local descriptionState: State<string?> = _import(description, DEFAULTS.NEW.DESCRIPTION)

	local buttonsState: State<{ ButtonData }> = _import(buttons, DEFAULTS.NEW.BUTTONS)

	local surfaceColorState: State<Color3> = _import(surfaceColor, DEFAULTS.NEW.SURFACE_COLOR)
	local buttonTextColorState: State<Color3> = _import(buttonTextColor, DEFAULTS.NEW.BUTTON_TEXT_COLOR)
	local disabledButtonTextColorState: State<Color3> =
		_import(disabledTextColor, DEFAULTS.NEW.DISABLED_TEXT_COLOR)

	local headlineColorState: State<Color3> = _import(headlineColor, DEFAULTS.NEW.HEADLINE_COLOR)
	local descriptionColorState: State<Color3> = _import(descriptionColor, DEFAULTS.NEW.DESCRIPTION_COLOR)
	local scrimColorState: State<Color3> = _import(scrimColor, DEFAULTS.NEW.SCRIM_COLOR)

	local buttonContainer = _bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
		LayoutOrder = 10,
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(sc: number): UDim
					return UDim.new(0, sc * BUTTON_LIST_PAD_DP)
				end, scaleState),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
			}),
		},
	})

	local inst = _new("Frame")({
		Size = UDim2.fromScale(0, 0),
		BackgroundTransparency = 0.5,
		BackgroundColor3 = scrimColorState,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(1, 1),
		AutomaticSize = Enum.AutomaticSize.XY,
		Children = {
			_new("UIListLayout")({
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			_new("Frame")({
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromScale(0, 0),
				BackgroundColor3 = surfaceColorState,
				Children = {
					maid:GiveTask(
						Util.List.ColdFusion.new(
							Enum.VerticalAlignment.Center,
							Enum.HorizontalAlignment.Center,
							Enum.FillDirection.Vertical,
							_Computed(function(sc: number): UDim
								return UDim.new(0, sc * LIST_PAD_DP)
							end, scaleState),
							Enum.UIFlexAlignment.None,
							Enum.UIFlexAlignment.Fill,
							Enum.ItemLineAlignment.Stretch,
							false
						)
					) :: Instance,
					_new("UICorner")({
						CornerRadius = _Computed(function(sc: number): UDim
							return UDim.new(0, sc * SHAPE_DP)
						end, scaleState),
					}),
					_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
						LayoutOrder = 1,
						Children = {
							_new("ImageLabel")({
								Size = _Computed(function(sc: number): UDim2
									return UDim2.fromOffset(sc * ICON_SIZE_DP, sc * ICON_SIZE_DP)
								end, scaleState),
								Visible = _Computed(function(i: ImageData?): boolean
									return i ~= nil
								end, iconState),
								BackgroundTransparency = 1,
								ImageColor3 = headlineColorState,
								Image = _Computed(function(i: ImageData?): string
									return if i then i.Image else ""
								end, iconState),
								ImageRectOffset = _Computed(function(i: ImageData?): Vector2
									return if i then i.ImageRectOffset else Vector2.zero
								end, iconState),
								ImageRectSize = _Computed(function(i: ImageData?): Vector2
									return if i then i.ImageRectSize else Vector2.zero
								end, iconState),
							}),
							maid:GiveTask(Util.List.ColdFusion.center()),
						},
					}),
					maid:GiveTask(Util.Padding.ColdFusion.new(
						_Computed(function(sc: number): UDim
							return UDim.new(0, sc * PADDING_DP)
						end, scaleState),
						_Computed(function(sc: number): UDim
							return UDim.new(0, sc * PADDING_DP)
						end, scaleState)
					)) :: Instance,
					_new("TextLabel")({
						Text = headlineState,
						LayoutOrder = 1,
						Visible = _Computed(function(h: string?): boolean
							return not (h == nil or h:len() == 0)
						end, headlineState),
						TextColor3 = headlineColorState,
						BackgroundTransparency = 1,
						TextXAlignment = _Computed(function(i: ImageData?): Enum.TextXAlignment
							return if i then Enum.TextXAlignment.Center else Enum.TextXAlignment.Left
						end, iconState),
						AutomaticSize = Enum.AutomaticSize.XY,
						TextSize = _Computed(function(f: FontData, sc: number): number
							return Typography.getTextSize(f.Size, sc)
						end, headlineFontDataState, scaleState),
						LineHeight = _Computed(function(f: FontData, sc: number): number
							return Typography.getGuiLineHeight(f.LineHeight, f.Size)
						end, headlineFontDataState, scaleState),
						FontFace = _Computed(function(f: FontData): Font
							return f.Font
						end, headlineFontDataState),
						Size = UDim2.fromOffset(0, 0),
					}),
					_new("TextLabel")({
						Text = descriptionState,
						LayoutOrder = 2,
						Visible = _Computed(function(d: string?): boolean
							return not (d == nil or d:len() == 0)
						end, descriptionState),
						TextColor3 = descriptionColorState,
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextSize = _Computed(function(f: FontData, sc: number): number
							return Typography.getTextSize(f.Size, sc)
						end, bodyFontDataState, scaleState),
						LineHeight = _Computed(function(f: FontData, sc: number): number
							return Typography.getGuiLineHeight(f.LineHeight, f.Size)
						end, bodyFontDataState, scaleState),
						FontFace = _Computed(function(f: FontData): Font
							return f.Font
						end, bodyFontDataState),
						Size = UDim2.fromOffset(0, 0),
						Children = {
							_new("UISizeConstraint")({
								MinSize = _Computed(function(sc: number): Vector2
									return Vector2.new(sc * MIN_DESC_WIDTH_DP, 0)
								end, scaleState),
							}),
						},
					}),
					buttonContainer,
				},
			}),
		},
	}) :: GuiObject

	for i = 1, MAX_BUTTON_COUNT do
		local buttonDataState = _Computed(function(bList: { ButtonData }): ButtonData?
			if #bList > MAX_BUTTON_COUNT then
				warn("dialogs have a max limit of 2 buttons")
			end
			return bList[i]
		end, buttonsState)

		_bind(maid:GiveTask(Button.ColdFusion.new(
			_Computed(function(bData: ButtonData?): () -> ()
				return if bData then bData.OnClick else function() end
			end, buttonDataState),
			_Computed(function(bData: ButtonData?): string
				return if bData then bData.Text or "" else ""
			end, buttonDataState),
			_Computed(function(bData: ButtonData?): ImageData?
				return if bData then bData.Icon else nil
			end, buttonDataState),
			buttonTextColorState,
			disabledButtonTextColorState,
			_Computed(function(bData: ButtonData?): boolean
				return if bData then bData.Enabled else false
			end, buttonDataState),
			ELEVATION,
			schemeTypeState,
			buttonFontDataState,
			scaleState
		)))({
			LayoutOrder = i,
			Visible = _Computed(function(bData: ButtonData?): boolean
				return bData ~= nil
			end, buttonDataState),
			Parent = buttonContainer,
		})
	end

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

return Interface
