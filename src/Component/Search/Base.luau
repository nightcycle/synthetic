--!strict
local _Package = script.Parent.Parent.Parent
local _Packages = _Package.Parent

-- Services
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local MaterialIcons = require(_Packages:WaitForChild("MaterialIcons"))

-- Modules
local IconButton = require(_Package:WaitForChild("Component"):WaitForChild("Button"):WaitForChild("IconButton"))

local Util = require(_Package:WaitForChild("Util"))
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))
local Enums = require(_Package:WaitForChild("Enums"))
local Sounds = require(_Package:WaitForChild("Sounds"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type RenderData = Types.RenderData
type ImageData = Types.ImageData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type AppearanceData = Types.AppearanceData
type Style = Style.Style
export type OptionConstructor = (key: string, onClick: (key: string) -> ()) -> GuiObject
-- Constants
local PADDING_DP = 8
local CORNER_DP = 4
local HEIGHT_DP = 40
local ICON_SIZE_DP = 18
local BUTTON_PADDING_DP = 12
local PADDING_BETWEEN_ELEMENTS_DP = 8

-- Variables
-- References
local Icons = MaterialIcons.default.dp_48.scale_1

-- Private Functions


function newPanel(
	isFilled: boolean,
	onClick: (content: string) -> (),
	initialText: string,
	button: GuiObject,
	textColorState: State<Color3>,
	backgroundColorState: State<Color3>,
	optionSolverState: State<(input: string) -> {[number]: string}>,
	optionConstructorState: State<OptionConstructor>,
	elevationState: State<number>,
	styleState: State<Style>
): GuiObject

	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local absolutePositionState = _Value(button.AbsolutePosition+Vector2.new(0, button.AbsoluteSize.Y))

	local elevatedTextColorState = _Computed(function(s: Style, tC: Color3, e: number): Color3
		return s:GetElevatedColor(tC, e)
	end, styleState, textColorState, elevationState)

	local textBox = _new("TextBox")({
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.None,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		TextColor3 = elevatedTextColorState,
		Text = initialText,
		ClipsDescendants = false,
		TextSize = _Computed(function(s: Style): number
			return s:GetTextSize(Enums.FontType.LabelLarge)
		end, styleState),
		LineHeight = _Computed(function(s: Style): number
			return s:GetLineHeight(Enums.FontType.LabelLarge)
		end, styleState),
		FontFace = _Computed(function(s: Style): Font
			return s:GetFont(Enums.FontType.LabelLarge)
		end, styleState),
		Size = _Computed(function(s: Style): UDim2
			return UDim2.new(1, 0, 0, s.Scale * 40)
		end, styleState),
		ClearTextOnFocus = false,
		Children = {
			_new("UIFlexItem")({
				FlexMode = Enum.UIFlexMode.Shrink,
			}),
		}
	}) :: TextBox

	textBox.TextTruncate = Enum.TextTruncate.None

	local currentTextState = _Value(textBox.Text)
	maid:GiveTask(textBox:GetPropertyChangedSignal("Text"):Connect(function()
		currentTextState:Set(textBox.Text)
	end))

	local optionsState = _Computed(function(solver: (input: string) -> {[number]: string}, txt: string): {[number]: string}
		return solver(txt)
	end, optionSolverState, currentTextState)

	maid:GiveTask(textBox.ReturnPressedFromOnScreenKeyboard:Connect(function()
		onClick(textBox.Text)
	end))

	maid:GiveTask(UserInputService.InputBegan:Connect(function(inputObj: InputObject)
		if inputObj.KeyCode == Enum.KeyCode.KeypadEnter or inputObj.KeyCode == Enum.KeyCode.Return then
			onClick(textBox.Text)
		end
	end))

	-- maid:GiveTask(textBox.FocusLost:Connect(function()
	-- 	onClick(textBox.Text)
	-- end))

	local backButton = _bind(IconButton.ColdFusion.new(
		function()
			onClick(textBox.Text)
		end,
		Icons.arrow_back,
		styleState,
		textColorState,
		textColorState,
		true,
		elevationState
	))({
		LayoutOrder = 1,
	}) :: GuiObject

	local clearButton = _bind(IconButton.ColdFusion.new(
		function()
			textBox.Text = ""
			textBox:CaptureFocus()
		end,
		Icons.clear,
		styleState,
		textColorState,
		textColorState,
		true,
		elevationState
	))({
		LayoutOrder = 3,
	}) :: GuiObject

	local scrollingFrame = _bind(maid:GiveTask(Util.ScrollingContainer.ColdFusion.new(
		0,
		textColorState
	)) :: ScrollingFrame)({
		LayoutOrder = 1,
		Size = UDim2.fromScale(1,0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Children = {
			maid:GiveTask(Util.List.ColdFusion.classic(
				Enum.VerticalAlignment.Top,
				Enum.HorizontalAlignment.Left,
				Enum.FillDirection.Vertical,
				UDim.new(0,0)-- _Computed(function(s: Style): UDim
				-- 	return UDim.new(0, s.Scale * PADDING_DP * 0.5)
				-- end, styleState)
			)) :: Instance,
			
		},
	}) :: ScrollingFrame


	local optionRegistry: {[string]: GuiObject} = {}

	local function updateOptions(opts: {[number]: string}, constructor: OptionConstructor)
		local registry: {[string]: true?} = {}
		for i, v in ipairs(opts) do
			registry[v] = true
			if not optionRegistry[v] then
				local gui = constructor(v, function()
					-- print(`on-click={v}`)
					textBox.Text = v
					onClick(v)
				end)
				gui.Parent = scrollingFrame

				maid[`option={v}`] = gui
				optionRegistry[v] = gui
			end
		end
		for k, v in pairs(optionRegistry) do
			if registry[k] == nil then
				v:Destroy()
			end
		end
		-- local rep = scrollingFrame:Clone()
		-- rep.Name = `tick={tick()}`
		-- rep.Parent = workspace

	end

	optionsState:Connect(function(cur: {[number]: string}, prev: {[number]: string}?)
		updateOptions(cur, optionConstructorState:Get())
	end)
	
	optionConstructorState:Connect(function(cur: OptionConstructor, prev: OptionConstructor?)
		updateOptions(optionsState:Get(), cur)
	end)

	local inst = _bind(Util.PopUp.ColdFusion.new(
		absolutePositionState,
		Vector2.zero
	))({
		BackgroundColor3 = _Computed(function(s: Style, bC: Color3, e: number): Color3
			return s:GetElevatedColor(bC, e)
		end, styleState, backgroundColorState, elevationState),
		BackgroundTransparency = if isFilled then 0 else 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Children = {
			_new("UICorner")({
				CornerRadius = _Computed(function(s: Style): UDim
					return UDim.new(0, s.Scale * CORNER_DP)
				end, styleState),
			}),
			_new("Frame")({
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.None,
				Size = _Computed(function(s: Style)
					return UDim2.new(1, 0, 0, s.Scale * 40)
				end, styleState),
				Children = {
					textBox :: Instance,
					maid:GiveTask(Util.Padding.ColdFusion.new(
						_Computed(function(s: Style): UDim
							return UDim.new(0, s.Scale * PADDING_DP)
						end, styleState),
						UDim.new()
					)),
					maid:GiveTask(Util.List.ColdFusion.new(
						Enum.VerticalAlignment.Center,
						Enum.HorizontalAlignment.Left,
						Enum.FillDirection.Horizontal,
						_Computed(function(s: Style): UDim
							return UDim.new(0, s.Scale * PADDING_DP)
						end, styleState),
						Enum.UIFlexAlignment.None,
						Enum.UIFlexAlignment.SpaceBetween,
						Enum.ItemLineAlignment.Center,
						false
					)),
					_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
						LayoutOrder = 1,
						Children = {
							_new("UIScale")({
								Scale = 0.6,
							}) :: Instance,
							maid:GiveTask(Util.List.ColdFusion.center()),
							backButton
						},
					}),
					-- backButton,
					_bind(maid:GiveTask(Util.Container.ColdFusion.new()))({
						LayoutOrder = 2,
						Children = {
							_new("UIScale")({
								Scale = 0.6,
							}) :: Instance,
							maid:GiveTask(Util.List.ColdFusion.center()),
							clearButton
						},
					}),
				},
			}),
			maid:GiveTask(Util.List.ColdFusion.classic(
				Enum.VerticalAlignment.Top,
				Enum.HorizontalAlignment.Left,
				Enum.FillDirection.Vertical,
				UDim.new(0, 0)
			)),
			scrollingFrame,
		},
	}) :: GuiObject

	maid:GiveTask(RunService.RenderStepped:Connect(function(deltaTime: number)

		local pos = button.AbsolutePosition--+Vector2.new(0, button.AbsoluteSize.Y)
		
		inst.Size = UDim2.fromOffset(
			button.AbsoluteSize.X, 
			button.AbsoluteSize.Y+1
		)
		absolutePositionState:Set(pos)

	end))

	textBox:CaptureFocus()

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))


	return inst
end

-- Class
local Base = {}

function Base.newBar(
	isFilled: boolean,
	onInputEntered: CanBeState<(input: string) -> string>,
	label: CanBeState<string?>,
	optionSolver: CanBeState<(input: string) -> {[number]: string}>,
	optionConstructor: CanBeState<OptionConstructor?>,
	textColor: CanBeState<Color3>,
	backgroundColor: CanBeState<Color3>,
	elevation: CanBeState<number>,
	style: CanBeState<Style>
): GuiObject
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local styleState: State<Style> = _import(style, nil :: any)
	local onInputEnteredState: State<(input: string) -> string> = _import(
		onInputEntered, 
		function(input: string): string 
			return input 
		end
	)
	local textColorState: State<Color3> = _import(textColor, Color3.new())
	local elevationState = _import(elevation, 0)

	local nextElevationState = _Computed(function(e: number): number
		return e + 1
	end, elevationState)
	local backgroundColorState: State<Color3> = _import(backgroundColor, Color3.new())


	local function newLabel(
		key: string,
		onClick: (key: string) -> ()
	): GuiObject

		local labelMaid = Maid.new()
		local fuse = ColdFusion.fuse(labelMaid)

		local elevatedTextColorState = fuse.Computed(function(s: Style, tC: Color3, e: number): Color3
			return s:GetElevatedColor(tC, e)
		end, styleState, textColorState, nextElevationState)
		local elevatedBackgroundColorState = fuse.Computed(function(s: Style, tC: Color3, e: number): Color3
			return s:GetElevatedColor(tC, e)
		end, styleState, backgroundColorState, nextElevationState)
		local isHoveredState = fuse.Value(false)

		local out = fuse.new("TextButton")({
			Text = key,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.fromScale(1,0),
			AutoButtonColor = true,
			BackgroundTransparency = if isFilled then 0 else 1,
			BackgroundColor3 = elevatedBackgroundColorState,
			TextColor3 = elevatedTextColorState,
			ClipsDescendants = false,
			TextSize = _Computed(function(s: Style): number
				return s:GetTextSize(Enums.FontType.LabelLarge)
			end, styleState),
			LineHeight = _Computed(function(s: Style): number
				return s:GetLineHeight(Enums.FontType.LabelLarge)
			end, styleState),
			FontFace = _Computed(function(s: Style): Font
				return s:GetFont(Enums.FontType.LabelLarge)
			end, styleState),
			Events = {
				Activated = function()
					onClick(key)
				end,
				MouseEnter = function()
					isHoveredState:Set(true)
				end,
				MouseLeave = function()
					isHoveredState:Set(false)
				end,
				SelectionGained = function()
					isHoveredState:Set(true)
				end,
				SelectionLost = function()
					isHoveredState:Set(false)
				end,
			},
			Children = {
				labelMaid:GiveTask(Util.Padding.ColdFusion.new(
					_Computed(function(s: Style): UDim
						return UDim.new(0, s.Scale * PADDING_DP)
					end, styleState),
					_Computed(function(s: Style): UDim
						return UDim.new(0, s.Scale * PADDING_DP * 0.25)
					end, styleState)
				)),
			}
		}) :: TextButton

		labelMaid:GiveTask(out.Destroying:Connect(function()
			labelMaid:Destroy()
		end))

		return out
	end

	local optionSolverState = _import(optionSolver, function(input: string): {[number]: string}
		return {}
	end)
	local optionConstructorState: State<OptionConstructor> = _import(
		optionConstructor, 
		newLabel
	)
	local labelState: State<string> = _import(label, "Search")
	local inputState = _Value("")
	local buttonTextState = _Computed(function(l: string, i: string): string
		return if i:len() == 0 then l else i
	end, labelState, inputState)

	local button: GuiObject

	local panelMaid = maid:GiveTask(Maid.new())
	local isEnabledState = _Value(true)

	local function onClick()
		panelMaid:DoCleaning()
		local panel = newPanel(
			isFilled,
			function(content: string)
				inputState:Set(content)
				panelMaid:DoCleaning()
				local onEnter = onInputEnteredState:Get()
				if onEnter then
					inputState:Set(onEnter(content))
				end
			end,
			inputState:Get(),
			button,
			textColorState,
			backgroundColorState,
			optionSolverState,
			optionConstructorState,
			nextElevationState,
			styleState
		)
		isEnabledState:Set(false)
		panelMaid:GiveTask(function()
			isEnabledState:Set(true)
		end)
		panelMaid:GiveTask(panel)
	end

	local isFocusedState = _Value(false)
	local isPressedState = _Value(false)
	local isHoveredState = _Value(false)
	local textScaleState = _import(1, 1)
	local currentStateState = _Computed(
		function(isEnab: boolean, isFocused: boolean, isPressed: boolean, isHovered: boolean): Enums.ButtonStateType
			if isEnab then
				if isPressed then
					return Enums.ButtonStateType.Pressed
				else
					if isHovered then
						return Enums.ButtonStateType.Hovered
					else
						if isFocused then
							return Enums.ButtonStateType.Focused
						else
							return Enums.ButtonStateType.Enabled
						end
					end
				end
			else
				return Enums.ButtonStateType.Disabled
			end
		end,
		isEnabledState,
		isFocusedState,
		isPressedState,
		isHoveredState
	) :: State<any>

	local renderDatasState: State<{[Enums.ButtonStateType]: RenderData}>

	if isFilled then
		renderDatasState = _Computed(
			function(
				s: Style,
				e: number,
				tC: Color3,
				sC: Color3,
				dTC: Color3,
				dSC: Color3,
				i: ImageData?
			): { [Enums.ButtonStateType]: RenderData }
				e += 1
				return {
					[Enums.ButtonStateType.Enabled] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 0),
						Types.newAppearanceData(s:GetElevatedColor(tC, e), 0),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Disabled] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(dSC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(dSC, e), 0.12),
						Types.newAppearanceData(s:GetElevatedColor(dTC, e), 0.12),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Hovered] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(sC, e + 1), 0.08),
						Types.newAppearanceData(s:GetElevatedColor(tC, e + 1), 0.08),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Focused] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 0.1),
						Types.newAppearanceData(s:GetElevatedColor(tC, e), 0.1),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Pressed] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(sC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(sC, e - 1), 0.1),
						Types.newAppearanceData(s:GetElevatedColor(tC, e - 1), 0.1),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						Types.newSoundData(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 0),
						nil
					),
				}
			end,
			styleState,
			elevationState,
			textColorState,
			backgroundColorState,
			textColorState,
			backgroundColorState,
			_Value(Icons.search)
		)

	else
		renderDatasState = _Computed(
			function(
				s: Style,
				e: number,
				hC: Color3,
				tC: Color3,
				dC: Color3,
				i: ImageData?
			): { [Enums.ButtonStateType]: RenderData }
				e += 1
				return {
					[Enums.ButtonStateType.Enabled] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(tC, e), 0),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Disabled] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(dC, e), 1),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Hovered] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(hC, e + 1), 1 - 0.08),
						Types.newAppearanceData(s:GetElevatedColor(tC, e + 1), 0),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Focused] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1 - 0.1),
						Types.newAppearanceData(s:GetElevatedColor(tC, e), 0),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						nil,
						nil
					),
					[Enums.ButtonStateType.Pressed] = Types.newRenderData(
						s.Scale,
						Types.newAppearanceData(s:GetElevatedColor(hC, e), 1),
						Types.newAppearanceData(s:GetElevatedColor(hC, e - 1), 1 - 0.1),
						Types.newAppearanceData(s:GetElevatedColor(tC, e - 1), 0),
						s:GetFontData(Enums.FontType.LabelLarge),
						i,
						Types.newSoundData(Sounds.Library[Enums.SoundType.ui_tap_variant_01], 1),
						nil
					),
				}
			end,
			styleState,
			elevationState,
			backgroundColorState,
			textColorState,
			textColorState,
			_Value(Icons.search)
		)
	end

	local currentRenderDataState = _Computed(
		function(state: Enums.ButtonStateType, r: { [Enums.ButtonStateType]: RenderData }): RenderData
			local renderData = r[state]
			assert(renderData ~= nil, `no renderData for {state}`)
			return renderData
		end,
		currentStateState,
		renderDatasState
	)
	local currentTextRenderData: State<AppearanceData> = _Computed(function(rData: RenderData): AppearanceData
		local tData = rData.Text
		assert(tData, `bad text data`)
		return tData
	end, currentRenderDataState)
	local sound = _new("Sound")({
		SoundId = _Computed(function(st: RenderData): string
			return if st.Sound then st.Sound.SoundId else ""
		end, currentRenderDataState),
		Volume = _Computed(function(st: RenderData): number
			return if st.Sound then st.Sound.Volume else 0
		end, currentRenderDataState),
	}) :: Sound
	local fontState = _Computed(function(st: RenderData): Font
		return if st.Font then st.Font.Font else Font.fromEnum(Enum.Font.Roboto)
	end, currentRenderDataState)
	local scaleState = _Computed(function(st: RenderData): number
		return st.Scale
	end, currentRenderDataState)

	currentRenderDataState:Connect(function()
		task.wait()
		SoundService:PlayLocalSound(sound)
	end)

	button = _new("TextButton")({
		Name = "TextButton",
		Text = "",
		BackgroundTransparency = _Computed(function(renderData: RenderData): number
			if renderData.Shadow then
				return 0
			else
				return renderData.Background.Transparency
			end
		end, currentRenderDataState),
		BackgroundColor3 = _Computed(function(renderData: RenderData): Color3
			return renderData.Background.Color3
		end, currentRenderDataState),
		Active = isEnabledState,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = _Computed(function(s: number, ts: number): UDim2
			return UDim2.fromOffset(0, s * HEIGHT_DP * ts)
		end, scaleState, textScaleState),
		Events = {
			Activated = function()
				if isEnabledState:Get() == false then
					return
				end
				onClick()
			end,
			MouseButton1Down = function(x: number, y: number)
				if isEnabledState:Get() == false then
					return
				end
				isPressedState:Set(true)
			end,
			MouseButton1Up = function(x: number, y: number)
				if isEnabledState:Get() == false then
					return
				end
				isPressedState:Set(false)
			end,
			MouseEnter = function()
				isHoveredState:Set(true)
			end,
			MouseLeave = function()
				isHoveredState:Set(false)
			end,
			SelectionGained = function()
				isFocusedState:Set(true)
			end,
			SelectionLost = function()
				isFocusedState:Set(false)
			end,
		},
		Children = {
			maid:GiveTask(Util.Padding.ColdFusion.fromStyleSimple(
				BUTTON_PADDING_DP,
				styleState
			)) :: Instance,
			_new("UICorner")({
				CornerRadius = UDim.new(0.5, 0),
			}),
			_new("UIListLayout")({
				Padding = _Computed(function(s: number): UDim
					return UDim.new(0, s * PADDING_BETWEEN_ELEMENTS_DP)
				end, scaleState),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				ItemLineAlignment = Enum.ItemLineAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
			}),
			_new("TextLabel")({
				Text = buttonTextState,
				Visible = true,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				FontFace = fontState,
				LayoutOrder = 2,
				TextColor3 = _Computed(function(renderData: AppearanceData): Color3
					return renderData.Color3
				end, currentTextRenderData),
				TextTransparency = _Computed(function(renderData: AppearanceData): number
					return renderData.Transparency
				end, currentTextRenderData),
				Size = _Computed(function(s: number, ts: number): UDim2
					return UDim2.fromOffset(0, s * ICON_SIZE_DP * ts)
				end, scaleState, textScaleState),
			}),
			_new("ImageLabel")({
				Name = "Icon",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				Visible = true,
				Image = Icons.search.Image,
				ImageColor3 = _Computed(function(renderData: AppearanceData): Color3
					return renderData.Color3
				end, currentTextRenderData),
				ImageRectOffset = Icons.search.ImageRectOffset,
				ImageRectSize = Icons.search.ImageRectSize,
				ImageTransparency = _Computed(function(renderData: AppearanceData): number
					return renderData.Transparency
				end, currentTextRenderData),
				SizeConstraint = Enum.SizeConstraint.RelativeYY,
				Size = _Computed(function(s: number): UDim2
					return UDim2.fromOffset(s * ICON_SIZE_DP, s * ICON_SIZE_DP)
				end, scaleState),
			}),
		},
	}) :: TextButton
	
	maid:GiveTask(button.Destroying:Connect(function()
		maid:Destroy()
	end))

	return button
end

return Base
