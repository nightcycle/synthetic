local fusion = require(game.ReplicatedStorage:WaitForChild("Packages"):WaitForChild('fusion'))
local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = game.ReplicatedStorage:WaitForChild("Packages")

synthetic = require(synthetic)

local screenGui = fusion.New "ScreenGui" {
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	Name = "TestGui",
	[fusion.Children] = {
		synthetic.New "Switch" {
			Position = UDim2.fromScale(0.5,0.5),
			AnchorPoint = Vector2.new(0.5,0.5),
		},
	}
}

