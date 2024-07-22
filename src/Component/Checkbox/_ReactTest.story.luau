--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local React = require(_Packages:WaitForChild("React"))
local ReactRoblox = require(_Packages:WaitForChild("ReactRoblox"))

-- Modules
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
				1.5,
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

			do
				local checkbox = React.createElement(Module.React.New, {
					onSelect = function(isSelected: boolean?)
						print("is selected", isSelected)
					end,
					initialSelection = nil,
					isEnabled = true,
					outlineColor = style:GetColor(Enums.ColorRoleType.OnSurfaceVariant),
					fillColor = style:GetColor(Enums.ColorRoleType.Primary),
					iconColor = style:GetColor(Enums.ColorRoleType.OnPrimary),
					disabledColor = style:GetColor(Enums.ColorRoleType.OnSurface),
					elevation = 0,
					schemeType = style.SchemeType,
					fontData = style:GetFontData(Enums.FontType.LabelLarge),
					scale = style.Scale,
				})
				print("A", checkbox)
				local root = ReactRoblox.createRoot(halfFrame)
				root:render(checkbox)
				-- print("B", checkbox)
				maid:GiveTask(function()
					root:render(nil)
				end)
			end

			return halfFrame
		end

		local COLORS: { [number]: Color3 } = {
			Color3.fromHSV(0, 0.9, 0.8),
			-- Color3.fromHSV(0, 0.25, 0.8),
			-- Color3.fromHSV(0, 0.9, 0.5),
			-- Color3.fromHSV(0.6, 0.9, 0.7),
			-- Color3.fromHSV(0.35, 0.9, 0.7),
			-- Color3.fromHSV(0.1, 0.9, 0.7),
		}

		for i, color in ipairs(COLORS) do
			local x = (i - 1) / #COLORS
			local width = 1 / #COLORS
			-- local dark = makeHalfFrame(true, color)

			-- dark.Size = UDim2.fromScale(width, 0.5)
			-- dark.Position = UDim2.fromScale(x, 0.5)
			-- dark.Parent = frame

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
