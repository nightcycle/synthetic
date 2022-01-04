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
		TextColor = util.import(params.TextColor) or f.v(Color3.new(1,1,1)),
		Input = util.import(params.Input) or f.v(false),
		DividerEnabled = util.import(params.DividerEnabled) or f.v(false),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}
	public.Value = f.get(function()
		return public.Input:get()
	end)

	--properties
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)

	--construct
	return util.set(f.new "Frame", public, params, {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.fromScale(1,0),
		BackgroundTransparency = 1,
		[f.c] = {
			f.new 'UIListLayout' {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0,0),
				FillDirection = Enum.FillDirection.Vertical,
			},
			f.new 'Frame' {
				Name = "Content",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1,0),
				[f.c] = {
					f.new 'UIPadding' {
						PaddingBottom = UDim.new(0,0),
						PaddingTop = UDim.new(0,0),
						PaddingLeft = _Padding,
						PaddingRight = _Padding,
					},
					f.new 'TextLabel' {
						LayoutOrder = 1,
						AutomaticSize = Enum.AutomaticSize.XY,
						TextColor3 = util.tween(public.TextColor),
						Text = public.Text,
						Position = UDim2.fromScale(0, 0.5),
						AnchorPoint = Vector2.new(0,0.5),
						BackgroundTransparency = 1,
						Font = f.get(function()
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