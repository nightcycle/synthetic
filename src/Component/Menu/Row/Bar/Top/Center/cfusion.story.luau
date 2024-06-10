--!strict
local _Package = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
-- Constants
-- Variables
-- References
local Icons = MaterialIcons.default.dp_48.scale_1

-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local Module = require(script.Parent)

		local listLayout = maid:GiveTask(Instance.new("UIListLayout"))
		listLayout.FillDirection = Enum.FillDirection.Vertical
		listLayout.Padding = UDim.new(0, 10)
		listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		listLayout.Parent = frame

		local function build(isDarkMode: boolean, color: Color3)
			local style =
				Style.new(1, "Source Sans", if isDarkMode then Enums.SchemeType.Dark else Enums.SchemeType.Light, color)

			local out = maid:GiveTask(
				Module.ColdFusion.new(
					"Title",
					{
						Types.newButtonData(function()
							print("save click")
						end, Icons.save),
						Types.newButtonData(function()
							print("publish click")
						end, Icons.publish),
					},
					Types.newButtonData(function()
						print("nav click")
					end, Icons.arrow_back),
					style:GetColor(Enums.ColorRoleType.Primary),
					style:GetColor(Enums.ColorRoleType.OnPrimary),
					1,
					style.SchemeType,
					style:GetFontData(Enums.FontType.TitleLarge),
					style:GetFontData(Enums.FontType.HeadlineMedium),
					style:GetFontData(Enums.FontType.LabelLarge),
					style.Scale
				)
			)

			out.Position = UDim2.fromScale(0.5, 0.5)
			out.AnchorPoint = Vector2.new(0.5, 0.5)
			out.Size = UDim2.fromScale(1, 0)
			out.Parent = frame
		end
		build(false, Color3.fromHSV(0.5, 0.3, 0.95))
		build(true, Color3.fromHSV(0.5, 0.5, 0.4))
		build(false, Color3.fromHSV(0.1, 0.3, 0.95))
		build(true, Color3.fromHSV(0.1, 0.5, 0.4))
		build(false, Color3.fromHSV(0.7, 0.3, 0.95))
		build(true, Color3.fromHSV(0.7, 0.5, 0.4))
	end)
	return function()
		maid:Destroy()
	end
end
