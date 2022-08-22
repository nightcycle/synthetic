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

local Button = require(package.Button)

export type ButtonListParameters = Types.FrameParameters & {
	ListPadding: ParameterValue<UDim>?,
	Padding: ParameterValue<UDim>?,
	CornerRadius: ParameterValue<UDim>?,
	IconScale: ParameterValue<number>?,
	SelectedTextColor3: ParameterValue<Color3>?,
	HoverTextColor3: ParameterValue<Color3>?,
	SelectedBackgroundColor3: ParameterValue<Color3>?,
	HoverBackgroundColor3: ParameterValue<Color3>?,
	BorderTransparency: ParameterValue<number>?,
	BackgroundTransparency: ParameterValue<number>?,
	TextTransparency: ParameterValue<number>?,
	TextSize: ParameterValue<number>?,
	TextColor3: ParameterValue<Color3>?,
	Font: ParameterValue<Enum.Font>?,
	TextXAlignment: ParameterValue<Enum.TextXAlignment>?,
	TextYAlignment: ParameterValue<Enum.TextYAlignment>?,
	TextOnly: ParameterValue<boolean>?,
	VerticalAlignment: ParameterValue<Enum.VerticalAlignment>?,
	HorizontalAlignment: ParameterValue<Enum.HorizontalAlignment>?,
	FillDirection: ParameterValue<Enum.FillDirection>?,
}

export type ButtonList = Frame

function Constructor(config: ButtonListParameters): ButtonList
	local _Maid: Maid = Maid.new()
	local _Fuse: Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new

	local Name = _import(config.Name, script.Name)

	local _BuildMaid = Maid.new()
	_Maid:GiveTask(_BuildMaid)

	local Data = _Value({})

	local Size = _import(config.Size, UDim2.fromScale(0,0))
	local AutomaticSize = _import(config.AutomaticSize, Enum.AutomaticSize.XY)

	local ListPadding = _import(config.ListPadding, UDim.new(0,2))
	local Padding = _import(config.Padding, UDim.new(0, 2))
	local CornerRadius = _import(config.CornerRadius, UDim.new(0,4))
	local TextSize = _import(config.TextSize, 14)

	local IconScale = _import(config.IconScale, 1.25)
	local BorderSizePixel = _import(config.BorderSizePixel, 3)
	local TextColor3 = _import(config.TextColor3, Color3.new(0.2,0.2,0.2))
	local Font = _import(config.Font, Enum.Font.GothamBold)
	local SelectedTextColor3 = _import(config.SelectedTextColor3, Color3.new(1,1,1))
	local HoverTextColor3 = _import(config.HoverTextColor3, Color3.new(0.2,0.2,0.2))
	local BackgroundColor3 = _import(config.BackgroundColor3,Color3.fromHSV(0.7,0,1))
	local BorderColor3 = _import(config.BorderColor3,Color3.fromHSV(0.7,0,0.3))
	local SelectedBackgroundColor3 = _import(config.SelectedBackgroundColor3,Color3.fromHSV(0.7,0.7,1))
	local HoverBackgroundColor3 = if config.HoverBackgroundColor3 then _import(config.HoverBackgroundColor3, Color3.new(1,1,1)) else _Computed(function(sCol: Color3, bCol: Color3)
		local h1,s1,v1 = sCol:ToHSV()
		local _,s2,v2 = bCol:ToHSV()
		return Color3.fromHSV(h1, s1 + (s2-s1)*0.5, v1 + (v2-v1)*0.5)
	end, SelectedBackgroundColor3, BackgroundColor3)
	local BackTrans: any = _import(config.BackgroundTransparency,0); local BackgroundTransparency: State<number> = BackTrans
	local BordTrans: any = _import(config.BackgroundTransparency,0); local BorderTransparency: State<number> = BordTrans
	local TextTransparency = _import(config.TextTransparency, 0)

	local TextXAlignment: State<Enum.TextXAlignment> = _import(config.TextXAlignment, Enum.TextXAlignment.Center)
	local TextYAlignment = _import(config.TextYAlignment, Enum.TextYAlignment.Center)

	local TextOnly: State<boolean> = _import(config.TextOnly, false)

	local VerticalAlignment = _import(config.VerticalAlignment, Enum.VerticalAlignment.Center)
	local HorizontalAlignment = _import(config.HorizontalAlignment, Enum.HorizontalAlignment.Center)
	local FillDirection = _import(config.FillDirection, Enum.FillDirection.Vertical)
	
	local parameters: any = {
		Name = Name,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0,0),
		Attributes = {
			ClassName = script.Name,
		},
		Children = {
			_Fuse.new "UIListLayout" {
				FillDirection = FillDirection,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = HorizontalAlignment,
				VerticalAlignment = VerticalAlignment,
				Padding = ListPadding,
			},
		}
	}

	config.BorderTransparency = nil
	config.ListPadding = nil
	config.Padding = nil
	config.CornerRadius = nil
	config.IconScale = nil
	config.SelectedTextColor3 = nil
	config.HoverTextColor3 = nil
	config.SelectedBackgroundColor3 = nil
	config.HoverBackgroundColor3 = nil
	config.TextTransparency = nil
	config.TextSize = nil
	config.TextColor3 = nil
	config.Font = nil
	config.TextXAlignment = nil
	config.TextYAlignment = nil
	config.TextOnly = nil
	config.VerticalAlignment = nil
	config.HorizontalAlignment = nil
	config.FillDirection = nil


	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end
	-- print("Parameters", parameters, self)
	local Output: any = _Fuse.new("Frame")(parameters)

	_Computed(function(data)
		_BuildMaid:DoCleaning()
		for k, buttonData in pairs(data) do
			local button = Button(_Maid)({
				Parent = Output,
				Size = Size,
				AutomaticSize = AutomaticSize,
				
				CornerRadius = CornerRadius,
				Padding = Padding,
				IconScale = IconScale,
				BorderSizePixel = BorderSizePixel,
				TextColor3 = TextColor3,
				TextSize = TextSize,
				Font = Font,
				SelectedTextColor3 = SelectedTextColor3,
				HoverTextColor3 = HoverTextColor3,
				BackgroundColor3 = BackgroundColor3,
				BorderColor3 = BorderColor3,
				SelectedBackgroundColor3 = SelectedBackgroundColor3,
				HoverBackgroundColor3 = HoverBackgroundColor3,
				BackgroundTransparency = BackgroundTransparency,
				BorderTransparency = BorderTransparency,
				TextTransparency = TextTransparency,
			
				TextXAlignment = TextXAlignment,
				TextYAlignment = TextYAlignment,
			
				Text = buttonData.Text,
				LeftIcon = buttonData.LeftIcon,
				RightIcon = buttonData.RightIcon,
				LayoutOrder = buttonData.LayoutOrder,
				TextOnly = TextOnly,
			})

			if buttonData.BindableEvent then
				local buttonActivated: Instance? = button:WaitForChild("Activated")
				assert(buttonActivated ~= nil and buttonActivated:IsA("BindableEvent"))
				_BuildMaid:GiveTask(buttonActivated.Event:Connect(function()
					buttonData.BindableEvent:Fire()
				end))
			end
			_BuildMaid:GiveTask(button)
		end
		return nil
	end, Data)

	Util.bindFunction(Output, _Maid, "InsertButton", function(txt: string, layoutOrder:number?,  bindableEvent: BindableEvent?, leftIcon: string?, rightIcon: string?)
		
		Data:Update(function(cur)
			cur[txt] = {
				Text = txt,
				LayoutOrder = layoutOrder,
				LeftIcon = leftIcon,
				RightIcon = rightIcon,
				BindableEvent = bindableEvent
			}
			return cur
		end)

	end)

	return Output
end

return function(maid: Maid?)
	return function(params: ButtonListParameters): ButtonList
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end