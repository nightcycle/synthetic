--!strict
-- Services
-- Packages
local Maid = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Maid"))
local ColdFusion =
	require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("ColdFusion"))

-- Modules
-- Types
-- Constants
local ANCHOR_POINT_KEY = "GuiAnchorPoint"
local HINT_ANCHOR_POINT_KEY = "HintAnchorPoint"
-- Variables
-- References
-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local module = require(script.Parent)

		local textLabel = maid:GiveTask(Instance.new("TextLabel"))
		textLabel.Size = UDim2.fromOffset(200, 50)
		textLabel.Parent = frame

		local hint = maid:GiveTask(Instance.new("TextLabel"))
		hint.Text = "Hint"
		hint.Size = UDim2.fromOffset(100, 25)
		hint.Parent = frame

		local _fuse = ColdFusion.fuse(maid)

		local _new = _fuse.new
		local _bind = _fuse.bind
		local _clone = _fuse.clone
		local _import = _fuse.import

		local _Value = _fuse.Value
		local _Computed = _fuse.Computed

		local anchorPointState = _Value(Vector2.one)
		local hintAnchorPointState = _Value(Vector2.zero)

		local container =
			maid:GiveTask(module.ColdFusion.fromGuiObject(textLabel, anchorPointState, hintAnchorPointState))

		container:SetAttribute(ANCHOR_POINT_KEY, anchorPointState:Get())
		maid:GiveTask(container:GetAttributeChangedSignal(ANCHOR_POINT_KEY):Connect(function()
			local anchorPoint = container:GetAttribute(ANCHOR_POINT_KEY)
			assert(typeof(anchorPoint) == "Vector2", `{ANCHOR_POINT_KEY} must be a Vector2`)
			anchorPointState:Set(anchorPoint)
		end))

		container:SetAttribute(HINT_ANCHOR_POINT_KEY, hintAnchorPointState:Get())
		maid:GiveTask(container:GetAttributeChangedSignal(HINT_ANCHOR_POINT_KEY):Connect(function()
			local hintAnchorPoint = container:GetAttribute(HINT_ANCHOR_POINT_KEY)
			assert(typeof(hintAnchorPoint) == "Vector2", `{HINT_ANCHOR_POINT_KEY} must be a Vector2`)
			hintAnchorPointState:Set(hintAnchorPoint)
		end))

		local uiLayout = maid:GiveTask(Instance.new("UIListLayout"))
		uiLayout.Parent = container
		hint.Parent = container
	end)
	return function()
		maid:Destroy()
	end
end
