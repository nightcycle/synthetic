local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = game.ReplicatedStorage:WaitForChild("Packages")

synthetic = require(synthetic)

local screenGui = synthetic.new("ScreenGui", {
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
})

local canvas = synthetic.new("Canvas", {
	Parent = screenGui
})
canvas.Size = UDim2.new(0.5, 0, 0.5, 0)
canvas.Transparency = 1

local listLayout = synthetic.new("ListLayout", {
	Parent = canvas
})

listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local button = synthetic.new("Button", {
	Parent = canvas
})
button.Size = UDim2.fromOffset(100, 50)
button.Text = "Test"
button:WaitForChild("InputEffect"):SetAttribute("StartSize", UDim2.fromOffset(100, 50))
print("Adding style component")

print("Done")

