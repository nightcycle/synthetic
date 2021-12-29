local packages = game.ReplicatedStorage:WaitForChild("Packages")
local typographyConstructor = require(packages:WaitForChild('typography'))
local fusion = require(packages:WaitForChild('fusion'))
local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = packages
synthetic = require(synthetic)

local headerType = typographyConstructor.new(Enum.Font.SourceSans, 10, 15)
local buttonType = typographyConstructor.new(Enum.Font.SourceSans, 10, 15)
local bodyType = typographyConstructor.new(Enum.Font.SourceSans, 10, 15)

local screenGui = fusion.New "ScreenGui" {
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	Name = "TestGui",
	[fusion.Children] = {
		fusion.New "UIListLayout" {
			FillDirection = Enum.FillDirection.Vertical,
		},
		synthetic.New "Switch" {
			Position = UDim2.fromScale(0.5,0.5),
			AnchorPoint = Vector2.new(0.5,0.5),
			Typography = buttonType,
		},
	}
}

