--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Sounds = require(_Package:WaitForChild("Sounds"))
local Enums = require(_Package:WaitForChild("Enums"))
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Theme = require(_Package:WaitForChild("Style"):WaitForChild("Theme"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type ImageData = Types.ImageData
type RenderData = Types.RenderData
type Style = Style.Style
type FontData = Types.FontData

-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
local LABEL_TEXT_ALIGNMENT = Enum.TextXAlignment.Center
local ICON_SIZE_DP = 20
local ICON_PAD_DP = 6
local PAD_DP = 4
local TXT_HEIGHT_DP = 14
local BADGE_PAD_DP = 3
local BADGE_TXT_HEIGHT_DP = 18

-- Variables
-- References
-- Private Functions
-- Class
local Interface = {}

function newThemedComponent(
	themeDefaults: typeof(DEFAULTS.ON_PRIMARY),
	style: CanBeState<Style>,
	textColor: Enums.ColorRoleType,
	hoverColor: Enums.ColorRoleType,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	label: CanBeState<string?>,
	count: CanBeState<number?>,
	elevation: CanBeState<number?>
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
		_import(onClick, themeDefaults.ON_CLICK),
		_import(icon, themeDefaults.ICON),
		_import(label, themeDefaults.LABEL),
		_import(count, themeDefaults.COUNT),
		_Computed(function(s: Style): Color3
			return s:GetColor(textColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(hoverColor)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Error)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.ErrorContainer)
		end, styleState),
		_import(elevation, themeDefaults.ELEVATION),
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

Interface = {}

function Interface.onPrimary(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	label: CanBeState<string?>,
	count: CanBeState<number?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.ON_PRIMARY,
		style,
		Enums.ColorRoleType.OnPrimary,
		Enums.ColorRoleType.InversePrimary,
		onClick,
		icon,
		label,
		count,
		elevation
	)
end

function Interface.onSurface(
	style: CanBeState<Style>,
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	label: CanBeState<string?>,
	count: CanBeState<number?>,
	elevation: CanBeState<number?>
): GuiObject
	return newThemedComponent(
		DEFAULTS.ON_SURFACE,
		style,
		Enums.ColorRoleType.OnSurface,
		Enums.ColorRoleType.InverseSurface,
		onClick,
		icon,
		label,
		count,
		elevation
	)
end

function Interface.new(
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	label: CanBeState<string?>,
	count: CanBeState<number?>,
	textColor: CanBeState<Color3>,
	hoverColor: CanBeState<Color3>,
	errorTextColor: CanBeState<Color3>,
	errorBackgroundColor: CanBeState<Color3>,
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

	local elevationState: State<number> = _import(elevation, DEFAULTS.NEW.ELEVATION)
	local textColorState: State<Color3> = _import(textColor, DEFAULTS.NEW.TEXT_COLOR)
	local hoverColorState: State<Color3> = _import(hoverColor, DEFAULTS.NEW.HOVER_COLOR)

	local errorTextColorState: State<Color3> = _import(errorTextColor, DEFAULTS.NEW.ERROR_TEXT_COLOR)
	local errorBackgroundColorState: State<Color3> =
		_import(errorBackgroundColor, DEFAULTS.NEW.ERROR_BACKGROUND_COLOR)

	local labelState = _import(label, DEFAULTS.NEW.LABEL)
	local countState = _import(count, DEFAULTS.NEW.COUNT)
	local iconState: State<ImageData> = _import(icon, DEFAULTS.NEW.ICON)
	local onClickState = _import(onClick, DEFAULTS.NEW.ON_CLICK)
	local isEnabledState = _Value(true)
	local isFocusedState = _Value(false)
	local isPressedState = _Value(false)
	local isHoveredState = _Value(false)
	local currentStateState = _Computed(
		function(
			isEnab: boolean,
			isFocused: boolean,
			isPressed: boolean,
			isHovered: boolean
		): Enums.ButtonStateType
			if isEnab then
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
		end,
		isEnabledState,
		isFocusedState,
		isPressedState,
		isHoveredState
	) :: State<any>

	local renderDatasState = _Computed(
		function(
			st: Enums.SchemeType,
			sc: number,
			f: FontData,
			e: number,
			hC: Color3,
			tC: Color3,
			i: ImageData?
		): { [Enums.ButtonStateType]: RenderData }
			e += 1
			return {
				[Enums.ButtonStateType.Enabled] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(hC, e, st), 1),
					Types.newAppearanceData(Theme.getElevatedColor(hC, e, st), 1),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e, st), 0),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Hovered] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(hC, e, st), 1),
					Types.newAppearanceData(Theme.getElevatedColor(hC, e + 1, st), 1 - 0.08),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e + 1, st), 0),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Focused] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(hC, e, st), 1),
					Types.newAppearanceData(Theme.getElevatedColor(hC, e, st), 1 - 0.1),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e, st), 0),
					f,
					i,
					nil,
					nil
				),
				[Enums.ButtonStateType.Pressed] = Types.newRenderData(
					sc,
					Types.newAppearanceData(Theme.getElevatedColor(hC, e, st), 1),
					Types.newAppearanceData(Theme.getElevatedColor(hC, e - 1, st), 1 - 0.1),
					Types.newAppearanceData(Theme.getElevatedColor(tC, e - 1, st), 0),
					f,
					i,
					Types.newSoundData(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 1),
					nil
				),
			}
		end,
		schemeTypeState,
		scaleState,
		fontDataState,
		elevationState,
		hoverColorState,
		textColorState,
		iconState
	)

	local currentRenderDataState = _Computed(
		function(state: Enums.ButtonStateType, rDatas: { [Enums.ButtonStateType]: RenderData }): RenderData
			local data = rDatas[state]
			assert(data ~= nil, `no renderData for {state}`)
			return data
		end,
		currentStateState,
		renderDatasState
	)

	local inst = _new("TextButton")({
		Text = "",
		Size = UDim2.new(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Events = {
			Activated = function()
				if isEnabledState:Get() == false then
					return
				end
				local click = onClickState:Get()
				do
					local data: Types.RenderData = currentRenderDataState:Get()
					if data.Sound then
						local sound = Instance.new("Sound")
						sound.Volume = data.Sound.Volume
						sound.SoundId = data.Sound.SoundId
						SoundService:PlayLocalSound(sound)
						sound:Destroy()
					end
				end

				click()
			end,
			MouseButton1Down = function()
				if isEnabledState:Get() == false then
					return
				end
				isPressedState:Set(true)
			end,
			MouseButton1Up = function()
				if isEnabledState:Get() == false then
					return
				end
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
			_new("UIListLayout")({
				Padding = _Computed(function(s: number): UDim
					return UDim.new(0, s * PAD_DP)
				end, scaleState),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			_new("TextLabel")({
				Text = labelState,
				Visible = _Computed(function(txt: string): boolean
					return txt:len() > 0
				end, labelState),
				TextScaled = true,
				TextXAlignment = LABEL_TEXT_ALIGNMENT,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				FontFace = _Computed(function(f: FontData): Font
					return f.Font
				end, fontDataState),
				LayoutOrder = 2,
				TextColor3 = _Computed(function(data: RenderData): Color3
					return if data.Text then data.Text.Color3 else Color3.new(1, 1, 1)
				end, currentRenderDataState),
				TextTransparency = _Computed(function(data: RenderData): number
					return if data.Text then data.Text.Transparency else 1
				end, currentRenderDataState),
				Size = _Computed(function(s: number): UDim2
					return UDim2.fromOffset(0, s * TXT_HEIGHT_DP)
				end, scaleState),
			}),
			_new("Frame")({
				Name = "Badge",
				LayoutOrder = 1,
				BackgroundColor3 = _Computed(function(s: RenderData): Color3
					return s.Background.Color3
				end, currentRenderDataState),
				BackgroundTransparency = _Computed(function(s: RenderData): number
					return s.Background.Transparency
				end, currentRenderDataState),
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromOffset(0, 0),
				Children = {
					_new("UIPadding")({
						PaddingLeft = _Computed(function(s: number): UDim
							return UDim.new(0, s * ICON_PAD_DP * 3)
						end, scaleState),
						PaddingRight = _Computed(function(s: number): UDim
							return UDim.new(0, s * ICON_PAD_DP * 3)
						end, scaleState),
						PaddingTop = _Computed(function(s: number): UDim
							return UDim.new(0, s * ICON_PAD_DP)
						end, scaleState),
						PaddingBottom = _Computed(function(s: number): UDim
							return UDim.new(0, s * ICON_PAD_DP)
						end, scaleState),
					}),
					_new("UIListLayout")({
						Padding = UDim.new(0, 0),
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical,
						ItemLineAlignment = Enum.ItemLineAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					}),
					_new("UICorner")({
						CornerRadius = UDim.new(0.5, 0),
					}),
					_new("ImageLabel")({
						Name = "Icon",
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						ImageColor3 = _Computed(function(data: RenderData): Color3
							return if data.Text then data.Text.Color3 else Color3.new(1, 1, 1)
						end, currentRenderDataState),
						ImageTransparency = _Computed(function(data: RenderData): number
							return if data.Text then data.Text.Transparency else 1
						end, currentRenderDataState),
						Image = _Computed(function(i: ImageData): string
							return i.Image
						end, iconState),
						ImageRectOffset = _Computed(function(i: ImageData): Vector2
							return i.ImageRectOffset
						end, iconState),
						ImageRectSize = _Computed(function(i: ImageData): Vector2
							return i.ImageRectSize
						end, iconState),
						Size = _Computed(function(s: number): UDim2
							return UDim2.fromOffset(s * ICON_SIZE_DP, s * ICON_SIZE_DP)
						end, scaleState),
						Children = {
							_new("TextLabel")({
								Name = "Badge",
								Position = _Computed(function(s: number, c: number?): UDim2
									if c == nil then
										return UDim2.new(1, -0.25 * BADGE_TXT_HEIGHT_DP, 0, 0)
									else
										return UDim2.new(0.5, s, 0, 0)
									end
								end, scaleState, countState),
								AnchorPoint = Vector2.new(0, 0.5),
								AutomaticSize = Enum.AutomaticSize.None,
								Visible = _Computed(function(c: number?): boolean
									return c ~= 0
								end, countState),
								Size = _Computed(function(c: number?, s: number): UDim2
									local x = BADGE_TXT_HEIGHT_DP
									if c ~= nil then
										if c > 999 then
											x += 15
										elseif c > 99 then
											x += 10
										elseif c > 9 then
											x += 5
										end
									else
										s *= 0.5
									end
									return UDim2.fromOffset(s * x, s * BADGE_TXT_HEIGHT_DP)
								end, countState, scaleState),
								TextScaled = true,
								RichText = true,
								Text = _Computed(function(c: number?): string
									if c and c > 0 then
										if c < 999 then
											return `<b>{c}</b>`
										else
											return `<b>999+</b>`
										end
									else
										return ""
									end
								end, countState),
								FontFace = _Computed(function(f: FontData): Font
									return f.Font
								end, fontDataState),
								BackgroundColor3 = _Computed(
									function(c: Color3, e: number, st: Enums.SchemeType): Color3
										return Theme.getElevatedColor(c, e + 1, st)
									end,
									errorBackgroundColorState,
									elevationState,
									schemeTypeState
								),
								TextColor3 = _Computed(
									function(c: Color3, e: number, st: Enums.SchemeType): Color3
										return Theme.getElevatedColor(c, e + 1, st)
									end,
									errorTextColorState,
									elevationState,
									schemeTypeState
								),
								Children = {
									_new("UIPadding")({
										PaddingLeft = _Computed(function(s: number): UDim
											return UDim.new(0, s * BADGE_PAD_DP)
										end, scaleState),
										PaddingRight = _Computed(function(s: number): UDim
											return UDim.new(0, s * BADGE_PAD_DP)
										end, scaleState),
										PaddingBottom = _Computed(function(s: number): UDim
											return UDim.new(0, s * BADGE_PAD_DP)
										end, scaleState),
									}),
									_new("UICorner")({
										CornerRadius = UDim.new(0.5, 0),
									}),
								},
							}),
						},
					}),
				},
			}),
		},
	}) :: TextButton

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

return Interface
