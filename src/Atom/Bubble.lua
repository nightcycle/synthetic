local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}


function constructor.new(params)

	--public states
	local public = {
		Transparency = util.import(params.Transparency) or f.v(0.2),
		Color = util.import(params.Color) or f.v(Color3.new(0.5,0.5,0.5)),
		Size = util.import(params.Size) or f.v(UDim.new(0,60)),
		Position = util.import(params.Position) or f.v(UDim.new(0,60)),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}

	local tweenParams = {
		Duration = 0.8,
		EasingStyle = Enum.EasingStyle.Cubic,
		EasingDirection = Enum.EasingDirection.Out,
	}

	--construct
	return util.set(f.new "Frame", public, params, {
		AnchorPoint = Vector2.new(0.5,0.5),
		Size = util.tween(f.get(function()
			return UDim2.new(public.Size:get(), public.Size:get())
		end), tweenParams),
		BackgroundColor3 = util.tween(public.Color, tweenParams),
		BackgroundTransparency = util.tween(public.Transparency, tweenParams),
		Position = public.Position,
		[f.c] = {
			f.new "UICorner" {
				CornerRadius = UDim.new(0.5,0),
			}
		}
	})
end

return constructor