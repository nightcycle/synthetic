local synthetic = script
local state = "New"
local constructors = {}

function init()
	state = "Initializing"
	for i, module in ipairs(script:GetDescendants()) do
		if module:IsA("ModuleScript") then
			constructors[module.Name] = require(module)
		end
	end
	state = "Ready"
end

function updateElevation(inst)
	local newParent = inst.Parent
	if newParent:IsA("GuiObject") then
		local parentAbsElevation = newParent:GetAttribute("AbsoluteElevation") or 0
		inst:SetAttribute("AbsoluteElevation", parentAbsElevation + inst:GetAttribute("ElevationIncrease"))
	end
end

return function(key, config)
	config = config or {}
	if state == "New" then
		init()
	elseif state == "Initializing" then
		repeat task.wait() until state == "Ready"
	end

	local const = constructors[key]
	if not const then error("No constructor found for "..tostring(key)) end

	local inst, maid = const.new(config or {})

	inst:SetAttribute("ElevationIncrease", 1)
	inst:SetAttribute("AbsoluteElevation", 0)
	updateElevation(inst)

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			-- print("Cleaning up "..tostring(key))
			for i, desc in ipairs(inst:GetDescendants()) do
				desc:Destroy()
			end
			maid:Destroy()
		else
			updateElevation(inst)
		end
	end)

	return inst
end