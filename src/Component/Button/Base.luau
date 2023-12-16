--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local CurveUtil = require(_Packages:WaitForChild("CurveUtil"))

-- Modules
local Enums = require(_Package:WaitForChild("Enums"))
local Types = require(_Package:WaitForChild("Types"))
-- Types
type Maid = Maid.Maid
type Fuse = ColdFusion.Fuse
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type ImageData = Types.ImageData
type RenderData = Types.RenderData
type FontData = Types.FontData
type AppearanceData = Types.AppearanceData
-- Constants
local HEIGHT_DP = 40
local SHAPE_DP = 20
local ICON_SIZE_DP = 18
local CONTAINER_WIDTH_MIN_DP = 48
local LEFT_RIGHT_PADDING_DP = 12
local LEFT_PADDING_WITH_ICON_DP = 12
local RIGHT_PADDING_WITH_ICON_DP = 16
local PADDING_BETWEEN_ELEMENTS_DP = 8
local LABEL_TEXT_ALIGNMENT = Enum.TextXAlignment.Center
local IMAGE_SIZE = 500
local RIP_STEP = 0.005
local HALF_IMAGE_SIZE = IMAGE_SIZE / 2

local Util = {}

Util.component = function(
	maid: Maid,
	onClick: CanBeState<() -> ()>,
	text: CanBeState<string>,
	isEnabled: CanBeState<boolean>,
	renderDatas: CanBeState<{ [Enums.ButtonStateType]: RenderData }>,
	hasMinimumSize: CanBeState<boolean>?,
	cornerRadius: CanBeState<number>?,
	paddingScale: CanBeState<number>?,
	useRipple: CanBeState<boolean>?,
	textScale: CanBeState<number>?
): GuiObject
	local fuse = ColdFusion.fuse(maid)

	local _new = fuse.new
	local _bind = fuse.bind
	local _clone = fuse.clone
	local _import = fuse.import

	local _Value = fuse.Value
	local _Computed = fuse.Computed
	local isEnabledState = _import(isEnabled, true)
	local isFocusedState = _Value(false)
	local isPressedState = _Value(false)
	local isHoveredState = _Value(false)
	local textScaleState = _import(textScale, 1)

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
		function(state: Enums.ButtonStateType, r: { [Enums.ButtonStateType]: RenderData }): RenderData
			local renderData = r[state]
			assert(renderData ~= nil, `no renderData for {state}`)
			return renderData
		end,
		currentStateState,
		renderDatasState
	)
	local sound = _new("Sound")({
		SoundId = _Computed(function(st: RenderData): string
			return if st.Sound then st.Sound.SoundId else ""
		end, currentRenderDataState),
		Volume = _Computed(function(st: RenderData): number
			return if st.Sound then st.Sound.Volume else 0
		end, currentRenderDataState),
	}) :: Sound

	currentRenderDataState:Connect(function()
		task.wait()
		SoundService:PlayLocalSound(sound)
	end)

	local scaleState = _Computed(function(st: RenderData): number
		return st.Scale
	end, currentRenderDataState)
	local onClickState = _import(onClick, function() end)
	local textState = _import(text, "")
	local fontState = _Computed(function(st: RenderData): Font
		return if st.Font then st.Font.Font else Font.fromEnum(Enum.Font.Roboto)
	end, currentRenderDataState)
	local iconState = _Computed(function(st: RenderData): ImageData?
		return if st.Image then st.Image else nil
	end, currentRenderDataState)

	local hasMinState = _import(hasMinimumSize, true)
	local cornerRadiusState = _import(cornerRadius, SHAPE_DP)
	local paddingScaleState = _import(paddingScale, 1)
	local useRippleState = _import(useRipple, false)
	local currentTextRenderData: State<AppearanceData> = _Computed(function(rData: RenderData): AppearanceData
		local tData = rData.Text
		assert(tData, `bad text data`)
		return tData
	end, currentRenderDataState)

	local inst: Frame

	local rippleColorState: ValueState<ColorSequence?> = _Value(nil :: ColorSequence?)

	local function ripple(clickPosition: Vector2)
		local runMaid = Maid.new()
		local alpha = 0
		local xStart = inst.AbsolutePosition.X

		local initialAlpha = math.clamp((clickPosition.X - xStart) / inst.AbsoluteSize.X, 0, 1)

		runMaid:GiveTask(RunService.RenderStepped:Connect(function(deltaTime: number)
			alpha += deltaTime / 0.6

			local moveAlpha = 1
				- CurveUtil.ease(1 - math.clamp(alpha / 0.5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In)
			local fadeAlpha =
				CurveUtil.ease(math.clamp((alpha - 0.1) / 0.7, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			local baseColor = (renderDatasState:Get()[Enums.ButtonStateType.Enabled] :: RenderData).Background.Color3
			local rippleColor = (Color3.new(1, 1, 1):Lerp(baseColor, 0.8)):Lerp(baseColor, fadeAlpha)

			local leftOffset =
				math.clamp(initialAlpha - moveAlpha, RIP_STEP, math.max(initialAlpha - RIP_STEP, RIP_STEP * 1.5))
			local rightOffset = math.clamp(
				initialAlpha + moveAlpha,
				math.min(initialAlpha + RIP_STEP, 1 - RIP_STEP * 1.5),
				1 - RIP_STEP
			)

			rippleColorState:Set(ColorSequence.new({
				ColorSequenceKeypoint.new(0, baseColor),
				ColorSequenceKeypoint.new(leftOffset - RIP_STEP * 0.5, baseColor),
				ColorSequenceKeypoint.new(leftOffset, rippleColor),
				ColorSequenceKeypoint.new(rightOffset, rippleColor),
				ColorSequenceKeypoint.new(rightOffset + RIP_STEP * 0.5, baseColor),
				ColorSequenceKeypoint.new(1, baseColor),
			}))

			if alpha >= 1 then
				rippleColorState:Set(nil)
				runMaid:Destroy()
			end
		end))
		maid._ripple = runMaid
	end

	local shadowSizeState = _Computed(function(s: number, renderData: RenderData): UDim
		return if renderData and renderData.Shadow
			then UDim.new(renderData.Shadow.Offset.X * 5, renderData.Shadow.Offset.Y * 5)
			else UDim.new(0, 0)
	end, scaleState, currentRenderDataState)

	local borderThicknessState = _Computed(function(s: number): number
		return math.max(s * 1, 1)
	end, scaleState)

	inst = _new("Frame")({
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Children = {
			_new("UIPadding")({
				PaddingTop = shadowSizeState,
			}),
			_new("CanvasGroup")({
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromScale(0, 0),
				BackgroundTransparency = 1,
				GroupTransparency = _Computed(function(renderData: RenderData): number
					if renderData.Shadow then
						return renderData.Background.Transparency
					end
					return 0
				end, currentRenderDataState),
				Children = {
					_new("UIPadding")({
						PaddingTop = _Computed(function(renderData: RenderData, thickness: number): UDim
							if renderData.Border.Transparency >= 1 then
								return UDim.new(0, 0)
							else
								return UDim.new(0, thickness)
							end
						end, currentRenderDataState, borderThicknessState),
						PaddingBottom = _Computed(function(renderData: RenderData, thickness: number): UDim
							if renderData.Border.Transparency >= 1 then
								return UDim.new(0, 0)
							else
								return UDim.new(0, thickness)
							end
						end, currentRenderDataState, borderThicknessState),
						PaddingLeft = _Computed(function(renderData: RenderData, thickness: number): UDim
							if renderData.Border.Transparency >= 1 then
								return UDim.new(0, 0)
							else
								return UDim.new(0, thickness)
							end
						end, currentRenderDataState, borderThicknessState),
						PaddingRight = _Computed(function(renderData: RenderData, thickness: number): UDim
							if renderData.Border.Transparency >= 1 then
								return UDim.new(0, 0)
							else
								return UDim.new(0, thickness)
							end
						end, currentRenderDataState, borderThicknessState),
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
						Image = "rbxassetid://15549395120",
						ImageColor3 = _Computed(function(renderData: RenderData): Color3
							return if renderData.Shadow and renderData.Shadow.Appearance
								then renderData.Shadow.Appearance.Color3
								else Color3.new(0, 0, 0)
						end, currentRenderDataState),
						BackgroundTransparency = 1,
						ImageTransparency = _Computed(function(renderData: RenderData): number
							return if renderData.Shadow and renderData.Shadow.Appearance
								then renderData.Shadow.Appearance.Transparency
								else 1
						end, currentRenderDataState),
						ScaleType = Enum.ScaleType.Slice,
						AutomaticSize = Enum.AutomaticSize.XY,
						SliceCenter = Rect.new(HALF_IMAGE_SIZE, HALF_IMAGE_SIZE, HALF_IMAGE_SIZE, HALF_IMAGE_SIZE),
						SliceScale = 1,
						Children = {
							_new("UIListLayout")({
								Padding = UDim.new(0, 0),
								SortOrder = Enum.SortOrder.LayoutOrder,
								FillDirection = Enum.FillDirection.Horizontal,
								ItemLineAlignment = Enum.ItemLineAlignment.Center,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
							}),
							_new("UIPadding")({
								PaddingBottom = shadowSizeState,
							}),
							_new("TextButton")({
								Name = "TextButton",
								Text = "",
								BackgroundTransparency = _Computed(function(renderData: RenderData): number
									if renderData.Shadow then
										return 0
									else
										return renderData.Background.Transparency
									end
								end, currentRenderDataState),
								BackgroundColor3 = _Computed(function(renderData: RenderData, useRip: boolean): Color3
									if useRip then
										return Color3.new(1, 1, 1)
									end
									return renderData.Background.Color3
								end, currentRenderDataState, useRippleState),
								Active = isEnabledState,
								AutomaticSize = Enum.AutomaticSize.X,
								Size = _Computed(function(s: number, ts: number): UDim2
									return UDim2.fromOffset(0, s * HEIGHT_DP * ts)
								end, scaleState, textScaleState),
								Events = {
									Activated = function()
										if isEnabledState:Get() == false then
											return
										end
										local click = onClickState:Get()
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
										if useRippleState:Get() then
											ripple(Vector2.new(x, y))
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
										CornerRadius = _Computed(function(s: number, cornerRad: number): UDim
											return UDim.new(0, s * cornerRad)
										end, scaleState, cornerRadiusState),
									}),
									_new("UIGradient")({
										Color = _Computed(
											function(
												useRip: boolean,
												renderData: RenderData,
												seq: ColorSequence?
											): ColorSequence
												if useRip then
													if seq then
														return seq
													else
														return ColorSequence.new(renderData.Background.Color3)
													end
												else
													return ColorSequence.new(Color3.new(1, 1, 1))
												end
											end,
											useRippleState,
											currentRenderDataState,
											rippleColorState
										),
									}),
									_new("UIStroke")({
										ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
										Color = _Computed(function(renderData: RenderData): Color3
											return renderData.Border.Color3
										end, currentRenderDataState),
										LineJoinMode = Enum.LineJoinMode.Round,
										Thickness = borderThicknessState,
										Transparency = _Computed(function(renderData: RenderData): number
											return renderData.Border.Transparency
										end, currentRenderDataState),
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
										Visible = _Computed(function(txt: string): boolean
											return txt:len() > 0
										end, textState),
										TextScaled = true,
										TextXAlignment = LABEL_TEXT_ALIGNMENT,
										TextYAlignment = Enum.TextYAlignment.Center,
										BackgroundTransparency = 1,
										AutomaticSize = Enum.AutomaticSize.X,
										FontFace = fontState,
										LayoutOrder = 2,
										TextColor3 = _Computed(function(renderData: AppearanceData): Color3
											return renderData.Color3
										end, currentTextRenderData),
										TextTransparency = _Computed(function(renderData: AppearanceData): number
											return renderData.Transparency
										end, currentTextRenderData),
										Size = _Computed(function(s: number, ts: number): UDim2
											return UDim2.fromOffset(0, s * ICON_SIZE_DP * ts)
										end, scaleState, textScaleState),
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
										ImageColor3 = _Computed(
											function(icon: ImageData?, renderData: AppearanceData?): Color3
												return if icon and renderData
													then renderData.Color3
													else Color3.new(1, 1, 1)
											end,
											iconState,
											currentTextRenderData
										),
										ImageRectOffset = _Computed(function(icon: ImageData?): Vector2
											return if icon then icon.ImageRectOffset else Vector2.zero
										end, iconState),
										ImageRectSize = _Computed(function(icon: ImageData?): Vector2
											return if icon then icon.ImageRectSize else Vector2.zero
										end, iconState),
										ImageTransparency = _Computed(
											function(icon: ImageData?, renderData: AppearanceData?): number
												return if icon and renderData then renderData.Transparency else 1
											end,
											iconState,
											currentTextRenderData
										),
										SizeConstraint = Enum.SizeConstraint.RelativeYY,
										Size = _Computed(function(s: number): UDim2
											return UDim2.fromScale(1, 1)
											-- return UDim2.fromOffset(s * ICON_SIZE_DP, s * ICON_SIZE_DP)
										end, scaleState),
									}),
									_new("UIPadding")({
										PaddingLeft = _Computed(
											function(s: number, icon: ImageData?, txt: string, padScale: number): UDim
												if icon then
													if txt:len() > 0 then
														return UDim.new(0, padScale * LEFT_PADDING_WITH_ICON_DP * s)
													else
														return UDim.new(
															0,
															padScale * s * (HEIGHT_DP - ICON_SIZE_DP) / 2
														)
													end
												else
													return UDim.new(0, padScale * LEFT_RIGHT_PADDING_DP * s)
												end
											end,
											scaleState,
											iconState,
											textState,
											paddingScaleState
										),
										PaddingRight = _Computed(
											function(s: number, icon: ImageData?, txt: string, padScale: number): UDim
												if icon then
													if txt:len() > 0 then
														return UDim.new(0, padScale * RIGHT_PADDING_WITH_ICON_DP * s)
													else
														return UDim.new(
															0,
															padScale * s * (HEIGHT_DP - ICON_SIZE_DP) / 2
														)
													end
												else
													return UDim.new(0, padScale * LEFT_RIGHT_PADDING_DP * s)
												end
											end,
											scaleState,
											iconState,
											textState,
											paddingScaleState
										),
										PaddingTop = _Computed(function(s: number, padScale: number): UDim
											return UDim.new(0, padScale * s * (HEIGHT_DP - ICON_SIZE_DP) / 2)
										end, scaleState, paddingScaleState),
										PaddingBottom = _Computed(function(s: number, padScale: number): UDim
											return UDim.new(0, padScale * s * (HEIGHT_DP - ICON_SIZE_DP) / 2)
										end, scaleState, paddingScaleState),
									}),
									_new("UISizeConstraint")({
										MaxSize = Vector2.new(math.huge, math.huge),
										MinSize = _Computed(function(s: number, hasMin: boolean): Vector2
											if hasMin then
												return Vector2.new(s * CONTAINER_WIDTH_MIN_DP, 0)
											else
												return Vector2.new(0, 0)
											end
										end, scaleState, hasMinState),
									}),
								},
							}) :: TextButton,
						},
					}),
				},
			}),
		},
	}) :: Frame

	return inst
end

return Util
