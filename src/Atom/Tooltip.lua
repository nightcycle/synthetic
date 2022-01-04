local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}


function constructor.new(params)

	--public states
	local public = {
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Text = util.import(params.Text) or f.v(""),
		BackgroundColor = util.import(params.BackgroundColor) or f.v(Color3.fromRGB(35,47,52)),
		TextColor = util.import(params.TextColor) or f.v(Color3.fromHex("#FFFFFF")),
		Position = util.import(params.Position) or f.v(UDim2.new(0.5,0.5)),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}

	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)

	--construct
	return util.set(f.new "TextLabel", public, params, {
		AnchorPoint = Vector2.new(0.5,0.5),
		AutomaticSize = Enum.AutomaticSize.X,
		Size = util.tween(f.get(function()
			local ts = _TextSize:get()
			return UDim2.fromOffset(ts, ts)
		end)),
		Font = f.get(function()
			return public.Typography:get().Font
		end),
		BackgroundColor3 = util.tween(public.BackgroundColor),
		Position = public.Position,
		TextColor3 = util.tween(public.TextColor),
		Text = public.Text,
		[f.c] = {
			f.new "UICorner" {
				CornerRadius = util.cornerRadius,
			},
			f.new 'UIPadding' {
				PaddingBottom = _Padding,
				PaddingTop = _Padding,
				PaddingLeft = f.get(function()
					local offset = _Padding:get().Offset
					return UDim.new(0,offset*0.5)
				end),
				PaddingRight = f.get(function()
					local offset = _Padding:get().Offset
					return UDim.new(0,offset*0.5)
				end),
			},
		}
	})
end

return constructor