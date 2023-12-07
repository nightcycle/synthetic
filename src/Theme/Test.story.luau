--!strict
-- Services
-- Packages
local Maid = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Maid"))
-- Modules
-- Types
-- Constants
local ORDER = {
	"Primary",
	"OnPrimary",
	"PrimaryContainer",
	"OnPrimaryContainer",
	"Secondary",
	"OnSecondary",
	"SecondaryContainer",
	"OnSecondaryContainer",
	"Tertiary",
	"OnTertiary",
	"TertiaryContainer",
	"OnTertiaryContainer",
	"Error",
	"OnError",
	"ErrorContainer",
	"OnErrorContainer",
	"Background",
	"OnBackground",
	"Surface",
	"OnSurface",
	"SurfaceVariant",
	"OnSurfaceVariant",
	"Outline",
	"OutlineVariant",
	"Shadow",
	"Scrim",
	"InverseSurface",
	'InverseOnSurface',
	"InversePrimary",
}
-- Variables
-- References
-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local Theme = require(script.Parent)
		local theme = Theme.new(
			Color3.new(0.8,0,0.8),
			{}
		)
		
		local function displayScheme(scheme: Theme.Scheme): Frame
			local halfFrame = maid:GiveTask(Instance.new("Frame"))

			local listLayout = maid:GiveTask(Instance.new("UIListLayout"))
			listLayout.FillDirection = Enum.FillDirection.Vertical
			listLayout.Padding = UDim.new(0.01, 0)
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.Parent = halfFrame

			for k, v in pairs(scheme) do
				local label = Instance.new("TextLabel")
				label.TextColor3 = Color3.new(0.5,0.5,0.5)
				label.Text = k
				label.BackgroundColor3 = v
				local i = table.find(ORDER, k)
				assert(i, `bad order for {k}`)
				label.LayoutOrder = i
				label.Size = UDim2.fromScale(0.9, 1/50)
				label.TextScaled = true
				label.Parent = halfFrame
			end

			return halfFrame
		end

		local light = displayScheme(theme.Schemes.Light)
		light.BackgroundColor3 = Color3.new(0.85, 0.85, 0.85)
		light.Position = UDim2.fromScale(0,0)
		light.Size = UDim2.fromScale(0.5,1)
		light.Parent = frame

		local dark = displayScheme(theme.Schemes.Dark)
		dark.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
		dark.Position = UDim2.fromScale(0.5,0)
		dark.Size = UDim2.fromScale(0.5,1)
		dark.Parent = frame

	end)
	return function()
		maid:Destroy()
	end
end