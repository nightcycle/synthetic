local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = game.ReplicatedStorage:WaitForChild("Packages")

synthetic = require(synthetic)

local screenGui = synthetic("ScreenGui", {
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
})

local canvas = synthetic("Canvas", {
	Parent = screenGui,
	Size = UDim2.new(0.5, 0, 0.5, 0),
	AbsoluteScrollLength = 700,
})

local listLayout = synthetic("ListLayout", {
	Parent = canvas:WaitForChild("Content")
})
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local button = synthetic("Button", {
	Parent = canvas:WaitForChild("Content"),
	Size = UDim2.fromOffset(100, 50),
	AnchorPoint = Vector2.new(0.5,1),
})
button.Text = "Test"
button:WaitForChild("InputEffect"):SetAttribute("StartSize", UDim2.fromOffset(100, 50))

local card = synthetic("Card", {
	Parent = canvas:WaitForChild("Content"),
	Size = UDim2.new(1, 0, 0, 250),
})

-- local slider = synthetic("Slider", {
-- 	Parent = card,
-- 	Position = UDim2.fromScale(0.5,0.5),
-- 	Size = UDim2.new(1, 0, 0, 200)
-- })

local dropdown = synthetic("Dropdown", {
	Parent = card,
	Value = "",
	Size = UDim2.fromOffset(100, 30)
})
dropdown:WaitForChild("SetOptions"):Fire({
	"Test",
	"A",
	"B",
	"C",
	"D",
})

-- local display = synthetic("Display", {
-- 	Parent = canvas:WaitForChild("Content"),
-- 	Size = UDim2.fromOffset(200,200),
-- 	Media = "Image",
-- })

-- local textBox = synthetic("TextBox", {
-- 	Parent = card,
-- 	Position = UDim2.fromScale(0.5,0.5),
-- 	Size = UDim2.fromOffset(150, 30)
-- })

