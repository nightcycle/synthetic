local fusion = require(game.ReplicatedStorage:WaitForChild("Packages"):WaitForChild('fusion'))
local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = game.ReplicatedStorage:WaitForChild("Packages")

synthetic = require(synthetic)

local screenGui = fusion.New "ScreenGui" {
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	Name = "TestGui",
	[fusion.Children] = {
		synthetic.New "Button" {
			Text = "CLICK ME!",
			Image = "rbxassetid://3926305904",
			ImageRectOffset = Vector2.new(84, 564),
			ImageRectSize = Vector2.new(36, 36),
			Position = UDim2.fromScale(0.5,0.5),
			AnchorPoint = Vector2.new(0.5,0.5),
		},
	}
}

