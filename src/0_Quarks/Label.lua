local synthetic

local packages = script.Parent.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local util = require(script.Parent.Parent:WaitForChild('Util'))
local typography = require(script.Parent.Parent:WaitForChild('Typography'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()

	--public states
	local Typography = util.import(params.Typography) or fusion.State("Body")
	local Text = util.import(params.Text) or fusion.State("")
	local Color = util.import(params.Color) or fusion.State(Color3.new(1,1,1))
	local Image = util.import(params.Image) or fusion.State("rbxassetid://3926305904")
	local ImageRectSize = util.import(params.ImageRectSize) or fusion.State(Vector2.new(0,0))
	local ImageRectOffset = util.import(params.ImageRectOffset) or fusion.State(Vector2.new(0, 0))

	--properties
	local _TextSize = typography.getTextSizeState(Typography)

	--preparing config
	local config = {
		Name = script.Name,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.new(1, 1, 1),
		[fusion.Children] = {
			fusion.New 'TextLabel' {
				LayoutOrder = 1000,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextColor3 = util.tween(Color),
				Text = Text,
				BackgroundTransparency = 1,
				Font = typography.getFontState(Typography),
				TextSize = util.tween(_TextSize),
			},
			fusion.New 'UIListLayout' {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = typography.getPaddingState(Typography),
				FillDirection = Enum.FillDirection.Horizontal,
			},
			fusion.New 'ImageButton' {
				BackgroundTransparency = 1,
				Image = Image,
				ImageRectSize = ImageRectSize,
				Size = util.tween(fusion.Computed(function()
					local textSize = _TextSize:get()
					return UDim2.fromOffset(textSize, textSize)
				end)),
				ImageColor3 = util.tween(Color),
				ImageRectOffset = ImageRectOffset,
				Name = 'Icon',
				Position = UDim2.new(0.5,0,0.5,0),
			},
		},
	}

	util.mergeConfig(config, params, nil, {
		Typography = true,
		Text = true,
		Color = true,
		Image = true,
		ImageRectSize = true,
		ImageRectOffset = true,
	})

	local inst = fusion.New 'Frame' (config)
	maid:GiveTask(inst)

	util.setPublicState("Color", Color, inst, maid)
	util.setPublicState("Typography", Typography, inst, maid)
	util.setPublicState("Text", Text, inst, maid)
	util.setPublicState("Image", Image, inst, maid)
	util.setPublicState("ImageRectSize", ImageRectSize, inst, maid)
	util.setPublicState("ImageRectOffset", ImageRectOffset, inst, maid)

	util.init(script.Name, inst, maid)

	return inst
end

return constructor