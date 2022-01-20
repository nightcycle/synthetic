local runService = game:GetService("RunService")
local packages = game.ReplicatedStorage:WaitForChild("Packages")
local typographyConstructor = require(packages:WaitForChild('typography'))
local fusion = require(packages:WaitForChild('fusion'))
local synthetic = require(packages:WaitForChild("synthetic"))

local screenGui = fusion.New "ScreenGui" {
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	[synthetic.Children] = {
		require(script.Parent:WaitForChild("TestComponent"))(synthetic)
	}
}
