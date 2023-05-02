--!strict
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)

local ColdFusion = require(Packages:WaitForChild("ColdFusion"))

type Fuse = ColdFusion.Fuse
type State<T> = {
	Get: (any) -> T,
}
type ValueState<T> = State<T> & {
	Set: (any, T) -> nil,
}

local Maid = require(Packages:WaitForChild("Maid"))
type Maid = Maid.Maid

export type CanBeState<T> = (State<T> | T)

export type InstanceParameters = any
-- {
-- 	Archivable: CanBeState<boolean>?,
-- 	Name: CanBeState<string>?,
-- 	Parent: CanBeState<Instance>?,
-- 	Children: { Instance }?,
-- }

export type GuiBase2dParameters = any
-- InstanceParameters & {
-- 	AbsolutePosition: CanBeState<Vector2>?,
-- 	AbsoluteRotiation: CanBeState<number>?,
-- 	AbsoluteSize: CanBeState<Vector2>?,
-- 	AutoLocalize: CanBeState<boolean>?,
-- 	RootLocalizationTable: CanBeState<LocalizationTable>?,
-- 	SelectionGroup: CanBeState<boolean>?,
-- }

export type LayerCollectorParameters = any
-- GuiBase2dParameters & {
-- 	Enabled: CanBeState<boolean>?,
-- 	ResetOnSpawn: CanBeState<boolean>?,
-- 	ZIndexBehavior: CanBeState<Enum.ZIndexBehavior>?,
-- }

export type GuiObjectParameters = any
-- GuiBase2dParameters & {
-- 	Active: CanBeState<boolean>?,
-- 	AnchorPoint: CanBeState<Vector2>?,
-- 	AutomaticSize: CanBeState<Enum.AutomaticSize>?,
-- 	BackgroundColor3: CanBeState<Color3>?,
-- 	BackgroundTransparency: CanBeState<number>?,
-- 	BorderColor3: CanBeState<Color3>?,
-- 	BorderMode: CanBeState<Enum.BorderMode>?,
-- 	BorderSizePixel: CanBeState<number>?,
-- 	ClipsDescendants: CanBeState<boolean>?,
-- 	LayoutOrder: CanBeState<number>?,
-- 	NextSelectionDown: CanBeState<GuiObject>?,
-- 	NextSelectionLeft: CanBeState<GuiObject>?,
-- 	NextSelectionRight: CanBeState<GuiObject>?,
-- 	NextSelectionUp: CanBeState<GuiObject>?,
-- 	Position: CanBeState<UDim2>?,
-- 	Rotation: CanBeState<number>?,
-- 	Selectable: CanBeState<boolean>?,
-- 	SelectionImageObject: CanBeState<GuiObject>?,
-- 	SelectionOrder: CanBeState<number>?,
-- 	Size: CanBeState<UDim2>?,
-- 	SizeConstraint: CanBeState<Enum.SizeConstraint>?,
-- 	Visible: CanBeState<boolean>?,
-- 	ZIndex: CanBeState<number>?,
-- }

export type FrameParameters = any 
-- GuiObjectParameters

export type GuiButtonParameters = any
-- GuiObjectParameters & {
-- 	AutoButtonColor: CanBeState<boolean>?,
-- 	Modal: CanBeState<boolean>?,
-- 	Selected: CanBeState<boolean>?,
-- 	Style: CanBeState<Enum.ButtonStyle>?,
-- }

type ImageDisplay = any
-- {
-- 	Image: CanBeState<string>?,
-- 	ImageColor3: CanBeState<Color3>?,
-- 	ImageRectOffset: CanBeState<Vector2>?,
-- 	ImageRectSize: CanBeState<Vector2>?,
-- 	ImageTransparency: CanBeState<number>?,
-- 	IsLoaded: CanBeState<boolean>?,
-- 	PressedImage: CanBeState<string>?,
-- 	ResampleMode: CanBeState<Enum.ResamplerMode>?,
-- 	ScaleType: CanBeState<Enum.ScaleType>?,
-- 	SliceCenter: CanBeState<Rect>?,
-- 	SliceScale: CanBeState<number>?,
-- 	TileSize: CanBeState<UDim2>?,
-- }

type TextDisplay = any
-- {
-- 	Font: CanBeState<Font>?,
-- 	FontFace: CanBeState<Font>?,
-- 	LineHeight: CanBeState<number>?,
-- 	MaxVisibleGraphemes: CanBeState<number>?,
-- 	RichText: CanBeState<boolean>?,
-- 	Text: CanBeState<string>?,
-- 	TextBounds: CanBeState<Vector2>?,
-- 	TextColor3: CanBeState<Color3>?,
-- 	TextFits: CanBeState<boolean>?,
-- 	TextScaled: CanBeState<boolean>?,
-- 	TextSize: CanBeState<number>?,
-- 	TextStrokeColor3: CanBeState<boolean>?,
-- 	TextStrokeTransparency: CanBeState<number>?,
-- 	TextTransparency: CanBeState<number>?,
-- 	TextTruncate: CanBeState<boolean>?,
-- 	TextWrapped: CanBeState<boolean>?,
-- 	TextXAlignment: CanBeState<Enum.TextXAlignment>?,
-- 	TextYAlignment: CanBeState<Enum.TextYAlignment>?,
-- }

export type TextButtonParameters = any
-- GuiButtonParameters & TextDisplay & {
-- 	ContentText: CanBeState<string>?,
-- }

export type ImageButtonParameters = any
-- GuiButtonParameters & ImageDisplay & {
-- 	HoverImage: CanBeState<string>?,
-- }

export type ImageLabelParameters = any
-- GuiObjectParameters & ImageDisplay
export type TextLabelParameters = any
-- GuiObjectParameters & TextDisplay

export type ScrollingFrameParameters = any
-- GuiObjectParameters & {
-- 	AbsoluteCanvasSize: CanBeState<Vector2>?,
-- 	AbsoluteWindowSize: CanBeState<Vector2>?,
-- 	AutomaticCanvasSize: CanBeState<Enum.AutomaticSize>?,
-- 	BottomImage: CanBeState<string>?,
-- 	CanvasPosition: CanBeState<Vector2>?,
-- 	CanvasSize: CanBeState<UDim2>?,
-- 	ElasticBehavior: CanBeState<Enum.ElasticBehavior>?,
-- 	HorizontalScrollBarInset: CanBeState<Enum.ScrollBarInset>?,
-- 	MidImage: CanBeState<string>?,
-- 	ScrollBarImageColor3: CanBeState<Color3>?,
-- 	ScrollBarImageTransparency: CanBeState<number>?,
-- 	ScrollBarThickness: CanBeState<number>?,
-- 	ScrollingDirection: CanBeState<Enum.ScrollingDirection>?,
-- 	ScrollingEnabled: CanBeState<boolean>?,
-- 	TopImage: CanBeState<string>?,
-- 	VerticalScrollBarInset: CanBeState<Enum.ScrollBarInset>?,
-- 	VerticalScrollBarPosition: CanBeState<Enum.VerticalScrollBarPosition>?,
-- }

export type ViewportFrameParameters = any
-- GuiObjectParameters & {
-- 	Ambient: CanBeState<Color3>?,
-- 	CurrentCamera: CanBeState<Camera>?,
-- 	ImageColor3: CanBeState<Color3>?,
-- 	ImageTransparency: CanBeState<number>?,
-- 	LightColor: CanBeState<Color3>?,
-- 	LightDirection: CanBeState<Vector3>?,
-- }

export type BillboardGuiParameters = any
-- LayerCollectorParameters & {
-- 	Active: CanBeState<boolean>?,
-- 	Adornee: CanBeState<Instance>?,
-- 	AlwaysOnTop: CanBeState<boolean>?,
-- 	Brightness: CanBeState<number>?,
-- 	ClipsDescendants: CanBeState<boolean>?,
-- 	CurrentDistance: CanBeState<number>?,
-- 	DistanceLowerLimit: CanBeState<number>?,
-- 	DistanceStep: CanBeState<number>?,
-- 	DistanceUpperLimit: CanBeState<number>?,
-- 	ExtentsOffset: CanBeState<Vector3>?,
-- 	ExtentsOffsetWorldSpace: CanBeState<Vector3>?,
-- 	LightInfluence: CanBeState<number>?,
-- 	MaxDistance: CanBeState<number>?,
-- 	PlayerToHideFrom: CanBeState<Instance>?,
-- 	Size: CanBeState<UDim2>?,
-- 	SizeOffset: CanBeState<Vector2>?,
-- 	StudsOffset: CanBeState<Vector3>?,
-- 	StudsOffsetWorldSpace: CanBeState<Vector3>?,
-- }

export type ScreenGuiParameters = any
-- LayerCollectorParameters & {
-- 	DisplayOrder: CanBeState<number>?,
-- 	IgnoreGuiInset: CanBeState<boolean>?,
-- }

export type SurfaceGuiParameters = any
-- LayerCollectorParameters & {
-- 	Active: CanBeState<boolean>?,
-- 	Adornee: CanBeState<Instance>?,
-- 	AlwaysOnTop: CanBeState<boolean>?,
-- 	Brightness: CanBeState<number>?,
-- 	CanvasSize: CanBeState<Vector2>?,
-- 	ClipsDescendants: CanBeState<boolean>?,
-- 	Face: CanBeState<Enum.NormalId>?,
-- 	LightInfluence: CanBeState<number>?,
-- 	PixelsPerStud: CanBeState<number>?,
-- 	SizingMode: CanBeState<Enum.SurfaceGuiSizingMode>?,
-- 	ToolPunchThroughDistance: CanBeState<number>?,
-- 	ZOffset: CanBeState<number>?,
-- }

export type TextBoxParameters = any
-- GuiObjectParameters & TextDisplay & {
-- 	ClearTextOnFocus: CanBeState<boolean>?,
-- 	CursorPosition: CanBeState<number>?,
-- 	MultiLine: CanBeState<boolean>?,
-- 	PlaceholderColor3: CanBeState<Color3>?,
-- 	PlaceholderText: CanBeState<string>?,
-- 	TextEditable: CanBeState<boolean>?,
-- 	ShowNativeInput: CanBeState<boolean>?,
-- }

return {}
