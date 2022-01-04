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

## Long Term Goals
- Improve component visuals
- Create a comprehensive port of the Material Components listed here: https://material.io/components

## Enjoy!
If you felt this library helped you out, any contributions to [my patreon](https://www.patreon.com/nightcycle) are appreciated! Thanks!