local userInputService = game:GetService("UserInputService")
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
	local maid = maidConstructor.new()
	--public states
	local public = {
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		BackgroundColor = util.import(params.BackgroundColor) or f.v(Color3.fromRGB(35,47,52)),
		TextColor = util.import(params.TextColor) or f.v(Color3.fromHex("#FFFFFF")),
		Position = util.import(params.Position) or f.v(UDim2.new(0.5,0.5)),
		Width = util.import(params.Width) or f.v(UDim.new(1,0)),
		Options = util.import(params.Options) or f.v({}),
		Input = util.import(params.Input) or f.v(""),
		SynthClassName = f.get(function()
			return script.Name
		end),
	}
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)
	local _AbsoluteSize = f.v(Vector2.new(0,0))
	-- local _List = f.v({})
	local frame = util.set(f.new "Frame", public, params, {
		Position = public.Position,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = util.tween(f.get(function()
			local v2 = _AbsoluteSize:get()
			-- local pad = _Padding:get().Offset
			return UDim2.new(public.Width:get(), UDim.new(0, v2.Y))
		end)),
		[f.c] = {
			f.new 'BindableEvent' {
				Name = "OnSelect",
			},
			f.new 'BindableEvent' {
				Name = "SetOptions",
				[f.e "Event"] = function(vals)
					public.Options:set(vals)
				end,
			},
			f.new 'BindableEvent' {
				Name = "ResetOptions",
				[f.e "Event"] = function()
					public.Options:set({})
				end,
			},
			f.new "Frame" {
				Name = "Content",
				AnchorPoint = Vector2.new(0,0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = util.tween(f.get(function()
					return UDim2.new(public.Width:get(), UDim.new(0,0))
				end)),

				BackgroundColor3 = util.tween(public.BackgroundColor),
				-- Position = public.Position,

				[f.c] = {
					f.new "UICorner" {
						CornerRadius = util.cornerRadius,
					},
					f.new "UIListLayout" {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top
					},
					f.new 'UIPadding' {
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
	f.gets(public.Options, function(index, value)
		local optionMaid = maidConstructor.new()
		maid:GiveTask(optionMaid)

		local _ButtonHovered = f.v(false)
		local _ButtonClicked = f.v(false)

		local button = f.new "TextButton" {
			Parent = contentFrame,
			Text = value,
			Visible = f.get(function()
				local val = public.Input:get()
				if val == value then return false else return true end
			end),
			LayoutOrder = index,
			Size = UDim2.fromScale(1,0),
			TextSize = _TextSize,
			Font = _Font,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = f.get(function()
				if _ButtonHovered:get() then
					return 0.8
				else
					return 1
				end
			end),
			BackgroundColor3 = Color3.new(0,0,0),

			[f.e "InputBegan"] = function(inputObj)
				_ButtonHovered:set(true)
			end,
			[f.e "InputEnded"] = function(inputObj)
				_ButtonHovered:set(false)
				_ButtonClicked:set(false)
			end,
			[f.e "Activated"] = function()
				effects.sound("ui_tap-variant-01")
				frame:WaitForChild("OnSelect"):Fire(value, index)
				_AbsoluteSize:set(Vector2.new(0,0))
			end,
			[f.e "MouseButton1Down"] = function(x, y)
				effects.sound("ui_tap-variant-01")
				_ButtonClicked:set(true)
			end,
			[f.e "MouseButton1Up"] = function()
				_ButtonClicked:set(false)
			end,
			[f.c] = {
				f.new 'UIPadding' {
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