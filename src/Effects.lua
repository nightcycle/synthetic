

local packages = script.Parent.Parent
local util = require(script.Parent:WaitForChild("Util"))
local f = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild("maid"))
local enums = require(script.Parent:WaitForChild("Enums"))

local runService = game:GetService("RunService")
local player
if runService:IsClient() then
	player  = game.Players.LocalPlayer
end

--[=[
	@class Effects
	A list of useful effects, some probably should just be Atom components
]=]

local fxHolder = f.new "ScreenGui" {
	Parent = player:WaitForChild("PlayerGui"),
	ResetOnSpawn = false,
	Name = "Effects",
	DisplayOrder = 1000,
}

local cam = game.Workspace.CurrentCamera
local screenSize = f.v(cam.ViewportSize)
cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	screenSize:set(cam.ViewportSize)
end)

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

local effects = {}

--[=[
	@function ripple
	Plays a ripple effect
	@within Effects
	@param Position FusionState --A UDim2 containing FusionState showing the desired target position
	@param Color FusionState --A Color3 containing FusionState showing the desired ripple color
]=]
ripple = function(position, color)
	local currentSize = f.v(UDim.new(0,10))
	local currentTransparency = f.v(0.2)
	local element = require(script.Parent:FindFirstChild("Bubble", true)).new({
		Size = currentSize,
		Transparency = currentTransparency,
		Color = color,
		Position = position,
		Parent = fxHolder,
	})
	task.delay(0, function()
		currentSize:set(UDim.new(0,60))
		currentTransparency:set(1)
		task.wait(0.9)
		element:Destroy()
	end)
end

--[=[
	@function sound
	Plays a sound effect
	@within Effects
	@param Key SoundKey --creates a new sound based on the filename of the [official material sounds](https://material.io/design/sound/sound-resources.html#).
]=]
sound = function(key)
	local soundInst = Instance.new("Sound", fxHolder)
	soundInst.SoundId = sounds[key]
	soundInst.Volume = 0.5
	soundInst.PlayOnRemove = true
	soundInst:Destroy()
end

--[=[
	@function menu
	Creates and returns a dropdown menu, this honestly should just be a Component
	@within Effects
	@param maid Maid --maid that will be called upon menu completion to clean up
	@param Parameters {any} --miscellaneous menu parameters
	@param HostSizeState FusionState --fusionState of the Vector2 of the host's absolute size
	@param HostPositionState FusionState --fusionState of the Vector2 of the host's absolute position
]=]
menu = function(maid, menuParams, hostSizeState, hostPositionState)
	menuParams.Parent = fxHolder
	menuParams.Position = f.get(function()
		local pos = hostPositionState:get()
		local size = hostSizeState:get()
		return UDim2.fromOffset(pos.X, pos.Y + size.Y)
	end)
	local inst = require(script.Parent:FindFirstChild("Menu", true)).new(menuParams)
	maid:GiveTask(inst)
	return inst
end
--[=[
	@function tip
	Creates and places Tooltips.
	@within Effects
	@param maid Maid --maid that will be called upon menu completion to clean up
	@param Parameters {any} --miscellaneous menu parameters
	@param HostSizeState FusionState --fusionState of the Vector2 of the host's absolute size
	@param HostPositionState FusionState --fusionState of the Vector2 of the host's absolute position
	@param PreferredDirection FusionState --fusionState of the Vector2 of the host's anchor point to be used
]=]
tip = function(maid, tipParams, hostAbsPositionState, hostAbsSizeState, preferredDirection)
	tipParams.AnchorPoint = f.get(function()
		local dir = Vector2.new(1,1) - preferredDirection:get()
		-- print("Pref: ", dir)
		local xWeight = math.abs(dir.X - 0.5)*2
		local yWeight = math.abs(dir.Y- 0.5)*2
		-- print('Anchor', dir, xWeight, yWeight)
		if yWeight >= 1 or xWeight >= 1 then
			return Vector2.new(dir.X, dir.Y)
		else
			return Vector2.new(math.round(dir.X), math.round(dir.Y))
		end
	end)
	tipParams.Position = f.get(function()
		--generate first potential point
		local anchorPoint = tipParams.AnchorPoint:get()
		local antiAnchor = Vector2.new(1,1)-anchorPoint
		local position = hostAbsPositionState:get()
		local size = hostAbsSizeState:get()
		local x = (antiAnchor.X-0.5)*2
		local y = (antiAnchor.Y-0.5)*2
		local offset = Vector2.new(x,y)*Vector2.new(4,4)
		local point = position + antiAnchor*size + offset

		--check to make sure it fits, nudging when necessary
		local screenBounds = screenSize:get()
		if point.X < 0 then point += Vector2.new(-point.X, 0) end
		if point.Y < 0 then point += Vector2.new(0, -point.Y) end
		if point.X > screenBounds.X then point -= Vector2.new(screenBounds.X-point.X, 0) end
		if point.Y > screenBounds.Y then point -= Vector2.new(0, screenBounds.Y-point.Y) end

		--check again for max distance point, nudging when necessary
		local maxPoint = point + (size*antiAnchor)
		if maxPoint.X < 0 then
			local fix = Vector2.new(-maxPoint.X, 0)
			point += fix
			maxPoint += fix
		end
		if maxPoint.Y < 0 then
			local fix = Vector2.new(0, -maxPoint.Y)
			point += fix
			maxPoint += fix
		end
		if maxPoint.X > screenBounds.X then
			local fix = Vector2.new(screenBounds.X-maxPoint.X, 0)
			point -= fix
			maxPoint -= fix
		end
		if maxPoint.Y > screenBounds.Y then
			local fix = Vector2.new(screenBounds.Y-maxPoint.Y, 0)
			point -= fix
			maxPoint -= fix
		end
		return UDim2.fromOffset(point.X, point.Y)
	end)
	tipParams.Parent = fxHolder

	local tipInst = require(script.Parent:FindFirstChild("Tooltip", true)).new(tipParams)
	maid:GiveTask(tipInst)
end

return effects