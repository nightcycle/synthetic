local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local enums = synthetic:WaitForChild("Enums")

local constructor = {}

local ed = Enum.EasingDirection
local es = Enum.EasingStyle

function newTweenInfo(params)
	params = params or {}
	local duration = params.Duration or 0.5
	local easingStyle = params.EasingStyle or es.Quint
	local easingDirection = params.EasingDirection or ed.InOut
	local repeatCount = params.RepeatCount or 0
	local reverses = params.Reverses or false
	local delayTime = params.DelayTime or 0
	return TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
end

local Tweens = {
	Transition = newTweenInfo(),
	Pop = newTweenInfo({es.Back, Duration = 0.25}),
}

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
		Elevation = fusion.State(1),
		IsFocused = fusion.State(false)
	})


	local target = script.Parent


	local inst = fusion.New "Configuration" {
		Name = "InputEffect",
		[fusion.Event "InputChanged"] = function()
			update(properties, "IsFocused", true)
		end,
		[fusion.Event "InputEnded"] = function()
			update(properties, "IsFocused", false)
		end,
		Size = fusion.Tween(fusion.Computed(function()
			if index(properties, "IsFocused") == true then
				return index(properties, "FocusSize")
			else
				return index(properties, "RestSize")
			end
		end), Tweens.Pop),
	}

	local maid = maidConstructor.new()
	maid.deathSignal = inst.AncestryChanged:Connect(function()
		target = script.Parent
		if not inst:IsAncestorOf(game.Players.LocalPlayer) then
			maid:DoCleaning()
		end
	end)
	for k, state in pairs(properties:get()) do
		inst:SetAttribute(k, state:get())
		maid[k] = inst:GetAttributeChangedSignal(k):Connect(function()
			local val = inst:GetAttribute(k)
			update(properties,k, val)
		end)
	end


	return
end

return constructor