local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local Component = synthetic:WaitForChild("Component")
local styleConstructor = require(Component:WaitForChild("Style"))
local elevationConstructor = require(Component:WaitForChild("Elevation"))
local lightingConstructor = require(Component:WaitForChild("Lighting"))
local inputEffectConstructor = require(Component:WaitForChild("InputEffect"))

local constructor = {}

function constructor.new(config)
	local inst = fusion.New "TextButton" {
		Text = "",
		AutoButtonColor = true,
		Name = "Button",
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}

	local styleComponent = styleConstructor.new()
	styleComponent:SetAttribute("TextClass", "Button")
	styleComponent.Parent = inst

	local elevationComponent = elevationConstructor.new()
	elevationComponent.Parent = inst

	local lightingComponent = lightingConstructor.new()
	lightingComponent.Parent = inst

	local inputEffectComponent = inputEffectConstructor.new()
	inputEffectComponent.Parent = inst

	local maid = maidConstructor.new()
	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
		end
	end)

	return inst
end

return constructor