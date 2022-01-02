local constructorModules = {}


for i, module in ipairs(script:GetDescendants()) do
	if module:IsA("ModuleScript") and module.Parent ~= script.Parent then
		constructorModules[module.Name] = module
	end
end

local constructors = {
	effects = require(script:WaitForChild("Effects")),
	enums = require(script:WaitForChild("Enums")),
	util = require(script:WaitForChild("Util")),
}

return {
	New = function(key)
		if not constructors[key] and constructorModules[key] then
			constructors[key] = require(constructorModules[key]).new
		end
		return constructors[key]
	end,
	Set = function(key, constructor) --in case you wanna add your own
		constructors[key] = constructor
	end,
}