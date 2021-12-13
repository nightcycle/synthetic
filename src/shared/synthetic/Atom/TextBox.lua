local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))

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

	local properties = fusion.State({
		Elevation = fusion.State(1),
		Input = fusion.State(""),
	})
	local filter = filterConstructor.new(game.Players.LocalPlayer)

	local text = fusion.Computed(function()
		local input = index(properties, "Input")
		return filter:Get(input)
	end)

	local ZIndex = fusion.Computed(function()
		local props = properties:get()
		local elevation = props.Elevation:get()
		return elevation*10
	end)

	local inst
	inst = fusion.New "TextBox" {
		Name = "TextBox",
		Text = text,
		ZIndex = ZIndex,
		[fusion.OnEvent "FocusLost"] = function()
			update(properties, "Input", inst.Text)
		end
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
			update(properties,k, val)
		end)
	end

	return inst
end

return constructor