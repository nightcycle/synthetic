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

### ColorName*(String)*:
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
- __SizeBump__ *(UDim)*: How much the size along both dimensions increases when hovered over
- __ElevationBump__ *(Number)*: Sets the "ElevationIncrease" attribute when hovered over

Style: Formats parented GuiObject based on SyntheticStyleConfiguration
#### Properties:
- __Category__ *(StyleCategory)*: Used to determine the colors applied to the parent GuiObject
_ __TextClass__ *(TextClass)*: Used to determine text treatment of parent GuiObject

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
- __AbsoluteScrollLength__ *(Number)*: The size of the scrollable canvas used to display elements

### Slider:
A basic slider between two numbers
#### Properties:
- __MinimumLabel__ *(String)*: Left side label
- __MaximumLabel__ *(String)*: Right side label
- __MinimumValue__ *(Number)*: Minimum slider value
- __MaximumValue__ *(Number)*: Maximum slider value
- __LineWidth__ *(Number)*: Width of slider line
- __Value__ *(Number)*: Current value on slider

### Switch:
A button which toggles from between and on & off state
#### Properties:
- __Value *(Boolean)*: Is the switch on or off

### Dropdown:
A dropdown button that allows users multiple options to select from
#### Properties:
- __Value__ *(String)*: The text currently filling the dropdown
- __EntryN__ *(String)*: Nth text entry to choose from
#### Functions:
- __SetEntry__ *(String)*: Adds entry
- __DestroyEntry__ *(String)*: Removes entry
- __ClearAllEntries__ *()*: Removes all entries
#### Events:
- __Selected__: Fired when an entry is selected

## Organisms:
Organisms are composed of molecules & atoms, and typically have more
### Prompt:
A prompt that you can trigger to appear for certain decision
#### Properties:
- __Text__ *(String)*: Provides context for prompt
- __Button1__ *(String)*: The text in the first button
- __Button2__ *(String)*: The text in the second button
#### Functions:
- __Fire__ *()*: Reveals prompt
#### Events:
- __OnDecision__ *()*: Fired when user selects an option

### Form:
A series of prompts the user must complete before firing completed signal
#### Properties:
- __AllComplete__ *(Boolean)*: Whether all rows are complete
- __CompleteN__ *(Boolean)*: Whether the Nth row is complete
- __PromptN__ *(String)*: The Nth text prompt used to provide context
- __FormatN__ *(EntryFormat)*: The Nth type of input accepted
- __ValueN__ *(EntryFormat)*: The Nth current value held in input zone
#### Functions:
- __SetRow__ *(prompt, format, value)*: Adds new row to form
- __DestroyRow__ *(Number)*: Removes row at index from form
- __GetRow__ *()*: Returns an array of row info objects
- __ClearAllRows__ *()*: Destroys all rows
#### Events:
- OnComplete: When all forms have been provided an acceptable answer
- OnRowComplete: When a specific entry has its value changed

# Further Development
This library will get expanded as I use it in more of my own projects, though long term I hope to add a bit more front-facing polish

## Long Term Goals
- Port this .md file to an actual wiki with demo gifs, if you want to do this for me please reach out.
- Create a plugin which allows users to manually create the UI in studio
- Create a comprehensive port of the Material Components listed here: https://material.io/components
- Create an SVG import tool using 3D parts, allowing for their display in a viewport frame
- Port Figma UI to Studio

## Reasons I probably won't achieve those long term goals
- They interest me, which means they're probably outta scope
- Frankly I'm capable enough to make most of the UI I need without them
- I have to pay bills, and these free libraries usually don't earn much money
- If you disagree with that last remark, you may prove me wrong at https://www.patreon.com/nightcycle
