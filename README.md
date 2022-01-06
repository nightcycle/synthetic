## Synthetic
Material UI inspired elements ported to Fusion! You can read all you need to know about Material UI design [here!](https://material.io/design)

The basic idea is to create a library of reusable UI elements that are configurable through changing Roblox attributes on the element, thus allowing easier real-time prototyping and better encapsulation.

### Atoms, Molecules, & Organisms
Synthetic uses Atomic design to organize its components. You can read more about it [here](https://atomicdesign.bradfrost.com/chapter-2/) but the gist is atoms can't use other Synthetic components, molecules can only use atoms, organisms can use molecules + atoms. In general, you won't use Atoms too often - they mostly exist for me to create building blocks for more useful components. A 4th category exists called "Templates" as well, but I'm reserving it for community contributions.

### Component Inheritance
One useful quirk of it mirroring the Fusion constructor model, is that it allows you to inherit functionality from a previously existing component. For example, the Slider component is actually build directly out of the ProgressBar component!

### Easily Add Your Own Components
While it comes with a suite of nearly 20 components already, as you create components in your own projects you can easily create custom components which can then be constructed in the same was as any other one!

### It's a Fusion Wrapper
The final Synthetic library is bundled on-top of Fusion, this means that any call you could make to Fusion can be made to Synthetic in the same manner.

## Enjoy!
If you felt this library helped you out, any contributions to [my patreon](https://www.patreon.com/nightcycle) are appreciated! Thanks!