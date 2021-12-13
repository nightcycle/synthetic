local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local enums = synthetic:WaitForChild("Enums")

local constructor = {}

function index(properties, key)
	local props = properties:get()
	return props[key]:get()
end

function update(properties, key, val)
	local props = properties:get()
	props[key]:set(val)
	properties:set(props)
end

local elevationAlphas = {
	[0] = 1,
	[1] = 0.95,
	[2] = 0.93,
	[3] = 0.92,
	[4] = 0.91,
	[5] = 0.89,
	[6] = 0.88,
	[7] = 0.86,
	[8] = 0.85,
	[9] = 0.84,
}

function constructor.new()
	local properties = fusion.State({
		Elevation = fusion.State(1)
	})

	local inst = fusion.New "Configuration" {
		Name = "Style"
	}

	local mediaTransparency = fusion.Computed(function()
		local elevation = index(properties, "Elevation")
		elevation = elevation or 0
		elevation = math.round(elevation)
		elevation = math.clamp(elevation, 0, 24)
		return 1-elevationAlphas[elevation]
	end)

	local maid = maidConstructor.new()
	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsAncestorOf(game.Players.LocalPlayer) then
			maid:DoCleaning()
		end
	end)
	for k, state in pairs(properties:get()) do
		inst:SetAttribute(k, state:get())
		maid[k] = inst:GetAttributeChangedSignal(k):Connect(function()
			local val = inst:GetAttribute(k)
			update(properties,k, val)
		end)
	end

	return
end

return constructor