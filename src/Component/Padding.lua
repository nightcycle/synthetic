local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild('attributer'))

local constructor = {}

function constructor.new(config)
	config = config or {}
	local padding = fusion.State(config.Padding or UDim.new(0,7))
	local maid = maidConstructor.new()

	config.Name = config.Name or script.Name
	config.PaddingBottom = config.PaddingBottom or padding
	config.PaddingTop = config.PaddingTop or padding
	config.PaddingLeft = config.PaddingLeft or padding
	config.PaddingRight = config.PaddingRight or padding
	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local inst = fusion.New "UIPadding" (config)
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

	return inst, maid
end

return constructor