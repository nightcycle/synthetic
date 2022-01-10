--[=[
	@class Synthetic
]=]
--[=[
	@prop Effects Effects
	list of useful effects to add interactivity to UI
	@within Synthetic

]=]

--[=[
	@prop Enums SynthEnum
	dictionary of custom enums used in library
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
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))

for i, folder in ipairs(script:GetChildren()) do
	for k, module in ipairs(folder:GetChildren()) do
		if module:IsA("ModuleScript") and module.Parent ~= script.Parent then
			constructorModules[module.Name] = module
		end
	end
end

local constructors = {}
local synthetic = {}
local interface = {}
setmetatable(interface, {
	__index = function(s, k)
		if constructorModules[k] then
			if not constructors[k] then
				synthetic.Set(k, require(constructorModules[k]).new)
			end
			return constructors[k]
		elseif synthetic[k] then
			return synthetic[k]
		elseif fusion[k] then
			return fusion[k]
		else
			warn("Nothing found for "..k)
		end
	end
})

synthetic.New = function(key)
	if constructors[key] then
		return constructors[key]
	elseif constructorModules[key] then
		synthetic.Set(key, require(constructorModules[key]).new)
		return constructors[key]
	else
		return fusion.New(key)
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

return interface