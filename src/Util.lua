local packages = script.Parent.Parent
local attributerConstructor = require(packages:WaitForChild("attributer"))
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

return {
	SetPublicState = function(key, state, inst, maid)
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
		bindAttributeToState(key, state)
	end
}