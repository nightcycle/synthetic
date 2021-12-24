local packages = script.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local camera = game.Workspace.CurrentCamera
local viewportSizeY = fusion.State(camera.ViewportSize.Y)
local util = require(script.Parent:WaitForChild("Util"))
local maidConstructor = require(packages:WaitForChild("maid"))

local viewportSizeChangeSignal = camera:GetPropertyChangedSignal("ViewportSize")
viewportSizeChangeSignal:Connect(function()
	viewportSizeY:set(camera.ViewportSize.Y)
end)

local pallete = {
	["Amber"] = {
		[50] = Color3.fromHex("#FFF8E1"),
		[100] = Color3.fromHex("#FFECB3"),
		[200] = Color3.fromHex("#FFE082"),
		[300] = Color3.fromHex("#FFD54F"),
		[400] = Color3.fromHex("#FFCA28"),
		[500] = Color3.fromHex("#FFC107"),
		[600] = Color3.fromHex("#FFB300"),
		[700] = Color3.fromHex("#FFA000"),
		[800] = Color3.fromHex("#FF8F00"),
		[900] = Color3.fromHex("#FF6F00"),
	},
	["Blue Grey"] = {
		[50] = Color3.fromHex("#ECEFF1"),
		[100] = Color3.fromHex("#CFD8DC"),
		[200] = Color3.fromHex("#B0BEC5"),
		[300] = Color3.fromHex("#90A4AE"),
		[400] = Color3.fromHex("#78909C"),
		[500] = Color3.fromHex("#607D8B"),
		[600] = Color3.fromHex("#546E7A"),
		[700] = Color3.fromHex("#455A64"),
		[800] = Color3.fromHex("#37474F"),
		[900] = Color3.fromHex("#263238"),
	},
	["Blue"] = {
		[50] = Color3.fromHex("#E3F2FD"),
		[100] = Color3.fromHex("#BBDEFB"),
		[200] = Color3.fromHex("#90CAF9"),
		[300] = Color3.fromHex("#64B5F6"),
		[400] = Color3.fromHex("#42A5F5"),
		[500] = Color3.fromHex("#2196F3"),
		[600] = Color3.fromHex("#1E88E5"),
		[700] = Color3.fromHex("#1976D2"),
		[800] = Color3.fromHex("#1565C0"),
		[900] = Color3.fromHex("#0D47A1"),
	},
	["Brown"] = {
		[50] = Color3.fromHex("#EFEBE9"),
		[100] = Color3.fromHex("#D7CCC8"),
		[200] = Color3.fromHex("#BCAAA4"),
		[300] = Color3.fromHex("#A1887F"),
		[400] = Color3.fromHex("#8D6E63"),
		[500] = Color3.fromHex("#795548"),
		[600] = Color3.fromHex("#6D4C41"),
		[700] = Color3.fromHex("#5D4037"),
		[800] = Color3.fromHex("#4E342E"),
		[900] = Color3.fromHex("#3E2723"),
	},
	["Cyan"] = {
		[50] = Color3.fromHex("#E0F7FA"),
		[100] = Color3.fromHex("#B2EBF2"),
		[200] = Color3.fromHex("#80DEEA"),
		[300] = Color3.fromHex("#4DD0E1"),
		[400] = Color3.fromHex("#26C6DA"),
		[500] = Color3.fromHex("#00BCD4"),
		[600] = Color3.fromHex("#00ACC1"),
		[700] = Color3.fromHex("#0097A7"),
		[800] = Color3.fromHex("#00838F"),
		[900] = Color3.fromHex("#006064"),
	},
	["Deep Orange"] = {
		[50] = Color3.fromHex("#FBE9E7"),
		[100] = Color3.fromHex("#FFCCBC"),
		[200] = Color3.fromHex("#FFAB91"),
		[300] = Color3.fromHex("#FF8A65"),
		[400] = Color3.fromHex("#FF7043"),
		[500] = Color3.fromHex("#FF5722"),
		[600] = Color3.fromHex("#F4511E"),
		[700] = Color3.fromHex("#E64A19"),
		[800] = Color3.fromHex("#D84315"),
		[900] = Color3.fromHex("#BF360C"),
	},
	["Deep Purple"] = {
		[50] = Color3.fromHex("#EDE7F6"),
		[100] = Color3.fromHex("#D1C4E9"),
		[200] = Color3.fromHex("#B39DDB"),
		[300] = Color3.fromHex("#9575CD"),
		[400] = Color3.fromHex("#7E57C2"),
		[500] = Color3.fromHex("#673AB7"),
		[600] = Color3.fromHex("#5E35B1"),
		[700] = Color3.fromHex("#512DA8"),
		[800] = Color3.fromHex("#4527A0"),
		[900] = Color3.fromHex("#311B92"),
	},
	["Green"] = {
		[50] = Color3.fromHex("#E8F5E9"),
		[100] = Color3.fromHex("#C8E6C9"),
		[200] = Color3.fromHex("#A5D6A7"),
		[300] = Color3.fromHex("#81C784"),
		[400] = Color3.fromHex("#66BB6A"),
		[500] = Color3.fromHex("#4CAF50"),
		[600] = Color3.fromHex("#43A047"),
		[700] = Color3.fromHex("#388E3C"),
		[800] = Color3.fromHex("#2E7D32"),
		[900] = Color3.fromHex("#1B5E20"),
	},
	["Grey"] = {
		[50] = Color3.fromHex("#FAFAFA"),
		[100] = Color3.fromHex("#F5F5F5"),
		[200] = Color3.fromHex("#EEEEEE"),
		[300] = Color3.fromHex("#E0E0E0"),
		[400] = Color3.fromHex("#BDBDBD"),
		[500] = Color3.fromHex("#9E9E9E"),
		[600] = Color3.fromHex("#757575"),
		[700] = Color3.fromHex("#616161"),
		[800] = Color3.fromHex("#424242"),
		[900] = Color3.fromHex("#212121"),
	},
	["Indigo"] = {
		[50] = Color3.fromHex("#E8EAF6"),
		[100] = Color3.fromHex("#C5CAE9"),
		[200] = Color3.fromHex("#9FA8DA"),
		[300] = Color3.fromHex("#7986CB"),
		[400] = Color3.fromHex("#5C6BC0"),
		[500] = Color3.fromHex("#3F51B5"),
		[600] = Color3.fromHex("#3949AB"),
		[700] = Color3.fromHex("#303F9F"),
		[800] = Color3.fromHex("#283593"),
		[900] = Color3.fromHex("#1A237E"),
	},
	["Light Blue"] = {
		[50] = Color3.fromHex("#E1F5FE"),
		[100] = Color3.fromHex("#B3E5FC"),
		[200] = Color3.fromHex("#81D4FA"),
		[300] = Color3.fromHex("#4FC3F7"),
		[400] = Color3.fromHex("#29B6F6"),
		[500] = Color3.fromHex("#03A9F4"),
		[600] = Color3.fromHex("#039BE5"),
		[700] = Color3.fromHex("#0288D1"),
		[800] = Color3.fromHex("#0277BD"),
		[900] = Color3.fromHex("#01579B"),
	},
	["Light Green"] = {
		[50] = Color3.fromHex("#F1F8E9"),
		[100] = Color3.fromHex("#DCEDC8"),
		[200] = Color3.fromHex("#C5E1A5"),
		[300] = Color3.fromHex("#AED581"),
		[400] = Color3.fromHex("#9CCC65"),
		[500] = Color3.fromHex("#8BC34A"),
		[600] = Color3.fromHex("#7CB342"),
		[700] = Color3.fromHex("#689F38"),
		[800] = Color3.fromHex("#558B2F"),
		[900] = Color3.fromHex("#33691E"),
	},
	["Lime"] = {
		[50] = Color3.fromHex("#F9FBE7"),
		[100] = Color3.fromHex("#F0F4C3"),
		[200] = Color3.fromHex("#E6EE9C"),
		[300] = Color3.fromHex("#DCE775"),
		[400] = Color3.fromHex("#D4E157"),
		[500] = Color3.fromHex("#CDDC39"),
		[600] = Color3.fromHex("#C0CA33"),
		[700] = Color3.fromHex("#AFB42B"),
		[800] = Color3.fromHex("#9E9D24"),
		[900] = Color3.fromHex("#827717"),
	},
	["Orange"] = {
		[50] = Color3.fromHex("#FFF3E0"),
		[100] = Color3.fromHex("#FFE0B2"),
		[200] = Color3.fromHex("#FFCC80"),
		[300] = Color3.fromHex("#FFB74D"),
		[400] = Color3.fromHex("#FFA726"),
		[500] = Color3.fromHex("#FF9800"),
		[600] = Color3.fromHex("#FB8C00"),
		[700] = Color3.fromHex("#F57C00"),
		[800] = Color3.fromHex("#EF6C00"),
		[900] = Color3.fromHex("#E65100"),
	},
	["Pink"] = {
		[50] = Color3.fromHex("#FCE4EC"),
		[100] = Color3.fromHex("#F8BBD0"),
		[200] = Color3.fromHex("#F48FB1"),
		[300] = Color3.fromHex("#F06292"),
		[400] = Color3.fromHex("#EC407A"),
		[500] = Color3.fromHex("#E91E63"),
		[600] = Color3.fromHex("#D81B60"),
		[700] = Color3.fromHex("#C2185B"),
		[800] = Color3.fromHex("#AD1457"),
		[900] = Color3.fromHex("#880E4F"),
	},
	["Purple"] = {
		[50] = Color3.fromHex("#F3E5F5"),
		[100] = Color3.fromHex("#E1BEE7"),
		[200] = Color3.fromHex("#CE93D8"),
		[300] = Color3.fromHex("#BA68C8"),
		[400] = Color3.fromHex("#AB47BC"),
		[500] = Color3.fromHex("#9C27B0"),
		[600] = Color3.fromHex("#8E24AA"),
		[700] = Color3.fromHex("#7B1FA2"),
		[800] = Color3.fromHex("#6A1B9A"),
		[900] = Color3.fromHex("#4A148C"),
	},
	["Red"] = {
		[50] = Color3.fromHex("#FFEBEE"),
		[100] = Color3.fromHex("#FFCDD2"),
		[200] = Color3.fromHex("#EF9A9A"),
		[300] = Color3.fromHex("#E57373"),
		[500] = Color3.fromHex("#F44336"),
		[600] = Color3.fromHex("#E53935"),
		[700] = Color3.fromHex("#D32F2F"),
		[800] = Color3.fromHex("#C62828"),
		[900] = Color3.fromHex("#B71C1C"),
	},
	["Teal"] = {
		[50] = Color3.fromHex("#E0F2F1"),
		[100] = Color3.fromHex("#B2DFDB"),
		[200] = Color3.fromHex("#80CBC4"),
		[300] = Color3.fromHex("#4DB6AC"),
		[400] = Color3.fromHex("#26A69A"),
		[500] = Color3.fromHex("#009688"),
		[600] = Color3.fromHex("#00897B"),
		[700] = Color3.fromHex("#00796B"),
		[800] = Color3.fromHex("#00695C"),
		[900] = Color3.fromHex("#004D40"),
	},
	["Yellow"] = {
		[50] = Color3.fromHex("#FFFDE7"),
		[100] = Color3.fromHex("#FFF9C4"),
		[200] = Color3.fromHex("#FFF59D"),
		[300] = Color3.fromHex("#FFF176"),
		[400] = Color3.fromHex("#FFEE58"),
		[500] = Color3.fromHex("#FFEB3B"),
		[600] = Color3.fromHex("#FDD835"),
		[700] = Color3.fromHex("#FBC02D"),
		[800] = Color3.fromHex("#F9A825"),
		[900] = Color3.fromHex("#F57F17"),
	}
}

local styleConfigInst = Instance.new("Configuration", game)
styleConfigInst.Name = "SyntheticStyleConfiguration"
local maid = maidConstructor.new()
maid:GiveTask(styleConfigInst)

local fontConfigs = {
	Gotham = {
		Headline = Enum.Font.GothamSemibold,
		Subtitle = Enum.Font.GothamBold,
		Body = Enum.Font.Gotham,
		Button = Enum.Font.GothamBlack,
		Caption = Enum.Font.Gotham,
	},
	SourceSans = {
		Headline = Enum.Font.SourceSansSemibold,
		Subtitle = Enum.Font.SourceSansBold,
		Body = Enum.Font.SourceSans,
		Button = Enum.Font.SourceSansBold,
		Caption = Enum.Font.SourceSansLight,
	},
}

local maxVertResolution = 1080
local minVertResolution = 320

local textConfigs = {
	Headline = {
		Maximum = 120,
		Minimum = 60,
	},
	Subtitle = {
		Maximum = 48,
		Minimum = 24,
	},
	Button = {
		Maximum = 24,
		Minimum = 18,
	},
	Body = {
		Maximum = 20,
		Minimum = 12,
	},
	Caption = {
		Maximum = 20,
		Minimum = 10,
	},
}

function getPalleteColor(color: string, shade: number, addVariants)
	if not color then warn("Color can't be nil") return colors.Error end
	if not shade then warn("Shade can't be nil") return colors.Error end
	if not pallete[color] then warn(tostring(color).." is not a valid pallete entry") return colors.Error end
	if not pallete[color][shade] then warn(tostring(shade).." is not a valid shade for "..tostring(color)) return colors.Error end

	if addVariants then
		shade = math.clamp(shade, 200, 700)
		return pallete[color][shade], pallete[color][shade-200], pallete[color][shade+200]
	else
		return pallete[color][shade]
	end
end

local Primary = fusion.State("Purple")
local Secondary = fusion.State("Cyan")
local Surface = fusion.State("Grey")
local Background = fusion.State("Grey")
local Error = fusion.State("Red")

local PrimaryShade = fusion.State(700)
local SecondaryShade = fusion.State(400)
local SurfaceShade = fusion.State(50)
local BackgroundShade = fusion.State(50)
local ErrorShade = fusion.State(700)

local SystemFont = fusion.State("Gotham")

util.setPublicState("SystemFont", SystemFont, styleConfigInst, maid)

util.setPublicState("Primary", Primary, styleConfigInst, maid)
util.setPublicState("Secondary", Secondary, styleConfigInst, maid)
util.setPublicState("Surface", Surface, styleConfigInst, maid)
util.setPublicState("Background", Background, styleConfigInst, maid)
util.setPublicState("Error", Error, styleConfigInst, maid)

util.setPublicState("PrimaryShade", PrimaryShade, styleConfigInst, maid)
util.setPublicState("SecondaryShade", SecondaryShade, styleConfigInst, maid)
util.setPublicState("SurfaceShade", SurfaceShade, styleConfigInst, maid)
util.setPublicState("BackgroundShade", BackgroundShade, styleConfigInst, maid)
util.setPublicState("ErrorShade", ErrorShade, styleConfigInst, maid)

local colors = {--On refers to the color of overlaid text & iconography
	Primary = fusion.Computed(function()
		local col = Primary:get()
		local shade = PrimaryShade:get()
		local base, _, _ = getPalleteColor(col, shade, true)
		return base
	end),
	PrimaryDark = fusion.Computed(function()
		local col = Primary:get()
		local shade = PrimaryShade:get()
		local _, dark, _ = getPalleteColor(col, shade, true)
		return dark
	end),
	PrimaryLight = fusion.Computed(function()
		local col = Primary:get()
		local shade = PrimaryShade:get()
		local _, _, light = getPalleteColor(col, shade, true)
		return light
	end),
	Secondary = fusion.Computed(function()
		local col = Secondary:get()
		local shade = SecondaryShade:get()
		local base, _, _ = getPalleteColor(col, shade, true)
		return base
	end),
	SecondaryDark = fusion.Computed(function()
		local col = Secondary:get()
		local shade = SecondaryShade:get()
		local _, dark, _ = getPalleteColor(col, shade, true)
		return dark
	end),
	SecondaryLight = fusion.Computed(function()
		local col = Secondary:get()
		local shade = SecondaryShade:get()
		local _, _, light = getPalleteColor(col, shade, true)
		return light
	end),
	Surface = fusion.Computed(function()
		local col = Surface:get()
		local shade = SurfaceShade:get()
		local base = getPalleteColor(col, shade, true)
		return base
	end),
	Background = fusion.Computed(function()
		local col = Background:get()
		local shade = BackgroundShade:get()
		local base = getPalleteColor(col, shade, true)
		return base
	end),
	Error = fusion.Computed(function()
		local col = Error:get()
		local shade = ErrorShade:get()
		local base = getPalleteColor(col, shade, true)
		return base
	end),
}

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
			local currentFontGroup = SystemFont:get()
			return fontConfigs[currentFontGroup][textKey]
		end)
	}
end

return {
	getColor = function(colorCategory:string)
		local key = tostring(colorCategory)
		local color = colors[key]
		if not color then warn("No color found at "..key) return colors.Error end
		return colors[key]
	end,
	getFont = function(tClass:string)
		return typography[tClass].Font
	end,
	getTextSize = function(tClass:string)
		return typography[tClass].TextSize
	end,
}