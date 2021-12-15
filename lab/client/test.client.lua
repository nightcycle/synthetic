local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = game.ReplicatedStorage:WaitForChild("Packages")

synthetic = require(synthetic)

local screenGui = synthetic("ScreenGui", {
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
})

local canvas = synthetic("Canvas", {
	Parent = screenGui,
	Size = UDim2.new(0.5, 0, 0.5, 0),
})

local listLayout = synthetic("ListLayout", {
	Parent = canvas:WaitForChild("Content")
})
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local button = synthetic("Button", {
	Parent = canvas:WaitForChild("Content"),
	Size = UDim2.fromOffset(100, 50),
})
button.Text = "Test"
button:WaitForChild("InputEffect"):SetAttribute("StartSize", UDim2.fromOffset(100, 50))


