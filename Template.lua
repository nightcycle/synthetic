local synthetic = require(script.Parent.Parent)
local packages = script.Parent.Parent.Parent
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local enums = require(script.Parent.Parent:WaitForChild('Enums'))

local constructor = {}

function constructor.new(params)
	--public states
	--[=[
		@class Template
		@tag Component
		@tag Atom / Molecule / Organism
		Fill this out accordingly
	]=]

	--public states
	local public = {}

	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within Button
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)

	-- define any private states here

	--construct
	local inst --sometimes useful to define inst variable early to allow for self references
	local maid = maidConstructor.new()
	local baseConstructor = fusion.New "Frame" -- or whatever
	local configuration = {} --fill this out like you would the table that goes after the constructor
	inst = util.set(baseConstructor, public, params, configuration, maid)

	return inst
end

return constructor