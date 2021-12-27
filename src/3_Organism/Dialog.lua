local packages = script.Parent.Parent.Parent
local maidConstructor = require(packages:WaitForChild('maid'))
local fusion = require(packages:WaitForChild('fusion'))

local synthetic
local util = require(script.Parent.Parent:WaitForChild("Util"))
local theme = require(script.Parent.Parent:WaitForChild("Theme"))
local typography = require(script.Parent.Parent:WaitForChild("Typography"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()
	local config = {}
	util.mergeConfig(config, params)

	local Prompt = fusion.State(config.Text or "Are you sure?")

	local maid = maidConstructor.new()
	local inst = fusion.New "Frame" (config)
	maid:GiveTask(inst)
	local OnDecision = fusion.New "BindableEvent" {
		Name = "OnDecision",
		Parent = inst
	}

	util.setPublicState("Prompt", Prompt, inst, maid)
	util.init(script.Name, inst, maid)
	return inst
end

return constructor