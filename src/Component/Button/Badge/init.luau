--!strict
local _Package = script.Parent.Parent.Parent
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

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type ImageData = Types.ImageData
type RenderData = Types.RenderData
type Style = Style.Style

-- Constants
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
function component(
	maid: Maid,
	onClick: CanBeState<() -> ()>,
	label: CanBeState<string>,
	icon: CanBeState<ImageData>,
	count: CanBeState<number?>,
	renderDatas: CanBeState<{ [Enums.ButtonStateType]: RenderData }>,
	elevation: CanBeState<number?>,
	style: CanBeState<Style>
): TextButton
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, nil :: any)
	local elevationState = _import(elevation, 0)

	local scaleState = _Computed(function(style: Style): number
		return style.Scale
	end, styleState)
	local labelState = _import(label, "")
	local countState = _import(count, nil :: number?)
	local iconState: State<ImageData> = _import(icon, nil :: any)
	local onClickState = _import(onClick, function() end)
	local isEnabledState = _Value(true)
	local isFocusedState = _Value(false)
	local isPressedState = _Value(false)
	local isHoveredState = _Value(false)
	local currentStateState = _Computed(
		function(isEnab: boolean, isFocused: boolean, isPressed: boolean, isHovered: boolean): Enums.ButtonStateType
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

	local renderDatasState = _import(renderDatas, {}) :: any

	local currentRenderDataState = _Computed(
		function(state: Enums.ButtonStateType, renderDatas: { [Enums.ButtonStateType]: RenderData }): RenderData
			local data = renderDatas[state]
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
			MouseButton1Down = function(x: number, y: number)
				if isEnabledState:Get() == false then
					return
				end
				isPressedState:Set(true)
			end,
			MouseButton1Up = function(x: number, y: number)
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
				FontFace = _Computed(function(style: Style): Font
					return style.Typography:Get(Enums.FontType.LabelMedium).Font
				end, styleState),
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
				BackgroundColor3 = _Computed(function(style: RenderData): Color3
					return style.Background.Color3
				end, currentRenderDataState),
				BackgroundTransparency = _Computed(function(style: RenderData): number
					return style.Background.Transparency
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
						Image = _Computed(function(icon: ImageData): string
							return icon.Image
						end, iconState),
						ImageRectOffset = _Computed(function(icon: ImageData): Vector2
							return icon.ImageRectOffset
						end, iconState),
						ImageRectSize = _Computed(function(icon: ImageData): Vector2
							return icon.ImageRectSize
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
								FontFace = _Computed(function(style: Style): Font
									return style.Typography:Get(Enums.FontType.LabelSmall).Font
								end, styleState),
								BackgroundColor3 = _Computed(function(style: Style, e: number): Color3
									return style:GetColor(Enums.ColorRoleType.Error, e + 1)
								end, styleState, elevationState),
								TextColor3 = _Computed(function(style: Style, e: number): Color3
									return style:GetColor(Enums.ColorRoleType.OnError, e + 1)
								end, styleState, elevationState),
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
	return inst
end

-- Class
local Interface = {}

Interface.ColdFusion = {}

function Interface.ColdFusion.new(
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	label: CanBeState<string?>,
	count: CanBeState<number?>,
	textColor: CanBeState<Color3>,
	hoverColor: CanBeState<Color3>,
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

	local styleState: State<Style> = _import(style, nil :: any)

	local elevationState: State<number> = _import(elevation, 0)
	local textColorState: State<Color3> = _import(textColor, Color3.new(1, 1, 1))
	local hoverColorState: State<Color3> = _import(hoverColor, Color3.new(1, 1, 1))

	local iconState: State<ImageData> = _import(icon, nil :: any)

	local button = component(
		maid,
		onClick,
		_import(label, ""),
		icon,
		count,
		_Computed(
			function(
				style: Style,
				e: number,
				hC: Color3,
				tC: Color3,
				i: ImageData?
			): { [Enums.ButtonStateType]: RenderData }
				e += 1
				return {
					[Enums.ButtonStateType.Enabled] = Types.newRenderData(
						style.Scale,
						Types.newAppearanceData(style:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(style:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(style:GetElevatedColor(tC, e), 0),
						style.Typography:Get(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Hovered] = Types.newRenderData(
						style.Scale,
						Types.newAppearanceData(style:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(style:GetElevatedColor(hC, e + 1), 1 - 0.08),
						Types.newAppearanceData(style:GetElevatedColor(tC, e + 1), 0),
						style.Typography:Get(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Focused] = Types.newRenderData(
						style.Scale,
						Types.newAppearanceData(style:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(style:GetElevatedColor(hC, e), 1 - 0.1),
						Types.newAppearanceData(style:GetElevatedColor(tC, e), 0),
						style.Typography:Get(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Pressed] = Types.newRenderData(
						style.Scale,
						Types.newAppearanceData(style:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(style:GetElevatedColor(hC, e - 1), 1 - 0.1),
						Types.newAppearanceData(style:GetElevatedColor(tC, e - 1), 0),
						style.Typography:Get(Enums.FontType.LabelLarge),
						i,
						Types.newSoundData(Sounds.ui_tap_variant_01, 1),
						nil
					),
				}
			end,
			styleState,
			elevationState,
			hoverColorState,
			textColorState,
			iconState
		),
		elevation,
		style
	)
	maid.bind(button)

	return button
end

return Interface
