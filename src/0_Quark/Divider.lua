local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}


function constructor.new(params)

	--public states
	local public = {
		Color = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2)),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Direction = util.import(params.Direction) or fusion.State("Horizontal"),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}
	local _Padding = fusion.Computed(function()
		return public.Typography:get().Padding
	end)
	--construct
	return util.set(fusion.New "Frame", public, params, {
		BackgroundTransparency = 1,
		Size = fusion.Computed(function()
			if enums.DividerDirection[public.Direction] == enums.DividerDirection.Horizontal then
				return UDim2.fromScale(1,0)
			else
				return UDim2.fromScale(0,1)
			end
		end),
		BorderSizePixel = 0,
		AutomaticSize = fusion.Computed(function()
			if enums.DividerDirection[public.Direction] == enums.DividerDirection.Horizontal then
				return Enum.AutomaticSize.Y
			else
				return Enum.AutomaticSize.X
			end
		end),
		[fusion.Children] = {
			fusion.New 'UIPadding' {
				PaddingBottom = fusion.Computed(function()
					if enums.DividerDirection[public.Direction] == enums.DividerDirection.Horizontal then
						return _Padding:get()
					else
						return UDim.new(0,0)
					end
				end),
				PaddingTop = fusion.Computed(function()
					if enums.DividerDirection[public.Direction] == enums.DividerDirection.Horizontal then
						return _Padding:get()
					else
						return UDim.new(0,0)
					end
				end),
				PaddingLeft = fusion.Computed(function()
					if enums.DividerDirection[public.Direction] == enums.DividerDirection.Horizontal then
						return UDim.new(0,0)
					else
						return _Padding:get()
					end
				end),
				PaddingRight = fusion.Computed(function()
					if enums.DividerDirection[public.Direction] == enums.DividerDirection.Horizontal then
						return UDim.new(0,0)
					else
						return _Padding:get()
					end
				end),
			},
			fusion.New 'Frame' {
				BackgroundColor3 = public.Color,
				Size = fusion.Computed(function()
					if enums.DividerDirection[public.Direction] == enums.DividerDirection.Horizontal then
						return UDim2.new(1, 0, 0, 2)
					else
						return UDim2.new(0, 2, 1, 0)
					end
				end),
				BorderSizePixel = 0,
			},
		}
	})
end

return constructor