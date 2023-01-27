--!strict
local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local ColdFusion = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

local EffectGui = require(package:WaitForChild("EffectGui"))
local TextLabel = require(package:WaitForChild("TextLabel"))

export type HintParameters = TextLabel.TextLabelParameters & {
	Enabled: State<boolean>?,
	Padding: CanBeState<UDim>?,
	GapPadding: CanBeState<UDim>?,
	CornerRadius: CanBeState<UDim>?,
	Override: CanBeState<boolean>?,
}

export type Hint = ScreenGui

function Constructor(config: HintParameters): Hint
	-- init workspace
	local _Maid = Maid.new()
	local _Fuse = ColdFusion.fuse(_Maid)
	local _new = _Fuse.new
	local _mount = _Fuse.mount
	local _import = _Fuse.import
	local _OUT = _Fuse.OUT
	local _REF = _Fuse.REF
	local _CHILDREN = _Fuse.CHILDREN
	local _ON_EVENT = _Fuse.ON_EVENT
	local _ON_PROPERTY = _Fuse.ON_PROPERTY
	local _Value = _Fuse.Value
	local _Computed = _Fuse.Computed

	-- unload config states
	local Name = _import(config.Name, script.Name)
	local Parent: State<GuiObject?> = _import(config.Parent, nil :: GuiObject?)
	local Font = _import(config.Font, Enum.Font.Gotham)
	local Text = _import(config.Text, nil)
	local TextSize = _import(config.TextSize, 10)
	local AnchorPoint = _import(config.AnchorPoint, Vector2.new(0, 0))
	local Padding: State<UDim> = _import(config.Padding, UDim.new(0, 2)) :: any
	local GapPadding = _import(config.GapPadding, UDim.new(0, 6))
	local CornerRadius = _import(config.CornerRadius, UDim.new(0, 3))
	local BackgroundTransparency = _import(config.BackgroundTransparency, 0)
	local TextTransparency = _import(config.TextTransparency, 0)
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0, 0, 0.7))
	local Enabled: State<boolean> = if config.Enabled then config.Enabled else _Value(true) :: any
	local Override = _import(config.Override, false)

	-- init internal states
	local AbsoluteSize = _Value(Vector2.new(0, 0))
	local CenterPosition = _Value(UDim2.fromOffset(0, 0))
	local Visible = _Value(Override:Get())
	local ActiveTextTransparency = _Computed(function(enab, trans)
		if enab then
			return trans
		else
			return 1
		end
	end, Enabled, TextTransparency):Tween()
	_Computed(function(par: GuiObject?): nil
		if par then
			_Maid._parentInputBeginSignal = par.InputChanged:Connect(function()
				if not Override:Get() then
					Visible:Set(true)			
				end
				local ValEnab: ValueState<boolean> = Enabled :: any
				if ValEnab.Set then
					ValEnab:Set(true)
				end
			end)
			_Maid._parentInputEndSignal = par.MouseLeave:Connect(function()
				local ValEnab: ValueState<boolean> = Enabled :: any
				if ValEnab.Set then
					ValEnab:Set(false)
				end
				task.wait(0.3)
				pcall(function()
					if Enabled:Get() == false then
						if not Override:Get() then
							Visible:Set(false)
						end
					end
				end)
			end)
		end
		return nil
	end, Parent)

	-- filter sub-config
	local tConfig: any = config
	tConfig.Override = nil
	tConfig.CornerRadius = nil
	tConfig.GapPadding = nil
	tConfig.Padding = nil
	tConfig.AnchorPoint = nil
	tConfig.Enabled = nil
	tConfig.BackgroundColor3 = nil
	tConfig.BackgroundTransparency = nil
	tConfig.LeftIcon = nil
	tConfig.RightIcon = nil
	tConfig.Text = Text
	tConfig.TextSize = TextSize
	tConfig.Font = Font
	tConfig.TextTransparency = ActiveTextTransparency

	-- construct sub-instance
	local bubbleFrame = _new("Frame")({
		Name = "Hint",
		Position = _Computed(function(center: UDim2, anchor: Vector2, size: Vector2, pad: UDim)
			local pos: Vector2 = Vector2.new(center.X.Offset, center.Y.Offset)
			local finalPoint = pos + (size * 0.5 + Vector2.new(1, 1) * pad.Offset) * anchor
			return UDim2.fromOffset(finalPoint.X, finalPoint.Y)
		end, CenterPosition, AnchorPoint, AbsoluteSize, GapPadding),
		AnchorPoint = _Computed(function(anchor)
			return Vector2.new(1, 1) * 0.5 - anchor
		end, AnchorPoint),
		BorderSizePixel = 0,
		ZIndex = 1,
		BackgroundColor3 = BackgroundColor3,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = _Computed(function(background, enab)
			if enab then
				return background
			else
				return 1
			end
		end, BackgroundTransparency, Enabled):Tween(),

		[_CHILDREN] = {
			_new("UIPadding")({
				PaddingBottom = Padding,
				PaddingTop = Padding,
				PaddingLeft = Padding,
				PaddingRight = Padding,
			}),
			_new("UICorner")({
				CornerRadius = CornerRadius,
			}),
			TextLabel(_Maid)(tConfig),
		} :: { Instance },
	})
	_Maid:GiveTask(bubbleFrame)

	-- assemble final parameters
	local parameters: any = {
		Name = Name,
		Parent = Parent,
		Enabled = Visible,
		[_CHILDREN] = {},
	}

	-- construct output instance
	local Output: ScreenGui = EffectGui(_Maid)(parameters)
	bubbleFrame.Parent = Output
	_Maid:GiveTask(Output:GetAttributeChangedSignal("AbsoluteSize"):Connect(function()
		AbsoluteSize:Set(Output:GetAttribute("AbsoluteSize") or Vector2.new(0, 0))
	end))

	_Maid:GiveTask(Output:GetAttributeChangedSignal("CenterPosition"):Connect(function()
		CenterPosition:Set(Output:GetAttribute("CenterPosition") or UDim2.fromOffset(0, 0))
	end))
	Util.cleanUpPrep(_Maid, Output)

	return Output
end

return function(maid: Maid?)
	return function(params: HintParameters): Hint
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
