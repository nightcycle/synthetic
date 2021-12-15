local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild('attributer'))

local constructor = {}

function constructor.new(config)
	config = config or {}
	local padding = fusion.State(config.Padding or 7)
	local paddingUdim = fusion.Computed(function()
		return UDim.new(0, padding)
	end)
	local maid = maidConstructor.new()

	local inst = fusion.New "UIPadding" {
		PaddingBottom = paddingUdim,
		PaddingTop = paddingUdim,
		PaddingLeft = paddingUdim,
		PaddingRight = paddingUdim,
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
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
	bindAttributeToState("Padding", padding)

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		end
	end)
	return inst
end

return constructor