--!strict
-- Services
-- Packages
-- Modules
local ThemeUtil = require(script:WaitForChild("ThemeUtil"))
local HCT = require(script:WaitForChild("HCT"))

-- Types
type GoogleHCT = HCT.HCT
type GoogleCustomColor = ThemeUtil.CustomColor
type GoogleTheme = ThemeUtil.Theme
type GoogleScheme = ThemeUtil.Scheme
type GoogleTonalPalette = ThemeUtil.TonalPalette
type GoogleColorGroup = ThemeUtil.ColorGroup
export type Scheme = {
	Primary: Color3,
	OnPrimary: Color3,
	PrimaryContainer: Color3,
	OnPrimaryContainer: Color3,
	Secondary: Color3,
	OnSecondary: Color3,
	SecondaryContainer: Color3,
	OnSecondaryContainer: Color3,
	Tertiary: Color3,
	OnTertiary: Color3,
	TertiaryContainer: Color3,
	OnTertiaryContainer: Color3,
	Error: Color3,
	OnError: Color3,
	ErrorContainer: Color3,
	OnErrorContainer: Color3,
	Background: Color3,
	OnBackground: Color3,
	Surface: Color3,
	OnSurface: Color3,
	SurfaceVariant: Color3,
	OnSurfaceVariant: Color3,
	Outline: Color3,
	OutlineVariant: Color3,
	Shadow: Color3,
	Scrim: Color3,
	InverseSurface: Color3,
	InverseOnSurface: Color3,
	InversePrimary: Color3,
}
export type TonalPalette = {
	[number]: Color3
}
export type ColorGroup = {
	Color: Color3,
	OnColor: Color3,
	ColorContainer: Color3,
	OnColorContainer: Color3,
}
export type CustomColorGroup = {
	Name: string,
	Value: number,
	IsBlended: boolean,
	Light: ColorGroup,
	Dark: ColorGroup,
}
export type Theme = {
	Source: Color3,
	Schemes: { 
		Light: Scheme, 
		Dark: Scheme
	},
	Palettes: {
		Primary: TonalPalette,
		Secondary: TonalPalette,
		Tertiary: TonalPalette,
		Neutral: TonalPalette,
		NeutralVariant: TonalPalette,
		Error: TonalPalette,
	},
	CustomColors: {
		[string]: CustomColorGroup
	},
}
-- Constants
-- Variables
-- References
-- Private Functions
function toHCT(color: Color3): GoogleHCT
	local function rgbToXyz(r: number, g: number, b: number): (number, number, number)
		-- Assuming sRGB color space and using a common conversion formula
		r = (r > 0.04045) and ((r + 0.055) / 1.055) ^ 2.4 or r / 12.92
		g = (g > 0.04045) and ((g + 0.055) / 1.055) ^ 2.4 or g / 12.92
		b = (b > 0.04045) and ((b + 0.055) / 1.055) ^ 2.4 or b / 12.92
		
		-- Convert to XYZ using the RGB to XYZ matrix for sRGB
		local x = r * 0.4124564 + g * 0.3575761 + b * 0.1804375
		local y = r * 0.2126729 + g * 0.7151522 + b * 0.0721750
		local z = r * 0.0193339 + g * 0.1191920 + b * 0.9503041
		
		return x, y, z
	end

	local function xyzToLab(x: number, y: number, z: number): (number, number, number)
		-- Observer = 2°, Illuminant = D65
		local refX, refY, refZ = 0.95047, 1.00000, 1.08883
		x = x / refX
		y = y / refY
		z = z / refZ
		
		x = (x > 0.008856) and x ^ (1/3) or (7.787 * x) + (16 / 116)
		y = (y > 0.008856) and y ^ (1/3) or (7.787 * y) + (16 / 116)
		z = (z > 0.008856) and z ^ (1/3) or (7.787 * z) + (16 / 116)
		
		local l = (116 * y) - 16
		local a = 500 * (x - y)
		local b = 200 * (y - z)
		
		return l, a, b
	end

	local function labToHct(l: number, a: number, b: number): (number, number, number)
		-- Convert LAB to HCT (Hue, Chroma, Tone)
		local hue = math.deg(math.atan2(b, a))
		if hue < 0 then hue = hue + 360 end
	 
		local chroma = math.sqrt(a^2 + b^2)
		local tone = l  -- In LAB, L* represents lightness which is analogous to tone
	 
		return hue, chroma, tone
	 end
		
	return HCT.from(labToHct(xyzToLab(rgbToXyz(color.R, color.G, color.B))))
end

function toColor3(hct: GoogleHCT): Color3
	local function hctToLab(hue: number, chroma: number, tone: number): (number, number, number)
		-- Convert HCT back to LAB
		local a = chroma * math.cos(math.rad(hue))
		local b = chroma * math.sin(math.rad(hue))
		local l = tone  -- In LAB, L* represents lightness which is analogous to tone
		return l, a, b
	end
	
	local function labToXyz(l: number, a: number, b: number): (number, number, number)
		local y = (l + 16) / 116
		local x = a / 500 + y
		local z = y - b / 200
	
		-- Observer= 2°, Illuminant= D65
		local refX, refY, refZ = 0.95047, 1.00000, 1.08883
		x = (x ^ 3 > 0.008856) and x ^ 3 or (x - 16 / 116) / 7.787
		y = (y ^ 3 > 0.008856) and y ^ 3 or (y - 16 / 116) / 7.787
		z = (z ^ 3 > 0.008856) and z ^ 3 or (z - 16 / 116) / 7.787
	
		x = refX * x
		y = refY * y
		z = refZ * z
	
		return x, y, z
	end
	
	local function xyzToRgb(x: number, y: number, z: number): (number, number, number)
		-- Convert XYZ to RGB
		local r = x * 3.2406 + y * -1.5372 + z * -0.4986
		local g = x * -0.9689 + y * 1.8758 + z * 0.0415
		local b = x * 0.0557 + y * -0.2040 + z * 1.0570
	
		r = (r > 0.0031308) and 1.055 * (r ^ (1 / 2.4)) - 0.055 or 12.92 * r
		g = (g > 0.0031308) and 1.055 * (g ^ (1 / 2.4)) - 0.055 or 12.92 * g
		b = (b > 0.0031308) and 1.055 * (b ^ (1 / 2.4)) - 0.055 or 12.92 * b
	
		-- Clamp the values to the 0-1 range
		r = math.max(0, math.min(1, r))
		g = math.max(0, math.min(1, g))
		b = math.max(0, math.min(1, b))
	
		return r, g, b
	end
	return Color3.new(xyzToRgb(labToXyz(hctToLab(hct:getHue(), hct:getChroma(), hct:getTone()))))
end

-- Class
local Theme = {}

function Theme.new(
	source: Color3, 
	custom: {[string]: Color3}, 
	blend: {[string]: boolean}?
): Theme
	local googleTheme: GoogleTheme
	do
		local customColors: {[number]: GoogleCustomColor} = {}
		for k, color in pairs(custom) do
			table.insert(customColors, ThemeUtil.customColor(
				toHCT(source):toInt(),
				k,
				if blend and blend[k] ~= nil then blend[k] else false
			))
		end

		googleTheme = ThemeUtil.themeFromSourceColor(
			toHCT(source):toInt(),
			customColors
		)

	end

	local lightScheme: Scheme
	local darkScheme: Scheme
	do
		local function fromScheme(scheme: GoogleScheme): Scheme
			return {
				Primary = toColor3(HCT.fromInt(scheme.primary)),
				OnPrimary = toColor3(HCT.fromInt(scheme.onPrimary)),
				PrimaryContainer = toColor3(HCT.fromInt(scheme.primary)),
				OnPrimaryContainer = toColor3(HCT.fromInt(scheme.onPrimaryContainer)),
				Secondary = toColor3(HCT.fromInt(scheme.secondary)),
				OnSecondary = toColor3(HCT.fromInt(scheme.onSecondary)),
				SecondaryContainer = toColor3(HCT.fromInt(scheme.secondaryContainer)),
				OnSecondaryContainer = toColor3(HCT.fromInt(scheme.onSecondaryContainer)),
				Tertiary = toColor3(HCT.fromInt(scheme.tertiary)),
				OnTertiary = toColor3(HCT.fromInt(scheme.onTertiary)),
				TertiaryContainer = toColor3(HCT.fromInt(scheme.tertiaryContainer)),
				OnTertiaryContainer = toColor3(HCT.fromInt(scheme.onTertiaryContainer)),
				Error = toColor3(HCT.fromInt(scheme.error)),
				OnError = toColor3(HCT.fromInt(scheme.onError)),
				ErrorContainer = toColor3(HCT.fromInt(scheme.errorContainer)),
				OnErrorContainer = toColor3(HCT.fromInt(scheme.onErrorContainer)),
				Background = toColor3(HCT.fromInt(scheme.background)),
				OnBackground = toColor3(HCT.fromInt(scheme.onBackground)),
				Surface = toColor3(HCT.fromInt(scheme.surface)),
				OnSurface = toColor3(HCT.fromInt(scheme.onSurface)),
				SurfaceVariant = toColor3(HCT.fromInt(scheme.surfaceVariant)),
				OnSurfaceVariant = toColor3(HCT.fromInt(scheme.onSurfaceVariant)),
				Outline = toColor3(HCT.fromInt(scheme.outline)),
				OutlineVariant = toColor3(HCT.fromInt(scheme.outlineVariant)),
				Shadow = toColor3(HCT.fromInt(scheme.shadow)),
				Scrim = toColor3(HCT.fromInt(scheme.scrim)),
				InverseSurface = toColor3(HCT.fromInt(scheme.inverseSurface)),
				InverseOnSurface = toColor3(HCT.fromInt(scheme.inverseOnSurface)),
				InversePrimary = toColor3(HCT.fromInt(scheme.inversePrimary)),
			}
		end
		lightScheme = fromScheme(googleTheme.schemes.light)
		darkScheme = fromScheme(googleTheme.schemes.dark)
	end

	local primaryPalette: TonalPalette
	local secondaryPalette: TonalPalette
	local tertiaryPalette: TonalPalette
	local neutralPalette: TonalPalette
	local neutralVariantPalette: TonalPalette
	local errorPalette: TonalPalette
	do
		local function fromPalette(tonalPalette: GoogleTonalPalette): TonalPalette
			local out: {[number]: Color3} = {}
			for k, v in pairs(tonalPalette.cache) do
				out[k] = toColor3(HCT.fromInt(v))
			end
			return out
		end
		primaryPalette = fromPalette(googleTheme.palettes.primary)
		secondaryPalette = fromPalette(googleTheme.palettes.secondary)
		tertiaryPalette = fromPalette(googleTheme.palettes.tertiary)
		neutralPalette = fromPalette(googleTheme.palettes.neutral)
		neutralVariantPalette = fromPalette(googleTheme.palettes.neutralVariant)
		errorPalette = fromPalette(googleTheme.palettes.error)
	end

	local customColors: {[string]: CustomColorGroup} = {}
	do
		local function fromColorGroup(group: GoogleColorGroup): ColorGroup
			return {
				Color = toColor3(HCT.fromInt(group.color)),
				OnColor = toColor3(HCT.fromInt(group.onColor)),
				ColorContainer = toColor3(HCT.fromInt(group.colorContainer)),
				OnColorContainer = toColor3(HCT.fromInt(group.onColorContainer)),
			}
		end
		for i, colorGroup in pairs(googleTheme.customColors) do
			customColors[colorGroup.color.name] = {
				Name = colorGroup.color.name,
				Value = colorGroup.value,
				IsBlended = colorGroup.color.blend,
				Light = fromColorGroup(colorGroup.light),
				Dark = fromColorGroup(colorGroup.dark),
			}
		end
	end

	local theme: Theme = {
		Source = source,
		Schemes = { 
			Light = lightScheme, 
			Dark = darkScheme
		},
		Palettes = {
			Primary = primaryPalette,
			Secondary = secondaryPalette,
			Tertiary = tertiaryPalette,
			Neutral = neutralPalette,
			NeutralVariant = neutralVariantPalette,
			Error = errorPalette,
		},
		CustomColors = customColors,
	}

	return theme
end

return Theme