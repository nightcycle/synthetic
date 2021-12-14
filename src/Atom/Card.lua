local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))

local Component = synthetic:WaitForChild("Component")
local paddingConstructor = require(Component:WaitForChild("Padding"))
local cornerConstructor = require(Component:WaitForChild("Corner"))
local styleConstructor = require(Component:WaitForChild("Style"))

local constructor = {}

function constructor.new(config)
	local maid = maidConstructor.new()
	local inst = fusion.New "Frame" {
		Name = "Card",
		AnchorPoint = Vector2.new(0.5,0.5),
		Parent = config.Parent or game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	}
	maid:GiveTask(inst)

	local padding = paddingConstructor.new()
	padding.Parent = inst
	maid:GiveTask(padding)

	local corner = cornerConstructor.new()
	corner.Parent = inst
	maid:GiveTask(corner)

	local style = styleConstructor.new()
	style.Parent = inst
	style:SetAttribute("Category", "Surface")
	maid:GiveTask(corner)

	maid.deathSignal = inst.AncestryChanged:Connect(function()
		if not inst:IsDescendantOf(game.Players.LocalPlayer) then
			maid:Destroy()
		end
	end)

	return inst
end

return constructor