--!strict
-- Services
-- Packages
local Maid = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Maid"))
-- Modules
-- Types
-- Constants
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

		local container = maid:GiveTask(module.ColdFusion.fromGuiObject(
			textLabel
		))
		local uiLayout = maid:GiveTask(Instance.new("UIListLayout"))
		uiLayout.Parent = container
		hint.Parent = container
	end)
	return function()
		maid:Destroy()
	end
end