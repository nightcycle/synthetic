local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local filterConstructor = require(packages:WaitForChild("filter"))
local attributerConstructor = require(packages:WaitForChild("attribute"))

local quark = synthetic:WaitForChild("Quark")
local atom = synthetic:WaitForChild("Atom")
local cardConstructor = require(atom:WaitForChild("Card"))
local buttonConstructor = require(atom:WaitForChild("Button"))
local paddingConstructor = require(quark:WaitForChild("Padding"))
local cornerConstructor = require(quark:WaitForChild("Corner"))
local listConstructor = require(quark:WaitForChild("ListLayout"))

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
		EnabledColor = fusion.State(Color3.fromHex("#1976d2")),
		DisabledColor = fusion.State(Color3.fromHex("#ff8f00")),
		Enabled = fusion.State(true),
	})

	local inst = buttonConstructor.new()
	inst.Name = "Switch"
	local maid = maidConstructor.new()

	maid.activationSignal = inst.Activated:Connect(function()
		properties:Update("Enabled", not index(properties,"Enabled"))
		inst:SetAttribute("Enabled", index(properties,"Enabled"))
	end)
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