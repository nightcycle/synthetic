local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local enums = synthetic:WaitForChild("Enums")
local UIAlignment = require(enums:WaitForChild("UIAlignment"))

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
	local properties = fusion.State({
		Padding = fusion.State(7)
	})
	local padding = fusion.New "UIPadding" {
		PaddingBottom = fusion.Computed(function()
			return UDim.new(0, index(properties,"Padding"))
		end),
		PaddingTop = fusion.Computed(function()
			return UDim.new(0, index(properties,"Padding"))
		end),
		PaddingLeft = fusion.Computed(function()
			return UDim.new(0, index(properties,"Padding"))
		end),
		PaddingRight = fusion.Computed(function()
			return UDim.new(0, index(properties,"Padding"))
		end),
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

	local maid = maidConstructor.new()
	maid.deathSignal = padding.AncestryChanged:Connect(function()
		if not padding:IsAncestorOf(game.Players.LocalPlayer) then
			maid:DoCleaning()
		end
	end)

	for k, state in pairs(properties:get()) do
		padding:SetAttribute(k, state:get())
		maid[k] = padding:GetAttributeChangedSignal(k):Connect(function()
			update(properties, k, padding:GetAttribute(k))
		end)
	end
	return padding
end

return constructor