local synthetic = script
local constructors = {}
for i, module in ipairs(script:GetDescendants()) do
	if module:IsA("ModuleScript") then
		constructors[module.Name] = require(module)
	end
end

return {
	new = function(key, parent)
		local const = constructors[key]
		if not const then error("No constructor found for "..tostring(key)) end
		local inst = const.new()
		if parent then inst.Parent = parent end
		return inst
	end
}