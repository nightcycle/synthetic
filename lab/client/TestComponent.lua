local color = Color3.fromHSV(0.7,0.7,1)
local lineColor = Color3.fromHSV(1, 0, 0.2)
local surfaceColor = Color3.fromHSV(1, 0, 0.95)

return function(synthetic)
	local headerType = synthetic.Util.newTypography(Enum.Font.GothamBlack, 17, 24)
	local buttonType = synthetic.Util.newTypography(Enum.Font.GothamBold, 15, 17)
	local bodyType = synthetic.Util.newTypography(Enum.Font.Gotham, 12, 15)
	local subHeadingType = synthetic.Util.newTypography(Enum.Font.GothamBold, 10, 12)

	return synthetic.New "Frame" {
		BackgroundColor3 = Color3.fromHSV(1, 0, 0.9),
		AnchorPoint = Vector2.new(0.5,0.5),
		Position = UDim2.fromScale(0.5,0.5),
		AutomaticSize = Enum.AutomaticSize.XY,
		[synthetic.Children] = {
			synthetic.New "UIPadding" {
				PaddingTop = UDim.new(0, 15),
				PaddingBottom = UDim.new(0, 15),
				PaddingLeft = UDim.new(0, 15),
				PaddingRight = UDim.new(0, 15),
			},
			synthetic.New "UIListLayout" {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
			},
			synthetic.New "Button" {
				Typography = buttonType,
				Text = "TEST",
				Color = color,
				TextColor = lineColor,
				LayoutOrder = 4,
				Tooltip = "Omg what a useful tip",
			},
			synthetic.New "Checkbox" {
				Typography = bodyType,
				LineColor = lineColor,
				BackgroundColor = surfaceColor,
				Color = color,
			},
			synthetic.New "Slider" {
				Typography = buttonType,
				Color = color,
				MinimumValue = synthetic.State(0),
				MaximumValue = synthetic.State(100),
				Notches = synthetic.State(5),
				Input = synthetic.State(50),
			},
			synthetic.Switch {
				Typography = buttonType,
				Color = color,
				BackgroundColor = surfaceColor,
			},
			synthetic.New "TextField" {
				Typography = buttonType,
				Color = color,
				TextColor = lineColor,
				Width = UDim.new(0.2,0),
				BackgroundColor = surfaceColor,
				Label = "Topic",
			},
			-- display,
			synthetic.New "ExpansionPanel" {
				Typography = bodyType,
				Text = "Expansion Panel Demo with a ViewportFrame",
				BackgroundColor = surfaceColor,
				TextColor = lineColor,
				Width = UDim.new(0,300),
			},
			synthetic.New "Dropdown" {
				Typography = bodyType,
				Label = "Bobby Tables",
				BackgroundColor = surfaceColor,
				Options = {"Borby", "Kibby", "Corn Boi"},
				TextColor = lineColor,
				Width = UDim.new(0, 200),
			},
			synthetic.New "ToggleList" {
				HeaderTypography = subHeadingType,
				BodyTypography = bodyType,

				HeaderText = "Test",

				Options = {
					Apple = synthetic.State(false),
					Banana = synthetic.State(false),
					Potato = synthetic.State(false),
				},
				Input = synthetic.State("Apple"),
				ToggleVariant = "RadioButton",
				BackgroundColor = surfaceColor,
				Color = color,
				TextColor = lineColor,
				Width = UDim.new(0,200),
			},
		}
	}
end
