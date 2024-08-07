--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Maid = require(_Packages:WaitForChild("Maid"))
-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Container = require(_Package:WaitForChild("Util"):WaitForChild("Container"):WaitForChild("ColdFusion"))
local Typography = require(_Package:WaitForChild("Typography"))

-- Types
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type Style = Style.Style
type ImageData = Types.ImageData
type FontData = Types.FontData
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

function Util.fromStyleSimple(
	text: CanBeState<string>,
	colorRoleType: CanBeState<Enums.ColorRoleType>,
	fontType: CanBeState<Enums.FontType>,
	style: CanBeState<Style>,
	elevation: CanBeState<number?>
): TextLabel
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local elevationState: State<number?> = _import(elevation, nil)
	local textState: State<string> = _import(text, "")
	local styleState: State<Style> = _import(style, nil :: any)
	local fontTypeState: State<Enums.FontType> = _import(fontType, Enums.FontType.LabelMedium)
	local colorRoleTypeState: State<Enums.ColorRoleType> =
		_import(colorRoleType, Enums.ColorRoleType.OnBackground)

	local out = _new("TextLabel")({
		Text = textState,
		RichText = true,
		LayoutOrder = 1,
		Visible = _Computed(function(h: string): boolean
			return h:len() > 0
		end, textState),
		TextColor3 = _Computed(function(s: Style, colorRole: Enums.ColorRoleType, e: number?): Color3
			return s:GetColor(colorRole, e)
		end, styleState, colorRoleTypeState, elevationState),
		TextTransparency = 0,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		TextSize = _Computed(function(s: Style, f: Enums.FontType): number
			return s:GetTextSize(f)
		end, styleState, fontTypeState),
		LineHeight = _Computed(function(s: Style, f: Enums.FontType): number
			return s:GetLineHeight(f)
		end, styleState, fontTypeState),
		FontFace = _Computed(function(s: Style, f: Enums.FontType): Font
			return s:GetFont(f)
		end, styleState, fontTypeState),
		Size = UDim2.fromOffset(0, 0),
	}) :: TextLabel
	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))
	return out
end

function Util.new(
	text: CanBeState<string>,
	textColor3: CanBeState<Color3>,
	textTransparency: CanBeState<number>,
	fontData: CanBeState<FontData>,
	scale: CanBeState<number>,
	leftIcon: CanBeState<ImageData?>,
	rightIcon: CanBeState<ImageData?>,
	paddingDp: CanBeState<number?>,
	ignoreLineHeight: CanBeState<boolean?>,
	textXAlignment: CanBeState<Enum.TextXAlignment?>
): Frame
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local scaleState: State<number> = _import(scale, 1)
	local fontDataState: State<FontData> = _import(fontData, nil :: any)

	local leftIconState = _import(leftIcon, nil :: ImageData?)
	local rightIconState = _import(rightIcon, nil :: ImageData?)

	local textState = _import(text, "")
	local textColor3State = _import(textColor3, Color3.new(1, 1, 1))
	local textTransparencyState = _import(textTransparency, 0)
	local textXAlignmentState = _import(textXAlignment, Enum.TextXAlignment.Left)

	local ignoreLineHeightState = _import(ignoreLineHeight, false)

	local paddingState: State<number> = _import(paddingDp, 0)

	local iconSizeState = _Computed(function(f: FontData, ign: boolean, sc: number): UDim2
		local dp = (if ign then 1 else Typography.getGuiLineHeight(f.LineHeight, f.Size))
			* Typography.getTextSize(f.Size, sc) -- s:GetTextSize(ft)
		return UDim2.fromOffset(dp, dp)
	end, fontDataState, ignoreLineHeightState, scaleState)

	local out = _bind(maid:GiveTask(Container.new()))({
		Name = "TextLabel",
		Children = {
			_new("UIListLayout")({
				Padding = _Computed(function(sc: number, dp: number): UDim
					return UDim.new(0, sc * dp)
				end, scaleState, paddingState),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
			}),
			_new("TextLabel")({
				Text = textState,
				RichText = true,
				LayoutOrder = 1,
				Visible = _Computed(function(h: string): boolean
					return h:len() > 0
				end, textState),
				TextColor3 = textColor3State,
				TextTransparency = textTransparencyState,
				BackgroundTransparency = 1,
				TextXAlignment = _Computed(
					function(i: ImageData?, alignment: Enum.TextXAlignment): Enum.TextXAlignment
						return if i then Enum.TextXAlignment.Center else alignment
					end,
					leftIconState,
					textXAlignmentState
				),
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = _Computed(function(f: FontData, sc: number): number
					return Typography.getTextSize(f.Size, sc)
				end, fontDataState, scaleState),
				LineHeight = _Computed(function(f: FontData, sc: number): number
					return Typography.getGuiLineHeight(f.LineHeight, f.Size)
				end, fontDataState, scaleState),
				FontFace = _Computed(function(f: FontData): Font
					return f.Font
				end, fontDataState),
				Size = _Computed(function(sc: number, f: FontData, ign: boolean): UDim2
					return UDim2.fromOffset(
						0,
						(if ign then 1 else Typography.getGuiLineHeight(f.LineHeight, f.Size))
							* Typography.getTextSize(f.Size, sc)
					)
				end, scaleState, fontDataState, ignoreLineHeightState),
			}),
			_new("ImageLabel")({
				Name = "LeftIcon",
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Visible = _Computed(function(icon: ImageData?): boolean
					return icon ~= nil
				end, leftIconState),
				Image = _Computed(function(icon: ImageData?): string
					return if icon then icon.Image else ""
				end, leftIconState),
				ImageColor3 = _Computed(function(icon: ImageData?, c: Color3): Color3
					return if icon then c else Color3.new(1, 1, 1)
				end, leftIconState, textColor3State),
				ImageRectOffset = _Computed(function(icon: ImageData?): Vector2
					return if icon then icon.ImageRectOffset else Vector2.zero
				end, leftIconState),
				ImageRectSize = _Computed(function(icon: ImageData?): Vector2
					return if icon then icon.ImageRectSize else Vector2.zero
				end, leftIconState),
				ImageTransparency = textTransparencyState,
				Size = iconSizeState,
			}),
			_new("ImageLabel")({
				Name = "RightIcon",
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Visible = _Computed(function(icon: ImageData?): boolean
					return icon ~= nil
				end, rightIconState),
				Image = _Computed(function(icon: ImageData?): string
					return if icon then icon.Image else ""
				end, rightIconState),
				ImageColor3 = _Computed(function(icon: ImageData?, c: Color3): Color3
					return if icon then c else Color3.new(1, 1, 1)
				end, rightIconState, textColor3State),
				ImageRectOffset = _Computed(function(icon: ImageData?): Vector2
					return if icon then icon.ImageRectOffset else Vector2.zero
				end, rightIconState),
				ImageRectSize = _Computed(function(icon: ImageData?): Vector2
					return if icon then icon.ImageRectSize else Vector2.zero
				end, rightIconState),
				ImageTransparency = textTransparencyState,
				Size = iconSizeState,
			}),
		},
	}) :: Frame

	maid:GiveTask(out.Destroying:Connect(function()
		maid:Destroy()
	end))

	return out
end

return Util
