local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
-- local attributerConstructor = require(packages:WaitForChild("attribute"))

local Component = synthetic:WaitForChild("Component")
local atom = synthetic:WaitForChild("Atom")
local molecule = synthetic:WaitForChild("Molecule")

local constructor = {}

function constructor.new(config)
	local properties = fusion.State({

	})

	local inst

	local maid = maidConstructor.new()
	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
		end
	end)
	for k, state in pairs(properties:get()) do
		inst:SetAttribute(k, state:get())
		maid[k] = inst:GetAttributeChangedSignal(k):Connect(function()
			local val = inst:GetAttribute(k)
			update(properties,k, val)
		end)
	end

	return inst
end

return constructor