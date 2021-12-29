local packages = script.Parent.Parent.Parent
local synthetic
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local util = require(script.Parent.Parent:WaitForChild("Util"))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	synthetic = synthetic or require(script.Parent.Parent)

	--public states
	local public = {
		Color = util.import(params.Color) or fusion.State(Color3.new(1,1,1)),
		Selected = util.import(params.Selected) or fusion.State(false),
		Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14),
	}

	--influencers
	local _Hovered = fusion.State(false)
	local _Clicked = fusion.State(false)

	--properties
	local _MainColor = util.getInteractionColor(_Clicked, _Hovered, public.Color)
	local _TextSize = fusion.Computed(function()
		return public.Typography:get().TextSize
	end)

	--preparing config
	local inst
	inst = util.set(fusion.New "ImageButton", public, params, {
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
					if public.Selected:get() then
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
					if public.Selected:get() then
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
			public.Selected:set(not public.Selected:get())
			effects.ripple(fusion.State(inst.Position), _MainColor)
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
	})

	return inst
end

return constructor