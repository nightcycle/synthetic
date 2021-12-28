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
	local newElement = Synthetic.New*(Insert_Element_Name_Here)(Insert_Configuration_Table_Here)*

Unlike most UI libraries, Synthetic also needs to be required by the server - this is mostly because of the text filtering & attributer server dependencies.
	<!* server *>
	local Synthetic = require*(Insert_Path_To_Module_Here)*

Every attribute is connected to some internal state, with the exception of any with an _ in the front, those are used mostly for internal calculations and passages of state between objects. Eventually I'll probably replace them with a bindable function, but for now they stay.

## Configuration:
Configuration instances set under the game / datamodel. These can't be manually constructed with Synthetic. Upon Synthetic first init though it will be added to the game.

### SyntheticStyleConfiguration:
This is used in the theme component and
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

## Quarks:
Like Roblox UIComponenets, Synthetic Components have no visual of their own, used instead to configure it's parent Element

## Atoms:
Basic building blocks of UI

### Button:
A simple button

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


## Molecules:
More advanced elements created out of atoms

## Organisms:
Organisms are composed of molecules & atoms, and typically have more

## Long Term Goals
- Improve component visuals
- Create a comprehensive port of the Material Components listed here: https://material.io/components

## Enjoy!
If you felt this library helped you out, any contributions to [my patreon](https://www.patreon.com/nightcycle) are appreciated! Thanks!