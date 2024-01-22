--!strict
local _Package = script.Parent.Parent
local _Packages = _Package.Parent
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
-- Packages
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Maid = require(_Packages:WaitForChild("Maid"))
-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Container = require(_Package:WaitForChild("Util"):WaitForChild("Container"))

-- Types
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type Style = Style.Style
type ImageData = Types.ImageData
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

Util.ColdFusion = {}

function Util.ColdFusion.new(
	absolutePosition: CanBeState<Vector2>,
	anchorHorizontalAlignment: CanBeState<Enum.HorizontalAlignment>,
	anchorVerticalAlignment: CanBeState<Enum.VerticalAlignment>
): Frame
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local goalAbsolutePositionState: State<Vector2> = _import(absolutePosition, Vector2.new(0,0))
	local horizontalAlignmentState: State<Enum.HorizontalAlignment> = _import(anchorHorizontalAlignment, Enum.HorizontalAlignment.Left)
	local verticalAlignmentState: State<Enum.VerticalAlignment> = _import(anchorVerticalAlignment, Enum.VerticalAlignment.Top)

	local finalPositionState: ValueState<Vector2> = _Value(goalAbsolutePositionState:Get())

	local anchorPointState = _Computed(function(h: Enum.HorizontalAlignment, v: Enum.VerticalAlignment): Vector2
		return Vector2.new(
			1-if h == Enum.HorizontalAlignment.Left then 0 elseif h == Enum.HorizontalAlignment.Right then 1 else 0.5,
			1-if v == Enum.VerticalAlignment.Top then 0 elseif v == Enum.VerticalAlignment.Bottom then 1 else 0.5
		)
	end, horizontalAlignmentState, verticalAlignmentState)

	local screenGui = maid:GiveTask(_new("ScreenGui")({
		Name = "PopUpGui",
		DisplayOrder = 10000,
		Parent = if RunService:IsRunning() and Players.LocalPlayer then Players.LocalPlayer:WaitForChild("PlayerGui") else game:GetService("CoreGui"),
	})) :: Frame

	local out = _bind(Container.ColdFusion.new())({
		Parent = screenGui,
		Position = _Computed(function(pos: Vector2): UDim2
			return UDim2.fromOffset(pos.X, pos.Y)
		end, finalPositionState),
		AnchorPoint = anchorPointState,
	}) :: Frame
	maid.bind(out)

	maid:GiveTask(RunService.RenderStepped:Connect(function(deltaTime: number)
		local viewportSize = workspace.CurrentCamera.ViewportSize
		local absSize = out.AbsoluteSize
		local goalPos = goalAbsolutePositionState:Get()
		local anchorPoint = anchorPointState:Get()
		local x = math.clamp(
			goalPos.X,
			absSize.X * (anchorPoint.X), 
			viewportSize.X - absSize.X * (1-anchorPoint.X)
		)
		local y = math.clamp(
			goalPos.Y,
			absSize.Y * (anchorPoint.Y), 
			viewportSize.Y - absSize.Y * (1-anchorPoint.Y)
		)
		finalPositionState:Set(Vector2.new(x,y))
	end))

	return out
end

function Util.ColdFusion.fromGuiObject(
	guiObject: CanBeState<GuiObject>,
	anchorHorizontalAlignment: CanBeState<Enum.HorizontalAlignment?>,
	anchorVerticalAlignment: CanBeState<Enum.VerticalAlignment?>
): Frame
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local guiObjectState: State<GuiObject> = _import(guiObject, nil :: any)
	local horizontalAlignmentState: State<Enum.HorizontalAlignment> = _import(anchorHorizontalAlignment, Enum.HorizontalAlignment.Left)
	local verticalAlignmentState: State<Enum.VerticalAlignment> = _import(anchorVerticalAlignment, Enum.VerticalAlignment.Top)

	local function getAbsolutePosition(): Vector2
		local gui = guiObjectState:Get()
		local absPosition = gui.AbsolutePosition
		local absSize = gui.AbsoluteSize
		local h = horizontalAlignmentState:Get()
		local v = verticalAlignmentState:Get()
		local xWeight = if h == Enum.HorizontalAlignment.Left then 0 elseif h == Enum.HorizontalAlignment.Right then 1 else 0.5
		local yWeight = if v == Enum.VerticalAlignment.Top then 0 elseif v == Enum.VerticalAlignment.Bottom then 1 else 0.5
		return absPosition + Vector2.new(
			absSize.X * xWeight,
			absSize.Y * yWeight
		)
	end
	local absolutePosition = _Value(getAbsolutePosition())

	local out = Util.ColdFusion.new(
		absolutePosition,
		horizontalAlignmentState,
		verticalAlignmentState
	)

	maid.bind(out)
	maid:GiveTask(RunService.RenderStepped:Connect(function(deltaTime: number)
		absolutePosition:Set(getAbsolutePosition())
	end))

	return out
end

return Util