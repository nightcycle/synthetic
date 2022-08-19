--!strict
local package = script.Parent
local packages = package.Parent

local ColdFusion = require(packages.coldfusion)

type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid

export type ParameterValue<T> = (State<T> | T)

export type InstanceParameters = {
	Archivable: ParameterValue<boolean>?,		
	Name: ParameterValue<string>?,
	Parent: ParameterValue<Instance>?,
}

export type GuiBase2dParameters = InstanceParameters & {	
	AbsolutePosition: ParameterValue<Vector2>?,
	AbsoluteRotiation: ParameterValue<number>?,
	AbsoluteSize: ParameterValue<Vector2>?,
	AutoLocalize: ParameterValue<boolean>?,
	RootLocalizationTable: ParameterValue<LocalizationTable>?,
	SelectionGroup: ParameterValue<boolean>?,
}

export type LayerCollectorParameters = GuiBase2dParameters & {
	Enabled: ParameterValue<boolean>?,
	ResetOnSpawn: ParameterValue<boolean>?,
	ZIndexBehavior: ParameterValue<Enum.ZIndexBehavior>?,
}

export type GuiObjectParameters = GuiBase2dParameters & {
	Active: ParameterValue<boolean>?,
	AnchorPoint: ParameterValue<Vector2>?,
	AutomaticSize: ParameterValue<Enum.AutomaticSize>?,
	BackgroundColor3: ParameterValue<Color3>?,
	BackgroundTransparency: ParameterValue<number>?,
	BorderColor3: ParameterValue<Color3>?,
	BorderMode: ParameterValue<Enum.BorderMode>?,	
	BorderSizePixel: ParameterValue<number>?,
	ClipsDescendants: ParameterValue<boolean>?,	
	LayoutOrder: ParameterValue<number>?,		
	NextSelectionDown: ParameterValue<GuiObject>?,
	NextSelectionLeft: ParameterValue<GuiObject>?,
	NextSelectionRight: ParameterValue<GuiObject>?,
	NextSelectionUp: ParameterValue<GuiObject>?,		
	Position: ParameterValue<UDim2>?,
	Rotation: ParameterValue<number>?,		
	Selectable: ParameterValue<boolean>?,		
	SelectionImageObject: ParameterValue<GuiObject>?,
	SelectionOrder: ParameterValue<number>?,				
	Size: ParameterValue<UDim2>?,			
	SizeConstraint: ParameterValue<Enum.SizeConstraint>?,		
	Visible: ParameterValue<boolean>?,
	ZIndex: ParameterValue<number>?,
}

export type FrameParameters = GuiObjectParameters

export type GuiButtonParameters = GuiObjectParameters & {
	AutoButtonColor: ParameterValue<boolean>?,	
	Modal: ParameterValue<boolean>?,
	Selected: ParameterValue<boolean>?,			
	Style: ParameterValue<Enum.ButtonStyle>?,	
}

type ImageDisplay = {
	Image: ParameterValue<string>?,
	ImageColor3: ParameterValue<Color3>?,
	ImageRectOffset: ParameterValue<Vector2>?,		
	ImageRectSize: ParameterValue<Vector2>?,	
	ImageTransparency: ParameterValue<number>?,	
	IsLoaded: ParameterValue<boolean>?,		
	PressedImage: ParameterValue<string>?,	
	ResampleMode: ParameterValue<Enum.ResamplerMode>?,
	ScaleType: ParameterValue<Enum.ScaleType>?,
	SliceCenter: ParameterValue<Rect>?,
	SliceScale: ParameterValue<number>?,
	TileSize: ParameterValue<UDim2>?,
}

type TextDisplay = {
	Font: ParameterValue<Enum.Font>?,
	FontFace: ParameterValue<Enum.Font>?,		
	LineHeight: ParameterValue<number>?,			
	MaxVisibleGraphemes: ParameterValue<number>?,
	RichText: ParameterValue<boolean>?,
	Text: ParameterValue<string>?,
	TextBounds: ParameterValue<Vector2>?,
	TextColor3: ParameterValue<Color3>?,
	TextFits: ParameterValue<boolean>?,
	TextScaled: ParameterValue<boolean>?,
	TextSize: ParameterValue<number>?,
	TextStrokeColor3: ParameterValue<boolean>?,
	TextStrokeTransparency: ParameterValue<number>?,
	TextTransparency: ParameterValue<number>?,
	TextTruncate: ParameterValue<boolean>?,		
	TextWrapped: ParameterValue<boolean>?,		
	TextXAlignment: ParameterValue<Enum.TextXAlignment>?,
	TextYAlignment: ParameterValue<Enum.TextYAlignment>?,
}

export type TextButtonParameters = GuiButtonParameters & TextDisplay & {			
	ContentText: ParameterValue<string>?,	
}

export type ImageButtonParameters = GuiButtonParameters & ImageDisplay & {
	HoverImage: ParameterValue<string>?,
}

export type ImageLabelParameters = GuiObjectParameters & ImageDisplay
export type TextLabelParameters = GuiObjectParameters & TextDisplay

export type ScrollingFrameParameters = GuiObjectParameters & {
	AbsoluteCanvasSize: ParameterValue<Vector2>?,	
	AbsoluteWindowSize: ParameterValue<Vector2>?,	
	AutomaticCanvasSize: ParameterValue<Enum.AutomaticSize>?,	
	BottomImage: ParameterValue<string>?,	
	CanvasPosition: ParameterValue<Vector2>?,	
	CanvasSize: ParameterValue<UDim2>?,	
	ElasticBehavior: ParameterValue<Enum.ElasticBehavior>?,			
	HorizontalScrollBarInset: ParameterValue<Enum.ScrollBarInset>?,	
	MidImage: ParameterValue<string>?,
	ScrollBarImageColor3: ParameterValue<Color3>?,
	ScrollBarImageTransparency: ParameterValue<number>?,		
	ScrollBarThickness: ParameterValue<number>?,
	ScrollingDirection: ParameterValue<Enum.ScrollingDirection>?,
	ScrollingEnabled: ParameterValue<boolean>?,
	TopImage: ParameterValue<string>?,
	VerticalScrollBarInset: ParameterValue<Enum.ScrollBarInset>?,			
	VerticalScrollBarPosition: ParameterValue<Enum.VerticalScrollBarPosition>?,	
}

export type ViewportFrameParameters = GuiObjectParameters & {
	Ambient: ParameterValue<Color3>?,	
	CurrentCamera: ParameterValue<Camera>?,	
	ImageColor3: ParameterValue<Color3>?,	
	ImageTransparency: ParameterValue<number>?,	
	LightColor: ParameterValue<Color3>?,
	LightDirection: ParameterValue<Vector3>?,
}


export type BillboardGuiParameters = LayerCollectorParameters & {
	Active: ParameterValue<boolean>?,
	Adornee: ParameterValue<Instance>?,
	AlwaysOnTop: ParameterValue<boolean>?,
	Brightness: ParameterValue<number>?,
	ClipsDescendants: ParameterValue<boolean>?,
	CurrentDistance: ParameterValue<number>?,
	DistanceLowerLimit: ParameterValue<number>?,
	DistanceStep: ParameterValue<number>?,
	DistanceUpperLimit: ParameterValue<number>?,
	ExtentsOffset: ParameterValue<Vector3>?,
	ExtentsOffsetWorldSpace: ParameterValue<Vector3>?,
	LightInfluence: ParameterValue<number>?,
	MaxDistance: ParameterValue<number>?,
	PlayerToHideFrom: ParameterValue<Instance>?,
	Size: ParameterValue<UDim2>?,
	SizeOffset: ParameterValue<Vector2>?,
	StudsOffset: ParameterValue<Vector3>?,	
	StudsOffsetWorldSpace: ParameterValue<Vector3>?,
}

export type ScreenGuiParameters = LayerCollectorParameters & {
	DisplayOrder: ParameterValue<number>?,
	IgnoreGuiInset: ParameterValue<boolean>?,
}

export type SurfaceGuiParameters = LayerCollectorParameters & {
	Active: ParameterValue<boolean>?,
	Adornee: ParameterValue<Instance>?,
	AlwaysOnTop: ParameterValue<boolean>?,
	Brightness: ParameterValue<number>?,
	CanvasSize: ParameterValue<Vector2>?,
	ClipsDescendants: ParameterValue<boolean>?,
	Face: ParameterValue<Enum.NormalId>?,
	LightInfluence: ParameterValue<number>?,
	PixelsPerStud: ParameterValue<number>?,
	SizingMode: ParameterValue<Enum.SurfaceGuiSizingMode>?,
	ToolPunchThroughDistance: ParameterValue<number>?,
	ZOffset: ParameterValue<number>?,
}

export type TextBoxParameters = GuiObjectParameters & TextDisplay & {
	ClearTextOnFocus: ParameterValue<boolean>?,		
	CursorPosition: ParameterValue<number>?,		
	MultiLine: ParameterValue<boolean>?,			
	PlaceholderColor3: ParameterValue<Color3>?,		
	PlaceholderText: ParameterValue<string>?,		
	TextEditable: ParameterValue<boolean>?,		
	ShowNativeInput: ParameterValue<boolean>?,
}

return {}