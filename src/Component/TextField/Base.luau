--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Icons = require(_Packages:WaitForChild("MaterialIcons"))
local OutlinedIcons = require(_Packages:WaitForChild("OutlinedMaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Util = require(_Package:WaitForChild("Util"))
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
local CONTAINER_HEIGHT_DP = 42
local LEFT_RIGHT_NO_ICONS_PADDING_DP = 14
local LEFT_RIGHT_YES_ICONS_PADDING_DP = 10
local TEXT_AND_ICON_PADDING_DP = 14
local SUPPORTING_TEXT_PADDING_DP = 4
local MIN_WIDTH_DP = math.round(CONTAINER_HEIGHT_DP * 1.5)
local DEFAULT_OUTLINE_THICKNESS_DP = 1
local FOCUSED_OUTLINE_THICKNESS_DP = 2
local RADIUS_DP = 4
local ICON_WIDTH_DP = 18
local DISABLED_TEXT_TRANSPARENCY = 1 - 0.38
local DISABLED_OUTLINE_TRANSPARENCY = 1 - 0.12
local DISABLED_BACKGROUND_TRANSPARENCY = 1 - 0.04

-- Variables
-- References

-- Private Functions

-- Class
local Interface = {}

function Interface.new(
	onSubmit: CanBeState<(text: string?) -> string?>,
	onInput: CanBeState<(text: string?) -> string?>,
	initialText: CanBeState<string?>,
	isEnabled: CanBeState<boolean>,
	isError: CanBeState<boolean>,
	label: CanBeState<string>,
	characterLimit: CanBeState<number?>,
	supportingText: CanBeState<string?>,
	leadingIcon: CanBeState<ImageData?>,

	textColor: CanBeState<Color3>,
	labelColor: CanBeState<Color3>,
	hightlightColor: CanBeState<Color3>,
	errorColor: CanBeState<Color3>,
	backgroundColor: CanBeState<Color3>,
	borderColor: CanBeState<Color3>,
	supportingTextColor: CanBeState<Color3>,

	elevation: CanBeState<number>,
	isOutlined: CanBeState<boolean>,
	schemeType: CanBeState<Enums.SchemeType>,
	bodyFontData: CanBeState<FontData>,
	supportFontData: CanBeState<FontData>,
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

	local scaleState: State<number> = _import(scale, 1)
	local schemeTypeState: State<Enums.SchemeType> = _import(schemeType, Enums.SchemeType.Light)
	local bodyFontDataState: State<FontData> = _import(bodyFontData, nil :: any)
	local supportFontDataState: State<FontData> = _import(supportFontData, nil :: any)

	local onSubmitState = _import(onSubmit, function(input: string?): string?
		return nil
	end)
	local onInputState = _import(onInput, function(input: string?): string?
		return nil
	end)

	local elevationState = _import(elevation, 0)
	local isEnabledState = _import(isEnabled, true)
	local initialTextState = _import(initialText, nil :: string?)
	local labelTextState = _import(label, nil :: string?)

	local characterLimitState: State<number?> = _import(characterLimit, nil :: number?)

	local supportingTextState: State<string?> = _import(supportingText, nil :: string?)
	local leadingIconState = _import(leadingIcon, nil :: ImageData?)
	local dropdownOptionsState: State<{ string }?> = _import(nil, nil :: { string }?)

	local function applyElevation(state: State<Color3>): State<Color3>
		return _Computed(function(c: Color3, e: number, st: Enums.SchemeType): Color3
			return Theme.getElevatedColor(c, e, st)
		end, state, elevationState, schemeTypeState)
	end

	local textColorState = applyElevation(_import(textColor, Color3.new()))
	local borderColorState = applyElevation(_import(borderColor, Color3.new()))
	local backgroundColorState = applyElevation(_import(backgroundColor, Color3.new()))
	local labelColorState = applyElevation(_import(labelColor, Color3.new()))
	local inputHighlightColorState = applyElevation(_import(hightlightColor, Color3.new()))
	local errorColorState = applyElevation(_import(errorColor, Color3.new()))
	local supportingTextColorState = applyElevation(_import(supportingTextColor, Color3.new()))

	local isOutlinedState = _import(isOutlined, true)
	local isErrorState = _import(isError, true)

	local highlightColorState = _Computed(function(isErr: boolean, hCol: Color3, eCol: Color3): Color3
		return if isErr then eCol else hCol
	end, isErrorState, inputHighlightColorState, errorColorState)

	local isFocusedState = _Value(false)
	local isPressedState = _Value(false)
	local isHoveredState = _Value(false)

	local valueState: ValueState<string?> = _Value(initialTextState:Get())
	local inputValueState: ValueState<string?> = _Value(initialTextState:Get())

	local buttonStateTypeState = _Computed(
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

	local isLabelMinimizedState = _Computed(function(isFoc: boolean, val: string?): boolean
		return if isFoc or (val and val:len() > 0) then true else false
	end, isFocusedState, valueState)

	local labelFontData: State<FontData> = _Computed(
		function(isMin: boolean, bF: FontData, sF: FontData): FontData
			if isMin then
				return sF
			else
				return bF
			end
		end,
		isLabelMinimizedState,
		bodyFontDataState,
		supportFontDataState
	)

	local rightIconState = _Computed(function(iE: boolean, d: { string }?, v: string?): ImageData?
		if iE then
			return Icons.error
		elseif v ~= nil then
			return OutlineIcons.cancel
		elseif d ~= nil then
			return Icons.arrow_drop_down
		else
			return nil
		end
	end, isErrorState, dropdownOptionsState, valueState)

	local iconAddedWidthState = _Computed(function(lead: ImageData?, sc: number): number
		local leftOffset = if lead then ICON_WIDTH_DP + TEXT_AND_ICON_PADDING_DP else 0
		local rightOffset = ICON_WIDTH_DP + TEXT_AND_ICON_PADDING_DP
		return (leftOffset + rightOffset) * sc
	end, leadingIconState, scaleState)

	local textBox: TextBox

	local function updateValue()
		local current = textBox.Text
		local oSubmit = onSubmitState:Get()
		if oSubmit then
			local fmt = oSubmit(current) or ""
			print(`fmt: {fmt}`)
			textBox.Text = fmt or ""
			valueState:Set(if textBox.Text == "" then nil else textBox.Text)
		end
	end

	textBox = _new("TextBox")({
		LayoutOrder = 2,
		RichText = true,
		Visible = true,
		TextColor3 = textColorState,
		TextTransparency = _Computed(function(isMin: boolean, isEnab: boolean): number
			return if isMin then if isEnab then 0 else DISABLED_TEXT_TRANSPARENCY else 1
		end, isLabelMinimizedState, isEnabledState),
		BackgroundTransparency = 1,
		Text = "",
		Selectable = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutomaticSize = Enum.AutomaticSize.X,
		TextSize = _Computed(function(f: FontData, sc: number): number
			return Typography.getTextSize(f.Size, sc)
		end, bodyFontDataState, scaleState),
		LineHeight = _Computed(function(f: FontData, sc: number): number
			return Typography.getGuiLineHeight(f.LineHeight, f.Size)
		end, bodyFontDataState, scaleState),
		FontFace = _Computed(function(f: FontData): Font
			return f.Font
		end, bodyFontDataState),
		Size = _Computed(function(sc: number, isMin: boolean, f: FontData): UDim2
			if isMin then
				return UDim2.fromOffset(
					0,
					sc
						* Typography.getTextSize(f.Size, sc)
						* Typography.getGuiLineHeight(f.LineHeight, f.Size)
				)
			else
				return UDim2.fromOffset(0, 0)
			end
		end, scaleState, isLabelMinimizedState, bodyFontDataState),
		Events = {
			Focused = function()
				isFocusedState:Set(true)
			end,
			FocusLost = function()
				isFocusedState:Set(false)

				updateValue()
			end,
		},
		Children = {
			-- maid:GiveTask(Util.Padding.ColdFusion.new(
			-- 	UDim.new(0,0),
			-- 	_Computed(function(s: Style): UDim
			-- 		return UDim.new(0, s.Scale * 8)
			-- 	end, styleState)
			-- )) :: Instance,
		},
	}) :: TextBox

	maid:GiveTask(textBox:GetPropertyChangedSignal("Text"):Connect(function()
		local current = textBox.Text
		local lim = characterLimitState:Get()
		if lim and current:len() > lim then
			current = current:sub(1, lim)
		end
		local oInput = onInputState:Get()
		if oInput then
			local fmt = oInput(current) or ""
			textBox.Text = fmt or ""
		end
		inputValueState:Set(textBox.Text)
	end))

	maid:GiveTask(initialTextState:Connect(function()
		textBox.Text = if initialTextState:Get() then initialTextState:Get() else ""
	end))
	textBox.Text = if initialTextState:Get() then initialTextState:Get() else ""

	local outlineThicknessState = _Computed(function(sc: number, isFoc: boolean): number
		return sc * if isFoc == false then DEFAULT_OUTLINE_THICKNESS_DP else FOCUSED_OUTLINE_THICKNESS_DP
	end, scaleState, isFocusedState)

	local inst = _bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
		Name = "TextField",
		Children = {
			maid:GiveTask(
				Util.List.ColdFusion.new(
					Enum.VerticalAlignment.Center,
					Enum.HorizontalAlignment.Left,
					Enum.FillDirection.Vertical,
					_Computed(function(sc: number): UDim
						return UDim.new(0, sc * SUPPORTING_TEXT_PADDING_DP)
					end, scaleState),
					Enum.UIFlexAlignment.None,
					Enum.UIFlexAlignment.Fill,
					Enum.ItemLineAlignment.Stretch,
					false
				)
			) :: Instance,
			_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
				LayoutOrder = 1,
				Name = "UpperLabelContainer",
				Children = {
					maid:GiveTask(
						Util.List.ColdFusion.new(
							Enum.VerticalAlignment.Center,
							Enum.HorizontalAlignment.Center,
							Enum.FillDirection.Horizontal,
							_Computed(function(sc: number): UDim
								return UDim.new(0, sc * TEXT_AND_ICON_PADDING_DP)
							end, scaleState),
							Enum.UIFlexAlignment.Fill,
							Enum.UIFlexAlignment.Fill,
							Enum.ItemLineAlignment.Center,
							false
						)
					) :: Instance,
					maid:GiveTask(
						Util.Padding.ColdFusion.new(
							_Computed(function(sc: number, l: ImageData?): UDim
								return if l
									then UDim.new(0, sc * LEFT_RIGHT_YES_ICONS_PADDING_DP)
									else UDim.new(0, sc * LEFT_RIGHT_NO_ICONS_PADDING_DP)
							end, scaleState, leadingIconState),
							UDim.new(0, 0)
						)
					) :: Instance,
					_bind(
						maid:GiveTask(
							Util.TextLabel.ColdFusion.new(
								labelTextState,
								_Computed(
									function(
										lCol: Color3,
										hCol: Color3,
										isFoc: boolean,
										isErr: boolean
									): Color3
										return if isFoc or isErr then hCol else lCol
									end,
									labelColorState,
									highlightColorState,
									isFocusedState,
									isErrorState
								),
								_Computed(function(isMin: boolean, isOut: boolean): number
									if isOut then
										return if isMin == true then 0 else 1
									else
										return 1
									end
								end, isLabelMinimizedState, isOutlinedState),
								supportFontDataState,
								scaleState,
								nil,
								nil,
								0,
								true,
								nil
							)
						)
					)({
						Name = "Label",
					}),
				},
			}),
			_new("TextButton")({
				LayoutOrder = 2,
				Size = _Computed(function(sc: number): UDim2
					return UDim2.fromOffset(0, math.round(sc * CONTAINER_HEIGHT_DP))
				end, scaleState),
				Text = "",
				BackgroundColor3 = backgroundColorState,
				BackgroundTransparency = _Computed(function(isOut: boolean, isEnab: boolean): number
					return if isOut then 1 elseif isEnab then 0 else DISABLED_BACKGROUND_TRANSPARENCY
				end, isOutlinedState, isEnabledState),
				AutomaticSize = Enum.AutomaticSize.XY,
				Events = {
					Activated = function()
						if isEnabledState:Get() == false then
							return
						end
						textBox:CaptureFocus()
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
				},
				Children = {
					_new("UIStroke")({
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = _Computed(
							function(
								bCol: Color3,
								hCol: Color3,
								isFoc: boolean,
								isErr: boolean,
								bState: Enums.ButtonStateType,
								tCol: Color3
							): Color3
								return if isFoc or isErr
									then hCol
									elseif bState == Enums.ButtonStateType.Hovered then tCol
									else bCol
							end,
							borderColorState,
							highlightColorState,
							isFocusedState,
							isErrorState,
							buttonStateTypeState,
							textColorState
						),
						Enabled = isOutlinedState,
						LineJoinMode = Enum.LineJoinMode.Round,
						Thickness = outlineThicknessState,
						Transparency = _Computed(function(isEnab: boolean): number
							return if isEnab then 0 else DISABLED_OUTLINE_TRANSPARENCY
						end, isEnabledState),
					}),
					_new("UICorner")({
						CornerRadius = _Computed(function(sc: number): UDim
							return UDim.new(0, sc * RADIUS_DP)
						end, scaleState),
					}),
					_new("UISizeConstraint")({
						MaxSize = Vector2.new(math.huge, math.huge),
						MinSize = _Computed(function(sc: number, add: number): Vector2
							return Vector2.new((sc * MIN_WIDTH_DP) + add, 0)
						end, scaleState, iconAddedWidthState),
					}),
					_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
						LayoutOrder = 3,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = _Computed(function(sc: number): UDim2
							return UDim2.fromOffset(0, sc * ICON_WIDTH_DP)
						end, scaleState),
						Children = {
							textBox :: Instance,
							_bind(
								maid:GiveTask(
									Util.TextLabel.ColdFusion.new(
										labelTextState,
										_Computed(function(isMin: boolean, lab: Color3, high: Color3): Color3
											return if isMin then high else lab
										end, isLabelMinimizedState, labelColorState, highlightColorState),
										_Computed(function(isEnab: boolean): number
											return if isEnab then 0 else DISABLED_TEXT_TRANSPARENCY
										end, isEnabledState),
										labelFontData,
										scaleState,
										nil,
										nil,
										0,
										true,
										nil
									)
								)
							)({
								Visible = _Computed(function(isMin: boolean, isOut: boolean): boolean
									if isOut then
										return isMin == false
									else
										return true
									end
								end, isLabelMinimizedState, isOutlinedState),
							}),
							maid:GiveTask(
								Util.List.ColdFusion.new(
									Enum.VerticalAlignment.Center,
									Enum.HorizontalAlignment.Left,
									Enum.FillDirection.Vertical,
									UDim.new(0, 0),
									Enum.UIFlexAlignment.None,
									Enum.UIFlexAlignment.Fill,
									Enum.ItemLineAlignment.Stretch,
									false
								)
							) :: Instance,
						},
					}),
					_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
						LayoutOrder = 1,
						Children = {
							_bind(
								maid:GiveTask(
									Util.ImageLabel.ColdFusion.new(
										leadingIcon,
										textColorState,
										_Computed(function(isEnab: boolean): number
											return if isEnab then 0 else DISABLED_TEXT_TRANSPARENCY
										end, isEnabledState)
									)
								)
							)({
								Visible = _Computed(function(i: ImageData?): boolean
									return i ~= nil
								end, leadingIconState),
								Size = _Computed(function(sc: number): UDim2
									return UDim2.fromOffset(sc * ICON_WIDTH_DP, sc * ICON_WIDTH_DP)
								end, scaleState),
							}),
							maid:GiveTask(_new("UIAspectRatioConstraint")({
								AspectRatio = 1,
								AspectType = Enum.AspectType.FitWithinMaxSize,
								DominantAxis = Enum.DominantAxis.Height,
							})),
							maid:GiveTask(Util.List.ColdFusion.center()) :: Instance,
						},
					}),
					_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
						LayoutOrder = 3,
						Children = {
							_new("ImageButton")({
								Image = _Computed(function(i: ImageData?): string
									return if i then i.Image else ""
								end, rightIconState),
								ImageRectOffset = _Computed(function(i: ImageData?): Vector2
									return if i then i.ImageRectOffset else Vector2.zero
								end, rightIconState),
								ImageRectSize = _Computed(function(i: ImageData?): Vector2
									return if i then i.ImageRectSize else Vector2.zero
								end, rightIconState),
								BackgroundTransparency = 1,
								ImageColor3 = _Computed(
									function(tCol: Color3, eCol: Color3, isErr: boolean): Color3
										return if isErr then eCol else tCol
									end,
									textColorState,
									errorColorState,
									isErrorState
								),
								ImageTransparency = _Computed(
									function(i: ImageData?, isEnab: boolean): number
										return if i ~= nil
											then if isEnab then 0 else DISABLED_TEXT_TRANSPARENCY
											else 1
									end,
									rightIconState,
									isEnabledState
								),
								Size = _Computed(function(sc: number): UDim2
									return UDim2.fromOffset(sc * ICON_WIDTH_DP, sc * ICON_WIDTH_DP)
								end, scaleState),
								Events = {
									Activated = function()
										if valueState:Get() and isErrorState:Get() == false then
											textBox.Text = ""
											updateValue()
										else
											local drops = dropdownOptionsState:Get()
											if drops and #drops > 0 then
												print("drop it")
											end
										end
									end,
								},
							}) :: Instance,
							maid:GiveTask(_new("UIAspectRatioConstraint")({
								AspectRatio = 1,
								AspectType = Enum.AspectType.FitWithinMaxSize,
								DominantAxis = Enum.DominantAxis.Height,
							})),
							maid:GiveTask(Util.List.ColdFusion.center()) :: Instance,
						},
					}),
					maid:GiveTask(
						Util.List.ColdFusion.new(
							Enum.VerticalAlignment.Center,
							Enum.HorizontalAlignment.Center,
							Enum.FillDirection.Horizontal,
							_Computed(function(sc: number): UDim
								return UDim.new(0, sc * TEXT_AND_ICON_PADDING_DP)
							end, scaleState),
							Enum.UIFlexAlignment.Fill,
							Enum.UIFlexAlignment.Fill,
							Enum.ItemLineAlignment.Center,
							false
						)
					) :: Instance,
					maid:GiveTask(
						Util.Padding.ColdFusion.new(
							_Computed(function(sc: number, l: ImageData?): UDim
								return if l
									then UDim.new(0, sc * LEFT_RIGHT_YES_ICONS_PADDING_DP)
									else UDim.new(0, sc * LEFT_RIGHT_NO_ICONS_PADDING_DP)
							end, scaleState, leadingIconState),
							UDim.new(0, 0)
						)
					) :: Instance,
				},
			}) :: Instance,
			_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
				Name = "SupportingTextContainer",
				LayoutOrder = 3,
				Children = {
					maid:GiveTask(
						Util.List.ColdFusion.new(
							Enum.VerticalAlignment.Center,
							Enum.HorizontalAlignment.Center,
							Enum.FillDirection.Horizontal,
							_Computed(function(sc: number): UDim
								return UDim.new(0, sc * TEXT_AND_ICON_PADDING_DP)
							end, scaleState),
							Enum.UIFlexAlignment.Fill,
							Enum.UIFlexAlignment.SpaceBetween,
							Enum.ItemLineAlignment.Center,
							false
						)
					) :: Instance,
					maid:GiveTask(
						Util.Padding.ColdFusion.new(
							_Computed(function(sc: number, l: ImageData?): UDim
								return if l
									then UDim.new(0, sc * LEFT_RIGHT_YES_ICONS_PADDING_DP)
									else UDim.new(0, sc * LEFT_RIGHT_NO_ICONS_PADDING_DP)
							end, scaleState, leadingIconState),
							UDim.new(0, 0)
						)
					) :: Instance,
					_bind(
						maid:GiveTask(
							Util.TextLabel.ColdFusion.new(
								_Computed(function(txt: string?): string
									return if txt then txt else ""
								end, supportingTextState),
								_Computed(function(sCol: Color3, eCol: Color3, isErr: boolean): Color3
									return if isErr then eCol else sCol
								end, supportingTextColorState, errorColorState, isErrorState),
								_Computed(function(txt: string?, isEnab: boolean): number
									return if txt and txt:len() > 0
										then if isEnab then 0 else DISABLED_TEXT_TRANSPARENCY
										else 1
								end, supportingTextState, isEnabledState),
								supportFontDataState,
								scaleState,
								nil,
								nil,
								0,
								true,
								nil
							)
						)
					)({
						LayoutOrder = 1,
					}),
					_bind(
						maid:GiveTask(
							Util.TextLabel.ColdFusion.new(
								_Computed(function(lim: number?, txt: string?): string
									if lim then
										local count = if txt then txt:len() else 0
										return `{count}/{lim}`
									else
										return ""
									end
								end, characterLimitState, inputValueState),
								supportingTextColorState,
								_Computed(function(lim: number?, isEnab: boolean): number
									return if lim then if isEnab then 0 else DISABLED_TEXT_TRANSPARENCY else 1
								end, characterLimitState, isEnabledState),
								supportFontDataState,
								scaleState,
								nil,
								nil,
								0,
								true,
								Enum.TextXAlignment.Right
							)
						)
					)({
						LayoutOrder = 2,
					}),
				},
			}),
		},
	}) :: GuiObject

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

return Interface
