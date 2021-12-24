local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = game.ReplicatedStorage:WaitForChild("Packages")

synthetic = require(synthetic)

local screenGui = synthetic("ScreenGui", {
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
})

synthetic "Button" {
	Parent = screenGui
}
synthetic "Canvas" {
	Parent = screenGui
}
synthetic "Media" {
	Parent = screenGui
}
synthetic "Panel" {
	Parent = screenGui
}
synthetic "Panel" {
	Parent = screenGui
}