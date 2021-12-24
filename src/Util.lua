local packages = script.Parent.Parent
local attributerConstructor = require(packages:WaitForChild("attributer"))
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))


function updateElevation(inst)
	local newParent = inst.Parent
	if newParent:IsA("GuiObject") then
		local parentAbsElevation = newParent:GetAttribute("AbsoluteElevation") or 0
		inst:SetAttribute("AbsoluteElevation", parentAbsElevation + inst:GetAttribute("ElevationIncrease"))
	end
end


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
	end,

	Init = function(key, inst, maid)
		inst:SetAttribute("SynthClass", key)
		inst:SetAttribute("ElevationIncrease", 1)
		inst:SetAttribute("AbsoluteElevation", 0)

		maid.deathSignal = inst.AncestryChanged:Connect(function()
			if not inst:IsDescendantOf(game.Players.LocalPlayer) then
				for i, desc in ipairs(inst:GetDescendants()) do
					desc:Destroy()
				end
				maid:Destroy()
			else
				updateElevation(inst)
			end
		end)
	end,
}