--!strict
local _Package = script.Parent.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))

-- Types
-- Constants
local SCALE = 1
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
			local selectionColor = nil --Color3.new(1,0.75,0)
			-- local frameColor = Color3.new(0, 0, 0)

			local theme = Types.newThemeData(
				0,
				isDarkMode,
				SCALE,
				Font.fromEnum(Enum.Font.SourceSans),
				color,
				nil, --frameColor,
				selectionColor
			)
	
			local out = maid:GiveTask(Module.cfusion(
				"Title",
				{
					Types.newButtonData(
						function() 
							print("save click")
						end,
						Icons.save
					),
					Types.newButtonData(
						function() 
							print("publish click")
						end,
						Icons.publish
					),
				},
				Types.newButtonData(
					function() 
						print("nav click")
					end,
					Icons.arrow_back
				),
				theme
			))

			out.Position = UDim2.fromScale(0.5, 0.5)
			out.AnchorPoint = Vector2.new(0.5, 0.5)
			out.Size=  UDim2.fromScale(1,0)
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
