--[=[
	@class Synthetic
	A library used for the construction of Material Design inspired fusion-powered UI Components.
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

synthetic.effects = require(script:WaitForChild("Effects"))
synthetic.enums = require(script:WaitForChild("Enums"))
synthetic.util = require(script:WaitForChild("Util"))

return synthetic