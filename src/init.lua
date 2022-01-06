--[=[
	@class Synthetic
]=]
--[=[
	@prop Effects Effects
	list of useful effects to add interactivity to UI
	@within Synthetic

]=]

--[=[
	@prop Enums {SynthEnum}
	List of custom enums used in library
	@within Synthetic
]=]

--[=[
	@prop Util Util
	a list of frequently used methods
	@within Synthetic
]=]

--[=[
	@function New
	Gets relevant constructor
	@within Synthetic
	@param key string -- The ClassName of SynthClassName of desired Component
	@return function --Returns the constructor used to create instance
]=]

--[=[
	@function Set
	Registers custom constructor for future use
	@within Synthetic
	@param key string --the key the constructor will be organized under
	@param constructor function --the constructor to be provided by synthetic.New
]=]

local constructorModules = {}
local runService = game:GetService("RunService")
local packages = script.Parent
if runService:IsServer() then
	require(packages:WaitForChild('filter'))
	require(packages:WaitForChild('attributer'))
	return {}
end

local util = require(script:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))

for i, module in ipairs(script:GetDescendants()) do
	if module:IsA("ModuleScript") and module.Parent ~= script.Parent then
		constructorModules[module.Name] = module
	end
end

local constructors = {}
local synthetic = f

synthetic.classicNew = f.New
synthetic.New = function(key)
	if constructors[key] then
		return constructors[key]
	elseif constructorModules[key] then
		constructors[key] = require(constructorModules[key]).new
		return constructors[key]
	else
		return f.classicNew(key)
	end
end
synthetic.new = synthetic.New


synthetic.Set = function(key, constructor) --in case you wanna add your own
	constructors[key] = constructor
end
synthetic.set = synthetic.Set


synthetic.Effects = require(script:WaitForChild("Effects"))
synthetic.Enums = require(script:WaitForChild("Enums"))
synthetic.Util = require(script:WaitForChild("Util"))

return synthetic