local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local typography = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()
	local inst
	local config = {}
	util.mergeConfig(config, params)

	--public states
	local Color = fusion.State(config.Color or Color3.new(0.5, 0, 1))
	local BackgroundColor = fusion.State(config.BackgroundColor or Color3.new(0.5,0.5,0.5))
	local MinimumValue = fusion.State(config.MinimumValue or 0)
	local MaximumValue = fusion.State(config.MaximumValue or 1)
	local Precision = fusion.State(config.Precision or 0.2)
	local Value = fusion.State(config.Value or 0.5)
	local Typography = util.import(params.Typography) or typography.new(Enum.Font.SourceSans, 10, 14)

	--read only public states
	local Alpha = fusion.State(0.5)
	local DisplayedValue = fusion.Computed(function()
		local minVal = MinimumValue:get()
		local maxVal = MaximumValue:get()
		local rangeVal = maxVal - minVal
		local alpha = Alpha:get()
		return minVal + alpha * rangeVal
	end)

	--public functions
	local OnSet = fusion.New "BindableEvent" {
		Name = "OnSet",
		Parent = inst
	}

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)


	--properties
	local _Padding = fusion.Computed(function()
		return Typography:get().Padding
	end)

	--Slider update variables
	local IsDragging = false
	local inputPosition = Vector2.new(0,0)
	local holdTrackerMaid = maidConstructor.new()
	maid:GiveTask(holdTrackerMaid)

	--preparing config
	local config = {
		Name = script.Name,
		LeftColor = Color,
		RightColor = BackgroundColor,
		Precision = Precision,
		Alpha = Alpha,
		KnobEnabled = true,
		Padding = _Padding,
		[fusion.OnEvent "InputBegan"] = function()
			if IsDragging == false and userInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then
				IsDragging = true
				local knob = inst:FindFirstChild("Knob")
				if knob then
					holdTrackerMaid:GiveTask(runService.RenderStepped:Connect(function()
						local startX = inst.AbsolutePosition.X
						local finishX = inst.AbsolutePosition.X + inst.AbsoluteSize.X
						local rangeX = finishX - startX
						local alpha = math.clamp((inputPosition.X-startX)/rangeX, 0, 1)
						local minValue = MinimumValue:get()
						local maxValue = MaximumValue:get()
						local range = maxValue - minValue
						local offsetVal = math.round(range*alpha/Precision:get())*Precision:get()
						alpha = offsetVal/range

					end))
				end
			end
		end,
	}
	util.mergeConfig(config, params, nil, {
		Selected = true,
		Theme = true,
		Color = true,
	})
	inst = synthetic.New "ProgressBar" (config)

	--bind to attributes
	util.setPublicState("Color", Color, inst, maid)
	util.setPublicState("BackgroundColor", BackgroundColor, inst, maid)
	util.setPublicState("MinimumValue", MinimumValue, inst, maid)
	util.setPublicState("MaximumValue", MaximumValue, inst, maid)
	util.setPublicState("Precision", Precision, inst, maid)
	util.setPublicState("Value", Value, inst, maid)
	util.setPublicState("DisplayedValue", DisplayedValue, inst, maid)
	util.setPublicState("Alpha", Alpha, inst, maid)

	util.init(script.Name, inst, maid)
	return inst
end

return constructor