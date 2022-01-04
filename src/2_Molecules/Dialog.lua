local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild('Util'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)


	--public states
	local public = {

		HeaderTypography = util.import(params.HeaderTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		BodyTypography = util.import(params.BodyTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		ButtonTypography = util.import(params.ButtonTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),

		HeaderText = util.import(params.HeaderText) or fusion.State(""),
		BodyText = util.import(params.BodyText) or fusion.State(""),
		Button1Text = util.import(params.Button1Text) or fusion.State("Action 1"),
		Button2Text = util.import(params.Button2Text) or fusion.State("Action 2"),

		BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.new(1,1,1)),
		Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1)),
		TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2)),

		Enabled = util.import(params.Enabled) or fusion.State(false),

		SynthClass = fusion.Computed(function()
			return script.Name
		end),
	}

	--properties
	local _Padding = fusion.Computed(function()
		return public.HeaderTypography:get().Padding
	end)
	local _HeaderTextSize = fusion.Computed(function()
		return public.HeaderTypography:get().TextSize
	end)
	local _HeaderFont = fusion.Computed(function()
		return public.HeaderTypography:get().Font
	end)
	local _BodyTextSize = fusion.Computed(function()
		return public.BodyTypography:get().TextSize
	end)
	local _BodyFont = fusion.Computed(function()
		return public.BodyTypography:get().Font
	end)
	local _AbsoluteHeaderSize = fusion.State(Vector2.new(0,0))

	--construct
	local inst
	inst = util.set(fusion.New "Frame", public, params,  {
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = util.tween(fusion.Computed(function()
			if public.Enabled:get() then
				return 0.5
			else
				return 1
			end
		end)),
		[fusion.Children] = {
			fusion.New "BindableEvent" {
				Name = "OnSelect",
			},
			fusion.New "Frame" {
				Name = "Panel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = public.BackgroundColor,
				Position = UDim2.fromScale(0.5, 0.5),
				Visible = public.Enabled,
				[fusion.Children] = {
					fusion.New "TextLabel" {
						Name = "Header",
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Visible = fusion.Computed(function()
							return not (public.HeaderText:get() == "")
						end),
						[fusion.OnChange "AbsoluteSize"] = function()
							local panel = inst:WaitForChild("Panel")
							local header = panel:WaitForChild("Header")
							_AbsoluteHeaderSize:set(header.AbsoluteSize)
						end,
						Font = _HeaderFont,
						Text = public.HeaderText,
						TextColor3 = public.TextColor,
						TextSize = _HeaderTextSize,
						TextXAlignment = Enum.TextXAlignment.Left
					},
					fusion.New "TextLabel" {
						Name = "Body",
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Visible = fusion.Computed(function()
							return not (public.BodyText:get() == "")
						end),
						Size = fusion.Computed(function()
							local absSize = _AbsoluteHeaderSize:get()
							return UDim2.fromOffset(absSize.X, 0)
						end),
						Font = _BodyFont,
						Text = public.BodyText,
						TextColor3 = public.TextColor,
						TextSize = _BodyTextSize,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextYAlignment = Enum.TextYAlignment.Top,

						[fusion.Children] = {
							fusion.New "UISizeConstraint" {
								MaxSize = Vector2.new(200, math.huge)
							}
						}
					},
					fusion.New "UIListLayout" {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = _Padding,
					},
					fusion.New "UIPadding" {
						PaddingBottom = _Padding,
						PaddingLeft = _Padding,
						PaddingRight = _Padding,
						PaddingTop = _Padding
					},
					fusion.New "UICorner" {
						CornerRadius = util.tween(fusion.Computed(function()
							return UDim.new(0, _Padding:get().Offset)
						end)),
					},
					fusion.New "Frame" {
						Name = "Response",
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Size = UDim2.fromScale(1, 0),

						[fusion.Children] = {
							fusion.New "UIListLayout" {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Right,
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 18)
							},
							synthetic.New "Button" {
								Name = "Button1",
								Variant = "Text",
								Typography = public.ButtonTypography,
								Text = public.Button1Text,
								TextColor = public.Color,
								AutomaticSize = Enum.AutomaticSize.XY,
								LayoutOrder = 1,
								[fusion.OnEvent "Activated"] = function()
									inst:WaitForChild("OnSelect"):Fire(public.Button1Text:get())
									public.Enabled:set(false)
								end,
							},
							synthetic.New "Button" {
								Name = "Button2",
								Variant = "Text",
								Typography = public.ButtonTypography,
								Text = public.Button2Text,
								TextColor = public.Color,
								AutomaticSize = Enum.AutomaticSize.XY,
								LayoutOrder = 2,
								[fusion.OnEvent "Activated"] = function()
									inst:WaitForChild("OnSelect"):Fire(public.Button2Text:get())
									public.Enabled:set(false)
								end,
							},
							fusion.New "UIPadding" {
								PaddingTop = _Padding,
							}
						}
					}
				}
			}
		},
	})

	return inst
end

return constructor

