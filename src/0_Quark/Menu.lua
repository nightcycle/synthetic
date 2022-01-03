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
	local maid = maidConstructor.new()
	--public states
	local public = {
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		Text = util.import(params.Text) or fusion.State(""),
		BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.fromRGB(35,47,52)),
		TextColor = util.import(params.TextColor) or fusion.State(Color3.fromHex("#FFFFFF")),
		Position = util.import(params.Position) or fusion.State(UDim2.new(0.5,0.5)),
		Width = util.import(params.Width) or fusion.State(UDim.new(1,0)),
		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}

	local _TextSize = fusion.Computed(function()
		return public.Typography:get().TextSize
	end)
	local _Padding = fusion.Computed(function()
		return public.Typography:get().Padding
	end)
	local _Font = fusion.Computed(function()
		return public.Typography:get().Font
	end)
	local frame =  util.set(fusion.New "Frame", public, params, {
		AnchorPoint = Vector2.new(0,0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = util.tween(fusion.Computed(function()
			return UDim2.fromScale(UDim.new(0,0), public.Width:get())
		end)),

		BackgroundColor3 = util.tween(public.BackgroundColor),
		Position = public.Position,

		[fusion.Children] = {
			fusion.New "UICorner" {
				CornerRadius = util.tween(fusion.Computed(function()
					return UDim.new(0, _Padding:get().Offset*0.5)
				end)),
			},
			fusion.New "UIListLayout" {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top
			},
			fusion.New 'UIPadding' {
				PaddingBottom = _Padding,
				PaddingTop = UDim.new(0,0),
				PaddingLeft = UDim.new(0,0),
				PaddingRight = UDim.new(0,0),
			},
			fusion.New 'BindableEvent' {
				Name = "OnSelect",
			}
		}
	}, maid)

	local _List = fusion.State({})
	fusion.ComputedPairs(_List, function(index, value)
		local optionMaid = maidConstructor.new()
		maid:GiveTask(optionMaid)

		local _ButtonHovered = fusion.State(false)
		local _ButtonClicked = fusion.State(false)

		local button = fusion.New "TextButton" {
			Parent = frame,
			Text = value,
			LayoutOrder = index,
			Size = UDim2.fromScale(1,0),
			TextSize = _TextSize,
			Font = _Font,
			BackgroundTransparency = fusion.Computed(function()
				if _ButtonHovered:get() then
					return 0.8
				else
					return 1
				end
			end),
			BackgroundColor3 = Color3.new(0,0,0),

			[fusion.OnEvent "InputBegan"] = function(inputObj)
				_ButtonHovered:set(true)
			end,
			[fusion.OnEvent "InputEnded"] = function(inputObj)
				_ButtonHovered:set(false)
				_ButtonClicked:set(false)
			end,
			[fusion.OnEvent "Activated"] = function()
				frame:WaitForChild("OnSelect"):Fire(value, index)
			end,
			[fusion.OnEvent "MouseButton1Down"] = function(x, y)
				effects.sound("ui_tap-variant-01")
				_ButtonClicked:set(true)
			end,
			[fusion.OnEvent "MouseButton1Up"] = function()
				_ButtonClicked:set(false)
			end,
			[fusion.Children] = {
				fusion.New 'UIPadding' {
					PaddingBottom = _Padding,
					PaddingTop = _Padding,
					PaddingLeft = _Padding,
					PaddingRight = _Padding,
				},
			},
		}
		optionMaid:GiveTask(button)
		return optionMaid
	end)

	return
end

return constructor