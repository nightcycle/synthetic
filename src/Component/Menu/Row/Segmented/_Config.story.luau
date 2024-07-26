--!strict
local _Package = script.Parent.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local Icons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

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
			halfFrame.BackgroundColor3 = style:GetColor(Enums.ColorRoleType.Surface)
			halfFrame.BorderSizePixel = 0
			local listLayout = maid:GiveTask(Instance.new("UIListLayout"))
			listLayout.FillDirection = Enum.FillDirection.Vertical
			listLayout.Padding = UDim.new(0, 10)
			listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.Parent = halfFrame

			local Module = require(script.Parent)

			local options = {
				Types.OptionData.new(function(onSelected: boolean)
					print("select 1", onSelected)
				end, false, true, "Unselected 1", Icons.gamepad, "Selected 1", Icons.handyman),
				Types.OptionData.new(function(onSelected: boolean)
					print("select 2", onSelected)
				end, false, false, "Selected 2", Icons.track_changes),
				Types.OptionData.new(function(onSelected: boolean)
					print("select 3", onSelected)
				end, true, false, "Disabled 3", Icons.badge),
				Types.OptionData.new(function(onSelected: boolean)
					print("select 4", onSelected)
				end, false, false, "Selected 4"),
				Types.OptionData.new(function(onSelected: boolean)
					print("select 5", onSelected)
				end, false, false, "Unselected 5", nil, "Selected 5", nil),
			}

			do
				local button = maid:GiveTask(
					Module.ColdFusion.new(
						options,
						0,
						false,
						style:GetColor(Enums.ColorRoleType.OnSurface),
						style:GetColor(Enums.ColorRoleType.OnSecondaryContainer),
						style:GetColor(Enums.ColorRoleType.SecondaryContainer),
						style:GetColor(Enums.ColorRoleType.Outline),
						0,
						style.SchemeType,
						style:GetFontData(Enums.FontType.LabelLarge),
						style.Scale
					)
				)
				button.Parent = halfFrame
			end

			do
				local button = maid:GiveTask(
					Module.ColdFusion.new(
						options,
						-2,
						true,
						style:GetColor(Enums.ColorRoleType.OnSurface),
						style:GetColor(Enums.ColorRoleType.OnSecondaryContainer),
						style:GetColor(Enums.ColorRoleType.SecondaryContainer),
						style:GetColor(Enums.ColorRoleType.Outline),
						0,
						style.SchemeType,
						style:GetFontData(Enums.FontType.LabelLarge),
						style.Scale
					)
				)
				button.Parent = halfFrame
			end

			do
				local button = maid:GiveTask(
					Module.ColdFusion.new(
						options,
						-4,
						true,
						style:GetColor(Enums.ColorRoleType.OnSurface),
						style:GetColor(Enums.ColorRoleType.OnSecondaryContainer),
						style:GetColor(Enums.ColorRoleType.SecondaryContainer),
						style:GetColor(Enums.ColorRoleType.Outline),
						0,
						style.SchemeType,
						style:GetFontData(Enums.FontType.LabelLarge),
						style.Scale
					)
				)
				button.Parent = halfFrame
			end

			return halfFrame
		end

		local COLORS: { [number]: Color3 } = {
			Color3.fromHSV(0, 0.9, 0.8),
			-- Color3.fromHSV(0, 0.25, 0.8),
			-- Color3.fromHSV(0, 0.9, 0.5),
			Color3.fromHSV(0.6, 0.9, 0.7),
			-- Color3.fromHSV(0.35, 0.9, 0.7),
			-- Color3.fromHSV(0.1, 0.9, 0.7),
		}

		for i, color in ipairs(COLORS) do
			local x = (i - 1) / #COLORS
			local width = 1 / #COLORS
			local dark = makeHalfFrame(true, color)

			dark.Size = UDim2.fromScale(1, width * 0.5)
			dark.Position = UDim2.fromScale(0, x)
			dark.Parent = frame

			local bright = makeHalfFrame(false, color)
			bright.Size = UDim2.fromScale(1, width * 0.5)
			bright.Position = UDim2.fromScale(0, x + width * 0.5)
			bright.Parent = frame
		end
	end)
	return function()
		maid:Destroy()
	end
end
