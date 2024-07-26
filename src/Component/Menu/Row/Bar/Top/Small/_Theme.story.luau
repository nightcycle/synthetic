--!strict
local _Package = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent
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
		local Module = require(script.Parent:WaitForChild("ColdFusion"))

		local listLayout = maid:GiveTask(Instance.new("UIListLayout"))
		listLayout.FillDirection = Enum.FillDirection.Vertical
		listLayout.Padding = UDim.new(0, 10)
		listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		listLayout.Parent = frame

		local function build(isDarkMode: boolean, color: Color3)
			local style = Style.new(
				0.75,
				Enum.Font.SourceSans,
				if isDarkMode then Enums.SchemeType.Dark else Enums.SchemeType.Light,
				color
			)

			do
				local out = maid:GiveTask(Module.primary(
					style,
					"Primary",
					{
						Types.ButtonData.new(function()
							print("save click")
						end, Icons.save),
						Types.ButtonData.new(function()
							print("publish click")
						end, Icons.publish),
					},
					Types.ButtonData.new(function()
						print("nav click")
					end, Icons.arrow_back)
				))

				out.Position = UDim2.fromScale(0.5, 0.5)
				out.AnchorPoint = Vector2.new(0.5, 0.5)
				out.Size = UDim2.fromScale(1, 0)
				out.Parent = frame
			end

			do
				local out = maid:GiveTask(Module.secondary(
					style,
					"Secondary",
					{
						Types.ButtonData.new(function()
							print("save click")
						end, Icons.save),
						Types.ButtonData.new(function()
							print("publish click")
						end, Icons.publish),
					},
					Types.ButtonData.new(function()
						print("nav click")
					end, Icons.arrow_back)
				))

				out.Position = UDim2.fromScale(0.5, 0.5)
				out.AnchorPoint = Vector2.new(0.5, 0.5)
				out.Size = UDim2.fromScale(1, 0)
				out.Parent = frame
			end

			do
				local out = maid:GiveTask(Module.tertiary(
					style,
					"Tertiary",
					{
						Types.ButtonData.new(function()
							print("save click")
						end, Icons.save),
						Types.ButtonData.new(function()
							print("publish click")
						end, Icons.publish),
					},
					Types.ButtonData.new(function()
						print("nav click")
					end, Icons.arrow_back)
				))

				out.Position = UDim2.fromScale(0.5, 0.5)
				out.AnchorPoint = Vector2.new(0.5, 0.5)
				out.Size = UDim2.fromScale(1, 0)
				out.Parent = frame
			end
		end
		build(false, Color3.new(1, 0, 0))
		build(true, Color3.new(1, 0, 0))
		build(false, Color3.new(0, 0, 1))
		build(true, Color3.new(0, 0, 1))
	end)
	return function()
		maid:Destroy()
	end
end
