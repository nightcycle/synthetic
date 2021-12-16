local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local constructor = {}

function constructor.new(config)
	config = config or {}
	local listLayout = fusion.New "UIListLayout" {
		Name = script.Name,
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

	local maid = maidConstructor.new()
	maid:GiveTask(listLayout)

	return listLayout, maid
end

return constructor