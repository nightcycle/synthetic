local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild("attributer"))

local constructor = {}

function constructor.new(config)
	config = config or {}
	local maid = maidConstructor.new()

	local radius = fusion.State(config.Radius or UDim.new(0, 5))
	local inst = fusion.New "UICorner" {
		CornerRadius = radius,
	}
	maid:GiveTask(inst)

	--bind to attributes
	local attributer = attributerConstructor.new(inst, {})
	maid:GiveTask(attributer)
	local function bindAttributeToState(key, state)
		attributer:Connect(key, state:get())
		maid:GiveTask(attributer.OnChanged:Connect(function(k, val)
			if k == key then
				state:set(val)
			end
		end))
	end
	bindAttributeToState("Radius", radius)

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		end
	end)

	return inst
end

return constructor