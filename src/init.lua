local module = script
local packages = module.Parent

local modules = {}
for i, mod in ipairs(script:GetChildren()) do
	modules[mod.Name] = mod
end

return function(className)
	assert(modules[className], "Bad Synthetic ClassName")
	return require(modules[className]).new
end
