local packages = script.Parent.Parent
local attributerConstructor = require(packages:WaitForChild("attributer"))
local fusion = require(packages:WaitForChild('fusion'))
local signalConstructor = require(packages:WaitForChild("signal"))

local ed = Enum.EasingDirection
local es = Enum.EasingStyle

function updateElevation(inst)
	local newParent = inst.Parent
	if newParent:IsA("GuiObject") then
		local parentAbsElevation = newParent:GetAttribute("AbsoluteElevation") or 0
		inst:SetAttribute("AbsoluteElevation", parentAbsElevation + inst:GetAttribute("ElevationIncrease"))
	end
end

return {
	setPublicState = function(key, state, inst, maid)
		--bind to attributes
		maid._attributer = maid._attributer or attributerConstructor.new(inst, {}, {})

		maid._attributer:Connect(key, state:get())
		local compat = fusion.Compat(state)
		maid:GiveTask(compat:onChange(function()
			if inst:GetAttribute(key) ~= state:get() then
				inst:SetAttribute(key, state:get())
			end
		end))
		maid:GiveTask(maid._attributer.OnChanged:Connect(function(k, val)
			if k == key and val ~= state:get() then
				state:set(val)
			end
		end))

	end,

	import = function(stateOrVal)
		if type(stateOrVal) == "table" or stateOrVal == nil then
			return stateOrVal
		else
			return fusion.State(stateOrVal)
		end
	end,

	init = function(key, inst, maid)
		inst:SetAttribute("SynthClass", key)
		local wasEverDescendeded = inst:IsDescendantOf(game.Players.LocalPlayer)
		maid.deathSignal = inst.AncestryChanged:Connect(function()
			if wasEverDescendeded == false then
				wasEverDescendeded = inst:IsDescendantOf(game.Players.LocalPlayer)
				if wasEverDescendeded == false then
					return
				end
			end
			wasEverDescendeded = true
			if not inst:IsDescendantOf(game.Players.LocalPlayer) then
				for i, desc in ipairs(inst:GetDescendants()) do
					desc:Destroy()
				end
				maid:Destroy()
				print("Destroy : "..tostring(key))
			else
				updateElevation(inst)
			end
		end)
	end,

	tween = function(state, params)
		params = params or {}
		local duration = params.Duration or 0.2
		local easingStyle = params.EasingStyle or es.Quint
		local easingDirection = params.EasingDirection or ed.InOut
		local repeatCount = params.RepeatCount or 0
		local reverses = params.Reverses or false
		local delayTime = params.DelayTime or 0
		return fusion.Tween(state, TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime))
	end,

	mergeConfig = function(baseConfig, changes, whiteList, blackList)
		if not whiteList then whiteList = changes end
		for k, v in pairs(changes) do
			if whiteList[k] ~= nil and baseConfig[k] == nil and blackList[k] == nil then
				baseConfig[k] = changes[k] or baseConfig[k]
			end
		end
		return baseConfig
	end
}