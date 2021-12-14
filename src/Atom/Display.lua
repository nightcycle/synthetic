local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local Component = synthetic:WaitForChild("Component")
local paddingConstructor = require(Component:WaitForChild("Padding"))
local cornerConstructor = require(Component:WaitForChild("Corner"))
local listConstructor = require(Component:WaitForChild("ListLayout"))
local attributerConstructor = require(packages:WaitForChild('attributer'))
local styleConstructor = require(Component:WaitForChild("Style"))

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

function constructor.new(config)
	--public states
	local Media = fusion.State(config.Media or "Text")
	local Text = fusion.State(config.Text or "")
	local Color = fusion.State(config.Color or Color3.new(1,1,1))

	--image specific public states
	local Image = fusion.State(config.Image or "")

	--icon specific public states
	local ImageRectOffset = fusion.State(config.ImageRectOffset or Vector2.new(0,0))
	local ImageRectSize = fusion.State(config.ImageRectSize or Vector2.new(0,0))

	--viewport specific public states
	local VFFocusNormal = fusion.State(config.VFFocusNormal or Vector3.new(0,0,1))
	local VFFocusDistance = fusion.State(config.VFFocusDistance or 5)
	local VFFocusOrigin = fusion.State(config.VFFocusOrigin or Vector3.new(0,0,0))
	local VFFocusFOV = fusion.State(config.VFFocusFOV or 40)
	local VFRestNormal = fusion.State(config.VFRestNormal or Vector3.new(0,0,1))
	local VFRestDistance = fusion.State(config.VFRestDistance or 6)
	local VFRestOrigin = fusion.State(config.VFRestOrigin or Vector3.new(0,0,0))
	local VFRestFOV = fusion.State(config.VFRestFOV or 70)

	--private states
	local isFocused = fusion.State(false)
	local maid = maidConstructor.new()
	local inst = fusion.New "Frame" {
		Name = "Display",
		[fusion.OnEvent "InputChanged"] = function()
			isFocused:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			isFocused:set(false)
		end,
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}
	maid:GiveTask(inst)

	local padding = paddingConstructor.new()
	padding.Parent = inst
	maid:GiveTask(padding)

	local listLayout = listConstructor.new()
	listLayout.Parent = inst
	maid:GiveTask(listLayout)

	local corner = cornerConstructor.new()
	corner.Parent = inst
	maid:GiveTask(corner)

	local styleComponent = styleConstructor.new()
	styleComponent.Parent = inst
	maid:GiveTask(styleComponent)

	local mediaMaid = maidConstructor.new()
	maid.MediaMaid = mediaMaid

	local displayMedia = fusion.Computed(function()
		mediaMaid:DoCleaning()

		local text = Text:get()
		local texture = Image:get()
		local imageRectOffset = ImageRectOffset:get()
		local imageRectSize = ImageRectSize:get()

		local textMedia
		local visualMedia
		if Media:get() == "Text" then
			textMedia = fusion.New "TextLabel" {
				Name = "Label",
				Text = text,
				Font = Enum.Font.GothamSemibold,
				LayoutOrder = 2,
				Parent = inst
			}
		end
		if Media:get() == "Icon" then
			visualMedia = fusion.New "ImageLabel" {
				Name = "Media",
				BackgroundTransparency = 1,
				Image = texture,
				imageRectOffset = imageRectOffset,
				imageRectSize = imageRectSize,
				LayoutOrder = 1,
				ImageColor3 = Color:get(),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Size = UDim2.fromScale(1,1),
				Parent = inst
			}
		elseif Media:get() == "Image" then
			visualMedia = fusion.New "ImageLabel" {
				Name = "Media",
				BackgroundTransparency = 1,
				Image = texture,
				LayoutOrder = 1,
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Size = UDim2.fromScale(1,1),
				Parent = inst
			}
		elseif Media:get() == "Viewport" then
			-- CF
			local cf = fusion.Computed(function()
				local cOrigin
				local cDirection
				local cDistance

				if isFocused:get() == true then
					cOrigin = VFFocusOrigin:get()
					cDirection = VFFocusNormal:get()
					cDistance = VFFocusDistance:get()
				else
					cOrigin = VFRestOrigin:get()
					cDirection = VFRestNormal:get()
					cDistance = VFRestDistance:get()
				end
				local offset = cOrigin + (cDirection * cDistance)
				return CFrame.new(offset, cOrigin)
			end)
			local tweenCF = fusion.Tween(cf, newTweenInfo())

			-- FOV
			local curFOV = fusion.Computed(function()
				if isFocused:get() == true then
					return VFFocusFOV:get()
				else
					return VFRestFOV:get()
				end
			end)
			local tweenFOV = fusion.Tween(curFOV, newTweenInfo({es.Back, Duration = 0.25}))

			local camera = fusion.New "Camera" {
				CFrame = tweenCF,
				FieldOfView = tweenFOV,
			}

			visualMedia = fusion.New "Viewport" {
				Name = "Media",
				CurrentCamera = camera,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Size = UDim2.fromScale(1,1),
				Parent = inst
			}
			camera.Parent = visualMedia
		end

		if textMedia then
			local textStyleComponent = styleConstructor.new()
			textStyleComponent.Parent = textMedia
			mediaMaid:GiveTask(textStyleComponent)
		end
		if visualMedia then
			local visualStyleComponent = styleConstructor.new()
			visualStyleComponent.Parent = textMedia
			mediaMaid:GiveTask(visualStyleComponent)
		end

		mediaMaid.TextMedia = textMedia
		mediaMaid.VisualMedia = visualMedia
	end)


	--bind to attributes
	local attributer = attributerConstructor.new(inst, {})
	maid:GiveTask(attributer)
	local function bindAttributeToState(key, state)
		attributer:Connect(key, state:get())
		maid:GiveTask(attributer.OnChanged:Connect(function(k, val)
			if k == key then
				state:set(val)
			end
		end))
	end
	bindAttributeToState("Media",Media)
	bindAttributeToState("Text",Text)
	bindAttributeToState("Color",Color)
	bindAttributeToState("Image",Image)

	bindAttributeToState("ImageRectOffset",ImageRectOffset)
	bindAttributeToState("ImageRectSize",ImageRectSize)

	bindAttributeToState("VFFocusNormal",VFFocusNormal)
	bindAttributeToState("VFFocusDistance",VFFocusDistance)
	bindAttributeToState("VFFocusOrigin",VFFocusOrigin)
	bindAttributeToState("VFFocusFOV",VFFocusFOV)

	bindAttributeToState("VFRestNormal",VFRestNormal)
	bindAttributeToState("VFRestDistance",VFRestDistance)
	bindAttributeToState("VFRestOrigin",VFRestOrigin)
	bindAttributeToState("VFRestFOV",VFRestFOV)

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
		end
	end)

	return inst
end

return constructor