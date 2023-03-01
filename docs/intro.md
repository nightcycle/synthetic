---
sidebar_position: 1
---

## Installation
Add to your wally.toml file the synthetic release listed here: https://github.com/UpliftGames/wally-index/tree/main/nightcycle

If you don't use wally this is your wake-up call to do so, however for those who don't want to go through the install process I'll be uploading a RBXM file whenever I make an announcement on the DevForum.


## Components

### Using within Studio
As you may have guessed, in order to use this UI library on the client you need to require it on the client. Unlike most UI libraries, Synthetic also needs to be required by the server - this is because of the text filtering server dependencies. I might eventually update the relevant dependencies so this is not the case.

### Constructing Components
To construct a Synthetic component you go about it the same was as with Fusion.

	local synthetic = require(modulePath)

	-- Standard style
	local button1 = synthetic.Button {
		Text = "Click me!"
	}

	-- Fusion style
	local button2 = synthetic.New "Button" {
		Text = "Click me!"
	}

## Passing State to Components
Like with Fusion, you can pass state and even Fusion flags through a Synthetic constructor, they'll

	local synthetic = require(modulePath)
	local _Text = fusion.State("Click me!")
	local button = synthetic.New "Button" {
		Text = _Text,
		[fusion.OnChange "Activated"] = function()
			_Text:set("I was clicked") --should change text on button
		end,
	}

### Properties
Attributes are meant to serve as custom public-facing properties, allowing you easy configuration at later points using other scripts. Any non read-only property listed in the API will have an associated internal state that can be read from and written by changing the associated attribute.

	-- construction script
	local synthetic = require(modulePath)
	local _Input = fusion.State(false) -- it will be off upon construction
	local switch = synthetic.New "Switch" {
		Input = _Input,
	}

	-- other script
	local switch = gui:WaitForChild("Switch")
	switch:SetAttribute("Input", true) --should change the _Input state above to match
	local currentSwitch = switch:GetAttribute("Input") --gets the current _Input value, not _Input itself

	-- creating a mirroring State, though it will take a frame to update it and is a bit messy
	local _InputMirror = fusion.State(false)
	local Maid = maidConstructor.new() --if you don't have a Maid library, please get one. I use Quenty's
	Maid:GiveTask(currentSwitch:GetAttributeChangedSignal("Input"):Connect(function(val)
		_InputMirror:set(currentSwitch:GetAttribute("Input"))
	end))


If you wish to keep a variable private, simply remove the attribute after construction but before you parent it.

### Events
Various components also include BindableEvents which you may use as Signal constructors.

	local synthetic = require(modulePath)
	local dialog = synthetic.New "Dialog" {
		Button1Text = "No",
		Button2Text = "Yes",
	}
	dialog.OnSelect:Connect(function(buttonText) --WaitForChild might be safer
		print("This was the button text of the selected button: ", buttonText)
	end)

### Functions
BindableEvents and BindableFunctions are both used to simulate calling a function on a component, with the main difference being if the function returns something it uses a BindableFunction

	local synthetic = require(modulePath)
	local display = synthetic.New "Display" {
		CameraPosition = Vector3.new(0,0,-4),
	}

	--let's put the player character in it
	local playerCharacter = game.Players.LocalPlayer.Character
	or game.Players.LocalPlayer.CharacterAdded:Wait()

	local vfController = display.InsertHumanoid:Invoke(playerCharacter) --RemoteFunction

	--let's hide this for later
	display.HideScene:Fire() --RemoteEvent

I originally considered using just BindableFunctions to keep the API consistent between function calls, but I felt that the comparably slow nature of them (they take at least 2x as long as BindableEvents) would be unnecessarily limiting.

It can be tempting to make a pseudoclass wrapper for these kinds of functions and properties, and make them feel even more like regular native Roblox instances. Before you do that though, I ask that you consider what you may lose. In their current form any script or thread with access to the instance has full access to the functionality with no extra steps. This allows for more modular code, as well as encourages developers to create their components encapsulated. I think that's worth a bit of extra API.

### Typography
Some of you will hate this, and I'm sorry about that. I've constructed a custom Typography class. This class is a FusionState table composed of 3 calculated properties: TextSize, Font, and Padding.

	local synthetic = require(modulePath)
	local font = Enum.Fonts.SourceSans
	local minTextSize = 10
	local maxTextSize = 14
	local _ButtonTypography = synthetic.newTypography(font, minTextSize, maxTextSize)
	local button = synthetic.New "Button" {
		Text = "Test",
		Typography = _Typography,
	}

Based on the dimensions of a person's screen, the Typography will solve for an ideal TextSize that will be used consistently across all instances of that TypographyState. The TextSize is also consistently used in padding.

The benefits of using a set list of Typography across your UI is pretty compelling. For instance you could allow users with poor eyesite to increase the size of their text. The text scaling will also be consistent across UI components if you like. Finally, if you want to try out new fonts, it's very easy to check how it would all look. If Roblox ever supports custom font uploading, this library will certainly update to allow for that.

### Adding Custom Components
If you want to add a custom component to your game, all you need to do is init that constructor when the client starts.

	local synthetic = require(modulePath)

	local key = "myNewComponent"
	function constructor(parameters: table | nil)
		--construct whatever you want and return it
		local inst
		return inst --if you want to add public attributes check out Util.set in API
	end

	synth.set(key, constructor)

	--any other script
	local inst = synth.New "myNewComponent"()

Eventually I might add some functionality to query whether a component exists, for now just run it in a pcall if you're facing a racing condition.

## Useful Tools
Synthetic also has an Effects and a Util library, both of which could save you a bit of code in your own components. They aren't nearly as polished or well documented though, so use with caution. You can explore the exact methods available in their associated API pages.