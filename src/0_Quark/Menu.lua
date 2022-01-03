local userInputService = game:GetService("UserInputService")
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
		BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.fromRGB(35,47,52)),
		TextColor = util.import(params.TextColor) or fusion.State(Color3.fromHex("#FFFFFF")),
		Position = util.import(params.Position) or fusion.State(UDim2.new(0.5,0.5)),
		Width = util.import(params.Width) or fusion.State(UDim.new(1,0)),
		Options = util.import(params.Options) or fusion.State({}),
		Input = util.import(params.Input) or fusion.State(""),
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
	local _AbsoluteSize = fusion.State(Vector2.new(0,0))
	-- local _List = fusion.State({})
	local frame = util.set(fusion.New "Frame", public, params, {
		Position = public.Position,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = util.tween(fusion.Computed(function()
			local v2 = _AbsoluteSize:get()
			-- local pad = _Padding:get().Offset
			return UDim2.new(public.Width:get(), UDim.new(0, v2.Y))
		end)),
		[fusion.Children] = {
			fusion.New 'BindableEvent' {
				Name = "OnSelect",
			},
			fusion.New 'BindableEvent' {
				Name = "SetOptions",
				[fusion.OnEvent "Event"] = function(vals)
					public.Options:set(vals)
				end,
			},
			fusion.New 'BindableEvent' {
				Name = "ResetOptions",
				[fusion.OnEvent "Event"] = function()
					public.Options:set({})
				end,
			},
			fusion.New "Frame" {
				Name = "Content",
				AnchorPoint = Vector2.new(0,0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = util.tween(fusion.Computed(function()
					return UDim2.new(public.Width:get(), UDim.new(0,0))
				end)),

				BackgroundColor3 = util.tween(public.BackgroundColor),
				-- Position = public.Position,

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

				}
			}
		}
	}, maid)
	local contentFrame = frame:WaitForChild("Content")
	fusion.ComputedPairs(public.Options, function(index, value)
		local optionMaid = maidConstructor.new()
		maid:GiveTask(optionMaid)

		local _ButtonHovered = fusion.State(false)
		local _ButtonClicked = fusion.State(false)

		local button = fusion.New "TextButton" {
			Parent = contentFrame,
			Text = value,
			Visible = fusion.Computed(function()
				local val = public.Input:get()
				if val == value then return false else return true end
			end),
			LayoutOrder = index,
			Size = UDim2.fromScale(1,0),
			TextSize = _TextSize,
			Font = _Font,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
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
				effects.sound("ui_tap-variant-01")
				frame:WaitForChild("OnSelect"):Fire(value, index)
				_AbsoluteSize:set(Vector2.new(0,0))
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
		_AbsoluteSize:set(contentFrame.AbsoluteSize)
		optionMaid:GiveTask(button)
		return optionMaid
	end)

	maid:GiveTask(userInputService.InputBegan:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			local x = inputObj.Position.X
			local y = inputObj.Position.Y
			local found = false
			for i, v in ipairs(game.Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(x,y)) do
				if v == contentFrame then found = true end
			end
			if not found then
				frame:WaitForChild("OnSelect"):Fire()
				_AbsoluteSize:set(Vector2.new(0,0))
			end
		end
	end))

	return frame
end

return constructor