local Players = game:GetService("Players")
local runService = game:GetService("RunService")
local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local signalConstructor = require(packages:WaitForChild('signal'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

local expandParams = {
	Duration = 0.25,
	EasingDirection = Enum.EasingDirection.Out,
	EasingStyle = Enum.EasingStyle.Quad,
}
local resetParams = {
	Duration = 0.3,
	EasingDirection = Enum.EasingDirection.Out,
	EasingStyle = Enum.EasingStyle.Quad,
}

local states = {
	Unknown = 0,
	Default = 1,
	Expanding = 2,
	Resetting = 3,
}

function constructor.new(params)
	local inst
	local maid = maidConstructor.new()
	local parentMaid = maidConstructor.new()
	maid:GiveTask(parentMaid)

	--public states
	local public = {
		Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1)),
		SynthClassName = fusion.Computed(function()
			return script.Name
		end),
	}

	--establish basic high level variables
	local _Parent = fusion.State(params.Parent)
	local _State = fusion.State(states.Default)
	local factor = 0.825

	local _HighlightColor = fusion.Computed(function()
		if _State:get() == states.Resetting then
			return public.Color:get()
		else
			local h,s,v = public.Color:get():ToHSV()
			return Color3.fromHSV(h,s*factor,1-(1-v)*factor)
		end
	end)


	--set up reset sequence
	local _ResetColor = util.tween(_HighlightColor, resetParams)
	local _ResetSequence = fusion.Computed(function()
		return ColorSequence.new(_ResetColor:get())
	end)

	--set up expand sequence
	local _StartPosition = fusion.State(0.5)
	local _Alpha = fusion.State(0)

	local _CurrentGoal = fusion.State(_Alpha)

	local _ExpandSequence = fusion.Computed(function()

		local startPos = _StartPosition:get()
		local currentAlpha = _CurrentGoal:get()
		local alpha = currentAlpha:get()

		local limit = 0.002
		local leftAlpha = math.clamp(startPos - alpha, limit, 1-limit)
		local rightAlpha = math.clamp(startPos + alpha, math.min(leftAlpha+limit, 1-limit*2), 1-limit)
		local fxCol = _HighlightColor:get()
		local baseCol = public.Color:get()

		local colSeq = {}
		if leftAlpha > 0.002 and leftAlpha < 1-0.002 then
			table.insert(colSeq, ColorSequenceKeypoint.new(0, baseCol))
			table.insert(colSeq, ColorSequenceKeypoint.new(leftAlpha-limit, baseCol))
			table.insert(colSeq, ColorSequenceKeypoint.new(leftAlpha-limit*0.5, fxCol))
		else
			table.insert(colSeq, ColorSequenceKeypoint.new(0, fxCol))
		end

		if rightAlpha > 0.002 and rightAlpha < 1-0.002 then
			table.insert(colSeq, ColorSequenceKeypoint.new(rightAlpha+limit*0.5, fxCol))
			table.insert(colSeq, ColorSequenceKeypoint.new(rightAlpha+limit, baseCol))
			table.insert(colSeq, ColorSequenceKeypoint.new(1, baseCol))
		else
			table.insert(colSeq, ColorSequenceKeypoint.new(1, fxCol))
		end

		return ColorSequence.new(colSeq)
	end)

	--default
	local defaultSignal = signalConstructor.new()
	maid:GiveTask(defaultSignal)
	maid:GiveTask(defaultSignal:Connect(function()
		if _State:get() ~= states.Resetting then return end
		_State:set(states.Default)
	end))

	-- reset
	local resetSignal = signalConstructor.new()
	maid:GiveTask(resetSignal)
	maid:GiveTask(resetSignal:Connect(function()
		if _State:get() ~= states.Expanding then return end
		_State:set(states.Resetting)
		task.wait(resetParams.Duration + 1/60)
		defaultSignal:Fire()
	end))

	-- expand
	local expandSignal = signalConstructor.new()
	maid:GiveTask(expandSignal)
	maid:GiveTask(expandSignal:Connect(function()
		if _State:get() == states.Resetting then return end
		_Alpha:set(0)
		_CurrentGoal:set(util.tween(_Alpha, expandParams))
		_Alpha:set(1)
		_State:set(states.Expanding)
		task.wait(expandParams.Duration + 1/60)
		resetSignal:Fire()
	end))

	--constructor
	inst = util.set(fusion.New "UIGradient", public, params, {
		Color = fusion.Computed(function()

			local defColor = public.Color:get()
			local expSeq = _ExpandSequence:get()
			local resSeq = _ResetSequence:get()

			if _State:get() == states.Default then
				return ColorSequence.new(defColor)
			elseif _State:get() == states.Expanding then
				return expSeq
			elseif _State:get() == states.Resetting then
				return resSeq
			end

		end),
		[fusion.Children] = {
			fusion.New "BindableEvent" {
				Name = "Effect",
				[fusion.OnEvent "Event"] = function(viewport:Vector2)
					local parent = _Parent:get()
					if not parent then return end

					if viewport then
						local absSize = parent.AbsoluteSize
						local absPos = parent.AbsolutePosition
						local dif = viewport.X - absPos.X
						_StartPosition:set(math.clamp(dif/absSize.X, 0, 1))
					else
						_StartPosition:set(0.5)
					end
					expandSignal:Fire()
				end,
			}
		},
		[fusion.OnEvent "AncestryChanged"] = function()
			parentMaid:DoCleaning()
			_Parent:set(inst.Parent)
		end,
	}, maid)

	return inst
end

return constructor