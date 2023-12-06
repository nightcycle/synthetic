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
local DEFAULT_VOLUME = Config.Sound.Volume
local HOVER_TRANSPARENCY = Config.Transparency.Background.Hovered
local FOCUS_TRANSPARENCY = Config.Transparency.Background.Focused
local PRESS_TRANSPARENCY = Config.Transparency.Background.Pressed
local DISABLE_TRANSPARENCY = Config.Transparency.Text.Disabled
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
function new(
	maid: Maid,
	onClick: CanBeState<() -> ()>,
	font: CanBeState<Font>,
	label: CanBeState<string>,
	styles: CanBeState<{ [Enums.ButtonStateType]: TextStyle }>,
	icon: CanBeState<ImageData>,
	count: CanBeState<number?>,
	scale: CanBeState<number>,
	sound: CanBeState<Sound?>
): TextButton
	
	local _fuse = ColdFusion.fuse(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local scaleState = _import(scale, 1)
	local fontState = _import(font, Font.fromEnum(Enum.Font.SourceSans))
	local labelState = _import(label, "")
	local soundState = _import(sound, nil :: Sound?)
	local countState = _import(count, nil :: number?)
	local iconState: State<ImageData> = _import(icon, nil :: any)
	local onClickState = _import(onClick, function() end)
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

	local stylesState = _import(styles, {}) :: any
	local currentStyleState = _Computed(
		function(state: Enums.ButtonStateType, styles: { [Enums.ButtonStateType]: TextStyle }): TextStyle
			local style = styles[state]
			assert(style ~= nil, `no style for {state}`)
			return style
		end,
		currentStateState,
		stylesState
	)

	local inst = _new("TextButton")({
		Text = "",
		Size = UDim2.new(0,0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Events = {
			Activated = function()
				if isEnabledState:Get() == false then
					return
				end
				local click = onClickState:Get()
				local s = soundState:Get()
				if s then
					SoundService:PlayLocalSound(s)
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
					return UDim.new(0, s*PAD_DP)
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
				FontFace = fontState,
				LayoutOrder = 2,
				TextColor3 = _Computed(function(style: TextStyle): Color3
					return style.TextColor3
				end, currentStyleState),
				TextTransparency = _Computed(function(style: TextStyle): number
					return style.TextTransparency
				end, currentStyleState),
				Size = _Computed(function(s: number): UDim2
					return UDim2.fromOffset(0, s * TXT_HEIGHT_DP)
				end, scaleState),
			}),
			_new("Frame")({
				Name = "Icon",
				LayoutOrder = 1,
				BackgroundColor3 = _Computed(function(style: TextStyle): Color3
					return style.BackgroundColor3
				end, currentStyleState),
				BackgroundTransparency = _Computed(function(style: TextStyle): number
					return style.BackgroundTransparency
				end, currentStyleState),
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromOffset(0,0),
				Children = {
					_new("UIPadding")({
						PaddingLeft = _Computed(function(s: number): UDim
							return UDim.new(0, s*ICON_PAD_DP*3)
						end, scaleState),
						PaddingRight = _Computed(function(s: number): UDim
							return UDim.new(0, s*ICON_PAD_DP*3)
						end, scaleState),
						PaddingTop = _Computed(function(s: number): UDim
							return UDim.new(0, s*ICON_PAD_DP)
						end, scaleState),
						PaddingBottom = _Computed(function(s: number): UDim
							return UDim.new(0, s*ICON_PAD_DP)
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
						CornerRadius = UDim.new(0.5,0)
					}),
					_new("ImageLabel")({
						Name = "Icon",
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						ImageColor3 = _Computed(function(style: TextStyle): Color3
							return style.BorderColor3
						end, currentStyleState),
						ImageTransparency = _Computed(function(style: TextStyle): number
							return style.BorderTransparency
						end, currentStyleState),
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
								Position = _Computed(function(s: number, c: number?): UDim2
									if c == nil then
										return UDim2.new(1, -0.25*BADGE_TXT_HEIGHT_DP, 0, 0)
									else
										return UDim2.new(0.5, s, 0, 0)
									end
								end, scaleState, countState),
								AnchorPoint = Vector2.new(0,0.5),
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
									return UDim2.fromOffset(
										s * x, 
										s * BADGE_TXT_HEIGHT_DP
									)
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
								FontFace = fontState,
								BackgroundColor3 = _Computed(function(style: TextStyle): Color3
									return Util.getReadableColor(style.BackgroundColor3, Util.LIGHT_SURFACE)
								end, currentStyleState),
								TextColor3 = Util.LIGHT_SURFACE,
								Children = {
									_new("UIPadding")({
										PaddingLeft = _Computed(function(s: number): UDim
											return UDim.new(0, s*BADGE_PAD_DP)
										end, scaleState),
										PaddingRight = _Computed(function(s: number): UDim
											return UDim.new(0, s*BADGE_PAD_DP)
										end, scaleState),
										PaddingBottom = _Computed(function(s: number): UDim
											return UDim.new(0, s*BADGE_PAD_DP)
										end, scaleState),
									}),
									_new("UICorner")({
										CornerRadius = UDim.new(0.5,0)
									}),
								},
							})
						}
					}),
				}
			}),
			
		},
	}) :: TextButton
	return inst
end

-- Class
local Interface = {}

function Interface.cfusion(
	onClick: CanBeState<() -> ()>,
	icon: CanBeState<ImageData>,
	label: CanBeState<string>,
	count: CanBeState<number?>,
	theme: CanBeState<ThemeData>
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
	local themeState = _import(
		theme,
		Types.newThemeData(
			1,
			false,
			1,
			Font.fromEnum(Enum.Font.SourceSansSemibold),
			Color3.fromHSV(0.8, 0.4, 0.8)
		)
	)

	local sound = maid:GiveTask(Instance.new("Sound"))
	sound.Volume = DEFAULT_VOLUME
	sound.SoundId = Sounds.ui_tap_variant_01

	local styles = _Computed(function(thm: ThemeData): { [Enums.ButtonStateType]: TextStyle }
		local color: Color3 = thm.Color3
		local textColor: Color3
		-- local borderColor: Color3
		if thm.IsDarkMode then
			-- borderColor = Util.getReadableColor(
			-- 	Util.LIGHT_SURFACE,
			-- 	color,
			-- 	1
			-- )
			textColor = color:Lerp(Util.LIGHT_SURFACE, 0.8)
		else
			-- borderColor = Util.getReadableColor(
			-- 	Util.LIGHT_SURFACE,
			-- 	color,
			-- 	1
			-- )
			textColor = color:Lerp(Util.DARK_SURFACE, 0.8)
		end
		color = Util.getElevatedColor(color, thm.Elevation, thm.IsDarkMode)
		-- borderColor = Util.getElevatedColor(borderColor, thm.Elevation, thm.IsDarkMode)
		textColor = Util.getElevatedColor(textColor, thm.Elevation, thm.IsDarkMode)

		local data = {
			[Enums.ButtonStateType.Enabled] = Types.newTextStyle(
				textColor, 
				0, 
				color, 
				1, 
				textColor, 
				0
			),
			[Enums.ButtonStateType.Disabled] = Types.newTextStyle(
				textColor,
				DISABLE_TRANSPARENCY,
				(function(): Color3
					if thm.IsDarkMode then
						local h, _s, v = color:ToHSV()
						return Util.getReadableColor(
							Color3.fromHSV(h, 0, v),
							if thm.BackgroundColor3 then thm.BackgroundColor3 else Color3.new(0.15, 0.15, 0.15)
						)
					else
						local h, _s, v = color:ToHSV()
						return Util.getReadableColor(
							Color3.fromHSV(h, 0, v),
							if thm.BackgroundColor3 then thm.BackgroundColor3 else Color3.new(0.85, 0.85, 0.85)
						)
					end
				end)(),
				1,
				textColor,
				DISABLE_TRANSPARENCY
			),
			[Enums.ButtonStateType.Focused] = Types.newTextStyle(
				textColor,
				0,
				color,
				FOCUS_TRANSPARENCY,
				textColor,
				0
			),
			[Enums.ButtonStateType.Hovered] = Types.newTextStyle(
				textColor,
				0,
				color,
				HOVER_TRANSPARENCY,
				textColor,
				0
			),
			[Enums.ButtonStateType.Pressed] = Types.newTextStyle(
				textColor,
				0,
				color,
				PRESS_TRANSPARENCY,
				textColor,
				0
			),
		}
		return data
	end, themeState)

	local button = new(
		maid,
		onClickState,
		_Computed(function(t: ThemeData): Font
			return t.Font
		end, themeState),
		label,
		styles,
		icon,
		count,
		_Computed(function(t: ThemeData): number
			return t.Scale
		end, themeState),
		sound
	)

	maid.bind(button)

	return button
end

return Interface
