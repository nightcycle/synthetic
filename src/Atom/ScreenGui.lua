local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local quark = synthetic:WaitForChild("Quark")

local enums = synthetic:WaitForChild("Enums")

local constructor = {}

function index(properties, key)
	local props = properties:get()
	return props[key]:get()
end

function update(properties, key, val)
	local props = properties:get()
	props[key]:set(val)
	properties:set(props)
end

function constructor.new()
	local gui = fusion.New "ScreenGui" {
		Name = "ScreenGui",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}
	return gui
end

return constructor