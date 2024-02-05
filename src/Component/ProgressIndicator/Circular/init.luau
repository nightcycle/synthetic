--!strict
-- inspired by the technique used here: https://devforum.roblox.com/t/circular-progression-module-for-all-your-ui-needs/1004470
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent

-- Services
local RunService = game:GetService("RunService")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Spring = require(_Packages:WaitForChild("Spring"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

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

-- Constants
local DIAMETER_DP = 48
local RING_ASSET_URL = "rbxassetid://3587367081"
local ROTATION_OFFSET = 180
local BUFFER = 10
local USE_EDITABLE_IMAGE = RunService:IsStudio()
-- Variables
-- References
-- Private Functions
function tickAlpha(period: number, offset: number?): number
	offset = offset or 0
	assert(offset)
	return ((tick() - offset) % period) / period
end
function tickCycle(period: number, offset: number?): number
	return math.cos(math.rad(360) * tickAlpha(period, offset))
end
function newSemiRotaryElement(
	maid: Maid,
	progressStartState: State<number>,
	progressFinishState: State<number>,
	colorState: State<Color3>,
	transparencyState: State<number>
): GuiObject
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local out = _new("CanvasGroup")({
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Children = {
			_new("UIGradient")({
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(0.499, 0),
					NumberSequenceKeypoint.new(0.5, 1),
					NumberSequenceKeypoint.new(1, 1),
				}),
				Rotation = _Computed(function(start: number): number
					return (start + ROTATION_OFFSET) % 360
				end, progressStartState),
			}),
			_new("ImageLabel")({
				Image = RING_ASSET_URL,
				ImageColor3 = colorState,
				ImageTransparency = transparencyState,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Children = {
					_new("UIGradient")({
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 1),
							NumberSequenceKeypoint.new(0.499, 1),
							NumberSequenceKeypoint.new(0.5, 0),
							NumberSequenceKeypoint.new(1, 0),
						}),
						Rotation = _Computed(function(finish: number): number
							return (finish + ROTATION_OFFSET) % 360
						end, progressFinishState),
					}),
				},
			}),
		},
	}) :: GuiObject

	return out
end

function newRotaryElement(
	maid: Maid,
	progressStartState: State<number>,
	progressWidthState: State<number>,
	colorState: State<Color3>,
	transparencyState: State<number>
): GuiObject
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local progressFinishState = _Computed(function(start: number, width: number): number
		return (start + width) % 360
	end, progressStartState, progressWidthState)
	local progressMidState = _Computed(function(start: number, width: number): number
		return (start + width * 0.5) % 360
	end, progressStartState, progressWidthState)


	return _new("Frame")({
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Children = {
			newSemiRotaryElement(maid, progressStartState, progressMidState, colorState, transparencyState),
			newSemiRotaryElement(maid, progressMidState, progressFinishState, colorState, transparencyState),
		},
	}) :: GuiObject


end

-- Class
local Interface = {}

Interface.ColdFusion = {}

function Interface.ColdFusion.primary(
	style: CanBeState<Style>,
	progress: CanBeState<number?>,
	isEnabled: CanBeState<boolean>?
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

	local out = Interface.ColdFusion.new(
		progress,
		if isEnabled == nil then true else isEnabled,
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Primary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.PrimaryContainer)
		end, styleState),
		styleState
	)

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.ColdFusion.secondary(
	style: CanBeState<Style>,
	progress: CanBeState<number?>,
	isEnabled: CanBeState<boolean>?
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

	local out = Interface.ColdFusion.new(
		progress,
		if isEnabled == nil then true else isEnabled,
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Secondary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.SecondaryContainer)
		end, styleState),
		styleState
	)

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.ColdFusion.tertiary(
	style: CanBeState<Style>,
	progress: CanBeState<number?>,
	isEnabled: CanBeState<boolean>?
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

	local out = Interface.ColdFusion.new(
		progress,
		if isEnabled == nil then true else isEnabled,
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.Tertiary)
		end, styleState),
		_Computed(function(s: Style): Color3
			return s:GetColor(Enums.ColorRoleType.TertiaryContainer)
		end, styleState),
		styleState
	)

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

function Interface.ColdFusion.new(
	progress: CanBeState<number?>,
	isEnabled: CanBeState<boolean>,
	fillColor: CanBeState<Color3>,
	emptyColor: CanBeState<Color3>,
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

	local inputProgressState: State<number?> = _import(progress, nil :: number?)
	local isEnabledState = _import(isEnabled, true)
	local fillColorState = _import(fillColor, Color3.new())
	local emptyColorState = _import(emptyColor, Color3.new())
	local styleState: State<Style> = _import(style, nil :: any)

	local transparencyState = _Computed(function(isEnab: boolean): number
		return if isEnab then 0 else 1
	end, isEnabledState):Tween(0.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)

	local progressStartState = _Value(0)
	local progressWidthState = _Value(0)

	local startSpring = Spring.new(30, 40, 0)
	local widthSpring = Spring.new(70, 80, 0)

	maid:GiveTask(RunService.RenderStepped:Connect(function(deltaTime: number)
		if inputProgressState:Get() ~= nil then
			local inputProgress = inputProgressState:Get()
			assert(inputProgress)
			startSpring:Set(0)
			widthSpring:Set(inputProgress * 360)
		else
			local start = (360 * tickAlpha(2)) % 360
			local width = (180 + 140 * tickCycle(5)) % 360

			startSpring:Set(start)
			widthSpring:Set(width)
		end

		if startSpring.Position - 180 > startSpring.Goal then
			startSpring.Position -= 360
		elseif startSpring.Position + 180 < startSpring.Goal then
			startSpring.Position += 360
		end

		-- if widthSpring.Position-180 > widthSpring.Goal then
		-- 	widthSpring.Position -= 360
		-- end

		startSpring:Step(deltaTime)
		widthSpring:Step(deltaTime)

		progressStartState:Set(startSpring:Get() % 360)
		progressWidthState:Set(widthSpring:Get() % 360)
	end))
	local editableImage = maid:GiveTask(Instance.new("EditableImage"))

	local imageLabel = _new("ImageLabel")({
		Size = UDim2.fromScale(1, 1),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		Children = {
			editableImage
		}
	}) :: GuiObject

	local out = _new("Frame")({
		Size = _Computed(function(s: Style): UDim2
			return UDim2.fromOffset(s.Scale * DIAMETER_DP, s.Scale * DIAMETER_DP)
		end, styleState),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		-- BackgroundColor3 = Color3.new(0.5,0.5,0.5),
		Children = if USE_EDITABLE_IMAGE then {imageLabel} else {
			_bind(newRotaryElement(maid, progressStartState, progressWidthState, fillColorState, transparencyState))({
				ZIndex = 2,
				Name = "Fill",
			}),
			_bind(newRotaryElement(
				maid,
				_Computed(function(start: number, width: number): number
					return (start + width + BUFFER) % 360
				end, progressStartState, progressWidthState),
				_Computed(function(width: number): number
					return 360 - width - BUFFER * 2
				end, progressWidthState),
				emptyColorState,
				transparencyState
			))({
				ZIndex = 1,
				Name = "Empty",
			}),
		},
	}) :: GuiObject

	if USE_EDITABLE_IMAGE then
		maid:GiveTask(RunService.RenderStepped:Connect(function(deltaTime: number)
			editableImage.Size = imageLabel.AbsoluteSize
			local outerRadius = editableImage.Size.X * 0.5
			local innerRadius = outerRadius * 0.5
			local center = editableImage.Size/2
			local fCol = fillColorState:Get()
			local eCol = emptyColorState:Get()

			local trans = transparencyState:Get()
			editableImage:DrawRectangle(Vector2.zero, editableImage.Size-Vector2.one, eCol, 1)
			for y=0, editableImage.Size.Y-1 do
				for x=0, editableImage.Size.X-1 do
					local offset = (Vector2.new(x,y)-center)*Vector2.new(1,-1)
					local dist = offset.Magnitude
					if dist > innerRadius and dist < outerRadius then
						local startAngle = progressStartState:Get()+BUFFER
						local widthAngle = progressWidthState:Get()
						local finishAngle = startAngle + widthAngle-BUFFER

						local angle = math.deg(math.atan2(offset.Y, offset.X))
						if angle < 0 then
							angle = math.deg(360)-angle
						end
						local isFilled = angle > startAngle and angle < finishAngle

						if isFilled then
							editableImage:DrawRectangle(
								Vector2.new(x,y),
								Vector2.one,
								fCol,
								trans
							)
						else
							editableImage:DrawRectangle(
								Vector2.new(x,y),
								Vector2.one,
								eCol,
								trans
							)
						end
					end
				end
			end
		end))
	end

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

return Interface
