--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local Icons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Types = require(_Package:WaitForChild("Types"))

-- Types
-- Constants
-- Variables
-- References

-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local function makeHalfFrame(isDarkMode: boolean, color: Color3): Frame
			local style = Style.new(
				1,
				Enum.Font.SourceSans,
				if isDarkMode then Enums.SchemeType.Dark else Enums.SchemeType.Light,
				color
			)

			local halfFrame = maid:GiveTask(Instance.new("Frame"))
			halfFrame.BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Background)
			halfFrame.BorderSizePixel = 0
			local listLayout = maid:GiveTask(Instance.new("UIListLayout"))
			listLayout.FillDirection = Enum.FillDirection.Vertical
			listLayout.Padding = UDim.new(0, 10)
			listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.Parent = halfFrame

			local Module = require(script.Parent:WaitForChild("ColdFusion"))

			do
				local button = maid:GiveTask(
					Module.new(
						{
							Types.ButtonData.new(function()
								print("Click 1")
							end, nil, "Select", true),
							Types.ButtonData.new(function()
								print("Click 2")
							end, nil, "Disabled", false),
						},
						Icons.usb,
						"Dialog",
						"Material Design is an adaptable system of guidelines, components, and tools that support the best practices of user interface design.",
						style:GetColor(Enums.ColorRoleType.SurfaceContainerHigh),
						style:GetColor(Enums.ColorRoleType.Primary),
						style:GetColor(Enums.ColorRoleType.OnSurface),
						style:GetColor(Enums.ColorRoleType.OnSurface),
						style:GetColor(Enums.ColorRoleType.OnSurfaceVariant),
						style:GetColor(Enums.ColorRoleType.SurfaceTint),
						style.SchemeType,
						style:GetFontData(Enums.FontType.HeadlineSmall),
						style:GetFontData(Enums.FontType.BodyMedium),
						style:GetFontData(Enums.FontType.LabelLarge),
						style.Scale
					)
				)
				button.Size = UDim2.fromScale(1, 1)
				button.Parent = halfFrame
			end

			return halfFrame
		end

		local COLORS: { [number]: Color3 } = {
			Color3.fromHSV(0, 0.9, 0.8),
			Color3.fromHSV(0.6, 0.9, 0.7),
			Color3.fromHSV(0.35, 0.9, 0.7),
		}

		for i, color in ipairs(COLORS) do
			local x = (i - 1) / #COLORS
			local width = 1 / #COLORS
			local dark = makeHalfFrame(true, color)

			dark.Size = UDim2.fromScale(width, 0.5)
			dark.Position = UDim2.fromScale(x, 0.5)
			dark.Parent = frame

			local bright = makeHalfFrame(false, color)
			bright.Size = UDim2.fromScale(width, 0.5)
			bright.Position = UDim2.fromScale(x, 0)
			bright.Parent = frame
		end
	end)
	return function()
		maid:Destroy()
	end
end
