local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)


	--public states
	local public = {
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Text = util.import(params.Text) or f.v(""),
		Color = util.import(params.Color) or f.v(Color3.new(1,1,1)),
		Image = util.import(params.Image) or f.v("rbxassetid://3926305904"),
		ImageRectSize = util.import(params.ImageRectSize) or f.v(Vector2.new(0,0)),
		ImageRectOffset = util.import(params.ImageRectOffset) or f.v(Vector2.new(0, 0)),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}

	--read only public states
	public.IconEnabled = f.get(function()
		local image = public.Image:get()
		if image == "" then
			return false
		else
			return true
		end
	end)

	--properties
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)

	--construct
	return util.set(f.new "Frame", public, params, {
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.new(1, 1, 1),
		[f.c] = {
			f.new 'TextLabel' {
				LayoutOrder = 1000,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextColor3 = util.tween(public.Color),
				Text = public.Text,
				BackgroundTransparency = 1,
				Font = f.get(function()
					return public.Typography:get().Font
				end)
			,
				TextSize = util.tween(_TextSize),
			},
			f.new 'UIListLayout' {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = f.get(function()
					return public.Typography:get().Padding
				end),
				FillDirection = Enum.FillDirection.Horizontal,
			},
			f.new 'ImageButton' {
				BackgroundTransparency = 1,
				Image = public.Image,
				ImageRectSize = public.ImageRectSize,
				Size = util.tween(f.get(function()
					local textSize = _TextSize:get()
					return UDim2.fromOffset(textSize, textSize)
				end)),
				Visible = public.IconEnabled,
				ImageColor3 = util.tween(public.Color),
				ImageRectOffset = public.ImageRectOffset,
				Name = 'Icon',
				Position = UDim2.new(0.5,0,0.5,0),
			},
		},
	})
end

return constructor