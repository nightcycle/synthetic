--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Enums = require(_Package:WaitForChild("Enums"))
local Theme = require(_Package:WaitForChild("Theme"))
local Typography = require(_Package:WaitForChild("Typography"))
local Types = require(_Package:WaitForChild("Types"))

-- Types
type Fuse = ColdFusion.Fuse
type State<V> = ColdFusion.State<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type Theme = Theme.Theme
type Typography = Typography.Typography
type FontData = Types.FontData
type RenderData = Types.RenderData
type SoundData = Types.SoundData
type ImageData = Types.ImageData
type AppearanceData = Types.AppearanceData
type ShadowData = Types.ShadowData
-- Constants
local FALLBACK_FONT_DATA = Types.newFontData(Font.fromEnum(Enum.Font.Roboto), 14)
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

function Util.newColor(
	fuse: Fuse,
	elevation: CanBeState<number>,
	schemeType: CanBeState<Enums.SchemeType>,
	role: CanBeState<Enums.ColorRoleType>,
	context: CanBeState<Enums.ColorContextType>,
	theme: CanBeState<Theme>
): State<Color3>

	local elevationState = fuse.import(elevation, 1)
	local schemeTypeState = fuse.import(schemeType, Enums.SchemeType.Dark)
	local roleState = fuse.import(role, Enums.ColorRoleType.Primary)
	local contextState = fuse.import(context, Enums.ColorContextType.Default)
	local themeState: State<Theme> = fuse.import(theme, nil :: any)

	return fuse.Computed(function(elev: number, scheme: Enums.SchemeType, r: Enums.ColorRoleType, c: Enums.ColorContextType, th: Theme): Color3
		return th:Get(
			r, 
			c, 
			scheme, 
			elev
		)
	end, elevationState, schemeTypeState, roleState, contextState, themeState)
end

function Util.newFontData(
	fuse: Fuse,
	fontType: CanBeState<Enums.FontType>,
	typography: CanBeState<Typography>
): State<FontData>
	local fontTypeState = fuse.import(fontType, "BodyMedium" :: Enums.FontType)
	local typographyState = fuse.import(typography, nil :: any)

	return fuse.Computed(function(fT: Enums.FontType, t: Typography): FontData
		local fontData = t:Get(fT)
		return fontData
	end, fontTypeState, typographyState)
end

function Util.newFont(
	fuse: Fuse,
	fontData: CanBeState<Enums.FontType>
): State<Font>
	local fontDataState = fuse.import(fontData, FALLBACK_FONT_DATA)

	return fuse.Computed(function(data: FontData): Font
		return data.Font
	end, fontDataState)
end

function Util.newLineHeight(
	fuse: Fuse,
	fontData: CanBeState<Enums.FontType>,
	scale: CanBeState<number>
): State<number>

	local fontDataState = fuse.import(fontData, FALLBACK_FONT_DATA)

	local scaleState = fuse.import(scale, 1)

	return fuse.Computed(function(data: FontData, s: number): number
		return (data.LineHeight / data.Size) * s
	end, fontDataState, scaleState)
end

function Util.newTextSize(
	fuse: Fuse,
	fontData: CanBeState<Enums.FontType>,
	scale: CanBeState<number>
): State<number>

	local fontDataState = fuse.import(fontData, FALLBACK_FONT_DATA)
	local scaleState = fuse.import(scale, 1)

	return fuse.Computed(function(data: FontData, s: number): number
		return data.Size * s
	end, fontDataState, scaleState)
end

function Util.newSoundData(
	fuse: Fuse,
	soundId: CanBeState<string?>,
	volume: CanBeState<number?>
): State<SoundData>

	local soundIdState = fuse.import(soundId, "")
	local volumeState = fuse.import(volume, nil :: number?)

	return fuse.Computed(function(s: string, v: number?): SoundData
		return Types.newSoundData(s, v)
	end, soundIdState, volumeState)
end

function Util.newShadowData(
	fuse: Fuse,
	appearanceData: CanBeState<AppearanceData>,
	offset: CanBeState<Vector2>
): State<ShadowData>

	local appearanceDataState: State<AppearanceData> = fuse.import(appearanceData, nil :: any)
	local offsetState: State<Vector2> = fuse.import(offset, nil :: Vector2?)

	return fuse.Computed(Types.newShadow, appearanceDataState, offsetState)
end

function Util.newRenderData(
	fuse: Fuse,
	scale: CanBeState<number>,
	border: CanBeState<AppearanceData>,
	background: CanBeState<AppearanceData>,
	text: CanBeState<AppearanceData?>,
	font: CanBeState<FontData?>,
	image: CanBeState<ImageData?>,
	sound: CanBeState<SoundData?>,
	shadow: CanBeState<ShadowData?>
): State<RenderData>

	local borderState: State<AppearanceData> = fuse.import(border, nil :: any)
	local backgroundState: State<AppearanceData> = fuse.import(background, nil :: any)
	local textState: State<AppearanceData?> = fuse.import(text, nil :: any)
	local fontState: State<FontData?> = fuse.import(font, nil :: any)
	local imageState: State<ImageData?> = fuse.import(image, nil :: any)
	local soundState: State<SoundData?> = fuse.import(sound, nil :: any)
	local shadowState: State<ShadowData?> = fuse.import(shadow, nil :: any)

	local scaleState = fuse.import(scale, 1)

	return fuse.Computed(Types.newRenderData, scaleState, borderState, backgroundState, textState, fontState, imageState, soundState, shadowState)
end

function Util.getScale(
	fuse: Fuse,
	renderData: CanBeState<RenderData>
): State<number>
	local renderDataState = fuse.import(renderData, nil :: RenderData?)
	return fuse.Computed(function(st: RenderData): number
		return st.Scale
	end, renderDataState)
end

function Util.getBorderAppearanceData(
	fuse: Fuse,
	renderData: CanBeState<RenderData>
): State<AppearanceData>
	local renderDataState = fuse.import(renderData, nil :: RenderData?)
	return fuse.Computed(function(st: RenderData): AppearanceData
		return st.Border
	end, renderDataState)
end

function Util.getBackgroundAppearanceData(
	fuse: Fuse,
	renderData: CanBeState<RenderData>
): State<AppearanceData>
	local renderDataState = fuse.import(renderData, nil :: RenderData?)
	return fuse.Computed(function(st: RenderData): AppearanceData
		return st.Background
	end, renderDataState)
end

function Util.getTextAppearanceData(
	fuse: Fuse,
	renderData: CanBeState<RenderData>
): State<AppearanceData?>
	local renderDataState = fuse.import(renderData, nil :: RenderData?)
	
	return fuse.Computed(function(st: RenderData): AppearanceData?
		return st.Text
	end, renderDataState)
end

function Util.getImageData(
	fuse: Fuse,
	renderData: CanBeState<RenderData>
): State<ImageData?>
	local renderDataState = fuse.import(renderData, nil :: RenderData?)
	
	return fuse.Computed(function(st: RenderData): ImageData?
		return st.Image
	end, renderDataState)
end

function Util.getFontData(
	fuse: Fuse,
	renderData: CanBeState<RenderData>
): State<FontData?>
	local renderDataState = fuse.import(renderData, nil :: RenderData?)
	
	return fuse.Computed(function(st: RenderData): FontData?
		return st.Font
	end, renderDataState)
end

function Util.getSoundData(
	fuse: Fuse,
	renderData: CanBeState<RenderData>
): State<SoundData?>

	local renderDataState = fuse.import(renderData, nil :: RenderData?)
	
	return fuse.Computed(function(st: RenderData): SoundData?
		return st.Sound
	end, renderDataState)
end

function Util.getShadowData(
	fuse: Fuse,
	renderData: CanBeState<RenderData>
): State<ShadowData?>

	local renderDataState = fuse.import(renderData, nil :: RenderData?)
	
	return fuse.Computed(function(st: RenderData): ShadowData?
		return st.Shadow
	end, renderDataState)
end

function Util.assert<T>(fuse: Fuse, state: State<T?>): State<T>
	return fuse.Computed(function(t: T?): T
		assert(t ~= nil)
		return t
	end, state)
end

function Util.isNil<T>(fuse: Fuse, state: State<T?>): State<boolean>
	return fuse.Computed(function(t: T?): boolean
		return t == nil
	end, state)
end

function Util.inverse(fuse: Fuse, state: State<boolean>): State<boolean>
	return fuse.Computed(function(v: boolean): boolean
		return not v
	end, state)
end

return Util