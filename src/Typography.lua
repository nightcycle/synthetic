local packages = script.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local camera = game.Workspace.CurrentCamera
local viewportSizeY = fusion.State(camera.ViewportSize.Y)
local util = require(script.Parent:WaitForChild("Util"))
local maidConstructor = require(packages:WaitForChild("maid"))
local enums = require(script.Parent:WaitForChild("Enums"))

local viewportSizeChangeSignal = camera:GetPropertyChangedSignal("ViewportSize")
viewportSizeChangeSignal:Connect(function()
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

local maxVertResolution = 1080
local minVertResolution = 320

local textConfigs = {
	[enums.Typography.Headline]= {
		Maximum = 120,
		Minimum = 60,
	},
	[enums.Typography.Subtitle] = {
		Maximum = 48,
		Minimum = 24,
	},
	[enums.Typography.Button] = {
		Maximum = 24,
		Minimum = 18,
	},
	[enums.Typography.Body] = {
		Maximum = 20,
		Minimum = 12,
	},
	[enums.Typography.Caption] = {
		Maximum = 20,
		Minimum = 10,
	},
}

local SystemFont = fusion.State("Gotham")

util.setPublicState("SystemFont", SystemFont, styleConfigInst, maid)

local typography = {}

for textKey, textConfig in pairs(textConfigs) do
	typography[textKey] = {
		TextSize = fusion.Computed(function()
			local vertResolution = math.clamp(game.Workspace.CurrentCamera.ViewportSize.Y, minVertResolution, maxVertResolution)
			local alpha = vertResolution/(maxVertResolution-minVertResolution)

			local min = textConfig.Minimum
			local max = textConfig.Maximum

			return math.round(alpha*(max-min) + min)
		end),
		Font = fusion.Computed(function()
			local currentFontGroup = enums.SystemFont[SystemFont:get()]
			return fontConfigs[currentFontGroup][textKey]
		end)
	}
end

local util
util = {
	getFont = function(textTheme: number)
		local typeset = typography[textTheme] or typography[enums.Typography.Body]
		return typeset.Font:get()
	end,
	getTextSize = function(textTheme: number)
		local typeset = typography[textTheme] or typography[enums.Typography.Body]
		return typeset.TextSize:get()
	end,
	getPadding = function(textTheme: number)
		return math.floor(util.getTextSize(textTheme)*0.5)
	end,
}

return util