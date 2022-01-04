local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild('Util'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)

	--public states
	local public = {
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Text = util.import(params.Text) or fusion.State(""),
		TextColor = util.import(params.TextColor) or fusion.State(Color3.new(1,1,1)),
		Input = util.import(params.Input) or fusion.State(false),
		DividerEnabled = util.import(params.DividerEnabled) or fusion.State(false),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}
	public.Value = fusion.Computed(function()
		return public.Input:get()
	end)

	--properties
	local _TextSize = fusion.Computed(function()
		return public.Typography:get().TextSize
	end)
	local _Padding = fusion.Computed(function()
		return public.Typography:get().Padding
	end)

	--construct
	return util.set(fusion.New "Frame", public, params, {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1,0),
		BackgroundTransparency = 1,
		[fusion.Children] = {
			fusion.New 'UIListLayout' {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0,0),
				FillDirection = Enum.FillDirection.Vertical,
			},
			fusion.New 'Frame' {
				Name = "Content",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1,0),
				[fusion.Children] = {
					fusion.New 'UIPadding' {
						PaddingBottom = UDim.new(0,0),
						PaddingTop = UDim.new(0,0),
						PaddingLeft = _Padding,
						PaddingRight = _Padding,
					},
					fusion.New 'TextLabel' {
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextColor3 = util.tween(public.TextColor),
						Text = public.Text,
						Position = UDim2.fromScale(0, 0.5),
						AnchorPoint = Vector2.new(0,0.5),
						BackgroundTransparency = 1,
						Font = fusion.Computed(function()
							return public.Typography:get().Font
						end),
						TextSize = util.tween(_TextSize),
					},
				},
			},
			synthetic.New "Divider" {
				Typography = public.Typography,
				Color = public.TextColor,
				LayoutOrder = 2,
				Visible = public.DividerEnabled,
				Direction = "Horizontal",
			},
		},
	})
end

return constructor