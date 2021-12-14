local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local constructor = {}

function constructor.new(config)
	local listLayout = fusion.New "UIListLayout" {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

	local maid = maidConstructor.new()
	maid:GiveTask(listLayout)
	maid.deathSignal = listLayout.AncestryChanged:Connect(function()
		if not listLayout:IsDescendantOf(game.Players.LocalPlayer) then
			maid:DoCleaning()
		end
	end)

	return listLayout
end

return constructor