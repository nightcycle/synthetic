local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}


function constructor.new(params)

	--public states
	local public = {
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Text = util.import(params.Text) or fusion.State(""),
		BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.fromRGB(35,47,52)),
		TextColor = util.import(params.TextColor) or fusion.State(Color3.fromHex("#FFFFFF")),
		Position = util.import(params.Position) or fusion.State(UDim2.new(0.5,0.5)),
		SynthClassName = fusion.Computed(function()
			return script.Name
		end),
	}

	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)

	--construct
	return util.set(fusion.New "TextLabel", public, params, {
		AnchorPoint = Vector2.new(0.5,0.5),
		AutomaticSize = Enum.AutomaticSize.X,
		Size = util.tween(fusion.Computed(function()
			local ts = _TextSize:get()
			return UDim2.fromOffset(ts, ts)
		end)),
		Font = fusion.Computed(function()
			return public.Typography:get().Font
		end),
		BackgroundColor3 = util.tween(public.BackgroundColor),
		Position = public.Position,
		TextColor3 = util.tween(public.TextColor),
		Text = public.Text,
		[fusion.Children] = {
			fusion.New "UICorner" {
				CornerRadius = util.cornerRadius,
			},
			fusion.New 'UIPadding' {
				PaddingBottom = _Padding,
				PaddingTop = _Padding,
				PaddingLeft = fusion.Computed(function()
					local offset = _Padding:get().Offset
					return UDim.new(0,offset*0.5)
				end),
				PaddingRight = fusion.Computed(function()
					local offset = _Padding:get().Offset
					return UDim.new(0,offset*0.5)
				end),
			},
		}
	})
end

return constructor