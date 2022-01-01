
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

local sounds = {
	["alarm_gentle"] = "rbxassetid://8419004462",
	["alert_error-01"] = "rbxassetid://8418989416",
	["alert_error-02"] = "rbxassetid://8418989547",
	["alert_error-03"] = "rbxassetid://8418989245",
	["alert_high-intensity"] = "rbxassetid://8419004267",
	["alert_simple"] = "rbxassetid://8419004128",
	["hero_decorative-celebration-01"] = "rbxassetid://8419021886",
	["hero_decorative-celebration-02"] = "rbxassetid://8419021655",
	["hero_decorative-celebration-03"] = "rbxassetid://8419021512",
	["hero_simple-celebration-01"] = "rbxassetid://8419021337",
	["hero_simple-celebration-02"] = "rbxassetid://8419021771",
	["hero_simple-celebration-03"] = "rbxassetid://8419021178",
	["navigation-cancel"] = "rbxassetid://8418988797",
	["navigation_backward-selection"] = "rbxassetid://8418969455",
	["navigation_backward-selection-minimal"] = "rbxassetid://8418969323",
	["navigation_forward-selection"] = "rbxassetid://8418969214",
	["navigation_forward-selection-minimal"] = "rbxassetid://8418969121",
	["navigation_hover-tap"] = "rbxassetid://8418969004",
	["navigation_selection-complete-celebration"] = "rbxassetid://8418968894",
	["navigation_transition-left"] = "rbxassetid://8418988941",
	["navigation_transition-right"] = "rbxassetid://8418989089",
	["navigation_unavailable-selection"] = "rbxassetid://8418988360",
	["notification_ambient"] = "rbxassetid://8419003895",
	["notification_decorative-01"] = "rbxassetid://8419003507",
	["notification_decorative-02"] = "rbxassetid://8419003320",
	["notification_high-intensity"] = "rbxassetid://8419003130",
	["notification_simple-01"] = "rbxassetid://8419002932",
	["notification_simple-02"] = "rbxassetid://8419004014",
	["ringtone_minimal"] = "rbxassetid://8419003725",
	["state-change_confirm-down"] = "rbxassetid://8418968790",
	["state-change_confirm-up"] = "rbxassetid://8418968701",
	["ui_camera-shutter"] = "rbxassetid://8418968330",
	["ui_loading"] = "rbxassetid://8418988677",
	["ui_lock"] = "rbxassetid://8418968256",
	["ui_refresh-feed"] = "rbxassetid://8418988545",
	["ui_tap-variant-01"] = "rbxassetid://8418968132",
	["ui_tap-variant-02"] = "rbxassetid://8418968059",
	["ui_tap-variant-03"] = "rbxassetid://8418968611",
	["ui_tap-variant-04"] = "rbxassetid://8418967845",
	["ui_unlock"] = "rbxassetid://8418968416",
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

	sound = function(key)
		local soundInst = Instance.new("Sound", fxHolder)
		soundInst.SoundId = sounds[key]
		soundInst.Volume = 0.5
		soundInst.PlayOnRemove = true
		soundInst:Destroy()
	end,
}