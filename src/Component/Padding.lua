local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild('attributer'))

local constructor = {}

function constructor.new(config)
	config = config or {}
	local padding = fusion.State(config.Padding or UDim.new(0,7))
	local maid = maidConstructor.new()

	local inst = fusion.New "UIPadding" {
		Name = script.Name,
		PaddingBottom = padding,
		PaddingTop = padding,
		PaddingLeft = padding,
		PaddingRight = padding,
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}
	maid:GiveTask(inst)

	--bind to attributes
	local attributer = attributerConstructor.new(inst, {})
	maid:GiveTask(attributer)
	local function bindAttributeToState(key, state)
		attributer:Connect(key, state:get())
		local compat = fusion.Compat(state)
		maid:GiveTask(compat:onChange(function()
			if inst:GetAttribute(key) ~= state:get() then
				inst:SetAttribute(key, state:get())
			end
		end))
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