local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local util = require(script.Parent.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local typographyConstructor = require(packages:WaitForChild('typography'))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)


	--public states
	local public = {

		HeaderTypography = util.import(params.HeaderTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		BodyTypography = util.import(params.BodyTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
		ButtonTypography = util.import(params.ButtonTypography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),

		HeaderText = util.import(params.HeaderText) or f.v(""),
		BodyText = util.import(params.BodyText) or f.v(""),
		Button1Text = util.import(params.Button1Text) or f.v("Action 1"),
		Button2Text = util.import(params.Button2Text) or f.v("Action 2"),

		BackgroundColor = util.import(params.BackgroundColor) or f.v(Color3.new(1,1,1)),
		Color = util.import(params.Color) or f.v(Color3.new(0.5,0,1)),
		TextColor = util.import(params.TextColor) or f.v(Color3.new(0.2,0.2,0.2)),

		Enabled = util.import(params.Enabled) or f.v(false),

		SynthClassName = f.get(function()
			return script.Name
		end),
	}

	--properties
	local _Padding, _HeaderTextSize, _HeaderFont = util.getTypographyStates(public.HeaderTypography)
	local _BodyPadding, _BodyTextSize, _BodyFont = util.getTypographyStates(public.Typography)
	local _AbsoluteHeaderSize = f.v(Vector2.new(0,0))

	--construct
	local inst
	inst = util.set(f.new "Frame", public, params,  {
		BackgroundColor3 = Color3.new(0,0,0),
		BackgroundTransparency = util.tween(f.get(function()
			if public.Enabled:get() then
				return 0.5
			else
				return 1
			end
		end)),
		[f.c] = {
			f.new "BindableEvent" {
				Name = "OnSelect",
			},
			f.new "Frame" {
				Name = "Panel",
				AnchorPoint = Vector2.new(0.5, 0.5),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = public.BackgroundColor,
				Position = UDim2.fromScale(0.5, 0.5),
				Visible = public.Enabled,
				[f.c] = {
					f.new "TextLabel" {
						Name = "Header",
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 1,
						Visible = f.get(function()
							return not (public.HeaderText:get() == "")
						end),
						[f.dt "AbsoluteSize"] = function()
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
					f.new "TextLabel" {
						Name = "Body",
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 2,
						Visible = f.get(function()
							return not (public.BodyText:get() == "")
						end),
						Size = f.get(function()
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

						[f.c] = {
							f.new "UISizeConstraint" {
								MaxSize = Vector2.new(200, math.huge)
							}
						}
					},
					f.new "UIListLayout" {
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = _Padding,
					},
					f.new "UIPadding" {
						PaddingBottom = _Padding,
						PaddingLeft = _Padding,
						PaddingRight = _Padding,
						PaddingTop = _Padding
					},
					f.new "UICorner" {
						CornerRadius = util.cornerRadius,
					},
					f.new "Frame" {
						Name = "Response",
						AutomaticSize = Enum.AutomaticSize.Y,
						BackgroundColor3 = Color3.new(1, 1, 1),
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						LayoutOrder = 3,
						Size = UDim2.fromScale(1, 0),

						[f.c] = {
							f.new "UIListLayout" {
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
								[f.e "Activated"] = function()
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
								[f.e "Activated"] = function()
									inst:WaitForChild("OnSelect"):Fire(public.Button2Text:get())
									public.Enabled:set(false)
								end,
							},
							f.new "UIPadding" {
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

