# Synthetic
Material UI inspired elements ported to Fusion! You can read all you need to know about Material UI design here: https://material.io/design

The basic idea is to create a library of reusable UI elements that are configurable through changing Roblox attributes on the element, thus allowing easier real-time prototyping and better encapsulation.


# Using Synthetic
## Installation
### Wally:
Add to your wally.toml file the synthetic release listed here: https://github.com/UpliftGames/wally-index/tree/main/nightcycle

### Github:
Download the source file here, and download any associated packages directly from their source. Create a "Packages" folder in ReplicatedStorage where you can place all of them.

### Roblox:
Get the free model on Roblox at insert_link_here_before_you_publish_it_moron

## Usage Example
As you may have guessed, in order to use this UI library on the client you need to require it on the client
	<!* client *>
	local Synthetic = require*(Insert_Path_To_Module_Here)*
	local newElement = Synthetic*(Insert_Element_Name_Here, Insert_Configuration_Table_Here)*

Unlike most UI libraries, Synthetic also needs to be required by the server - this is mostly because of the text filtering & attributer server dependencies.
	<!* server *>
	local Synthetic = require*(Insert_Path_To_Module_Here)*

Every attribute is connected to some internal state, with the exception of any with an _ in the front, those are used mostly for internal calculations and passages of state between objects. Eventually I'll probably replace them with a bindable function, but for now they stay.

The Synthetic library constructor also endows each element it creates with self-cleaning functionality, as well as tracks things like relative and absolute elevation - a metric used for various style components.

## Constructor Configuration
When constructing a new element you can pass a table of optional GuiObject properties. Alongside these global properties, you can also include any element unique attributes as well. Non GuiObject elements like components and ScreenGuis may not work.

- Parent *(Instance)*: What you'll parent the element to
- Size *(UDim2)*: Size of the element
- Position *(UDim2)*: Position of the element
- AnchorPoint *(Vector2)*: Point things like position and rotation are set from
- LayoutOrder *(Number)*: Order used in lists
- SizeConstraint *(Enum)*: The axes the element will be sized off of
- Visible *(Boolean)*: Whether the element will render and be interactable

## PropertyTypes:
Synthetic uses various non native data formats, below is a comprehensive list.

### ColorName *(String)*:
The vertical axis of the graph shown at https://material.io/resources/color

### Shade *(Number)*:
The horizontal axis of the graph shown at https://material.io/resources/color

### Typeface *(String)*:
A typography with an adequate list of usable font variants
- __SourceSans__: A geometric sans-serif typeface released by Adobe
- __Gotham__: A geometric sans-serif typeface which is quite readable

### StyleCategory *(String)*:
The stylistic intent of the an element
- __Primary__: Important areas
- __Secondary__: Accent elements
- __Surface__: Bland backdrop used for legibility
- __Error__: Critically important information, such as errors, alerts, and exit buttons

### TextClass *(String)*:
Manner in which the SynthFont is applied
- __Headline__: Largest
- __Subtitle__: Second largest used to provide extra title info
- __Button__: Bold but small
- __Body__: Most legible and meant for longer paragraphs
- __Caption__: Smallest font meant for contextual info

### MediaType *(String)*:
Type of visual is being displayed
- __Text__: Letters and emojis
- __Image__: An uploaded texture
- __Icon__: A specific section of an uploaded spritesheet texture
- __Viewport__: A mini-datamodel used to display 3D objects

## Configuration:
Configuration instances set under the game / datamodel. These can't be manually constructed with Synthetic. Upon Synthetic first init though it will be added to the game.

### SyntheticStyleConfiguration:
This is used in the style component and
#### Properties:
- __Primary_Color__ *(ColorName)*: The color used on important areas
- __Primary_Shade__ *(Shade)*: The shade used on important areas
- __Secondary_Color__ *(ColorName)*: The color used in accenting elements
- __Secondary_Shade__ *(Shade)*: The shade used in accenting elements
- __Surface_Color__ *(ColorName)*: The color used to create a bland backdrop for legibility
- __Surface_Shade__ *(Shade)*: The shade used to create a bland backdrop for legibility
- __Background_Color__ *(ColorName)*: The color used as the base layer of a UI component to provide a sense of depth
- __Background_Shade__ *(Shade)*: The shade used as the base layer of a UI component to provide a sense of depth
- __Error_Color__ *(ColorName)*: The color used to draw attention to something, such as an error, an alert, or exit button
- __Error_Shade__ *(Shade)*: The shade used to draw attention to something, such as an error, an alert, or exit button
- __Font__ *(Typeface)*: The set of fonts used for any text
#### Functions:
#### Events:

# Element Library

Below is a comprehensive list relating to every element you can construct with Synthetic, if you create something cool and usable let me know and I can add it. I'm not super strict with backend code format, just make sure it uses attributes / bindable functions for the controls and doesn't bring in a bunch of new packages.

## Components:
Like Roblox UIComponenets, Synthetic Components have no visual of their own, used instead to configure it's parent Element

### Corner:
A simple port of the Roblox UICorner
#### Properties:
- __Radius__ *(UDim)*: The radius of the UICorner circle

### ListLayout:
A simple port of the Roblox UIListLayout configured for vertical centered lists

### Padding:
A simple port of Roblox UIPadding with a single padding variable
#### Properties:
- __Padding__ *(UDim)*: How much padding to apply to each side

### Elevation:
Applies basic dropshadow using UIStroke using parent "ElevationIncrease" attribute

### Lighting:
Makes button brighter as "AbsoluteElvation" increases, works best with Elevation component

### InputEffect:
Makes parent GuiObject do a small bounce size increase when hovered over by cursor
#### Properties:
- __StartSize__ *(UDim2)*: The size to return to when not hovered over
- __StartStyleCategory__ *(StyleCategory)*: Default parent StyleCategory if relevant
- __StartElevation__ *(Number)*: Default elevation bump
- __InputSizeBump__ *(UDim)*: How much the size along both dimensions increases when hovered over
- __InputElevationBump__ *(Number)*: Sets the "ElevationIncrease" attribute when hovered over
- __InputStyleCategory__ *(StyleCategory)*: Overwrites parent StyleCategory if relevant

### Style:
Formats parented GuiObject based on SyntheticStyleConfiguration
#### Properties:
- __StyleCategory__ *(StyleCategory)*: Used to determine the colors applied to the parent GuiObject
- __TextClass__ *(TextClass)*: Used to determine text treatment of parent GuiObject

## Atoms:
Basic building blocks of UI

### Button:
A simple button

### Card:
A portable frame used to display information in a panel

### Display:
A dynamic element used to display various media
#### Properties:
- __Media__ *(MediaType)*: What type of media is being displayed
- __Text__ *(String)*: The text being displayed alongside media
- __Color__ *(Color3)*: The color of the media
- __Image__ *(Roblox Content URL String)*: The texture used for 2D media
- __ImageRectOffset__ *(Vector2)*: Position on spritesheet
- __ImageRectSize__ *(Vector2)*: Cell size on spritesheet
- __VFFocusNormal__ *(Vector3)*: Offset direction of camera when activated
- __VFFocusDistance__ *(Number)*: Distance of camera when activated
- __VFFocusOrigin__ *(Vector3)*: Point camera orbits around and is facing when activated
- __VFFocusFOV__ *(Number)*: Field of view on camera when activated
- __VFRestNormal__ *(Vector3)*: Offset direction of camera when not activated
- __VFRestDistance__ *(Number)*: Distance of camera when not activated
- __VFRestOrigin__ *(Vector3)*: Point camera orbits around and is facing when not activated
- __VFRestFOV__ *(Number)*: Field of view on camera when not activated

### ScreenGui:
A simple port of the Roblox ScreenGui instance

### TextBox:
A way for a player to provide text input
#### Properties:
- __Input__ *(String)*: The text currented inputted

## Molecules:
More advanced elements created out of atoms

### Canvas:
A background used to mount other elements
#### Properties:
- __Open__ *(Boolean)*: Whether canvas is current visible
- __OpenPosition__ *(UDim2)*: Position on screen when closed
- __ClosePosition__ *(UDim2)*: Position on screen when open
- __OpenSize__ *(UDim2)*: Size when open
- __CloseSize__ *(UDim2)*: Size when closed
- __ExitButtonEnabled__ *(Boolean)*: Whether there's an exit button in the upper right corner

### Slider:
A basic slider between two numbers
#### Properties:
- __Precision__ *(Number)*: Separation between notches
- __MinimumValue__ *(Number)*: Minimum slider value
- __MaximumValue__ *(Number)*: Maximum slider value
- __LineWidth__ *(Number)*: Width of slider line
- __LabelWidth__ *(UDim)*: Width of labels at sides of slider
- __Value__ *(Number)*: Current value on slider
#### Events:
- __OnSet__ *(value)*: Fired when slider is released

### Switch:
A button which toggles from between and on & off state
#### Properties:
- __Value__ *(Boolean)*: Is the switch on or off
- __EnabledText__ *(String)*: Text displayed when switch is on
- __DisabledText__ *(String)*: Text displayed when switch is off
#### Events:
- __OnEnabled__: Fired when enabled
- __OnDisabled__: Fired when enabled

### Dropdown:
A dropdown button that allows users multiple options to select from
#### Properties:
- __Value__ *(String)*: The text currently filling the dropdown
#### Functions:
- __SetOptions__ *(String array)*: Adds options
- __SetOption__ *(String)*: Adds option
- __RemoveOption__ *(Index)*: Removes option at index
- __ClearAllOptions__ *()*: Removes all options
#### Events:
- __OnSelected__: Fired when an entry is selected

## Organisms:
Organisms are composed of molecules & atoms, and typically have more
### Prompt:
A prompt that you can trigger to appear for certain decision
#### Properties:
- __Text__ *(String)*: Provides context for prompt
- __ConfirmLabel__ *(String)*: The text in the first button
- __DenyLabel__ *(String)*: The text in the second button
#### Functions:
- __Fire__ *()*: Reveals prompt
#### Events:
- __OnDecision__ *()*: Fired when user selects an option

## Known Issues
- Working with components under other elements can feel cumbersome.
- The various style components are a bit janky.
- Currently you can't use fusion states as parameters for elements.
- Tweening just does not work and I don't know why.

## Long Term Goals
- Improve component visuals
- Find a quicker way to export
- Create a comprehensive port of the Material Components listed here: https://material.io/components

## Enjoy!
If you felt this library helped you out, any contributions to [my patreon](https://www.patreon.com/nightcycle) are appreciated! Thanks!