--!strict
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Maid"))
local ColdFusion = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("ColdFusion"))
-- Modules
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))

-- Types
-- Constants
local KEY = "ProgressValue"
-- Variables
-- References

-- Private Functions
-- Class
return function(frame: Frame)
	local maid = Maid.new()
	local isDead = false
	task.spawn(function()
		local _fuse = ColdFusion.fuse(maid)

		local _new = _fuse.new
		local _bind = _fuse.bind
		local _clone = _fuse.clone
		local _import = _fuse.import

		local _Value = _fuse.Value
		local _Computed = _fuse.Computed

		local progressState: ColdFusion.ValueState<number?> = _Value(nil :: number?)
		maid:GiveTask(frame:GetAttributeChangedSignal(KEY):Connect(function()
			progressState:Set(frame:GetAttribute(KEY))
		end))
		frame:SetAttribute(KEY, math.random())

		local function makeHalfFrame(isDarkMode: boolean, color: Color3): Frame
			local style = Style.new(
				1,
				"Source Sans",
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
				local button = maid:GiveTask(
					Module.ColdFusion.new(
						progressState,
						true,
						style:GetColor(Enums.ColorRoleType.Primary, 1),
						style:GetColor(Enums.ColorRoleType.PrimaryContainer, 1),
						style
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

			dark.Size = UDim2.fromScale(width, 0.5)
			dark.Position = UDim2.fromScale(x, 0.5)
			dark.Parent = frame

			local bright = makeHalfFrame(false, color)
			bright.Size = UDim2.fromScale(width, 0.5)
			bright.Position = UDim2.fromScale(x, 0)
			bright.Parent = frame
		end

		for i = 1, 1000 do
			task.wait(4)
			if isDead then
				break
			end
			if i % 2 == 0 then
				frame:SetAttribute(KEY, nil)
			else
				frame:SetAttribute(KEY, math.random())
			end
			-- frame:SetAttribute(KEY, nil)
		end
	end)

	return function()
		isDead = false
		maid:Destroy()
	end
end
