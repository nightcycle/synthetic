---
sidebar_position: 2
---
You make something cool and want to share? Great! Saves us all time! If you want to save some time, copy the Template.lua folder at the root of this library!

## Guidlines
If you already wrote it and it doesn't match that's fine, I can just add it myself. Ideally though here's how custom components will work

### I Don't Care If the Backend is Messy
I honestly don't care if your code's messy - I'm not exactly an expert programmer so I won't judge you. Now don't get me wrong, if you can make your code readable and elegant go for it. But if you're worried about sending in some cool component you built just because I'll look down on you for it, don't worry about it. Just don't obfuscate it or anything lol.

### Label Your GuiObjects
If you make an element composed of multiple GuiObjects, please give them unique names

### All Public Properties, BindableEvents, and BindableFunctions are PascalCase
That means the first letter of each word is capitalized and there aren't any underscores used.

### Use Util.cornerRadius for non-circular UICorners
If you must deviate from it, at least use it within a Computed FusionState to adjust accordingly.

### Content is where you leave room for miscellaneous GuiObject Additions
If you're making a component meant to hold other GuiObjects that aren't explicitly created by that component, then name the holding frame "Content". An example of this would be like a ScrollingFrame.

### Inputs & Values
User inputs should always be provided with an "Input" State, and the output should be a read-only "Value" state. It's mostly arbitrary, but various components need that kind of separation and I think this naming convention works okay.

### Use Typography for Text, UICorner's, and Padding when possible
Whether you like them or not, Typography currently shapes much of the current UI scaling, so integrating the custom class into your components will allow them to fit in better. Don't use TextScaling for any text elements either.

### I'm Not Super Strict on Use of Material Design
The reality is Material was designed for webpages, not videogames. I understand that we can't always get an exact translation. So long as the UI fits the general vibe we've got going here I'm fine with that.

## Just Fork this File
If you could include any links / gifs of the final UI demo that would certainly be appreciated. Make sure you put your new UI Component under the Template folder. If you think it's a worth addition to a lower level one let me know, but for now I'm just going to assume everyone's making Template level stuff.
