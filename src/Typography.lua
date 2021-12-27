local packages = script.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local camera = game.Workspace.CurrentCamera
local viewportSizeY = fusion.State(camera.ViewportSize.Y)
local util = require(script.Parent:WaitForChild("Util"))
local maidConstructor = require(packages:WaitForChild("maid"))
local enums = require(script.Parent:WaitForChild("Enums"))

local viewportSizeChangeSignal = camera:GetPropertyChangedSignal("ViewportSize")
viewportSizeChangeSignal:Connect(function()
	-- print("Size changhes")
	viewportSizeY:set(camera.ViewportSize.Y)
end)

local styleConfigInst = Instance.new("Configuration", game)
styleConfigInst.Name = "SyntheticTypography"
local maid = maidConstructor.new()
maid:GiveTask(styleConfigInst)

local fontConfigs = {
	[enums.SystemFont.Gotham] = {
		[enums.Typography.Headline] = Enum.Font.GothamSemibold,
		[enums.Typography.Subtitle] = Enum.Font.GothamBold,
		[enums.Typography.Body] = Enum.Font.Gotham,
		[enums.Typography.Button] = Enum.Font.GothamBlack,
		[enums.Typography.Caption] = Enum.Font.Gotham,
	},
	[enums.SystemFont.SourceSans] = {
		[enums.Typography.Headline] = Enum.Font.SourceSansSemibold,
		[enums.Typography.Subtitle] = Enum.Font.SourceSansBold,
		[enums.Typography.Body] = Enum.Font.SourceSans,
		[enums.Typography.Button] = Enum.Font.SourceSansBold,
		[enums.Typography.Caption] = Enum.Font.SourceSansLight,
	},
}

local maxVertResolution = 1200
local minVertResolution = 300

local textConfigs = {
	[enums.Typography.Headline]= {
		Maximum = 32,
		Minimum = 22,
	},
	[enums.Typography.Subtitle] = {
		Maximum = 20,
		Minimum = 16,
	},
	[enums.Typography.Button] = {
		Maximum = 16,
		Minimum = 12,
	},
	[enums.Typography.Body] = {
		Maximum = 14,
		Minimum = 10,
	},
	[enums.Typography.Caption] = {
		Maximum = 9,
		Minimum = 6,
	},
}

local SystemFont = fusion.State("Gotham")

util.setPublicState("SystemFont", SystemFont, styleConfigInst, maid)

local TextSizes = fusion.State({})
local Fonts = fusion.State({})
local Paddings = fusion.State({})

local dependents = {}

for textKey, textConfig in pairs(textConfigs) do
	local TextSize = fusion.Computed(function()
		local viewportSizeY = viewportSizeY:get()

		local vertResolution = math.clamp(viewportSizeY, minVertResolution, maxVertResolution)
		local alpha = vertResolution/(maxVertResolution-minVertResolution)

		local min = textConfig.Minimum
		local max = textConfig.Maximum

		local value = math.round(alpha*(max-min) + min)
		local newTable = TextSizes:get()
		newTable[textKey] = value
		-- TextSizes[textKey] = value
		return value
	end)
	local Font = fusion.Computed(function()
		local currentFontGroup = enums.SystemFont[SystemFont:get()]
		local value = fontConfigs[currentFontGroup][textKey]
		local newTable = Fonts:get()
		newTable[textKey] = value
		Fonts:set(newTable)
		-- Fonts[textKey] = value
		return value
	end)
	local Padding = fusion.Computed(function()
		local textSize = TextSizes:get()[textKey]
		local textSize = math.floor(textSize*0.5)
		local value = UDim.new(0, textSize)
		local newTable = Paddings:get()
		newTable[textKey] = value
		Paddings:set(newTable)
		-- Paddings[textKey] = value
		return value
	end)
	table.insert(dependents, TextSize)
	table.insert(dependents, Font)
	table.insert(dependents, Padding)
end

local util = {
	getFontState = function(typographyState)
		return fusion.Computed(function()
			for i=1, #dependents do dependents[i]:get() end
			local typo = enums.Typography[typographyState:get()]
			local fonts = Fonts:get()
			return fonts[typo]
		end)
	end,
	getTextSizeState = function(typographyState)
		return fusion.Computed(function()
			for i=1, #dependents do dependents[i]:get() end
			local typo = enums.Typography[typographyState:get()]
			local textSizes = TextSizes:get()
			return textSizes[typo]
		end)
	end,
	getPaddingState = function(typographyState)
		return fusion.Computed(function()
			for i=1, #dependents do dependents[i]:get() end
			local typo = enums.Typography[typographyState:get()]
			local paddings = Paddings:get()
			print(paddings[typo])
			return paddings[typo]
		end)
	end,
}

return util