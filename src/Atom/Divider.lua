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
	--[=[
		@class Divider
		@tag Component
		@tag Atom
		A simple bar used to visually separate elements
	]=]

	local public = {}

	--[=[
		@prop Color Color3 | FusionState | nil
		The color of the divider line
		@within Divider
	]=]
	public.Color = util.import(params.Color) or fusion.State(Color3.new(0.2,0.2,0.2))

	--[=[
		@prop Typography Typography | FusionState | nil
		The Typography to be used to determine padding
		@within Divider
	]=]
	public.Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)

	--[=[
		@prop Direction DividerDirection | FusionState | nil
		The direction the divider will be displayed
		@within Divider
	]=]
	public.Direction = util.import(params.Direction) or fusion.State("Horizontal")

	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within Divider
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)

	--construct
	return util.set(fusion.New "Frame", public, params, {
		BackgroundTransparency = 1,
		Size = fusion.Computed(function()
			if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
				return UDim2.fromScale(1,0)
			else
				return UDim2.fromScale(0,1)
			end
		end),
		BorderSizePixel = 0,
		AutomaticSize = fusion.Computed(function()
			if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
				return Enum.AutomaticSize.Y
			else
				return Enum.AutomaticSize.X
			end
		end),
		[fusion.Children] = {
			fusion.New 'UIPadding' {
				PaddingBottom = fusion.Computed(function()
					if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
						return _Padding:get()
					else
						return UDim.new(0,0)
					end
				end),
				PaddingTop = fusion.Computed(function()
					if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
						return _Padding:get()
					else
						return UDim.new(0,0)
					end
				end),
				PaddingLeft = fusion.Computed(function()
					if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
						return UDim.new(0,0)
					else
						return _Padding:get()
					end
				end),
				PaddingRight = fusion.Computed(function()
					if enums.DividerDirection[public.Direction:get()] == enums.DividerDirection.Horizontal then
						return UDim.new(0,0)
					else
						return _Padding:get()
					end
				end),
			},
			fusion.New 'Frame' {
				Name = "Bar",
				BackgroundColor3 = public.Color,
				BackgroundTransparency = 0.8,
				Size = fusion.Computed(function()
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