# Synthetic
Material UI inspired elements ported to Fusion! You can read all you need to know about Material UI design here: https://material.io/design

The basic idea is to create a library of reusable UI elements that are configurable through changing Roblox attributes on the element, thus allowing easier real-time prototyping and better encapsulation.


# Using Synthetic
## Installation:
Add to your wally.toml file the synthetic release listed here: https://github.com/UpliftGames/wally-index/tree/main/nightcycle

If you don't use wally this is your wake-up call to do so, however for those who don't want to go through the install process I'll be uploading a RBXM file whenever I make an announcement on the DevForum.

## Atoms, Molecules, Organisms, & Templates
Synthetic uses Atomic design to organize its components. You can read more about it [here](https://atomicdesign.bradfrost.com/chapter-2/) but the gist is atoms can't use other Synthetic components, molecules can only use atoms, organisms can use molecules + atoms, and templates can use organisms + molecules + atoms.

## Usage Example
As you may have guessed, in order to use this UI library on the client you need to require it on the client
	<!* client *>
	local Synthetic = require*(Insert_Path_To_Module_Here)*
	local newElement = Synthetic.New*(Insert_Element_Name_Here)(Insert_Configuration_Table_Here)*

Unlike most UI libraries, Synthetic also needs to be required by the server - this is because of the text filtering server dependencies.
	<!* server *>
	local Synthetic = require*(Insert_Path_To_Module_Here)*

## Attributes & BindableEvents/Functions
Attributes are meant to serve as custom public-facing properties, allowing you easy configuration at later points using other scripts. Various modules also include bindable instances which allow for the tracking of events and calling of relevant functions. The dream is that you'll be able to use this similar to any native Roblox instance.

## It's a Fusion Wrapper
The final Synthetic library is bundled on-top of Fusion, this means that any call you could make to Fusion can be made to Synthetic in the same manner.

## Long Term Goals
### Basic Stewardship
- Improve documentation
- Improve component appearance, performance, & stability
- Clean up the code to be a bit more readable, documented, and less hacky whenever possible
- Add more imperative functionality for existing elements.
### New Features
- Allow for the native calling of official [material icons](https://fonts.google.com/icons) by name, as well as allowing for specifying filled / outlined variants.
- Allow for users to publish and easily subscribe / import other user's published components.

## Enjoy!
If you felt this library helped you out, any contributions to [my patreon](https://www.patreon.com/nightcycle) are appreciated! Thanks!