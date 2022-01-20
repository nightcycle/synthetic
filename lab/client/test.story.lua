
local packages = game.ReplicatedStorage:WaitForChild("Packages")
local synthetic = require(packages:WaitForChild("synthetic"))
local testComponent = require(script.Parent:WaitForChild("TestComponent"))
return function(target)
	synthetic.hoarcekat(target)
	local inst = testComponent(synthetic)
	inst.Parent = target
	return function()
		inst:Destroy()
	end
end