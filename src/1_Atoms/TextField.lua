local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
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

	--public states
	local Value = fusion.State(config.Value or "")
	local Label = fusion.State(config.Label or "")
	local Prefix = fusion.State(config.Prefix or "")
	local Suffix = fusion.State(config.Suffix or "")

	--influencers
	local _Focused = fusion.State(false)
	local _Hovering = fusion.State(false)

	--properties
	local filter = filterConstructor.new(game.Players.LocalPlayer)

	--preparing config
	local config = {
		Name = script.Name,
	}


	local inst = fusion.New "TextBox" (config)

	--bind to attributes
	util.setPublicState("Value", Value, inst, maid)
	util.init(script.Name, inst, maid)
	return inst
end

return constructor