# synthesis
Material UI inspired elements ported to Fusion! You can read all you need to know about Material UI design here: https://material.io/design

The basic idea is to create a library of reusable UI elements that are configurable through changing Roblox attributes on the element, thus allowing easier real-time prototyping and better encapsulation.

Usage:

	local Synthetic = require(Insert_Path_To_Module_Here)
	local newElement = Synthetic(Insert_Element_Name_Here, Insert_Configuration_Table_Here)

Constructor Configuration: when constructing a new element you can pass a table of optional GuiObject properties. Alongside these global properties, you can also include any element unique attributes as well.

	Parent [Instance]: What you'll parent the element to

	Size [UDim2]: Size of the element

	Position [UDim2]: Position of the element

	LayoutOrder [Number]: Order used in lists

	Rotation [Number]: Rotation in degrees

	SizeConstraint [Enum]: The axes the element will be sized off of

	Visible [Boolean]: Whether the element will render and be interactable

PropertyTypes:

	ColorName [String]: The vertical axis of the graph shown at https://material.io/resources/color

	Shade [Number]: The horizontal axis of the graph shown at https://material.io/resources/color

	Typeface [String]: A typography with an adequate list of usable font variants
		SourceSans: A geometric sans-serif typeface released by Adobe
		Gotham: A geometric sans-serif typeface which is quite readable

	StyleCategory [String]: The stylistic intent of the an element
		Primary: Important areas
		Secondary: Accent elements
		Surface: Bland backdrop used for legibility
		Error: Critically important information, such as errors, alerts, and exit buttons

	TextClass [String]: Manner in which the SynthFont is applied
		Headline: Largest
		Subtitle: Second largest used to provide extra title info
		Button: Bold but small
		Body: Most legible and meant for longer paragraphs
		Caption: Smallest font meant for contextual info

	MediaType [String]: Type of visual is being displayed
		Text: Letters and emojis
		Image: An uploaded texture
		Icon: A specific section of an uploaded spritesheet texture
		Viewport: A mini-datamodel used to display 3D objects

Configuration: configuration instances set under the game / datamodel

	SyntheticStyleConfiguration: Used in Style Component
		Primary_Color[ColorName]: The color used on important areas
		Primary_Shade[Shade]: The shade used on important areas
		Secondary_Color[ColorName]: The color used in accenting elements
		Secondary_Shade[Shade]: The shade used in accenting elements
		Surface_Color[ColorName]: The color used to create a bland backdrop for legibility
		Surface_Shade[Shade]: The shade used to create a bland backdrop for legibility
		Background_Color[ColorName]: The color used as the base layer of a UI component to provide a sense of depth
		Background_Shade[Shade]: The shade used as the base layer of a UI component to provide a sense of depth
		Error_Color[ColorName]: The color used to draw attention to something, such as an error, an alert, or exit button
		Error_Shade[Shade]: The shade used to draw attention to something, such as an error, an alert, or exit button
		Font[Typeface]: The set of fonts used for any text

Elements: a list of elements & their various attributes available for configuration

	Components: Like Roblox UIComponenets, Synthetic Components have no visual of their own, used instead to configure it's parent Element

		Corner: A simple port of the Roblox UICorner
			Radius [UDim]: The radius of the UICorner circle

		ListLayout: A simple port of the Roblox UIListLayout configured for vertical centered lists

		Padding: A simple port of Roblox UIPadding with a single padding variable
			Padding [UDim]: How much padding to apply to each side

		Elevation: Applies basic dropshadow using UIStroke using parent "ElevationIncrease" attribute

		Lighting: Makes button brighter as "AbsoluteElvation" increases, works best with Elevation component

		InputEffect: Makes parent GuiObject do a small bounce size increase when hovered over by cursor
			StartSize [UDim2]: The size to return to when not hovered over
			SizeBump [UDim]: How much the size along both dimensions increases when hovered over
			ElevationBump [Number]: Sets the "ElevationIncrease" attribute when hovered over

		Style: Formats parented GuiObject based on SyntheticStyleConfiguration
				Category [StyleCategory]: Used to determine the colors applied to the parent GuiObject
				TextClass [TextClass]: Used to determine text treatment of parent GuiObject

	Atoms: Basic building blocks of UI

		Button: A simple button

		Card: A portable frame used to display information in a panel

		Display: A dynamic element used to display various media
			Media [MediaType]: What type of media is being displayed
			Text [String]: The text being displayed alongside media
			Color [Color3]: The color of the media
			Image [Roblox Content URL String]: The texture used for 2D media
			ImageRectOffset [Vector2]: Position on spritesheet
			ImageRectSize [Vector2]: Cell size on spritesheet
			VFFocusNormal [Vector3]: Offset direction of camera when activated
			VFFocusDistance [Number]: Distance of camera when activated
			VFFocusOrigin [Vector3]: Point camera orbits around and is facing when activated
			VFFocusFOV [Number]: Field of view on camera when activated
			VFRestNormal [Vector3]: Offset direction of camera when not activated
			VFRestDistance [Number]: Distance of camera when not activated
			VFRestOrigin [Vector3]: Point camera orbits around and is facing when not activated
			VFRestFOV [Number]: Field of view on camera when not activated

		ScreenGui: A simple port of the Roblox ScreenGui instance

		TextBox: A way for a player to provide text input
			Input [String]: The text currented inputted

	Molecules: More advanced elements created out of atoms

		Canvas: A background used to mount other elements
			Open [Boolean]: Whether canvas is current visible
			OpenPosition [UDim2]: Position on screen when closed
			ClosePosition [UDim2]: Position on screen when open
			OpenSize [UDim2]: Size when open
			CloseSize [UDim2]: Size when closed
			ExitButtonEnabled [Boolean]: Whether there's an exit button in the upper right corner
			AbsoluteScrollLength [Number]: The size of the scrollable canvas used to display elements

		Slider: A basic slider between two numbers
			MinimumLabel [String]: Left side label
			MaximumLabel [String]: Right side label
			MinimumValue [Number]: Minimum slider value
			MaximumValue [Number]: Maximum slider value
			LineWidth [Number]: Width of slider line
			Value [Number]: Current value on slider

		Switch: A button which toggles from between and on & off state