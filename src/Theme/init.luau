--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
-- Modules
local ThemeUtil = require(script:WaitForChild("ThemeUtil"))
local HCT = require(script:WaitForChild("HCT"))
local Enums = require(script.Parent:WaitForChild("Enums"))
local Blend = require(script:WaitForChild("Blend"))

-- Types
type GoogleHCT = HCT.HCT
type GoogleCustomColor = ThemeUtil.CustomColor
type GoogleTheme = ThemeUtil.Theme
type GoogleScheme = ThemeUtil.Scheme
type GoogleTonalPalette = ThemeUtil.TonalPalette
type GoogleColorGroup = ThemeUtil.ColorGroup
export type Scheme = {[Enums.ColorRoleType]: {[Enums.ColorContextType]: Color3}}
export type TonalPalette = (alpha: number, noClamp: boolean?) -> Color3
export type CustomColorGroup = {
	Name: string,
	Value: number,
	IsBlended: boolean,
	Schemes: {
		[Enums.SchemeType]: {[Enums.ColorContextType]: Color3},
	},
}
export type Theme = {
	__index: Theme,
	Source: Color3,
	_Schemes: {[Enums.SchemeType]: Scheme},
	Palettes: {[Enums.PaletteType]: TonalPalette},
	_CustomColors: {
		[string]: CustomColorGroup
	},
	Get: (
		self: Theme,
		role: Enums.ColorContextType | string,
		context: Enums.ColorContextType,
		schemeType: Enums.SchemeType,
		elevation: number
	) -> Color3,
	getElevatedColor: (
		color: Color3, 
		elevation: number, 
		schemeType: Enums.SchemeType
	) -> Color3,
	new: (
		source: Color3, 
		custom: {[string]: Color3}?
	) -> Theme,

}
-- Constants
local ELEVATION_TINTS = {0.05, 0.08, 0.11, 0.12, 0.14}
-- Variables
-- References
-- Private Functions

-- Class
local Theme = {} :: Theme
Theme.__index = Theme

function Theme.new(
	source: Color3, 
	custom: {[string]: Color3}?
): Theme
	
	local googleTheme: GoogleTheme
	do
		local customColors: {[number]: GoogleCustomColor} = {}
		if custom then
			for k, color in pairs(custom) do
				table.insert(customColors, ThemeUtil.customColor(
					HCT.fromColor3(source):toInt(),
					k,
					false
				))
			end
		end

		googleTheme = ThemeUtil.themeFromSourceColor(
			HCT.fromColor3(source):toInt(),
			customColors
		)

	end

	local lightScheme: Scheme
	local darkScheme: Scheme
	do
		local function fromScheme(scheme: GoogleScheme): Scheme
			return {
				Primary = {
					Default = HCT.fromInt(scheme.primary):toColor3(),
					OnPrimary = HCT.fromInt(scheme.onPrimary):toColor3(),
					PrimaryContainer = HCT.fromInt(scheme.primaryContainer):toColor3(),
					OnPrimaryContainer = HCT.fromInt(scheme.onPrimaryContainer):toColor3(),
				},
				Secondary = {
					Default = HCT.fromInt(scheme.secondary):toColor3(),
					OnSecondary = HCT.fromInt(scheme.onSecondary):toColor3(),
					SecondaryContainer = HCT.fromInt(scheme.secondaryContainer):toColor3(),
					OnSecondaryContainer = HCT.fromInt(scheme.onSecondaryContainer):toColor3(),	
				},
				
				Tertiary = {
					Default = HCT.fromInt(scheme.tertiary):toColor3(),
					OnTertiary = HCT.fromInt(scheme.onTertiary):toColor3(),
					TertiaryContainer = HCT.fromInt(scheme.tertiaryContainer):toColor3(),
					OnTertiaryContainer = HCT.fromInt(scheme.onTertiaryContainer):toColor3(),	
				},
				Error = {
					Default = HCT.fromInt(scheme.error):toColor3(),
					OnError = HCT.fromInt(scheme.onError):toColor3(),
					ErrorContainer = HCT.fromInt(scheme.errorContainer):toColor3(),
					OnErrorContainer = HCT.fromInt(scheme.onErrorContainer):toColor3(),	
				},
				Background = {
					Default = HCT.fromInt(scheme.background):toColor3(),
					OnBackground = HCT.fromInt(scheme.onBackground):toColor3(),
				},
				Surface = {
					Default = HCT.fromInt(scheme.surface):toColor3(),
					OnSurface = HCT.fromInt(scheme.onSurface):toColor3(),
					SurfaceVariant = HCT.fromInt(scheme.surfaceVariant):toColor3(),
					OnSurfaceVariant = HCT.fromInt(scheme.onSurfaceVariant):toColor3(),
					InverseSurface = HCT.fromInt(scheme.inverseSurface):toColor3(),
					InverseOnSurface = HCT.fromInt(scheme.inverseOnSurface):toColor3(),
					InversePrimary = HCT.fromInt(scheme.inversePrimary):toColor3(),
					SurfaceDim = HCT.fromInt(scheme.surfaceDim):toColor3(),
					SurfaceBright = HCT.fromInt(scheme.surfaceBright):toColor3(),
					SurfaceContainerLowest = HCT.fromInt(scheme.surfaceContainerLowest):toColor3(),
					SurfaceContainerLow = HCT.fromInt(scheme.surfaceContainerLow):toColor3(),
					SurfaceContainer = HCT.fromInt(scheme.surfaceContainer):toColor3(),
					SurfaceContainerHigh = HCT.fromInt(scheme.surfaceContainerHigh):toColor3(),
					SurfaceContainerHighest = HCT.fromInt(scheme.surfaceContainerHighest):toColor3(),
					SurfaceTint = HCT.fromInt(scheme.surfaceTint):toColor3(),
				},
				Outline = {
					Default = HCT.fromInt(scheme.outline):toColor3(),
					OutlineVariant = HCT.fromInt(scheme.outlineVariant):toColor3(),
				},
				Shadow = {
					Default = HCT.fromInt(scheme.shadow):toColor3(),
				},
				Scrim = {
					Default = HCT.fromInt(scheme.scrim):toColor3(),
				},
			} :: Scheme
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
			-- local out: {[number]: ColorSequenceKeypoint} = {}
			-- for i=50, 900, 50 do
			-- 	table.insert(
			-- 		out,
			-- 		ColorSequenceKeypoint.new(
			-- 			(i-50)/(900-50),
			-- 			toColor3(HCT.fromInt())
			-- 		)
			-- 	)
			-- end

			return function(alpha: number, noClamp: boolean?): Color3

				return HCT.fromInt(tonalPalette:getTone(if noClamp then alpha*100 else math.clamp(alpha, 0.05, 0.9)*100)):toColor3()
			end
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
		local function fromColorGroup(group: GoogleColorGroup): {[Enums.ColorContextType]: Color3}
			return {
				[Enums.ColorContextType.Default] = HCT.fromInt(group.color):toColor3(),
				[Enums.ColorContextType.On] = HCT.fromInt(group.onColor):toColor3(),
				[Enums.ColorContextType.Container] = HCT.fromInt(group.colorContainer):toColor3(),
				[Enums.ColorContextType.OnContainer] = HCT.fromInt(group.onColorContainer):toColor3(),
			}
		end
		for i, colorGroup in pairs(googleTheme.customColors) do
			customColors[colorGroup.color.name] = {
				Name = colorGroup.color.name,
				Value = colorGroup.value,
				IsBlended = colorGroup.color.blend,
				Schemes = {
					Light = fromColorGroup(colorGroup.light),
					Dark = fromColorGroup(colorGroup.dark),
				},
			}
		end
	end

	local theme: Theme = setmetatable({
		Source = source,
		_Schemes = { 
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
	}, Theme) :: any

	return theme
end

function Theme.getElevatedColor(
	color: Color3, 
	elevation: number, 
	schemeType: Enums.SchemeType
): Color3
	local hct = HCT.fromColor3(color)
	local tone = hct:getTone()
	elevation = math.clamp(elevation, 1, #ELEVATION_TINTS)

	if ELEVATION_TINTS[elevation] then
		local newColor = HCT.fromColor3(color)
		newColor:setTone(((1-tone) * ELEVATION_TINTS[elevation]))
		return newColor:toColor3()
	else
		local up = math.ceil(elevation)
		local down = math.floor(elevation)

		local downColor = HCT.fromColor3(color)
		downColor:setTone(((1-tone) * ELEVATION_TINTS[down]))

		local upColor = HCT.fromColor3(color)
		upColor:setTone(((1+tone) * ELEVATION_TINTS[up]))

		return HCT.fromInt(Blend.cam16Ucs(
			downColor:toInt(),
			upColor:toInt(),
			(elevation - down)
		)):toColor3()
	end
end

function Theme:Get(
	role: Enums.ColorRoleType | string,
	context: Enums.ColorContextType,
	schemeType: Enums.SchemeType,
	elevation: number
): Color3

	local scheme: Scheme = self._Schemes[schemeType]

	local color: Color3
	if scheme[role :: Enums.ColorRoleType] then
		local contexts = scheme[role :: Enums.ColorRoleType]
		if contexts[context] then
			color = contexts[context]
		else
			error(`no color with context {context} under {role}`)
		end
	else
		local colorGroup: CustomColorGroup = self._CustomColors[role]
		if colorGroup then
			local subGroup = colorGroup.Schemes[schemeType]
			color = subGroup[context]
			if not color then
				error(`no color with context {context} under custom {role}`)
			end
		else
			error(`no role named {role}`)
		end
	end

	return self.getElevatedColor(color, elevation, schemeType)
end

return Theme