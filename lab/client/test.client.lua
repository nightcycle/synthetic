local runService = game:GetService("RunService")
local packages = game.ReplicatedStorage:WaitForChild("Packages")
local typographyConstructor = require(packages:WaitForChild('typography'))
local fusion = require(packages:WaitForChild('fusion'))
local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = packages
synthetic = require(synthetic)

local color = Color3.fromHSV(0.7,0.7,1)
local lineColor = Color3.fromHSV(1, 0, 0.2)
local surfaceColor = Color3.fromHSV(1, 0, 0.9)
local headerType = typographyConstructor.new(Enum.Font.GothamBlack, 17, 24)
local buttonType = typographyConstructor.new(Enum.Font.GothamBold, 15, 17)
local bodyType = typographyConstructor.new(Enum.Font.Gotham, 12, 15)

local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local camCF = fusion.State(CFrame.new(0,0,0))

runService.RenderStepped:Connect(function(delta)
	camCF:set(game.Workspace.CurrentCamera.CFrame)
end)

local display = synthetic.New "Display" {
	-- CameraCFrame = camCF,
	CameraPosition = fusion.Computed(function()
		return camCF:get().p
	end),
	CameraXVector = fusion.Computed(function()
		return camCF:get().XVector
	end),
	CameraYVector = fusion.Computed(function()
		return camCF:get().YVector
	end),
	CameraZVector = fusion.Computed(function()
		return camCF:get().ZVector
	end),
	FOV = 30,
	Size = UDim2.fromOffset(70,70),
}

display.InsertHumanoid:Invoke(character, 30)
display.InsertModel:Invoke(game.Workspace:WaitForChild("FireEngine"), 30)
local screenGui = fusion.New "ScreenGui" {
	Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui"),
	Name = "TestGui",
	[fusion.Children] = {
		fusion.New "UIListLayout" {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			Padding = UDim.new(0, 10),
			SortOrder = Enum.SortOrder.LayoutOrder,
		},
		synthetic.New "Button" {
			Typography = buttonType,
			Text = "TEST",
			BackgroundColor = color,
			LineColor = lineColor,
			LayoutOrder = 4,
			Tooltip = "Omg what a useful tip",
		},
		synthetic.New "Checkbox" {
			Typography = buttonType,
			LineColor = lineColor,
			BackgroundColor = surfaceColor,
			Color = color,
		},
		synthetic.New "RadioButton" {
			Typography = buttonType,
			Color = color,
			LineColor = surfaceColor,
		},
		synthetic.New "Slider" {
			Typography = buttonType,
			Color = color,
			MinimumValue = fusion.State(0),
			MaximumValue = fusion.State(100),
			Notches = fusion.State(5),
			Input = fusion.State(50),
		},
		synthetic.New "Switch" {
			Typography = buttonType,
			Color = color,
			BackgroundColor = surfaceColor,
		},
		synthetic.New "TextField" {
			Typography = buttonType,
			Color = color,
			TextColor = lineColor,
			BackgroundColor = surfaceColor,
			Label = "Topic",
		},
		display,
		synthetic.New "ExpansionPanel" {
			Typography = bodyType,
			Text = "Hmm",
			BackgroundColor = surfaceColor,
			TextColor = lineColor,
			Width = UDim.new(0,300),
		},
		synthetic.New "Dropdown" {
			Typography = bodyType,
			Label = "Bobby Tables",
			BackgroundColor = surfaceColor,
			Options = {"Borby", "Kibby", "Corn Boi"},
			TextColor = lineColor,
			Width = UDim.new(0, 120),
		},
	}
}

