local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local theme = require(script.Parent.Parent:WaitForChild("Theme"))

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()
	local config = {}
	util.mergeConfig(config, params)

	local isFocused = fusion.State(false)
	config[fusion.OnEvent "InputChanged"] = function()
		isFocused:set(true)
	end
	config[fusion.OnEvent "InputEnded"] = function()
		isFocused:set(false)
	end

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
	local maid = maidConstructor.new()
	local inst = fusion.New "Frame" (config)
	maid:GiveTask(inst)

	local padding = synthetic("Padding")
	padding.Parent = inst
	maid:GiveTask(padding)

	local listLayout = synthetic("ListLayout")
	listLayout.Parent = inst
	maid:GiveTask(listLayout)

	local corner = synthetic("Corner")
	corner.Parent = inst
	maid:GiveTask(corner)

	local styleComponent = synthetic("Theme")
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
				Size = UDim2.fromScale(0,0),
				AnchorPoint = Vector2.new(0.5,0.5),
				Parent = inst,
				AutomaticSize = Enum.AutomaticSize.XY,
			}
			textMedia.BackgroundTransparency = 1
		end
		if Media:get() == "Icon" then
			visualMedia = fusion.New "ImageLabel" {
				Name = "Media",
				BackgroundTransparency = 1,
				Image = texture,
				ImageRectOffset = imageRectOffset,
				ImageRectSize = imageRectSize,
				LayoutOrder = 1,
				ImageColor3 = Color:get(),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Size = UDim2.fromScale(0,0),
				AutomaticSize = Enum.AutomaticSize.XY,
				Parent = inst
			}
			visualMedia.BackgroundTransparency = 1
		elseif Media:get() == "Image" then
			visualMedia = fusion.New "ImageLabel" {
				Name = "Media",
				BackgroundTransparency = 1,
				Image = texture,
				LayoutOrder = 1,
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Size = UDim2.fromScale(0,0),
				AutomaticSize = Enum.AutomaticSize.XY,
				Parent = inst
			}
			visualMedia.BackgroundTransparency = 1
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
			local tweenCF = fusion.Tween(cf, util.newTweenInfo())

			-- FOV
			local curFOV = fusion.Computed(function()
				if isFocused:get() == true then
					return VFFocusFOV:get()
				else
					return VFRestFOV:get()
				end
			end)
			local tweenFOV = fusion.Tween(curFOV, util.newTweenInfo({Enum.EasingStyle.Back, Duration = 0.25}))

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
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromScale(0,0),
				Parent = inst
			}
			visualMedia.BackgroundTransparency = 1
			camera.Parent = visualMedia
		end

		if textMedia then
			local textStyleComponent = synthetic("Theme")
			textStyleComponent.Parent = textMedia
			mediaMaid:GiveTask(textStyleComponent)
		end
		if visualMedia then
			local visualStyleComponent = synthetic("Theme")
			visualStyleComponent.Parent = textMedia
			mediaMaid:GiveTask(visualStyleComponent)
		end

		mediaMaid.TextMedia = textMedia
		mediaMaid.VisualMedia = visualMedia
	end)


	--bind to attributes
	util.setPublicState("Media",Media, inst, maid)
	util.setPublicState("Text",Text, inst, maid)
	util.setPublicState("Color",Color, inst, maid)
	util.setPublicState("Image",Image, inst, maid)

	util.setPublicState("ImageRectOffset",ImageRectOffset, inst, maid)
	util.setPublicState("ImageRectSize",ImageRectSize, inst, maid)

	util.setPublicState("VFFocusNormal",VFFocusNormal, inst, maid)
	util.setPublicState("VFFocusDistance",VFFocusDistance, inst, maid)
	util.setPublicState("VFFocusOrigin",VFFocusOrigin, inst, maid)
	util.setPublicState("VFFocusFOV",VFFocusFOV, inst, maid)

	util.setPublicState("VFRestNormal",VFRestNormal, inst, maid)
	util.setPublicState("VFRestDistance",VFRestDistance, inst, maid)
	util.setPublicState("VFRestOrigin",VFRestOrigin, inst, maid)
	util.setPublicState("VFRestFOV",VFRestFOV, inst, maid)

	util.init(inst, maid)
	return inst
end

return constructor