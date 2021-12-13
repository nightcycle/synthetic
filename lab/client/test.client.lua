local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = game.ReplicatedStorage:WaitForChild("Packages")

synthetic = require(synthetic)

local screenGui = synthetic.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local canvas = synthetic.new("Canvas", screenGui)
local listLayout = canvas.new("ListLayout", canvas)
