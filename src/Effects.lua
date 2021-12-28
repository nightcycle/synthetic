
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
	ripple = function(position, size, color)
		local currentSize = fusion.State(size)
		local currentTransparency = fusion.State(0)
		local duration = 0.7
		local tweenParams = {
			Duration = duration,
			EasingStyle = Enum.EasingStyle.Quint,
			EasingDirection = Enum.EasingDirection.Out,
		}
		local TweenSize = util.tween(currentSize, tweenParams)
		local TweenTransparency = util.tween(currentTransparency, tweenParams)
		local element = fusion.New "Frame" {
			Name = "Ripple",
			Parent = fxHolder,
			Size = TweenSize,
			BackgroundColor3 = color,
			BackgroundTransparency = TweenTransparency,
			Position = position,
		}
		task.delay(0, function()
			currentSize:set(size)
			currentTransparency:set(1)
			task.wait(duration)
			element:Destroy()
		end)
	end,

	clickSound = function(pitch)
		pitch = pitch or 1
		local soundInst = Instance.new("Sound", fxHolder)
		soundInst.SoundId = "rbxassetid://179235828"
		soundInst.Volume = 0.3
		soundInst.Pitch = pitch
		soundInst.PlayOnRemove = true
		soundInst:Destroy()
	end,
}