local RunService = game:GetService("RunService")

local packages = script.Parent.Parent.Parent

local Maid = require(packages:WaitForChild("maid"))
local math = require(packages:WaitForChild("math"))

return function(coreGui)
	local maid = Maid.new()
	local Synthetic = require(script.Parent.Parent)
	task.spawn(function()
		local board = Synthetic("BoardFrame"){
			Parent = coreGui,
			Size = UDim2.fromScale(0.5,0.5),
			Position = UDim2.fromScale(0.5,0.5),
			AnchorPoint = Vector2.new(0.5,0.5),
			CanvasTransparency = 0,
			CanvasMaterial = "SmoothPlastic",
			CanvasMaterialVariant = "Grid",
		}
		
		local part = Instance.new("Part", board:WaitForChild("Canvas"))
		part.Name = "Point"
		part.Shape = Enum.PartType.Block
		part.Anchored = true
		part.Color = Color3.new(0,0,1)
		part.Transparency = 0
		part.CFrame = CFrame.new(Vector3.new(5,3,0), Vector3.new(0,0,1))
		part.Size = Vector3.new(2,4,1)
		maid:GiveTask(part)

		maid:GiveTask(RunService.RenderStepped:Connect(function(dt)
			part.CFrame *= CFrame.Angles(dt*math.rad(30), dt*math.rad(30), dt*math.rad(30))
		end))

		local boundingBoxFrame = Synthetic("BoundingBoxFrame"){
			Parent = board,
			Target = part,
			BackgroundTransparency = 0.5,
		}

		maid:GiveTask(board)
	end)

	return function()
		maid:Destroy()
	end
end