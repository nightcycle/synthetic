
local packages = script.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local util = require(script.Parent:WaitForChild("Util"))
local maidConstructor = require(packages:WaitForChild("maid"))
local enums = require(script.Parent:WaitForChild("Enums"))

local player = game.Players.LocalPlayer
local fxHolder = fusion.New "ScreenGui" {
	Parent = player:WaitForChild("PlayerGui"),
	ResetOnSpawn = false,
	Name = "Effects",
	DisplayOrder = math.huge,
}

return {
	ripple = function(position, color)
		local currentSize = fusion.State(UDim2.fromOffset(10,10))
		local currentTransparency = fusion.State(0.2)
		local duration = 0.9
		local tweenParams = {
			Duration = duration,
			EasingStyle = Enum.EasingStyle.Cubic,
			EasingDirection = Enum.EasingDirection.Out,
		}
		local TweenSize = util.tween(currentSize, tweenParams)
		local TweenTransparency = util.tween(currentTransparency, tweenParams)
		local element = fusion.New "Frame" {
			Name = "Ripple",
			Parent = fxHolder,
			AnchorPoint = Vector2.new(0.5,0.5),
			Size = TweenSize,
			BackgroundColor3 = color,
			BackgroundTransparency = TweenTransparency,
			Position = position,
			[fusion.Children] = {
				fusion.New "UICorner" {
					CornerRadius = UDim.new(0.5,0),
				}
			}
		}
		task.delay(0, function()
			currentSize:set(UDim2.fromOffset(60,60))
			currentTransparency:set(1)
			task.wait(duration)
			element:Destroy()
		end)
	end,

	clickSound = function(pitch)
		pitch = pitch or 1
		local soundInst = Instance.new("Sound", fxHolder)
		soundInst.SoundId = "rbxassetid://421058925"
		soundInst.Volume = 0.1
		soundInst.Pitch = pitch
		soundInst.PlayOnRemove = true
		soundInst:Destroy()
	end,
}