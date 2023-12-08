--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- Services
-- Packages
local Enums = require(ReplicatedStorage.Packages.synthetic.Enums)
local Maid = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Maid"))
-- Modules
-- Types
-- Constants

-- Variables
-- References
-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local Theme = require(script.Parent)

		
		local function displayScheme(schemeType: Enums.SchemeType): Frame
			local theme = Theme.new(
				Color3.new(0.8,0,0.8)
			)
			local scheme = theme._Schemes[schemeType]
			local halfFrame = maid:GiveTask(Instance.new("Frame"))

			local listLayout = maid:GiveTask(Instance.new("UIListLayout"))
			listLayout.FillDirection = Enum.FillDirection.Vertical
			listLayout.Padding = UDim.new(0.01, 0)
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.Parent = halfFrame

			local contextCounts = #Enums.getEnumItems("ColorContextType")

			for role, contexts in pairs(scheme) do
				for context, v in pairs(contexts) do
					local label = Instance.new("TextLabel")
					label.TextColor3 = Color3.new(0.5,0.5,0.5)
					label.Text = `{role}-{context}`
					label.BackgroundColor3 = v
					label.LayoutOrder = (Enums.getValueFromEnumItem("ColorRoleType", role) * contextCounts) + Enums.getValueFromEnumItem("ColorRoleType", role)
					label.Size = UDim2.fromScale(0.9, 1/50)
					label.TextScaled = true
					label.Parent = halfFrame
				end
			end

			return halfFrame
		end

		do
			local light = displayScheme(Enums.SchemeType.Light)
			light.BackgroundColor3 = Color3.new(0.85, 0.85, 0.85)
			light.Position = UDim2.fromScale(0,0)
			light.Size = UDim2.fromScale(0.25,1)
			light.Parent = frame
		end



		do
			local dark = displayScheme(Enums.SchemeType.Light)
			dark.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
			dark.Position = UDim2.fromScale(0.5,0)
			dark.Size = UDim2.fromScale(0.25,1)
			dark.Parent = frame
		end


	end)
	return function()
		maid:Destroy()
	end
end