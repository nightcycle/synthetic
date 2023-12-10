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
	theme: CanBeState<Theme>
): State<Color3>
	local elevationState = fuse.import(elevation, 1)
	local schemeTypeState = fuse.import(schemeType, Enums.SchemeType.Dark)
	local roleState = fuse.import(role, Enums.ColorRoleType.Primary)
	local themeState: State<Theme> = fuse.import(theme, nil :: any)

	return fuse.Computed(function(elev: number, scheme: Enums.SchemeType, r: Enums.ColorRoleType, th: Theme): Color3
		return th:Get(r, scheme, elev)
	end, elevationState, schemeTypeState, roleState, themeState)
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

function Util.newFont(fuse: Fuse, fontData: CanBeState<Enums.FontType>): State<Font>
	local fontDataState = fuse.import(fontData, FALLBACK_FONT_DATA)

	return fuse.Computed(function(data: FontData): Font
		return data.Font
	end, fontDataState)
end

function Util.newAppearanceData(
	fuse: Fuse,
	color3: CanBeState<Color3>,
	transparency: CanBeState<number>?
): State<AppearanceData>
	local colorState = fuse.import(color3, Color3.new(1, 1, 1))
	local transparencyState = fuse.import(transparency, 0)

	return fuse.Computed(Types.newAppearanceData, colorState, transparencyState)
end

function Util.newLineHeight(fuse: Fuse, fontData: CanBeState<Enums.FontType>, scale: CanBeState<number>): State<number>
	local fontDataState = fuse.import(fontData, FALLBACK_FONT_DATA)

	local scaleState = fuse.import(scale, 1)

	return fuse.Computed(function(data: FontData, s: number): number
		return (data.LineHeight / data.Size) * s
	end, fontDataState, scaleState)
end

function Util.newTextSize(fuse: Fuse, fontData: CanBeState<Enums.FontType>, scale: CanBeState<number>): State<number>
	local fontDataState = fuse.import(fontData, FALLBACK_FONT_DATA)
	local scaleState = fuse.import(scale, 1)

	return fuse.Computed(function(data: FontData, s: number): number
		return data.Size * s
	end, fontDataState, scaleState)
end

function Util.newSoundData(fuse: Fuse, soundId: CanBeState<string?>, volume: CanBeState<number?>): State<SoundData>
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

	return fuse.Computed(
		Types.newRenderData,
		scaleState,
		borderState,
		backgroundState,
		textState,
		fontState,
		imageState,
		soundState,
		shadowState
	)
end

function Util.getScale(fuse: Fuse, renderData: CanBeState<RenderData>): State<number>
	local renderDataState = fuse.import(renderData, nil :: RenderData?)
	return fuse.Computed(function(st: RenderData): number
		return st.Scale
	end, renderDataState)
end

return Util
