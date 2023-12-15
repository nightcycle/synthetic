--!strict
local _Package = script.Parent.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Sounds = require(_Package:WaitForChild("Sounds"))

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

-- Constants
local ICONS = MaterialIcons.default.dp_48.scale_1
local CHECK_ICON = ICONS.check
local DASH_ICON = ICONS.remove
local LAYER_SIZE_DP = 40
local CHECKBOX_SIZE_DP = 18
local CHECKBOX_SHAPE_DP = 2
local UNSELECT_OUTLINE_WIDTH_DP = 2
-- Variables
-- References
-- Private Functions

-- Class
local Interface = {}

Interface.ColdFusion = {}

function Interface.ColdFusion.new(
	onSelect: (isSelected: boolean?) -> (),
	initialSelection: CanBeState<boolean?>,
	isEnabled: CanBeState<boolean>,
	outlineColor: CanBeState<Color3>,
	fillColor: CanBeState<Color3>,
	iconColor: CanBeState<Color3>,
	disabledColor: CanBeState<Color3>,
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

	local initialSelectionState = _import(initialSelection, nil :: boolean?)
	local outlineColorState = _import(outlineColor, Color3.new(1, 1, 1))
	local fillColorState = _import(fillColor, Color3.new(1, 1, 1))
	local disabledColorState = _import(disabledColor, Color3.new(1, 1, 1))
	local iconColorState = _import(iconColor, Color3.new(1, 1, 1))
	local elevationState = _import(elevation, 0)
	local isEnabledState = _import(isEnabled, true)
	local onSelectState = _import(onSelect, function(isSelected: boolean?) end)

	local clickCountState = _Value(0)
	local hasClicked = _Value(false)

	initialSelectionState:Connect(function()
		hasClicked:Set(false)
	end)

	local valueState = _Computed(function(initial: boolean?, count: number, hasClick: boolean): boolean?
		if initial == nil then
			initial = false
			if count == 0 and hasClick == false then
				return nil
			end
		end
		if count % 2 == 0 then
			return initial
		else
			return not initial
		end
	end, initialSelectionState, clickCountState, hasClicked)

	local styleState: State<Style> = _import(style, nil :: any)

	local renderDatasState = _Computed(
		function(
			s: Style,
			oC: Color3,
			fC: Color3,
			iC: Color3,
			dC: Color3,
			e: number
		): { [Enums.ButtonStateType]: RenderData }
			return {
				[Enums.ButtonStateType.Enabled] = Types.newRenderData(
					s.Scale,
					Types.newAppearanceData(s:GetElevatedColor(oC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(fC, e), 1),
					Types.newAppearanceData(s:GetElevatedColor(iC, e), 0),
					nil,
					nil,
					nil,
					nil
				),
				[Enums.ButtonStateType.Disabled] = Types.newRenderData(
					s.Scale,
					Types.newAppearanceData(s:GetElevatedColor(dC, e), 1 - 0.38),
					Types.newAppearanceData(s:GetElevatedColor(dC, e), 1),
					Types.newAppearanceData(s:GetElevatedColor(dC, e), 1 - 0.38),
					nil,
					nil,
					nil,
					nil
				),
				[Enums.ButtonStateType.Hovered] = Types.newRenderData(
					s.Scale,
					Types.newAppearanceData(s:GetElevatedColor(oC, e + 1), 0),
					Types.newAppearanceData(s:GetElevatedColor(fC, e + 1), 1 - 0.08),
					Types.newAppearanceData(s:GetElevatedColor(iC, e + 1), 0),
					nil,
					nil,
					nil,
					nil
				),
				[Enums.ButtonStateType.Focused] = Types.newRenderData(
					s.Scale,
					Types.newAppearanceData(s:GetElevatedColor(oC, e), 0),
					Types.newAppearanceData(s:GetElevatedColor(fC, e), 1 - 0.1),
					Types.newAppearanceData(s:GetElevatedColor(iC, e), 0),
					nil,
					nil,
					nil,
					nil
				),
				[Enums.ButtonStateType.Pressed] = Types.newRenderData(
					s.Scale,
					Types.newAppearanceData(s:GetElevatedColor(oC, e - 1), 0),
					Types.newAppearanceData(s:GetElevatedColor(fC, e - 1), 1 - 0.1),
					Types.newAppearanceData(s:GetElevatedColor(iC, e - 1), 0),
					nil,
					nil,
					nil,
					nil
				),
			}
		end,
		styleState,
		outlineColorState,
		fillColorState,
		iconColorState,
		disabledColorState,
		elevationState
	)

	local isFocusedState = _Value(false)
	local isPressedState = _Value(false)
	local isHoveredState = _Value(false)

	local iconImageState = _Computed(function(v: boolean?): ImageData
		if v == nil then
			return DASH_ICON
		elseif v == true then
			return CHECK_ICON
		else
			return Types.newImageData("")
		end
	end, valueState)

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

	local renderDataState = _Computed(
		function(renderDatas: { [Enums.ButtonStateType]: RenderData }, bState: Enums.ButtonStateType): RenderData
			return renderDatas[bState]
		end,
		renderDatasState,
		currentStateState
	)

	local inst = _new("ImageButton")({
		Size = _Computed(function(s: Style): UDim2
			return UDim2.fromOffset(s.Scale * LAYER_SIZE_DP, s.Scale * LAYER_SIZE_DP)
		end, styleState),
		BackgroundColor3 = _Computed(function(data: RenderData): Color3
			return data.Background.Color3
		end, renderDataState),
		BackgroundTransparency = _Computed(function(data: RenderData): number
			return data.Background.Transparency
		end, renderDataState),
		Events = {
			Activated = function()
				if isEnabledState:Get() == false then
					return
				end
				hasClicked:Set(true)
				local onClick = onSelectState:Get()
				local count = clickCountState:Get() + 1
				clickCountState:Set(count)

				do
					local sound = Instance.new("Sound")
					sound.Volume = 1
					if valueState:Get() == true then
						sound.SoundId = Sounds.navigation_forward_selection_minimal
					else
						sound.SoundId = Sounds.navigation_backward_selection_minimal
					end
					SoundService:PlayLocalSound(sound)
					sound:Destroy()
				end

				onClick(valueState:Get())
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
			_new("UICorner")({
				CornerRadius = UDim.new(0.5, 0),
			}),
			_new("UIListLayout")({
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			_new("ImageLabel")({
				Size = _Computed(function(s: Style): UDim2
					local dpWidth = CHECKBOX_SIZE_DP - (UNSELECT_OUTLINE_WIDTH_DP * 2)
					return UDim2.fromOffset(s.Scale * dpWidth, s.Scale * dpWidth)
				end, styleState),
				BackgroundTransparency = _Computed(function(v: boolean?, enab: boolean): number
					return if enab then if v == false then 1 else 0 else 1
				end, valueState, isEnabledState),
				ImageTransparency = _Computed(function(v: boolean?): number
					return if v == false then 1 else 0
				end, valueState),
				BackgroundColor3 = _Computed(function(renderData: RenderData): Color3
					return renderData.Background.Color3
				end, renderDataState),
				ImageColor3 = _Computed(function(renderData: RenderData, enab: boolean): Color3
					return if not enab
						then renderData.Border.Color3
						else if renderData.Text then renderData.Text.Color3 else Color3.new(1, 1, 1)
				end, renderDataState, isEnabledState),
				Image = _Computed(function(i: ImageData?): string
					if i then
						return i.Image
					else
						return ""
					end
				end, iconImageState),
				ImageRectOffset = _Computed(function(i: ImageData?): Vector2
					return if i then i.ImageRectOffset else Vector2.zero
				end, iconImageState),
				ImageRectSize = _Computed(function(i: ImageData?): Vector2
					return if i then i.ImageRectSize else Vector2.zero
				end, iconImageState),
				Children = {
					_new("UICorner")({
						CornerRadius = _Computed(function(s: Style): UDim
							return UDim.new(0, s.Scale * CHECKBOX_SHAPE_DP)
						end, styleState),
					}),
					_new("UIStroke")({
						ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
						Color = _Computed(function(renderData: RenderData, v: boolean?): Color3
							return if v == false then renderData.Border.Color3 else renderData.Background.Color3
						end, renderDataState, valueState),
						LineJoinMode = Enum.LineJoinMode.Round,
						Thickness = _Computed(function(s: Style): number
							return s.Scale * UNSELECT_OUTLINE_WIDTH_DP
						end, styleState),
						Transparency = _Computed(function(renderData: RenderData): number
							return renderData.Border.Transparency
						end, renderDataState),
					}),
				},
			}),
		},
	}) :: GuiObject

	maid.bind(inst)

	return inst
end

return Interface
