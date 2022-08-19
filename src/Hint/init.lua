--!strict
local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local Types = require(package.Types)
type ParameterValue<T> = Types.ParameterValue<T>

local ColdFusion = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

local EffectGui = require(package:WaitForChild("EffectGui"))
local TextLabel = require(package:WaitForChild("TextLabel"))

-- setmetatable(Hint, Isotope)

-- function Hint.Destroy(self: any)
-- 	Isotope.Destroy(self)
-- end

export type HintParameters = TextLabel.TextLabelParameters & {
	Enabled: ParameterValue<boolean>?,
	Padding: ParameterValue<UDim>?,
	GapPadding: ParameterValue<UDim>?,
	CornerRadius: ParameterValue<UDim>?,
	Override: ParameterValue<boolean>?,
}

export type Hint = TextLabel

return function (config: HintParameters): Hint
	local _Maid = Maid.new()
	local _Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new

	local Name = _import(config.Name, script.Name)
	local Parent = _import(config.Parent, nil)
	local Font = _import(config.Font, Enum.Font.Gotham)
	local Text = _import(config.Text, nil)
	local TextSize = _import(config.TextSize, 10)
	local AnchorPoint = _import(config.AnchorPoint, Vector2.new(0,0))
	local P: any = _import(config.Padding, UDim.new(0,2)); local Padding: State<UDim> = P
	local GapPadding = _import(config.GapPadding, UDim.new(0,6))
	local CornerRadius = _import(config.CornerRadius , UDim.new(0,3))
	local BackgroundTransparency = _import(config.BackgroundTransparency, 0)
	local TextTransparency = _import(config.TextTransparency, 0)
	local BackgroundColor3 = _import(config.BackgroundColor3, Color3.fromHSV(0,0,0.7))
	local Enabled = _Value(if typeof(config.Enabled) == "boolean" then config.Enabled elseif typeof(config.Enabled) == "table" then config.Enabled:Get() else false)

	local Override = _import(config.Override, false)
	local Visible = _Value(false)

	local ActiveTextTransparency = _Computed(function(enab, trans)
		if enab then
			return trans
		else
			return 1
		end
	end, Enabled, TextTransparency):Tween()

	_Computed(function(par): nil
		if par then
			_Maid._parentInputBeginSignal = par.InputChanged:Connect(function()
				if not Override:Get() then
					Visible:Set(false)
				end
				if Enabled:IsA("Value") then
					Enabled:Set(true)
				end
			end)
			_Maid._parentInputEndSignal =  par.MouseLeave:Connect(function()
				if Enabled:IsA("Value") then
					Enabled:Set(false)
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
	local parameters: any = {
		Name = Name,
		Parent = Parent,
		Enabled = Visible,
	}
	local Output: any = EffectGui(parameters)

	local AbsoluteSize = _Fuse.Attribute(Output, "AbsoluteSize"):Else(Vector2.new(0,0))
	local CenterPosition = _Fuse.Attribute(Output, "CenterPosition"):Else(UDim2.fromOffset(0,0))

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

	local TextLabel = TextLabel(tConfig)

	local bubbleFrame = _new "Frame" {
		Name = "Hint",
		Parent = Output,
		Position = _Computed(function(center: UDim2, anchor: Vector2, size: Vector2, pad: UDim)
			local pos: Vector2 = Vector2.new(center.X.Offset, center.Y.Offset)
			local finalPoint = pos + (size*0.5 + Vector2.new(1,1)*pad.Offset)*anchor
			return UDim2.fromOffset(finalPoint.X, finalPoint.Y)
		end, CenterPosition, AnchorPoint, AbsoluteSize, GapPadding),
		AnchorPoint = _Computed(function(anchor)
			return Vector2.new(1,1)*0.5-anchor
		end, AnchorPoint),
		BorderSizePixel = 0,
		ZIndex = 1,
		BackgroundColor3 = BackgroundColor3,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromOffset(0,0),
		BackgroundTransparency = _Computed(function(background, enab)
			if enab then
				return background
			else
				return 1
			end
		end, BackgroundTransparency, Enabled):Tween(),
		Attributes = {
			ClassName = script.Name,
		},
		Children = {
			_new "UIPadding" {
				PaddingBottom = Padding,
				PaddingTop = Padding,
				PaddingLeft = Padding,
				PaddingRight = Padding,
			},
			_new "UICorner" {
				CornerRadius = CornerRadius,
			},
			TextLabel,
		} :: {Instance}
	}
	_Maid:GiveTask(bubbleFrame)

	Util.cleanUpPrep(_Maid, Output)

	return Output
end
