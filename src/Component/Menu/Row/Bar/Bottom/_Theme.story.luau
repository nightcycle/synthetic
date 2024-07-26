--!strict
local _Package = script.Parent.Parent.Parent.Parent.Parent.Parent
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
type ButtonData = Types.ButtonData
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
			listLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
			listLayout.Parent = halfFrame

			local Module = require(script.Parent:WaitForChild("ColdFusion"))

			do
				local button = maid:GiveTask(Module.primary(
					style,
					{
						Types.ButtonData.new(function()
							print("click 1")
						end, Icons.gamepad, nil, true),
						Types.ButtonData.new(function()
							print("click 2")
						end, Icons.waves, nil, true),
						Types.ButtonData.new(function()
							print("click 3")
						end, Icons.work_off, nil, true),
					},
					Types.ButtonData.new(function()
						print("click fab")
					end, Icons.plus_one, nil, true)
				))
				button.Parent = halfFrame
			end

			do
				local button = maid:GiveTask(Module.secondary(
					style,
					{
						Types.ButtonData.new(function()
							print("click 1")
						end, Icons.gamepad, nil, true),
						Types.ButtonData.new(function()
							print("click 2")
						end, Icons.waves, nil, true),
						Types.ButtonData.new(function()
							print("click 3")
						end, Icons.work_off, nil, true),
					},
					Types.ButtonData.new(function()
						print("click fab")
					end, Icons.plus_one, nil, true)
				))
				button.Parent = halfFrame
			end
			do
				local button = maid:GiveTask(Module.tertiary(
					style,
					{
						Types.ButtonData.new(function()
							print("click 1")
						end, Icons.gamepad, nil, true),
						Types.ButtonData.new(function()
							print("click 2")
						end, Icons.waves, nil, true),
						Types.ButtonData.new(function()
							print("click 3")
						end, Icons.work_off, nil, true),
					},
					Types.ButtonData.new(function()
						print("click fab")
					end, Icons.plus_one, nil, true)
				))
				button.Parent = halfFrame
			end

			return halfFrame
		end

		local COLORS: { [number]: Color3 } = {
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
