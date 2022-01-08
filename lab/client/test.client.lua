local runService = game:GetService("RunService")
local packages = game.ReplicatedStorage:WaitForChild("Packages")
local typographyConstructor = require(packages:WaitForChild('typography'))
local fusion = require(packages:WaitForChild('fusion'))
local synthetic = game.Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("synthetic")
synthetic.Parent = packages
synthetic = require(synthetic)

local color = Color3.fromHSV(0.7,0.7,1)
local lineColor = Color3.fromHSV(1, 0, 0.2)
local surfaceColor = Color3.fromHSV(1, 0, 0.95)
local headerType = typographyConstructor.new(Enum.Font.GothamBlack, 17, 24)
local buttonType = typographyConstructor.new(Enum.Font.GothamBold, 15, 17)
local bodyType = typographyConstructor.new(Enum.Font.Gotham, 12, 15)
local subHeadingType = typographyConstructor.new(Enum.Font.GothamBold, 10, 12)

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
		fusion.New "Frame" {
			BackgroundColor3 = Color3.fromHSV(1, 0, 0.9),
			AnchorPoint = Vector2.new(0.5,0.5),
			Position = UDim2.fromScale(0.5,0.5),
			AutomaticSize = Enum.AutomaticSize.XY,
			[fusion.Children] = {
				fusion.New "UIPadding" {
					PaddingTop = UDim.new(0, 15),
					PaddingBottom = UDim.new(0, 15),
					PaddingLeft = UDim.new(0, 15),
					PaddingRight = UDim.new(0, 15),
				},
				fusion.New "UIListLayout" {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, 10),
					SortOrder = Enum.SortOrder.LayoutOrder,
				},
				synthetic.New "Button" {
					 Typography = buttonType,
					Text = "TEST",
					Color = color,
					TextColor = lineColor,
					LayoutOrder = 4,
					Tooltip = "Omg what a useful tip",
				},
				synthetic.New "Checkbox" {
					Typography = bodyType,
					LineColor = lineColor,
					BackgroundColor = surfaceColor,
					Color = color,
				},
				synthetic.New "Slider" {
					Typography = buttonType,
					Color = color,
					MinimumValue = fusion.State(0),
					MaximumValue = fusion.State(100),
					Notches = fusion.State(5),
					Input = fusion.State(50),
				},
				synthetic.Switch {
					Typography = buttonType,
					Color = color,
					BackgroundColor = surfaceColor,
				},
				synthetic.New "TextField" {
					Typography = buttonType,
					Color = color,
					TextColor = lineColor,
					Width = UDim.new(0.2,0),
					BackgroundColor = surfaceColor,
					Label = "Topic",
				},
				-- display,
				synthetic.New "ExpansionPanel" {
					Typography = bodyType,
					Text = "Expansion Panel Demo with a ViewportFrame",
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
					Width = UDim.new(0, 200),
				},
				synthetic.New "ToggleList" {
					HeaderTypography = subHeadingType,
					BodyTypography = bodyType,

					HeaderText = "Test",

					Options = {
						Apple = fusion.State(false),
						Banana = fusion.State(false),
						Potato = fusion.State(false),
					},
					Input = fusion.State("Apple"),
					ToggleVariant = "RadioButton",
					BackgroundColor = surfaceColor,
					Color = color,
					TextColor = lineColor,
					Width = UDim.new(0,200),
				},
				-- synthetic.New "Dialog" {
				-- 	 HeaderTypography = headerType,
				-- 	 BodyTypography = bodyType,
				-- 	 ButtonTypography = buttonType,

				-- 	 BackgroundColor = surfaceColor,
				-- 	 Color = color,
				-- 	 TextColor = lineColor,

				-- 	 Enabled = true,

				-- 	 Size = UDim2.fromOffset(300,300),
				-- },
			},
		},
	}
}
local contentFrame = screenGui:WaitForChild("Frame"):WaitForChild("ExpansionPanel"):WaitForChild("Body"):WaitForChild("Content")
contentFrame.AutomaticSize = Enum.AutomaticSize.Y
local listLayout = Instance.new("UIListLayout")
listLayout.Parent = contentFrame
display.Parent = contentFrame
display.Size = UDim2.fromOffset(300,300)