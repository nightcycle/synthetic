local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local theme = require(script.Parent.Parent:WaitForChild("Theme"))
local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()

	local config = {}

	util.mergeConfig(config, params)

	local inst = fusion.New "TextButton" (config)
	maid:GiveTask(inst)
	util.init(inst, maid)

	return inst
end

return constructor