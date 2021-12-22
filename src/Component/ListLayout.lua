local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local constructor = {}

function constructor.new(config)
	config = config or {}

	config.Name = config.Name or script.Name
	config.FillDirection = config.FillDirection or Enum.FillDirection.Vertical
	config.SortOrder = config.SortOrder or Enum.SortOrder.LayoutOrder
	config.Padding = config.Padding or UDim.new(0, 5)
	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local listLayout = fusion.New "UIListLayout" (config)
	local maid = maidConstructor.new()
	maid:GiveTask(listLayout)

	return listLayout, maid
end

return constructor