local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))

local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local constructor = {}

function constructor.new(params)
	local inst
	local maid = maidConstructor.new()

	--public states
	local public = {
		Color = fusion.State(params.Color or Color3.new(0.5, 0, 1)),
		BackgroundColor = fusion.State(params.BackgroundColor or Color3.new(0.5,0.5,0.5)),
		MinimumValue = fusion.State(params.MinimumValue or 0),
		MaximumValue = fusion.State(params.MaximumValue or 1),
		Precision = fusion.State(params.Precision or 0.2),
		Value = fusion.State(params.Value or 0.5),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}

	--read only public states
	public.Alpha = fusion.State(0.5)
	public.DisplayedValue = fusion.Computed(function()
		local minVal = public.MinimumValue:get()
		local maxVal = public.MaximumValue:get()
		local rangeVal = maxVal - minVal
		local alpha = public.Alpha:get()
		return minVal + alpha * rangeVal
	end)

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)

	--properties
	local _Padding = fusion.Computed(function()
		return public.Typography:get().Padding
	end)

	--Slider update variables
	local IsDragging = false
	local inputPosition = Vector2.new(0,0)
	local holdTrackerMaid = maidConstructor.new()
	maid:GiveTask(holdTrackerMaid)

	--preparing config
	inst = util.set(synthetic.New "ProgressBar", public, params, {
		Name = script.Name,
		LeftColor = public.Color,
		RightColor = public.BackgroundColor,
		Precision = public.Precision,
		Alpha = public.Alpha,
		KnobEnabled = true,
		Padding = _Padding,
		[fusion.Children] = {
			fusion.New "BindableEvent" {
				Name = "OnSet",
			},
		},
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
						local minValue = public.MinimumValue:get()
						local maxValue = public.MaximumValue:get()
						local range = maxValue - minValue
						local offsetVal = math.round(range*alpha/public.Precision:get())*public.Precision:get()
						alpha = offsetVal/range
					end))
				end
			end
		end,
	}, maid)

	return inst
end

return constructor