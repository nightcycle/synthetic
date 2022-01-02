local packages = game.ReplicatedStorage:WaitForChild("Packages")
local typographyConstructor = require(packages:WaitForChild('typography'))
local fusion = require(packages:WaitForChild('fusion'))
local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = packages
synthetic = require(synthetic)

local color = Color3.fromHSV(0.55,1,1)
local lineColor = Color3.fromHSV(1, 0, 0.2)
local surfaceColor = Color3.fromHSV(1, 0, 0.7)
local headerType = typographyConstructor.new(Enum.Font.GothamBlack, 15, 20)
local buttonType = typographyConstructor.new(Enum.Font.GothamBold, 12, 17)
local bodyType = typographyConstructor.new(Enum.Font.Gotham, 10, 15)

local screenGui = fusion.New "ScreenGui" {
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	Name = "TestGui",
	[fusion.Children] = {
		fusion.New "UIListLayout" {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 10)
		},
		synthetic.New "Button" {
			Typography = buttonType,
			Text = "TEST",
			BackgroundColor = color,
			LineColor = lineColor,
		},
		synthetic.New "Checkbox" {
			Typography = buttonType,
			LineColor = lineColor,
			BackgroundColor = surfaceColor,
			Color = color,
		},
		synthetic.New "RadioButton" {
			Typography = buttonType,
			Color = color,
			LineColor = surfaceColor,
		},
		synthetic.New "Slider" {
			Typography = buttonType,
			Color = color,
			MinimumValue = fusion.State(0),
			MaximumValue = fusion.State(100),
			Notches = fusion.State(10),
			Value = fusion.State(50),
		},
		synthetic.New "Switch" {
			Typography = buttonType,
			Color = color,
			BackgroundColor = surfaceColor,
		},
		synthetic.New "TextField" {
			Typography = buttonType,
			LineColor = lineColor,
			BackgroundColor = surfaceColor,
		},
	}
}

