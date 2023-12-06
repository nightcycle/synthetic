--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
-- Types
-- Constants
local SCALE = 1.2
-- Variables
-- References
local Icons = MaterialIcons.default.dp_48.scale_1

-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local function makeHalfFrame(isDarkMode: boolean, color: Color3): Frame
			local halfFrame = maid:GiveTask(Instance.new("Frame"))
			halfFrame.BackgroundColor3 = if isDarkMode
				then Color3.new(0.15, 0.15, 0.15)
				else Color3.new(0.85, 0.85, 0.85)

			local listLayout = maid:GiveTask(Instance.new("UIListLayout"))
			listLayout.FillDirection = Enum.FillDirection.Vertical
			listLayout.Padding = UDim.new(0, 10)
			listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.Parent = halfFrame

			local img = Types.newImageData(
				Icons.voice_chat.Image,
				Icons.voice_chat.ImageRectOffset,
				Icons.voice_chat.ImageRectSize
			)

			local Module = require(script.Parent)
			local theme = Types.newThemeData(
				1,
				isDarkMode,
				SCALE,
				Font.fromEnum(Enum.Font.SourceSans),
				color,
				halfFrame.BackgroundColor3
			)

			do
				local button = maid:GiveTask(Module.cfusion(function()
					print("click nil")
				end, img, "Badge nil", nil, theme))
				button.Parent = halfFrame
			end
			do
				local button = maid:GiveTask(Module.cfusion(function()
					print("click 0")
				end, img, "Badge 0", 0, theme))
				button.Parent = halfFrame
			end
			do
				local button = maid:GiveTask(Module.cfusion(function()
					print("click 1")
				end, img, "Badge 1", 1, theme))
				button.Parent = halfFrame
			end
			do
				local button = maid:GiveTask(Module.cfusion(function()
					print("click 64")
				end, img, "Badge 64", 64, theme))
				button.Parent = halfFrame
			end
			do
				local button = maid:GiveTask(Module.cfusion(function()
					print("click 360")
				end, img, "Badge 360", 360, theme))
				button.Parent = halfFrame
			end
			do
				local button = maid:GiveTask(Module.cfusion(function()
					print("click 1024")
				end, img, "Badge 1024", 1024, theme))
				button.Parent = halfFrame
			end
			return halfFrame
		end

		local COLORS: { [number]: Color3 } = {
			Color3.fromHSV(0, 0.9, 0.8),
			Color3.fromHSV(0, 0.25, 0.8),
			Color3.fromHSV(0, 0.9, 0.5),
			Color3.fromHSV(0.6, 0.9, 0.7),
			Color3.fromHSV(0.35, 0.9, 0.7),
			Color3.fromHSV(0.1, 0.9, 0.7),
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
