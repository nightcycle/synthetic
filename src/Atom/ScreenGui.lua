local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local constructor = {}

function constructor.new(config)
	config = config or {}
	local gui = fusion.New "ScreenGui" {
		Name = "ScreenGui",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}
	local maid = maidConstructor.new()
	maid:GiveTask(gui)
	return gui, maid
end

return constructor