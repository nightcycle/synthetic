--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local CurveUtil = require(_Packages:WaitForChild("CurveUtil"))
-- Modules
-- Types
-- Constants
local LUM_LIMIT = 0.03928
local LUM_DENOM = 12.92
local LUM_OFFSET = 0.055
local LUM_OFFSET_DENOM = 1.055
local R_WEIGHT = 0.2126
local G_WEIGHT = 0.7152
local B_WEIGHT = 0.0722
local L_EXP = 2.4
local MIN_HEX_DIFFERENCE = 100 / 255
local DEFAULT_CONTRAST_RATIO = 4.5
local BLACK_COLOR = Color3.new(0, 0, 0)
local WHITE_COLOR = Color3.new(1, 1, 1)
local MAX_ELEVATION = 16
-- Variables
-- References
-- Private Functions

function getContrastRatio(textColor3: Color3, backgroundColor3: Color3): number
	local function getRelativeLuminance(color: Color3): number
		local function solveSpace(v: number): number
			if v < LUM_LIMIT then
				return v / LUM_DENOM
			else
				return ((v + LUM_OFFSET) / LUM_OFFSET_DENOM) ^ L_EXP
			end
		end
		return R_WEIGHT * solveSpace(color.R) + G_WEIGHT * solveSpace(color.G) + B_WEIGHT * solveSpace(color.B)
	end

	local _fH, _fS, fV = textColor3:ToHSV()
	local _bH, _bS, bV = backgroundColor3:ToHSV()

	local fLum = getRelativeLuminance(textColor3)
	local bLum = getRelativeLuminance(backgroundColor3)

	local lighterRelativeLuminance: number
	local darkerRelativeLuminance: number
	if fV < bV then
		lighterRelativeLuminance = bLum
		darkerRelativeLuminance = fLum
	else
		lighterRelativeLuminance = fLum
		darkerRelativeLuminance = bLum
	end

	return (lighterRelativeLuminance + 0.05) / (darkerRelativeLuminance + 0.05)
end

-- Class
local Util = {}

Util.DARK_SURFACE = Color3.new(0.15, 0.15, 0.15)
Util.LIGHT_SURFACE = Color3.new(0.85, 0.85, 0.85)

function Util.getIfReadable(textColor3: Color3, backgroundColor3: Color3, minConstrastRatio: number?): boolean
	minConstrastRatio = minConstrastRatio or DEFAULT_CONTRAST_RATIO
	assert(minConstrastRatio)
	local ratio = getContrastRatio(textColor3, backgroundColor3)
	return ratio >= minConstrastRatio
end

-- https://github.com/alex-page/a11ycolor/blob/main/index.js
function Util.getReadableColor(
	textColor3: Color3,
	backgroundColor3: Color3,
	minConstrastRatio: number?
): Color3
	minConstrastRatio = minConstrastRatio or DEFAULT_CONTRAST_RATIO
	assert(minConstrastRatio)

	-- Check the ratio straight away, if it passes return the value as hex
	if Util.getIfReadable(textColor3, backgroundColor3, minConstrastRatio) then
		return textColor3
	end

	-- Ratio didn't pass so we need to find the nearest color
	local isBlackContrast = Util.getIfReadable(BLACK_COLOR, backgroundColor3, minConstrastRatio)
	local isWhiteContrast = Util.getIfReadable(WHITE_COLOR, backgroundColor3, minConstrastRatio)

	local cH, cS, cV = textColor3:ToHSV()
	local minValue = 0
	local maxValue = 1
	local isDarkColor = false

	-- If black and white both pass on the background
	if isBlackContrast and isWhiteContrast then
		-- Change the min lightness if the color is light
		if cV >= 0.5 then
			minValue = cV
		else -- Change the max lightness if the color is dark
			maxValue = cV
			isDarkColor = true
		end
	elseif isBlackContrast then -- If our colour passes contrast on black
		maxValue = cV
		isDarkColor = true
	else -- Colour doesn't meet contrast pass on black
		minValue = cV
	end

	-- The color to return
	local finalColor: Color3?

	-- Binary search until we find the colour that meets contrast
	local prevColor: Color3?
	while not finalColor do
		local midValue = (minValue + maxValue) / 2
		local midColor = Color3.fromHSV(cH, cS, midValue)

		if Util.getIfReadable(midColor, backgroundColor3, minConstrastRatio) then
			if maxValue - minValue <= MIN_HEX_DIFFERENCE then
				finalColor = midColor
			elseif isDarkColor then
				minValue = midValue
			else
				maxValue = midValue
			end
		elseif isDarkColor then
			maxValue = midValue
		else
			minValue = midValue
		end

		if prevColor == midColor then
			break
		end

		prevColor = midColor
	end

	return finalColor or textColor3
end

function Util.getElevatedColor(color: Color3, elevation: number, isDarkMode: boolean): Color3
	elevation = math.clamp(elevation, 0, MAX_ELEVATION)
	local alpha = 1 - CurveUtil.ease(elevation / MAX_ELEVATION, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	if isDarkMode then
		return CurveUtil.lerp(color, Color3.new(1, 1, 1), alpha * 0.1)
	else
		return CurveUtil.lerp(color, Color3.new(1, 1, 1), alpha * 0.25)
	end
end

return Util
