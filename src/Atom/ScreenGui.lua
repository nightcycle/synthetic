local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local constructor = {}

function constructor.new(config)
	config = config or {}
	config.Name = config.Name or "ScreenGui"
	config.ResetOnSpawn = config.ResetOnSpawn or false
	config.ZIndexBehavior = config.ZIndexBehavior or Enum.ZIndexBehavior.Sibling
	config.Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local gui = fusion.New "ScreenGui" (config)
	local maid = maidConstructor.new()
	maid:GiveTask(gui)
	return gui, maid
end

return constructor