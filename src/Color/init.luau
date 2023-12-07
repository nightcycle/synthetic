--!strict
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/utils/theme_utils.ts#L77
local Blend = require(script:WaitForChild("Blend"))
local CorePalette = require(script:WaitForChild("Palettes"):WaitForChild("Core"))
local TonalPalette = require(script:WaitForChild("Palettes"):WaitForChild("Tonal"))
local Scheme = require(script:WaitForChild("Scheme"))

type Scheme = Scheme.Scheme
type TonalPalette = TonalPalette.TonalPalette
export type CustomColor = {
	value: number,
	name: string,
	blend: boolean,
}

export type ColorGroup = {
	color: number,
	onColor: number,
	colorContainer: number,
	onColorContainer: number,
}

export type CustomColorGroup = {
	color: CustomColor,
	value: number,
	light: ColorGroup,
	dark: ColorGroup,
}

export type Theme = {
	source: number,
	schemes: { light: Scheme, dark: Scheme },
	palettes: {
		primary: TonalPalette,
		secondary: TonalPalette,
		tertiary: TonalPalette,
		neutral: TonalPalette,
		neutralVariant: TonalPalette,
		error: TonalPalette,
	},
	customColors: { CustomColorGroup },
}

local Util = {}

-- Generate a theme from a source color
function Util.themeFromSourceColor(source: number, customColors: { CustomColor }): Theme
	local palette = CorePalette.of(source)
	return {
		source = source,
		schemes = {
			light = Scheme.light(source),
			dark = Scheme.dark(source),
		},
		palettes = {
			primary = palette.a1,
			secondary = palette.a2,
			tertiary = palette.a3,
			neutral = palette.n1,
			neutralVariant = palette.n2,
			error = palette.error,
		},
		customColors = (function(): { CustomColorGroup }
			local out: { CustomColorGroup } = {}
			for i, c in ipairs(customColors) do
				out[i] = Util.customColor(source, c)
			end
			return out
		end)(),
	}
end

-- Generate custom color group from source and target color
function Util.customColor(source: number, color: CustomColor): CustomColorGroup
	local value = color.value
	local from = value
	local to = source
	if color.blend then
		value = Blend.harmonize(from, to)
	end
	local palette = CorePalette.of(value)
	local tones = palette.a1
	return {
		color = color,
		value = value,
		light = {
			color = tones.tone(40),
			onColor = tones.tone(100),
			colorContainer = tones.tone(90),
			onColorContainer = tones.tone(10),
		},
		dark = {
			color = tones.tone(80),
			onColor = tones.tone(20),
			colorContainer = tones.tone(30),
			onColorContainer = tones.tone(90),
		},
	}
end

return Util
