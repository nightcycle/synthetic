local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local Component = synthetic:WaitForChild("Component")
local paddingConstructor = require(Component:WaitForChild("Padding"))
local cornerConstructor = require(Component:WaitForChild("Corner"))
local listConstructor = require(Component:WaitForChild("ListLayout"))

local enums = synthetic:WaitForChild("Enums")
local UIDisplay = require(enums:WaitForChild("UIDisplay"))

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

function index(properties, key)
	local props = properties:get()
	if not props[key] then return end
	return props[key]:get()
end

function update(properties, key, val)
	local props = properties:get()
	props[key]:set(val)
	properties:set(props)
end

function constructor.new()
	local isFocused = fusion.State(false)

	local properties = fusion.State({
		Media = fusion.State(UIDisplay.Text),
		Text = fusion.State(""),
		Elevation = fusion.State(1),
		Color = fusion.State(Color3.new(1,1,1)),
		FocusNormal = fusion.State(Vector3.new(0,0,1)),
		FocusDistance = fusion.State(5),
		FocusOrigin = fusion.State(Vector3.new(0,0,0)),
		FocusFOV = fusion.State(40),
		RestNormal = fusion.State(Vector3.new(0,0,1)),
		RestDistance = fusion.State(6),
		RestOrigin = fusion.State(Vector3.new(0,0,0)),
		RestFOV = fusion.State(70),
	})

	local ZIndex = fusion.Computed(function()
		local props = properties:get()
		local elevation = props.Elevation:get()
		return elevation*10
	end)

	local inst = fusion.New "Frame" {
		Name = "Display",
		[fusion.OnEvent "InputChanged"] = function()
			isFocused:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			isFocused:set(false)
		end,
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

	local padding = paddingConstructor.new()
	padding.Parent = inst

	local listLayout = listConstructor.new()
	listLayout.Parent = inst

	local corner = cornerConstructor.new()
	corner.Parent = inst

	local maid = maidConstructor.new()
	local mediaMaid = maidConstructor.new()
	maid.MediaMaid = mediaMaid

	local displayMedia = fusion.Computed(function()
		local text = index(properties,"Text") or ""
		local texture = index(properties,"Image") or ""
		local imageRectOffset = index(properties,"ImageRectOffset") or Vector2.new(0,0)
		local imageRectSize = index(properties,"ImageRectSize") or Vector2.new(0,0)

		local textMedia
		local visualMedia
		if index(properties,"Media") == UIDisplay.Text then
			textMedia = fusion.New "TextLabel" {
				Name = "Label",
				Text = text,
				BackgroundTransparency = 1,
				TextSize = 14,
				Font = Enum.Font.GothamSemibold,
				-- TextColor3 = properties:get("Color"),
				LayoutOrder = 2,
				ZIndex = ZIndex,
				TextTransparency = properties:get("Elevation"),
				Parent = inst
			}
		end
		if index(properties,"Media") == UIDisplay.Icon then
			visualMedia = fusion.New "ImageLabel" {
				Name = "Media",
				BackgroundTransparency = 1,
				Image = texture,
				imageRectOffset = imageRectOffset,
				imageRectSize = imageRectSize,
				LayoutOrder = 1,
				ZIndex = ZIndex,
				ImageColor3 = properties:get("Color"),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Size = UDim2.fromScale(1,1),
				Parent = inst
			}
		elseif index(properties,"Media") == UIDisplay.Image then
			visualMedia = fusion.New "ImageLabel" {
				Name = "Media",
				BackgroundTransparency = 1,
				Image = texture,
				ZIndex = ZIndex,
				LayoutOrder = 1,
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Size = UDim2.fromScale(1,1),
				Parent = inst
			}
		elseif index(properties,"Media") == UIDisplay.Viewport then
			-- CF
			local cf = fusion.Computed(function()
				local cOrigin
				local cDirection
				local cDistance

				if isFocused:get() == true then
					cOrigin = index(properties,"FocusOrigin")
					cDirection = index(properties,"FocusNormal")
					cDistance = index(properties,"FocusDistance")
				else
					cOrigin = index(properties,"RestOrigin")
					cDirection = index(properties,"RestNormal")
					cDistance = index(properties,"RestDistance")
				end
				local offset = cOrigin + (cDirection * cDistance)
				return CFrame.new(offset, cOrigin)
			end)
			local tweenCF = fusion.Tween(cf, newTweenInfo())

			-- FOV
			local curFOV = fusion.Computed(function()
				if isFocused:get() == true then
					return index(properties, "FocusFOV")
				else
					return index(properties, "RestFOV")--index(properties,"RestFOV")
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
				ZIndex = ZIndex,
				LayoutOrder = 1,
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Size = UDim2.fromScale(1,1),
				Parent = inst
			}
			camera.Parent = visualMedia
		end

		mediaMaid.TextMedia = textMedia
		mediaMaid.VisualMedia = visualMedia
	end)

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsAncestorOf(game.Players.LocalPlayer) then
			maid:DoCleaning()
		end
	end)
	for k, state in pairs(properties:get()) do
		inst:SetAttribute(k, state:get())
		maid[k] = inst:GetAttributeChangedSignal(k):Connect(function()
			local val = inst:GetAttribute(k)
			-- index(properties,k, val)
			update(properties, k, val)
		end)
	end

	return inst
end

return constructor