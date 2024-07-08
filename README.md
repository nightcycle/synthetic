# Synthetic
Synthetic = Fusion created Material

This UI library is powered by a variant of the fusion library, with the goal of creating a Roblox compatible port of the Google Material Design framework / philosophy.

It is compatible with all major UI workflows:
- Vanilla / No Framework
- [Cold-Fusion](https://github.com/nightcycle/cold-fusion)
- [Fusion](https://github.com/dphfox/Fusion)
- [Roact](https://github.com/Roblox/roact/)
- [Blend](https://quenty.github.io/NevermoreEngine/api/Blend)

https://github.com/nightcycle/synthetic/assets/77173389/42044196-0b4a-4e76-9276-88edaf60ef55

# Goals

It has been iterated heavily upon since it began in 2020, with its mission statement evolving over time.

## Components Should Be Decoupled
Stylesheet solutions are inevitable, however until we have one that everyone can agree upon (so likely never), the components in this framework shouldn't require the developer buy into a whole ecosystem. If you just need a switch, or a slider, or whatever - you should be able to just take it.

That being said, stylesheet solutions exist for a reason. In the case of Synthetic the compromise was to have all root constructors (aka `.new(...)`) use only native Roblox parameters with the exception of a few simple mutable datatypes that can be created with a single function call.

From there, quality-of-life functions that have far fewer parameters would all fully embrace the framework's styling solution. If this solution ever evolves / gets swapped out with a standardized solution, the base components shouldn't need much refactoring.

## It Should Support All Major Workflows
In the past whenever I see a great UI library, I often find myself torn on whether to use it due to it not integrating cleanly into my workflow.

I use a fairly niche variant of [Fusion](https://github.com/dphfox/Fusion), called [Cold-Fusion](https://github.com/nightcycle/cold-fusion). It's an opinionated Fusion wrapper meant to make things readable by moving away from the functional elegance of Fusion, and towards an OOP direction with memory leak protections in mind. This is the language I wrote Synthetic in.

I've written interface `definition.json` files, allowing for the easy parsing of how the constructors are configured. From then I use a [python script](scripts/compile/run.py) to generate the appropriate ports for them.

## Components Should Strive to Scale Dynamically
The Roblox UI native behavior is a bit messy, with many components with overlapping control fighting for the scale / position of elements on screen. When possible, I would prefer to not get involved in that battle.

As a result, the components are designed to allow for rescaling of the root instance as desired without skewing / breaking the component. There are limits - you can't just make an element infinitely small and expect it to remain usable.

## Type Safety is Non-Negotiable
I love fusion, but the table based method all the constructors use is a headache. There are of course workaround solutions such as [Fusion Autocomplete](https://github.com/VirtualButFake/fusion_autocomplete), however this feels like a band-aid solution to the underlying problem.

I've gone and used parameter dense functions for constructors, relying on the parameter name hinting to guide me. In my experience, this reduces debugging turnaround and leads to faster implementation.

# Style
A lot of UI coding is assigning colors, fonts, and sizing - Synthetic attempts to fix that with a new immutable datatype: "Style". It's immutable due to its intention to be swapped out within states - a case where changes are much more easily detected when the datatype is immutable.

```luau
-- construct
local style = Synthetic.Style.new(
	1, -- scale applied to all components
	Enum.Font.SourceSans -- Enum.Font or Typography type,
	if isDarkMode then Enums.SchemeType.Dark else Enums.SchemeType.Light, -- used for theme engine solver
	color -- the singular color the entire theme should be built around
)

-- ez usage
local primarySwitch = Synthetic.Components.Switch.ColdFusion.primary(
	style,
	function(isSelected: boolean)
		print("is selected", isSelected)
	end,
	true -- initialSelection
)

-- this is a lot easier to set up than this
-- this constructor can be used without a style state
local newSwitch = Module.ColdFusion.new(
	function(isSelected: boolean?)
		print("is selected", isSelected)
	end,
	true,
	true,
	true,
	true,
	style:GetColor(Enums.ColorRoleType.SurfaceContainerHighest),
	style:GetColor(Enums.ColorRoleType.Outline),
	style:GetColor(Enums.ColorRoleType.Primary),
	style:GetColor(Enums.ColorRoleType.PrimaryContainer),
	style:GetColor(Enums.ColorRoleType.OnPrimaryContainer),
	style:GetColor(Enums.ColorRoleType.Surface),
	style:GetColor(Enums.ColorRoleType.OnSurface),
	1,
	style.SchemeType,
	style:GetFontData(Enums.FontType.LabelLarge),
	style.Scale
)

```

## Theme
It's inspired by the philosophy of the [Material Design style system](https://m3.material.io/styles/color/roles), and powered by their [open source theme engine](https://github.com/material-foundation/material-color-utilities).

## Typography

# Components
## Buttons
- [Badge](https://m3.material.io/components/badges/overview)

### Common
- [Elevated](https://m3.material.io/components/buttons/overview)
- [Filled](https://m3.material.io/components/buttons/overview)
- [Outlined](https://m3.material.io/components/buttons/overview)
- [Text](https://m3.material.io/components/buttons/overview)

### Icons
- [Filled icon](https://m3.material.io/components/icon-buttons/overview)
- [Outlined icon](https://m3.material.io/components/icon-buttons/overview)

### FAB
- [FAB](https://m3.material.io/components/floating-action-button/overview)
- [Extended FAB](https://m3.material.io/components/floating-action-button/overview)

### Chips
- [Assist Chip](https://m3.material.io/components/chips/overview)
- [Filter Chip](https://m3.material.io/components/chips/overview)

## Menu
### Row
- [Segmented](https://m3.material.io/components/segmented-buttons/overview)

### Bar
- [Bottom](https://m3.material.io/components/bottom-app-bar/overview)
- [Top Center](https://m3.material.io/components/top-app-bar/overview)
- [Top Large](https://m3.material.io/components/top-app-bar/overview)
- [Top Medium](https://m3.material.io/components/top-app-bar/overview)
- [Top Small](https://m3.material.io/components/top-app-bar/overview)

## Text Field
- [Filled](https://m3.material.io/components/text-fields/overview)
- [Outlined](https://m3.material.io/components/text-fields/overview)

## Progress Indicator
- [Circular](https://m3.material.io/components/progress-indicators/overview)

## Snackbar
- [Small](https://m3.material.io/components/snackbar/overview)
- [Large](https://m3.material.io/components/snackbar/overview)

## Search
- [Filled](https://m3.material.io/components/search/overview)
- [Text](https://m3.material.io/components/search/overview)

## Misc
- [Dialog](https://m3.material.io/components/dialogs/overview)
- [Checkbox](https://m3.material.io/components/checkbox/overview)
- [Radio Button](https://m3.material.io/components/radio-button/overview)
- [Switch](https://m3.material.io/components/switch/overview)
- [Slider](https://m3.material.io/components/sliders/overview)

# Contributing
If you like this framework, please feel free to contribute!

## Bug Fixes / Optimizations / Refactors
Definitely feel free to make pull requests for bug fixes, for the most part I've got no issue with those so long as they don't change any APIs or expected behaviors.

## New Components
Please make an issue before you start working on anything new. For the most part any [Material Design Components](https://m3.material.io/components) are fair game. Please rely on the specs sections of each component to make sure the port properly translates the majority of functionality.

That being said - I recognize Material Design is tackling a slightly different problem than game development, so some components such as proximity prompts, color pickers, etc just don't exist. In the cases where the component is a clear upgrade, I am more than happy to allow for its addition.

New components can be written in non [Cold Fusion](https://github.com/nightcycle/cold-fusion) frameworks, however if you can stomach it, using Cold Fusion is preferred as we want to avoid adding too many translation layers for performance reasons. If you do a fusion variant language, the public facing parameters should all be a `CanBeState<V>` type.


