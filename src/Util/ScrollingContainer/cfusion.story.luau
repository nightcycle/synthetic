--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
-- Modules
-- Types
-- Constants
-- Variables
-- References
-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local Module = require(script.Parent)

		local style = Style.new(
			1,
			"Arial",
			"Dark",
			Color3.fromHSV(math.random(), 0.7, 1),
			nil
		)

		local container = maid:GiveTask(Instance.new("Frame"))
		container.AnchorPoint = Vector2.one*0.5
		container.Position = UDim2.fromScale(0.5,0.5)
		container.Size = UDim2.fromOffset(300, 400)
		container.BorderSizePixel = 0
		container.Parent = frame

		local uiListLayout = maid:GiveTask(Instance.new("UIListLayout"))
		uiListLayout.Parent = container

		local out = maid:GiveTask(Module.ColdFusion.new())
		out.Size = UDim2.fromScale(1,1)
		out.Parent = container
	end)
	return function()
		maid:Destroy()
	end
end