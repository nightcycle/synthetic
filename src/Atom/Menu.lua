local userInputService = game:GetService("UserInputService")
local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}


function constructor.new(params)
	--[=[
		@class Menu
		@tag Component
		@tag Atom
		A basic menu pop-up used by the Dropdown component.
	]=]
	local maid = maidConstructor.new()
	--public states
	local public = {}

	--[=[
		@prop Typography Typography | FusionState | nil
		The Typography to be used for this component
		@within Menu
	]=]
	public.Typography = util.import(params.Typography) or typographyConstructor.new(Enum.Font.SourceSans, 10, 14)
	--[=[
		@prop BackgroundColor Color3 | FusionState | nil
		Color used for background of menu
		@within Menu
	]=]
	public.BackgroundColor = util.import(params.BackgroundColor) or fusion.State(Color3.new(0.8,0.8,0.8))

	--[=[
		@prop Color Color3 | FusionState | nil
		Color used to add texture to component
		@within Menu
	]=]
	public.Color = util.import(params.Color) or fusion.State(Color3.new(0.5,0,1))

	--[=[
		@prop TextColor Color3 | FusionState | nil
		Color used for text
		@within Menu
	]=]
	public.TextColor = util.import(params.TextColor) or fusion.State(Color3.new(0.2,0.2,0.2))

	--[=[
		@prop Width UDim | FusionState | nil
		Width of the entire component, as Height is solved using Typography
		@within Menu
	]=]
	public.Width = util.import(params.Width) or fusion.State(UDim.new(1, 0))

	--[=[
		@prop Options {string} | FusionState | nil
		A list of options that can be selected from
		@within Menu
	]=]
	public.Options = util.import(params.Options) or fusion.State({})

	--[=[
		@prop Open bool | FusionState | nil
		Whether the menu is currently open
		@within Menu
	]=]
	public.Open = util.import(params.Open) or fusion.State(false)

	--[=[
		@prop SynthClassName string
		Attribute used to identify what type of component it is
		@within Menu
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)
	local _Padding, _TextSize, _Font = util.getTypographyStates(public.Typography)
	local _AbsoluteSize = fusion.State(Vector2.new(0,0))

	--[=[
		@function OnSelect:Connect
		Creates a signal that fires when an option is clicked
		@within Menu
	]=]

	local frame = util.set(fusion.New "Frame", public, params, {
		Position = public.Position,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Size = util.tween(fusion.Computed(function()
			local v2 = _AbsoluteSize:get()
			-- local pad = _Padding:get().Offset
			return UDim2.new(public.Width:get(), UDim.new(0, v2.Y))
		end)),
		[fusion.OnChange] = {
			fusion.New 'BindableEvent' {
				Name = "OnSelect",
			},
			fusion.New "Frame" {
				Name = "Content",
				AnchorPoint = Vector2.new(0,0),
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = util.tween(fusion.Computed(function()
					return UDim2.new(public.Width:get(), UDim.new(0,0))
				end)),

				BackgroundColor3 = util.tween(public.BackgroundColor),
				-- Position = public.Position,

				[fusion.OnChange] = {
					fusion.New "UICorner" {
						CornerRadius = util.cornerRadius,
					},
					fusion.New "UIListLayout" {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top
					},
					fusion.New 'UIPadding' {
						PaddingBottom = _Padding,
						PaddingTop = UDim.new(0,0),
						PaddingLeft = UDim.new(0,0),
						PaddingRight = UDim.new(0,0),
					},

				}
			}
		}
	}, maid)
	local contentFrame = frame:WaitForChild("Content")
	fusion.Computeds(public.Options, function(index, value)
		local optionMaid = maidConstructor.new()
		maid:GiveTask(optionMaid)

		local _ButtonHovered = fusion.State(false)
		local _ButtonClicked = fusion.State(false)

		local button = fusion.New "TextButton" {
			Parent = contentFrame,
			Text = value,
			Visible = fusion.Computed(function()
				local val = public.Input:get()
				if val == value then return false else return true end
			end),
			LayoutOrder = index,
			Size = UDim2.fromScale(1,0),
			TextSize = _TextSize,
			Font = _Font,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			BackgroundTransparency = fusion.Computed(function()
				if _ButtonHovered:get() then
					return 0.8
				else
					return 1
				end
			end),
			BackgroundColor3 = Color3.new(0,0,0),

			[fusion.OnEvent "InputBegan"] = function(inputObj)
				_ButtonHovered:set(true)
			end,
			[fusion.OnEvent "InputEnded"] = function(inputObj)
				_ButtonHovered:set(false)
				_ButtonClicked:set(false)
			end,
			[fusion.OnEvent "Activated"] = function()
				effects.sound("ui_tap-variant-01")
				frame:WaitForChild("OnSelect"):Fire(value, index)
				_AbsoluteSize:set(Vector2.new(0,0))
			end,
			[fusion.OnEvent "MouseButton1Down"] = function(x, y)
				effects.sound("ui_tap-variant-01")
				_ButtonClicked:set(true)
			end,
			[fusion.OnEvent "MouseButton1Up"] = function()
				_ButtonClicked:set(false)
			end,
			[fusion.OnChange] = {
				fusion.New 'UIPadding' {
					PaddingBottom = _Padding,
					PaddingTop = _Padding,
					PaddingLeft = _Padding,
					PaddingRight = _Padding,
				},
			},
		}
		_AbsoluteSize:set(contentFrame.AbsoluteSize)
		optionMaid:GiveTask(button)
		return optionMaid
	end)

	maid:GiveTask(userInputService.InputBegan:Connect(function(inputObj)
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 then
			local x = inputObj.Position.X
			local y = inputObj.Position.Y
			local found = false
			for i, v in ipairs(game.Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(x,y)) do
				if v == contentFrame then found = true end
			end
			if not found then
				frame:WaitForChild("OnSelect"):Fire()
				_AbsoluteSize:set(Vector2.new(0,0))
			end
		end
	end))

	return frame
end

return constructor