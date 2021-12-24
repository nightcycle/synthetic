local constructors = {}

for i, module in ipairs(script:GetDescendants()) do
	if module:IsA("ModuleScript") and module.Parent ~= script.Parent then
		constructors[module.Name] = require(module).new
	end
end

return constructors