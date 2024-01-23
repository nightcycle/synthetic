--!strict
-- inspired by the technique used here: https://devforum.roblox.com/t/circular-progression-module-for-all-your-ui-needs/1004470
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

-- Variables
-- References
-- Private Functions
function tickAlpha(period: number): number
	return (tick()%period)/period
end
function tickCycle(period: number): number
	return math.sin(math.rad(360)*tickAlpha(period))
end
function newRotaryElement(
	maid: Maid,
	progressStartState: State<number>,
	progressFinishState: State<number>,
	colorState: State<Color3>
): GuiObject
	local _fuse = ColdFusion.fuse(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local out = _new("CanvasGroup")({
		Size = UDim2.fromScale(1,1),
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5,0.5),
		BackgroundTransparency = 1,
		Children = {
			_new("UIGradient")({
				Transparency = NumberSequence.new(
					{
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(0.499, 0),
						NumberSequenceKeypoint.new(0.5, 1),
						NumberSequenceKeypoint.new(1, 1),
					}
				),
				Rotation = _Computed(function(start: number): number
					return (start + ROTATION_OFFSET)%360
				end, progressStartState),
			}),
			_new("ImageLabel")({
				Image = RING_ASSET_URL,
				ImageColor3 = colorState,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1,1),
				Position = UDim2.fromScale(0.5,0.5),
				AnchorPoint = Vector2.new(0.5,0.5),
				Children = {
					_new("UIGradient")({
						Transparency = NumberSequence.new(
							{
								NumberSequenceKeypoint.new(0, 1),
								NumberSequenceKeypoint.new(0.499, 1),
								NumberSequenceKeypoint.new(0.5, 0),
								NumberSequenceKeypoint.new(1, 0),
							}
						),
						Rotation = _Computed(function(finish: number): number
							return (finish + ROTATION_OFFSET)%360
						end, progressFinishState),
					}),
				}
			}),
		}
	}) :: GuiObject

	return out
end


-- Class
local Interface = {}

Interface.ColdFusion = {}
function Interface.ColdFusion.new(
	progress: CanBeState<number?>,
	isEnabled: CanBeState<boolean>,
	fillColor: CanBeState<Color3>,
	dividerColor: CanBeState<Color3>,
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
	local dividerColorState = _import(dividerColor, Color3.new())
	local emptyColorState = _import(emptyColor, Color3.new())
	local styleState: State<Style> = _import(style, nil :: any)

	local progressStartState = _Value(0)
	local progressWidthState = _Value(5)
	local progressFinishState = _Computed(function(start: number, width: number): number
		return (start + width)%360
	end, progressStartState, progressWidthState)

	maid:GiveTask(RunService.RenderStepped:Connect(function()
		progressStartState:Set(360*tickAlpha(2))
		progressWidthState:Set(90+60*tickCycle(3))
	end))

	local out = _new("Frame")({
		Size = _Computed(function(s: Style): UDim2
			return UDim2.fromOffset(s.Scale * DIAMETER_DP, s.Scale * DIAMETER_DP)
		end, styleState),
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5,0.5),
		BackgroundTransparency = 0.5,
		BackgroundColor3 = Color3.new(0.5,0.5,0.5),
		Children = {
			newRotaryElement(
				maid,
				progressStartState, 
				progressFinishState,
				fillColorState
			)
		}
	}) :: GuiObject

	maid:GiveTask(out.Destroying:Connect(function() maid:Destroy() end))

	return out
end

return Interface
