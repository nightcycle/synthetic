--!strict
local _Package = script.Parent.Parent.Parent
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

function Util.new(absolutePosition: CanBeState<Vector2>, anchorPoint: CanBeState<Vector2>): Frame
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local goalAbsolutePositionState: State<Vector2> = _import(absolutePosition, Vector2.new(0, 0))
	local anchorPointState: State<Vector2> = _import(anchorPoint, Vector2.zero)
	local finalPositionState: ValueState<Vector2> = _Value(goalAbsolutePositionState:Get())

	local screenGui = maid:GiveTask(_new("ScreenGui")({
		Name = "PopUpGui",
		DisplayOrder = 10000,
		Parent = if RunService:IsRunning() and Players.LocalPlayer
			then Players.LocalPlayer:WaitForChild("PlayerGui")
			else game:GetService("CoreGui"),
	})) :: Frame

	local out = _bind(Container.ColdFusion.new())({
		Parent = screenGui,
		Position = _Computed(function(pos: Vector2): UDim2
			return UDim2.fromOffset(pos.X, pos.Y)
		end, finalPositionState),
		AnchorPoint = anchorPointState,
	}) :: Frame
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	maid:GiveTask(RunService.RenderStepped:Connect(function(deltaTime: number)
		local viewportSize = workspace.CurrentCamera.ViewportSize
		local absSize = out.AbsoluteSize
		local goalPos = goalAbsolutePositionState:Get()
		local aPoint = anchorPointState:Get()
		local xMin = absSize.X * aPoint.X
		local yMin = absSize.Y * aPoint.Y

		local x = math.clamp(goalPos.X, xMin, math.max(xMin, viewportSize.X - absSize.X * (1 - aPoint.X)))
		local y = math.clamp(goalPos.Y, yMin, math.max(yMin, viewportSize.Y - absSize.Y * (1 - aPoint.Y)))
		finalPositionState:Set(Vector2.new(x, y))
	end))

	return out
end

function Util.fromGuiObject(
	guiObject: CanBeState<GuiObject>,
	guiObjectAnchorPoint: CanBeState<Vector2>,
	hintAnchorPoint: CanBeState<Vector2>
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
	local guiAnchorPoint: State<Vector2> = _import(guiObjectAnchorPoint, Vector2.one)

	local function getAbsolutePosition(): Vector2
		local gui = guiObjectState:Get()
		local absPosition = gui.AbsolutePosition
		local absSize = gui.AbsoluteSize
		local gAnchor = guiAnchorPoint:Get()

		return absPosition + Vector2.new(absSize.X * gAnchor.X, absSize.Y * gAnchor.Y)
	end
	local absolutePosition = _Value(getAbsolutePosition())

	local out = Util.new(absolutePosition, hintAnchorPoint)

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))
	maid:GiveTask(RunService.RenderStepped:Connect(function(deltaTime: number)
		absolutePosition:Set(getAbsolutePosition())
	end))

	return out
end

return Util
