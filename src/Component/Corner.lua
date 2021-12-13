local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
-- local attributerConstructor = require(packages:WaitForChild("attribute"))

local Component = synthetic:WaitForChild("Component")
local atom = synthetic:WaitForChild("Atom")
local molecule = synthetic:WaitForChild("Molecule")

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
	local properties = fusion.State({
		CornerRadius = fusion.State(UDim.new(0, 5))
	})

	local UICorner = fusion.New "UICorner" {
		CornerRadius = index(properties, "CornerRadius"),
	}

	local maid = maidConstructor.new()
	maid.deathSignal = UICorner.AncestryChanged:Connect(function()
		if not UICorner:IsAncestorOf(game.Players.LocalPlayer) then
			maid:DoCleaning()
		end
	end)

	for k, state in pairs(properties:get()) do
		UICorner:SetAttribute(k, state:get())
		maid[k] = UICorner:GetAttributeChangedSignal(k):Connect(function()
			update(properties, k, UICorner:GetAttribute(k))
		end)
	end

	return UICorner
end

return constructor