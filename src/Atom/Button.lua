local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local quark = synthetic:WaitForChild("Quark")

local enums = synthetic:WaitForChild("Enums")
local UIAlignment = require(enums:WaitForChild("UIAlignment"))

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

function constructor.new()
	local isFocused = fusion.State(false)
	local debounce = true

	local properties = fusion.State({
		Elevation = fusion.State(1),
		RestSize = fusion.State(UDim2.fromScale(1,1)),
		FocusSize = fusion.State(UDim2.new(1, 5, 1, 5)),
	})
	local ZIndex = fusion.Computed(function()
		local props = properties:get()
		local elevation = props.Elevation:get()
		return elevation*10
	end)
	local inst = fusion.New "TextButton" {
		TextLabel = "",
		ZIndex = ZIndex,
		Name = "Button",
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

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
			-- index(properties,k, val)
			update(properties, k, val)
		end)
	end

	return inst
end

return constructor