local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild('Util'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()

	--public states
	local public = {
		HeaderTypography = util.import(params.HeaderTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		BodyTypography = util.import(params.BodyTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),

		HeaderText = util.import(params.HeaderText) or fusion.State(""),

		Options = util.import(params.Options) or fusion.State({}),

		Color = util.import(params.Color) or fusion.State(Color3.new(1,1,1)),
		TextColor = util.import(params.TextColor) or fusion.State(Color3.new(1,1,1)),
		Variant = util.import(params.Variant) or fusion.State("Switch"),
		BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.new(1,1,1)),
		Width = util.import(params.Width) or fusion.State(UDim.new(1,0)),
		Input = util.import(params.Input) or fusion.State(""),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}
	public.Value = fusion.Computed(function()
		return public.Input:get()
	end)

	--properties
	local _Padding = fusion.Computed(function()
		return public.BodyTypography:get().Padding
	end)
	local _TextSize = fusion.Computed(function()
		return public.HeaderTypography:get().TextSize
	end)
	local _Font = fusion.Computed(function()
		return public.HeaderTypography:get().Font
	end)

	--construct
	local inst
	inst = util.set(fusion.New "Frame", public, params, {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = fusion.Computed(function()
			return UDim2.new(public.Width:get(), UDim.new(0,0))
		end),
		BackgroundTransparency = 1,
		[fusion.Children] = {
			fusion.New "UIListLayout" {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = _Padding,
			},
			fusion.New 'TextLabel' {
				Name = "Header",
				LayoutOrder = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = _TextSize,
				TextWrapped = false,
				Visible = fusion.Computed(function()
					return not (public.HeaderText:get() == "")
				end),
				Font = _Font,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = public.HeaderText,
				Size = UDim2.fromScale(1, 0),
				[fusion.Children] = {
					fusion.New 'UIPadding' {
						PaddingBottom = _Padding,
						PaddingTop = UDim.new(0,0),
						PaddingLeft = UDim.new(0,0),
						PaddingRight = UDim.new(0,0),
					},
				}
			},
		},
	}, maid)
	fusion.ComputedPairs(public.Options, function(key, _Input)
		local optionMaid = maidConstructor.new()
		local var = public.Variant:get()
		maid:GiveTask(optionMaid)

		local _ButtonHovered = fusion.State(false)
		local _ButtonClicked = fusion.State(false)

		local prompt = synthetic.New "TextPrompt" {
			Name = key,
			Parent = inst,
			Text = key,
			TextColor = public.TextColor,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			Input = _Input,
			DividerEnabled = true,
			LayoutOrder = 3,
		}

		local toggleConfig = {
			Color = public.Color,
			LayoutOrder = 10,
			Position = UDim2.fromScale(1, 0.5),
			AnchorPoint = Vector2.new(1,0.5),
			Input = fusion.Computed(function()
				local curVal = _Input:get()
				local variant = public.Variant:get()
				local listInput = public.Input:get()
				if variant == "RadioButton" then
					if key == listInput then
						return true
					else
						return false
					end
				else
					return curVal
				end
			end),
			Parent = prompt:WaitForChild("Content"),
		}

		-- fusion.Computed(function()
		local button
		local newConfig = {}
		for k, v in pairs(toggleConfig) do
			newConfig[k] = v
		end
		if var == "Switch" then
			newConfig.BackgroundColor = public.BackgroundColor
		elseif var == "Checkbox" then
			newConfig.BackgroundColor = public.BackgroundColor
			newConfig.LineColor = public.LineColor
		elseif var == "RadioButton" then
			newConfig.Color = public.Color
			newConfig.LineColor = public.LineColor
			newConfig[fusion.OnEvent "Activated"] = function()
				public.Input:set(key)
				-- for k, v in pairs(public.Options:get()) do
				-- 	if k ~= key then
				-- 		v:set(false)
				-- 	end
				-- end
				-- if _Input:get() == true then
				-- 	public.Input:set(key)
				-- else
				-- 	public.Input:set("")
				-- end
			end
		end
		button = synthetic.New (var) (newConfig)
		-- end)

		optionMaid:GiveTask(prompt)
		return optionMaid
	end)
	return inst
end

return constructor