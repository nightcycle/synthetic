--!strict
local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local Types = require(package.Types)
type ParameterValue<T> = Types.ParameterValue<T>

local ColdFusion: Fuse = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

local Format = require(packages:WaitForChild("format"))

local Icon = require(package:WaitForChild("IconLabel"))

export type TextLabelParameters = Types.FrameParameters & {
	Padding: ParameterValue<UDim>?,
	TextSize: ParameterValue<number>?,
	TextColor3: ParameterValue<Color3>?,
	TextTransparency: ParameterValue<number>?,
	TextXAlignment: ParameterValue<Enum.TextXAlignment>?,
	TextYAlignment: ParameterValue<Enum.TextYAlignment>?,
	Text: ParameterValue<string>?,
	Font: ParameterValue<Enum.Font>?,
	IconScale: ParameterValue<number>?,
	LeftIcon: ParameterValue<string>?,
	RightIcon: ParameterValue<string>?,
}

export type TextLabel = Frame

function Constructor(config: TextLabelParameters): TextLabel
	local _Maid = Maid.new()
	local _Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new

	local Padding = _import(config.Padding, UDim.new(0, 2))
	local TextSize = _import(config.TextSize, 14)
	local TextColor3 = _import(config.TextColor3, Color3.new(1,1,1))
	local TextTransparency = _import(config.TextTransparency, 0)
	local TextXAlignment = _import(config.TextXAlignment, Enum.TextXAlignment.Center)
	local TextYAlignment = _import(config.TextYAlignment, Enum.TextYAlignment.Center)
	local Text = _import(config.Text, false)
	local Font = _import(config.Font, Enum.Font.Gotham)
	local IconScale = _import(config.IconScale, 1.25)
	local LeftIcon = _import(config.LeftIcon, "")
	local RightIcon = _import(config.RightIcon, "")
	local IconSize = _Computed(function(textSize: number, scale: number)
		local size = math.round(textSize*scale)
		return UDim2.fromOffset(size, size)
	end, TextSize, IconScale)

	local parameters: any = {
		Name = _import(config.Name, script.Name),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0,0),
		Attributes = {
			Text = Text,
			ClassName = _Computed(function() return script.Name end)
		},
		Children = {
			_new("UIListLayout")({
				Name = "Test",
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = _Computed(function(xAlign: Enum.TextXAlignment)
					if xAlign == Enum.TextXAlignment.Center then
						return Enum.HorizontalAlignment.Center
					elseif xAlign == Enum.TextXAlignment.Left then
						return Enum.HorizontalAlignment.Left
					elseif xAlign == Enum.TextXAlignment.Right then
						return Enum.HorizontalAlignment.Right
					end
					error("HorizontalAlignment Error")
				end, TextXAlignment),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = _Computed(function(yAlign)
					if yAlign == Enum.TextYAlignment.Center then
						return Enum.VerticalAlignment.Center
					elseif yAlign == Enum.TextYAlignment.Top then
						return Enum.VerticalAlignment.Top
					elseif yAlign == Enum.TextYAlignment.Bottom then
						return Enum.VerticalAlignment.Bottom
					end
					error("VerticalAlignment Error")
				end, TextYAlignment),
				Attributes = {},
				Padding = Padding,
				Children = {},
			}),
			_new("TextLabel")({
				RichText = true,
				TextColor3 = TextColor3,
				TextSize = TextSize,
				Visible = _Computed(function(txt)
					if not txt or string.len(txt) == 0 then
						return false
					else
						return true
					end
				end, Text),
				Font = Font,
				LayoutOrder = 2,
				TextTransparency = TextTransparency,
				Text = _Computed(function(txt)
					return Format(txt)
					-- return txt
				end, Text),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
			}),
			Icon(_Maid){
				Size = IconSize,
				LayoutOrder = 1,
				Visible = _Computed(function(icon)
					return icon ~= nil and icon ~= ""
				end, LeftIcon),
				Name = "LeftIcon",
				Icon = LeftIcon,
				IconColor3 = TextColor3,
				IconTransparency = TextTransparency,
			},
			Icon(_Maid){
				Size = IconSize,
				LayoutOrder = 3,
				Visible = _Computed(function(icon)
					return icon ~= nil and icon ~= ""
				end, RightIcon),
				Name = "RightIcon",
				Icon = RightIcon,
				IconColor3 = TextColor3,
				IconTransparency = TextTransparency,
			},
		} :: {Instance}
	}

	config.Padding = nil
	config.TextSize = nil
	config.TextColor3 = nil
	config.TextTransparency = nil
	config.TextXAlignment = nil
	config.TextYAlignment = nil
	config.Text = nil
	config.Font = nil
	config.IconScale = nil
	config.LeftIcon = nil
	config.RightIcon = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end
	-- print("Parameters", parameters, self)
	local Output = _new("Frame")(parameters)

	Util.cleanUpPrep(_Maid, Output)
	
	return Output
end

return function(maid: Maid?)
	return function(...): TextLabel
		local inst = Constructor(...)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end