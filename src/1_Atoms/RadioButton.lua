local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local typography = require(script.Parent.Parent:WaitForChild("Typography"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)
	local maid = maidConstructor.new()

	--public states
	local Color = util.import(params.Color) or fusion.State(Color3.new(1,1,1))
	local Selected = util.import(params.Selected) or fusion.State(false)

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)
	local _Typography = fusion.State("Body")

	--properties
	local _MainColor = util.getInteractionColor(_Clicked, _Hovered, Color)
	local _TextSize = typography.getTextSizeState(_Typography)

	--preparing config
	local config = {
		Name = script.Name,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = util.tween(_MainColor),
		BackgroundTransparency = 1,
		Size = fusion.Computed(function()
			local dim = _TextSize:get()
			return UDim2.fromOffset(dim, dim)
		end),
		Text = "",
		[fusion.Children] = {
			fusion.New "UICorner" {
				CornerRadius = UDim.new(0.5,0),
			},
			fusion.New "UIStroke" {
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
				Color = util.tween(fusion.Computed(function()
					if Selected:get() then
						return _MainColor:get()
					else
						return Color3.new(0.5,0.5,0.5)
					end
				end)),
				Thickness = 2,
			},
			fusion.New "Frame" {
				AnchorPoint = Vector2.new(0.5,0.5),
				Position = UDim2.fromScale(0.5,0.5),
				BackgroundTransparency = util.tween(fusion.Computed(function()
					if Selected:get() then
						return 0
					else
						return 1
					end
				end)),
				BackgroundColor3 = util.tween(_MainColor),
				Size = util.tween(fusion.Computed(function()
					local dim = _TextSize:get() - 4
					return UDim2.fromOffset(dim, dim)
				end)),
				[fusion.Children] = {
					fusion.New "UICorner" {
						CornerRadius = UDim.new(0.5,0),
					},
				}
			}
		},
		[fusion.OnEvent "Activated"] = function()
			Selected:set(not Selected:get())
			effects.clickSound(0.5)
		end,
		[fusion.OnEvent "InputBegan"] = function()
			_Hovered:set(true)
		end,
		[fusion.OnEvent "InputEnded"] = function()
			_Hovered:set(false)
			_Clicked:set(false)
		end,
		[fusion.OnEvent "MouseButton1Down"] = function()
			_Clicked:set(true)
		end,
		[fusion.OnEvent "MouseButton1Up"] = function()
			_Clicked:set(false)
		end,
	}
	util.mergeConfig(config, params, nil, {
		Selected = true,
		Theme = true,
		Color = true,
	})

	local inst = fusion.New "TextButton" (config)

	util.setPublicState("Color", Color, inst, maid)
	util.setPublicState("Selected", Selected, inst, maid)

	maid:GiveTask(inst)
	util.init(script.Name, inst, maid)

	return inst
end

return constructor