local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()
	local config = {
		AnchorPoint = Vector2.new(0.5, 0.5),
		SizeConstraint = Enum.SizeConstraint.RelativeXX,
		Size = UDim2.new(0.5,0,0,0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Name = 'Card',
		Position = UDim2.new(0.5,0,0.5,0),
		BackgroundColor3 = Color3.new(1, 1, 1),
		[fusion.Children] = {
			fusion.New 'UICorner' {
				CornerRadius = UDim.new(0,6),
			},
			fusion.New 'Frame' {
				Size = UDim2.new(1,0,0,12),
				AutomaticSize = Enum.AutomaticSize.Y,
				Name = 'Header',
				BorderSizePixel = 0,
				Transparency = 1,
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.new(0, 1, 1),
				[fusion.Children] = {
					fusion.New 'Frame' {
						SizeConstraint = Enum.SizeConstraint.RelativeYY,
						Size = UDim2.new(0,0,1,4),
						AutomaticSize = Enum.AutomaticSize.X,
						Name = 'Icon',
						Transparency = 1,
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.new(1, 1, 1),
						[fusion.Children] = {
							fusion.New 'UIListLayout' {
								VerticalAlignment = Enum.VerticalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								Padding = UDim.new(0,4),
							},
							fusion.New 'UIPadding' {
								PaddingTop = UDim.new(0,4),
								PaddingBottom = UDim.new(0,4),
								PaddingRight = UDim.new(0,4),
								PaddingLeft = UDim.new(0,4),
							},
							fusion.New 'ImageLabel' {
								AnchorPoint = Vector2.new(0.5, 0.5),
								Image = 'rbxasset://textures/ui/GuiImagePlaceholder.png',
								AutomaticSize = Enum.AutomaticSize.XY,
								Size = UDim2.new(0,30,0,30),
								Position = UDim2.new(0.5,0,0.5,0),
								BackgroundColor3 = Color3.new(1, 1, 1),
								[fusion.Children] = {
									fusion.New 'UICorner' {
										CornerRadius = UDim.new(0.5,0),
									},
								},
							},
							fusion.New 'UIAspectRatioConstraint' {
							},
							fusion.New 'UISizeConstraint' {
								MinSize = Vector2.new(40, 0),
							},
						},
					},
					fusion.New 'Frame' {
						Size = UDim2.new(0,0,1,4),
						AutomaticSize = Enum.AutomaticSize.X,
						Name = 'Info',
						BorderSizePixel = 0,
						Transparency = 1,
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.new(1, 1, 1),
						[fusion.Children] = {
							fusion.New 'UIListLayout' {
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0,4),
							},
							fusion.New 'TextLabel' {
								BorderSizePixel = 0,
								Transparency = 1,
								BackgroundColor3 = Color3.new(1, 1, 1),
								TextTransparency = 0.10000000149012,
								AutomaticSize = Enum.AutomaticSize.XY,
								TextColor3 = Color3.new(0, 0, 0),
								Text = 'Test Title',
								BackgroundTransparency = 1,
								Font = Enum.Font.GothamBold,
								Name = 'Title',
								TextSize = 20,
							},
							fusion.New 'TextLabel' {
								BorderSizePixel = 0,
								Transparency = 1,
								BackgroundColor3 = Color3.new(1, 1, 1),
								TextTransparency = 0.40000000596046,
								AutomaticSize = Enum.AutomaticSize.XY,
								TextColor3 = Color3.new(0, 0, 0),
								BackgroundTransparency = 1,
								Font = Enum.Font.GothamSemibold,
								Name = 'Subtitle',
								TextSize = 11,
							},
							fusion.New 'UIPadding' {
								PaddingTop = UDim.new(0,4),
								PaddingBottom = UDim.new(0,4),
								PaddingRight = UDim.new(0,4),
								PaddingLeft = UDim.new(0,4),
							},
						},
					},
					fusion.New 'UIListLayout' {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Horizontal,
					},
					fusion.New 'UIPadding' {
						PaddingTop = UDim.new(0,8),
						PaddingBottom = UDim.new(0,4),
						PaddingRight = UDim.new(0,8),
						PaddingLeft = UDim.new(0,8),
					},
				},
			},
			fusion.New 'UIListLayout' {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			},
			fusion.New 'Frame' {
				LayoutOrder = 2,
				Size = UDim2.new(1,0,0,0),
				ClipsDescendants = true,
				AutomaticSize = Enum.AutomaticSize.Y,
				Name = 'Media',
				BorderSizePixel = 0,
				Position = UDim2.new(-0.126,0,0.428,0),
				BackgroundColor3 = Color3.new(0.6, 1, 0),
				[fusion.Children] = {
					fusion.New 'ImageLabel' {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = 'rbxasset://textures/ui/GuiImagePlaceholder.png',
						AutomaticSize = Enum.AutomaticSize.X,
						ScaleType = Enum.ScaleType.Crop,
						Size = UDim2.new(1,0,1,0),
						BorderSizePixel = 0,
						Position = UDim2.new(0.5,0,0.5,0),
						BackgroundColor3 = Color3.new(1, 1, 1),
					},
					fusion.New 'UIListLayout' {
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
					},
				},
			},
			fusion.New 'Frame' {
				LayoutOrder = 3,
				Size = UDim2.new(1,0,0,0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Name = 'Interactions',
				Transparency = 1,
				Position = UDim2.new(0,0,0.694,0),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.new(0.666667, 0, 1),
				[fusion.Children] = {
					fusion.New 'Frame' {
						LayoutOrder = 2,
						Size = UDim2.new(1,0,0,0),
						AutomaticSize = Enum.AutomaticSize.Y,
						Name = 'Buttons',
						BorderSizePixel = 0,
						Transparency = 1,
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.new(0, 1, 0),
						[fusion.Children] = {
							fusion.New 'Frame' {
								AnchorPoint = Vector2.new(0, 0.5),
								AutomaticSize = Enum.AutomaticSize.XY,
								Name = 'Actions',
								Transparency = 1,
								Position = UDim2.new(0,0,0.5,0),
								BackgroundTransparency = 1,
								BackgroundColor3 = Color3.new(1, 1, 1),
								[fusion.Children] = {
									fusion.New 'TextButton' {
										Transparency = 1,
										BackgroundColor3 = Color3.new(1, 1, 1),
										BackgroundTransparency = 1,
										TextSize = 11,
										Name = 'ActionButton1',
										TextColor3 = Color3.new(0.666667, 0, 1),
										Text = 'ACTION 1',
										Font = Enum.Font.GothamBold,
										AutomaticSize = Enum.AutomaticSize.XY,
									},
									fusion.New 'UIListLayout' {
										VerticalAlignment = Enum.VerticalAlignment.Center,
										SortOrder = Enum.SortOrder.LayoutOrder,
										Padding = UDim.new(0,12),
										FillDirection = Enum.FillDirection.Horizontal,
									},
									fusion.New 'UIPadding' {
									},
									fusion.New 'TextButton' {
										LayoutOrder = 1,
										Transparency = 1,
										BackgroundColor3 = Color3.new(1, 1, 1),
										BackgroundTransparency = 1,
										TextSize = 11,
										Name = 'ActionButton2',
										TextColor3 = Color3.new(0.666667, 0, 1),
										Text = 'ACTION 2',
										Font = Enum.Font.GothamBold,
										AutomaticSize = Enum.AutomaticSize.XY,
									},
								},
							},
							fusion.New 'Frame' {
								AnchorPoint = Vector2.new(1, 0.5),
								AutomaticSize = Enum.AutomaticSize.XY,
								Name = 'Icons',
								BorderSizePixel = 0,
								Transparency = 1,
								Position = UDim2.new(1,0,0.5,0),
								BackgroundTransparency = 1,
								BackgroundColor3 = Color3.new(1, 1, 1),
								[fusion.Children] = {
									fusion.New 'ImageButton' {
										BorderSizePixel = 0,
										Transparency = 1,
										BackgroundColor3 = Color3.new(1, 1, 1),
										BackgroundTransparency = 1,
										Image = 'rbxasset://textures/ui/GuiImagePlaceholder.png',
										Size = UDim2.new(0,30,0,30),
									},
									fusion.New 'UIListLayout' {
										VerticalAlignment = Enum.VerticalAlignment.Center,
										SortOrder = Enum.SortOrder.LayoutOrder,
										HorizontalAlignment = Enum.HorizontalAlignment.Right,
										Padding = UDim.new(0,4),
										FillDirection = Enum.FillDirection.Horizontal,
									},
									fusion.New 'UIPadding' {
									},
									fusion.New 'ImageButton' {
										BorderSizePixel = 0,
										Transparency = 1,
										BackgroundColor3 = Color3.new(1, 1, 1),
										BackgroundTransparency = 1,
										Image = 'rbxasset://textures/ui/GuiImagePlaceholder.png',
										Size = UDim2.new(0,30,0,30),
									},
									fusion.New 'ImageButton' {
										BorderSizePixel = 0,
										Transparency = 1,
										BackgroundColor3 = Color3.new(1, 1, 1),
										BackgroundTransparency = 1,
										Image = 'rbxasset://textures/ui/GuiImagePlaceholder.png',
										Size = UDim2.new(0,30,0,30),
									},
								},
							},
							fusion.New 'UIPadding' {
								PaddingTop = UDim.new(0,12),
								PaddingBottom = UDim.new(0,12),
								PaddingRight = UDim.new(0,12),
								PaddingLeft = UDim.new(0,12),
							},
						},
					},
					fusion.New 'UIListLayout' {
						SortOrder = Enum.SortOrder.LayoutOrder,
					},
					fusion.New 'TextLabel' {
						TextWrapped = true,
						BorderSizePixel = 0,
						Transparency = 1,
						TextYAlignment = Enum.TextYAlignment.Top,
						BackgroundColor3 = Color3.new(1, 1, 1),
						AutomaticSize = Enum.AutomaticSize.Y,
						Size = UDim2.new(1,0,0,0),
						TextColor3 = Color3.new(0, 0, 0),
						Text = 'Card containers hold all card elements, and their size is determined by the space those elements occupy',
						BackgroundTransparency = 1,
						Font = Enum.Font.Gotham,
						TextXAlignment = Enum.TextXAlignment.Left,
						TextSize = 11,
						[fusion.Children] = {
							fusion.New 'UIPadding' {
								PaddingTop = UDim.new(0,12),
								PaddingRight = UDim.new(0,12),
								PaddingLeft = UDim.new(0,12),
							},
						},
					},
				},
			},
		},
	}
	util.mergeConfig(config, params)
	local inst = fusion.New "Frame"(config)

	maid:GiveTask(inst)

	maid:GiveTask(synthetic "Theme" {
		ThemeCategory = "Surface",
		TextClass = "Body",
		Parent = inst,
	})

	util.init(script.Name, inst, maid)
	return inst
end

return constructor