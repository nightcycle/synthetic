local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)
	local maid = maidConstructor.new()

	--public states
	local public = {
		HeaderTypography = util.import(params.HeaderTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		BodyTypography = util.import(params.BodyTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),

		HeaderText = util.import(params.HeaderText) or f.v(""),

		Options = util.import(params.Options) or f.v({}),

		Color = util.import(params.Color) or f.v(Color3.new(1,1,1)),
		TextColor = util.import(params.TextColor) or f.v(Color3.new(1,1,1)),
		Variant = util.import(params.Variant) or f.v("Switch"),
		BackgroundColor = util.import(params.BackgroundColor) or f.v(Color3.new(1,1,1)),
		Width = util.import(params.Width) or f.v(UDim.new(1,0)),
		Input = util.import(params.Input) or f.v(""),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}
	public.Value = f.get(function()
		return public.Input:get()
	end)

	--properties
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.HeaderTypography)

	--construct
	local inst
	inst = util.set(f.new "Frame", public, params, {
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = f.get(function()
			return UDim2.new(public.Width:get(), UDim.new(0,0))
		end),
		BackgroundTransparency = 1,
		[f.c] = {
			f.new "UIListLayout" {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = _Padding,
			},
			f.new 'TextLabel' {
				Name = "Header",
				LayoutOrder = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextSize = _TextSize,
				TextWrapped = false,
				Visible = f.get(function()
					return not (public.HeaderText:get() == "")
				end),
				Font = _Font,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Text = public.HeaderText,
				Size = UDim2.fromScale(1, 0),
				[f.c] = {
					f.new 'UIPadding' {
						PaddingBottom = _Padding,
						PaddingTop = UDim.new(0,0),
						PaddingLeft = UDim.new(0,0),
						PaddingRight = UDim.new(0,0),
					},
				}
			},
		},
	}, maid)
	f.gets(public.Options, function(key, _Input)
		local optionMaid = maidConstructor.new()
		local var = public.Variant:get()
		maid:GiveTask(optionMaid)

		local _ButtonHovered = f.v(false)
		local _ButtonClicked = f.v(false)

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
			Input = f.get(function()
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

		-- f.get(function()
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
			newConfig[f.e "Activated"] = function()
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