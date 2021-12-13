local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local Component = synthetic:WaitForChild("Component")
local paddingConstructor = require(Component:WaitForChild("Padding"))
local cornerConstructor = require(Component:WaitForChild("Corner"))

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

function constructor.new()
	local properties = fusion.State({
		Open = fusion.State(false),
		Blur = fusion.State(true),
		Alignment = fusion.State(1),
		Elevation = fusion.State(1),
		OpenPosition = fusion.State(UDim2.fromScale(0.5,0.5)),
		ClosePosition = fusion.State(UDim2.fromScale(0.5,0.5)),
	})
	local ZIndex = fusion.Computed(function()
		local props = properties:get()
		local elevation = props.Elevation:get()
		return elevation*10
	end)

	local inst = fusion.New "Frame" {
		Name = "Card",
		AnchorPoint = fusion.Computed(function()
			local alignment = alignmentData:get()
			if alignment then
				return alignment.Anchor
			else
				return Vector2.new(0.5,0.5)
			end
		end),
		ZIndex = ZIndex,
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

	local padding = paddingConstructor.new()
	padding.Parent = inst

	local corner = cornerConstructor.new()
	corner.Parent = inst

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