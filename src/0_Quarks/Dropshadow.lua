local packages = script.Parent.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local theme = require(script.Parent.Parent:WaitForChild("Theme"))

local multiplier = 2.5
local elevationToValueGain = {
	[0] = 0*multiplier,
	[1] = 0.05*multiplier,
	[2] = 0.07*multiplier,
	[3] = 0.08*multiplier,
	[4] = 0.09*multiplier,
	[5] = 0.11*multiplier,
	[6] = 0.12*multiplier,
	[7] = 0.14*multiplier,
	[8] = 0.15*multiplier,
	[9] = 0.16*multiplier,
}

function resetParent(parent: Instance, maid)
	local isViable = parent:GetAttribute("StartLightConfig")
	if not isViable then return end
	parent:SetAttribute("StartLightConfig", false)
	if not parent or not parent:IsA("GuiObject") then return end

	parent:SetAttribute("StartLightConfig", nil)
	maid:DoCleaning()
end

local constructor = {}

function constructor.new(params)

	local maid = maidConstructor.new()
	local parentMaid = maidConstructor.new()
	maid:GiveTask(parentMaid)

	local currentParent
	local Weight = fusion.State(params.Weight or 1)

	local imageSize = 64
	local rimWidth = 16

	local parentSize = fusion.State(Vector2.new(0,0))
	local cornerRadius = fusion.State(0)

	local function updateRadius(cornerComponent)
		if cornerComponent == nil then cornerRadius:set(0) end
		local scale = cornerComponent.CornerRadius.Scale
		local offset = cornerComponent.CornerRadius.Offset
		local parent = cornerComponent.Parent
		local parSize = parent.AbsoluteSize
		local minLength = math.min(parSize.X, parSize.Y)
		local maxRadius = math.round(minLength*scale) + offset
		cornerRadius:set(math.min(maxRadius, math.round(minLength*0.5)))
	end

	local absoluteSize = fusion.Computed(function()
		local minSize = parentSize:get()
		local minRadius = cornerRadius:get()

		local x = minSize.X + minRadius
		local y = minSize.Y + minRadius
		return Vector2.new(x, y)
	end)

	local SliceScale = fusion.Computed(function()
		local innerCornerOffset = cornerRadius:get()
		local cornerOuterOffset = innerCornerOffset * 2
		local absSize = absoluteSize:get()
		local maxLength = math.floor(math.max(absSize.X, absSize.Y)*0.5)
		return cornerOuterOffset/maxLength
	end)

	local config = {
		ImageColor3 = Color3.new(1, 0, 0),
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = 'rbxassetid://8322594959',
		SliceCenter = Rect.new(imageSize*0.5, imageSize*0.5, imageSize*0.5, imageSize*0.5),
		ScaleType = Enum.ScaleType.Slice,
		Size = fusion.Computed(function()
			local xy = absoluteSize:get()
			return UDim2.fromOffset(xy.X, xy.Y)
		end),
		Transparency = 1,
		Name = 'Shadow',
		Position = UDim2.new(0.5,0,0.5,0),
		SliceScale = SliceScale,
		ImageTransparency = 0.7,
		BackgroundColor3 = Color3.new(1, 0, 0),
		[fusion.Children] = {
			fusion.New 'UIGradient' {
				Rotation = 90,
				Transparency = fusion.Computed(function()
					local weight = Weight:get()
					return NumberSequence.new({
						NumberSequenceKeypoint.new(0, weight*0.49726778268814),
						NumberSequenceKeypoint.new(0.5, weight*0.50819671154022),
						NumberSequenceKeypoint.new(0.70131582021713, weight*0.18579238653183),
						NumberSequenceKeypoint.new(1, weight*0),
					})
				end),
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
					ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
				}),
			},
		},
	}
	util.mergeConfig(config, params, {
		Parent = true,
	})

	--set control states
	local netElevation = fusion.State(0)
	config.BackgroundTransparency = 1
	config.ImageTransparency = fusion.Computed(function()
		local currentValue = math.clamp(netElevation:get(), 0, 9)
		local alpha = currentValue - math.floor(currentValue)
		local minVal = elevationToValueGain[math.floor(currentValue)]
		local maxVal = elevationToValueGain[math.ceil(currentValue)]
		local range = maxVal - minVal
		local avgValue = maxVal - range*alpha
		return avgValue
	end)

	--create inst
	local inst = fusion.New 'ImageLabel' (config)
	maid:GiveTask(inst)

	--bind to attributes
	util.setPublicState("Weight", Weight, inst, maid)

	--connect goals to currents & parent with tweenCompat
	local function setParent(par)
		currentParent = inst.Parent
		if currentParent == nil then return end
		netElevation:set((currentParent:GetAttribute("AbsoluteElevation") or 0)+(currentParent:GetAttribute("ElevationIncrease") or 0))
		parentMaid:GiveTask(currentParent:GetAttributeChangedSignal("AbsoluteElevation"):Connect(function()
			if not inst:IsDescendantOf(game.Players.LocalPlayer) then return end
			if not currentParent then return end
			netElevation:set((currentParent:GetAttribute("AbsoluteElevation") or 0)+(currentParent:GetAttribute("ElevationIncrease") or 0))
		end))
	end
	local cornerRadiusMaid = maidConstructor.new()
	maid:GiveTask(inst.ChildAdded:Connect(function(child)
		if child:IsA("UICorner") then
			updateRadius(child)
			cornerRadiusMaid._currentTask = child.Changed:Connect(function()
				updateRadius(child)
			end)
		end
	end))
	maid:GiveTask(cornerRadiusMaid)
	maid:GiveTask(inst.ChildRemoved:Connect(function(child)
		if child:IsA("UICorner") then
			cornerRadiusMaid:GiveTask()
			updateRadius()
		end
	end))
	local parentMaid = maidConstructor.new()
	maid:GiveTask(inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then return end
		if inst:IsDescendantOf(game.Players.LocalPlayer:WaitForChild("PlayerGui")) == false then
			maid:Destroy()
			print("Cleaning up "..tostring(script.Name))
		elseif inst.Parent ~= nil or currentParent ~= nil then
			parentMaid.Resized = inst:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				updateRadius(cornerRadiusMaid._currentTask)
			end)
			setParent(inst.Parent)
		else
			resetParent(currentParent, parentMaid)
			parentMaid:DoCleaning()
			netElevation:set(0)
			currentParent = nil
		end
	end))
	maid:GiveTask(parentMaid)
	if config.Parent then
		setParent(config.Parent)
	end
	util.init(inst, maid)
	return inst
end

return constructor