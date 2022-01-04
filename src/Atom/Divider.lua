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
		Color = util.import(params.TextColor) or f.v(Color3.new(0.2,0.2,0.2)),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Direction = util.import(params.Direction) or f.v("Horizontal"),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)

	--construct
	return util.set(f.new "Frame", public, params, {
		BackgroundTransparency = 1,
		Size = f.get(function()
			if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
				return UDim2.fromScale(1,0)
			else
				return UDim2.fromScale(0,1)
			end
		end),
		BorderSizePixel = 0,
		AutomaticSize = f.get(function()
			if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
				return Enum.AutomaticSize.Y
			else
				return Enum.AutomaticSize.X
			end
		end),
		[f.c] = {
			f.new 'UIPadding' {
				PaddingBottom = f.get(function()
					if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
						return _Padding:get()
					else
						return UDim.new(0,0)
					end
				end),
				PaddingTop = f.get(function()
					if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
						return _Padding:get()
					else
						return UDim.new(0,0)
					end
				end),
				PaddingLeft = f.get(function()
					if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
						return UDim.new(0,0)
					else
						return _Padding:get()
					end
				end),
				PaddingRight = f.get(function()
					if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
						return UDim.new(0,0)
					else
						return _Padding:get()
					end
				end),
			},
			f.new 'Frame' {
				Name = "Bar",
				BackgroundColor3 = public.Color,
				BackgroundTransparency = 0.8,
				Size = f.get(function()
					if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
						return UDim2.new(1, 0, 0, 1)
					else
						return UDim2.new(0, 1, 1, 0)
					end
				end),
				BorderSizePixel = 0,
			},
		}
	})
end

return constructor