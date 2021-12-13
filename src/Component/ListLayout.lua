local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local enums = synthetic:WaitForChild("Enums")

local constructor = {}

function index(properties, key)
	local props = properties:get()
	return props[key]:get()
end

function update(properties, key, val)
	local props = properties:get()
	props[key]:set(val)
	properties:set(props)
end

function constructor.new()
	local properties = fusion.State({})

	local listLayout = fusion.New "UIListLayout" {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

	local maid = maidConstructor.new()
	maid.deathSignal = listLayout.AncestryChanged:Connect(function()
		if not listLayout:IsAncestorOf(game.Players.LocalPlayer) then
			maid:DoCleaning()
		end
	end)

	for k, state in pairs(properties:get()) do
		listLayout:SetAttribute(k, state:get())
		maid[k] = listLayout:GetAttributeChangedSignal(k):Connect(function()
			update(properties, k, listLayout:GetAttribute(k))
		end)
	end

	return listLayout
end

return constructor