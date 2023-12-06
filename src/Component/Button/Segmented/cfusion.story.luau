--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
-- Constants
local SCALE = 2
-- Variables
-- References
local Icons = MaterialIcons.default.dp_48.scale_1

-- Class
return function(frame: Frame)
	local maid = Maid.new()
	task.spawn(function()
		local Module = require(script.Parent)
		local isDarkMode = true
		local color = Color3.new(1, 0, 0)
		local selectionColor = nil --Color3.new(1,0.75,0)
		local frameColor = Color3.new(0, 0, 0)

		local theme = Types.newThemeData(
			1,
			isDarkMode,
			SCALE,
			Font.fromEnum(Enum.Font.SourceSans),
			color,
			frameColor,
			selectionColor
		)

		local out = maid:GiveTask(Module.cfusion({
			Types.newOptionData(function()
				print("click 1")
			end, false, true, "Test"),
			Types.newOptionData(function()
				error("disabled click?")
			end, true, false, "Disabled"),
			Types.newOptionData(function()
				print("icon click")
			end, false, false, "Icon Test", Icons.wifi_off),
			Types.newOptionData(function()
				print("selection click")
			end, false, false, "Unselected", Icons.zoom_in, "Selected", Icons.zoom_out),
		}, false, theme, 0))
		out.Position = UDim2.fromScale(0.5, 0.5)
		out.AnchorPoint = Vector2.new(0.5, 0.5)
		out.Parent = frame
	end)
	return function()
		maid:Destroy()
	end
end
