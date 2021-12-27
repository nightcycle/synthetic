local packages = script.Parent.Parent
local fusion = require(packages:WaitForChild('fusion'))
local util = require(script.Parent:WaitForChild("Util"))
local maidConstructor = require(packages:WaitForChild("maid"))
local enums = require(script.Parent:WaitForChild("Enums"))

local pallete = {
	[enums.ColorPallete["Amber"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#FFF8E1"),
		[enums.ColorShade["100"]] = Color3.fromHex("#FFECB3"),
		[enums.ColorShade["200"]] = Color3.fromHex("#FFE082"),
		[enums.ColorShade["300"]] = Color3.fromHex("#FFD54F"),
		[enums.ColorShade["400"]] = Color3.fromHex("#FFCA28"),
		[enums.ColorShade["500"]] = Color3.fromHex("#FFC107"),
		[enums.ColorShade["600"]] = Color3.fromHex("#FFB300"),
		[enums.ColorShade["700"]] = Color3.fromHex("#FFA000"),
		[enums.ColorShade["800"]] = Color3.fromHex("#FF8F00"),
		[enums.ColorShade["900"]] = Color3.fromHex("#FF6F00"),
	},
	[enums.ColorPallete["Blue Grey"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#ECEFF1"),
		[enums.ColorShade["100"]] = Color3.fromHex("#CFD8DC"),
		[enums.ColorShade["200"]] = Color3.fromHex("#B0BEC5"),
		[enums.ColorShade["300"]] = Color3.fromHex("#90A4AE"),
		[enums.ColorShade["400"]] = Color3.fromHex("#78909C"),
		[enums.ColorShade["500"]] = Color3.fromHex("#607D8B"),
		[enums.ColorShade["600"]] = Color3.fromHex("#546E7A"),
		[enums.ColorShade["700"]] = Color3.fromHex("#455A64"),
		[enums.ColorShade["800"]] = Color3.fromHex("#37474F"),
		[enums.ColorShade["900"]] = Color3.fromHex("#263238"),
	},
	[enums.ColorPallete["Blue"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#E3F2FD"),
		[enums.ColorShade["100"]] = Color3.fromHex("#BBDEFB"),
		[enums.ColorShade["200"]] = Color3.fromHex("#90CAF9"),
		[enums.ColorShade["300"]] = Color3.fromHex("#64B5F6"),
		[enums.ColorShade["400"]] = Color3.fromHex("#42A5F5"),
		[enums.ColorShade["500"]] = Color3.fromHex("#2196F3"),
		[enums.ColorShade["600"]] = Color3.fromHex("#1E88E5"),
		[enums.ColorShade["700"]] = Color3.fromHex("#1976D2"),
		[enums.ColorShade["800"]] = Color3.fromHex("#1565C0"),
		[enums.ColorShade["900"]] = Color3.fromHex("#0D47A1"),
	},
	[enums.ColorPallete["Brown"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#EFEBE9"),
		[enums.ColorShade["100"]] = Color3.fromHex("#D7CCC8"),
		[enums.ColorShade["200"]] = Color3.fromHex("#BCAAA4"),
		[enums.ColorShade["300"]] = Color3.fromHex("#A1887F"),
		[enums.ColorShade["400"]] = Color3.fromHex("#8D6E63"),
		[enums.ColorShade["500"]] = Color3.fromHex("#795548"),
		[enums.ColorShade["600"]] = Color3.fromHex("#6D4C41"),
		[enums.ColorShade["700"]] = Color3.fromHex("#5D4037"),
		[enums.ColorShade["800"]] = Color3.fromHex("#4E342E"),
		[enums.ColorShade["900"]] = Color3.fromHex("#3E2723"),
	},
	[enums.ColorPallete["Cyan"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#E0F7FA"),
		[enums.ColorShade["100"]] = Color3.fromHex("#B2EBF2"),
		[enums.ColorShade["200"]] = Color3.fromHex("#80DEEA"),
		[enums.ColorShade["300"]] = Color3.fromHex("#4DD0E1"),
		[enums.ColorShade["400"]] = Color3.fromHex("#26C6DA"),
		[enums.ColorShade["500"]] = Color3.fromHex("#00BCD4"),
		[enums.ColorShade["600"]] = Color3.fromHex("#00ACC1"),
		[enums.ColorShade["700"]] = Color3.fromHex("#0097A7"),
		[enums.ColorShade["800"]] = Color3.fromHex("#00838F"),
		[enums.ColorShade["900"]] = Color3.fromHex("#006064"),
	},
	[enums.ColorPallete["Deep Orange"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#FBE9E7"),
		[enums.ColorShade["100"]] = Color3.fromHex("#FFCCBC"),
		[enums.ColorShade["200"]] = Color3.fromHex("#FFAB91"),
		[enums.ColorShade["300"]] = Color3.fromHex("#FF8A65"),
		[enums.ColorShade["400"]] = Color3.fromHex("#FF7043"),
		[enums.ColorShade["500"]] = Color3.fromHex("#FF5722"),
		[enums.ColorShade["600"]] = Color3.fromHex("#F4511E"),
		[enums.ColorShade["700"]] = Color3.fromHex("#E64A19"),
		[enums.ColorShade["800"]] = Color3.fromHex("#D84315"),
		[enums.ColorShade["900"]] = Color3.fromHex("#BF360C"),
	},
	[enums.ColorPallete["Deep Purple"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#EDE7F6"),
		[enums.ColorShade["100"]] = Color3.fromHex("#D1C4E9"),
		[enums.ColorShade["200"]] = Color3.fromHex("#B39DDB"),
		[enums.ColorShade["300"]] = Color3.fromHex("#9575CD"),
		[enums.ColorShade["400"]] = Color3.fromHex("#7E57C2"),
		[enums.ColorShade["500"]] = Color3.fromHex("#673AB7"),
		[enums.ColorShade["600"]] = Color3.fromHex("#5E35B1"),
		[enums.ColorShade["700"]] = Color3.fromHex("#512DA8"),
		[enums.ColorShade["800"]] = Color3.fromHex("#4527A0"),
		[enums.ColorShade["900"]] = Color3.fromHex("#311B92"),
	},
	[enums.ColorPallete["Green"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#E8F5E9"),
		[enums.ColorShade["100"]] = Color3.fromHex("#C8E6C9"),
		[enums.ColorShade["200"]] = Color3.fromHex("#A5D6A7"),
		[enums.ColorShade["300"]] = Color3.fromHex("#81C784"),
		[enums.ColorShade["400"]] = Color3.fromHex("#66BB6A"),
		[enums.ColorShade["500"]] = Color3.fromHex("#4CAF50"),
		[enums.ColorShade["600"]] = Color3.fromHex("#43A047"),
		[enums.ColorShade["700"]] = Color3.fromHex("#388E3C"),
		[enums.ColorShade["800"]] = Color3.fromHex("#2E7D32"),
		[enums.ColorShade["900"]] = Color3.fromHex("#1B5E20"),
	},
	[enums.ColorPallete["Grey"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#FAFAFA"),
		[enums.ColorShade["100"]] = Color3.fromHex("#F5F5F5"),
		[enums.ColorShade["200"]] = Color3.fromHex("#EEEEEE"),
		[enums.ColorShade["300"]] = Color3.fromHex("#E0E0E0"),
		[enums.ColorShade["400"]] = Color3.fromHex("#BDBDBD"),
		[enums.ColorShade["500"]] = Color3.fromHex("#9E9E9E"),
		[enums.ColorShade["600"]] = Color3.fromHex("#757575"),
		[enums.ColorShade["700"]] = Color3.fromHex("#616161"),
		[enums.ColorShade["800"]] = Color3.fromHex("#424242"),
		[enums.ColorShade["900"]] = Color3.fromHex("#212121"),
	},
	[enums.ColorPallete["Indigo"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#E8EAF6"),
		[enums.ColorShade["100"]] = Color3.fromHex("#C5CAE9"),
		[enums.ColorShade["200"]] = Color3.fromHex("#9FA8DA"),
		[enums.ColorShade["300"]] = Color3.fromHex("#7986CB"),
		[enums.ColorShade["400"]] = Color3.fromHex("#5C6BC0"),
		[enums.ColorShade["500"]] = Color3.fromHex("#3F51B5"),
		[enums.ColorShade["600"]] = Color3.fromHex("#3949AB"),
		[enums.ColorShade["700"]] = Color3.fromHex("#303F9F"),
		[enums.ColorShade["800"]] = Color3.fromHex("#283593"),
		[enums.ColorShade["900"]] = Color3.fromHex("#1A237E"),
	},
	[enums.ColorPallete["Light Blue"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#E1F5FE"),
		[enums.ColorShade["100"]] = Color3.fromHex("#B3E5FC"),
		[enums.ColorShade["200"]] = Color3.fromHex("#81D4FA"),
		[enums.ColorShade["300"]] = Color3.fromHex("#4FC3F7"),
		[enums.ColorShade["400"]] = Color3.fromHex("#29B6F6"),
		[enums.ColorShade["500"]] = Color3.fromHex("#03A9F4"),
		[enums.ColorShade["600"]] = Color3.fromHex("#039BE5"),
		[enums.ColorShade["700"]] = Color3.fromHex("#0288D1"),
		[enums.ColorShade["800"]] = Color3.fromHex("#0277BD"),
		[enums.ColorShade["900"]] = Color3.fromHex("#01579B"),
	},
	[enums.ColorPallete["Light Green"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#F1F8E9"),
		[enums.ColorShade["100"]] = Color3.fromHex("#DCEDC8"),
		[enums.ColorShade["200"]] = Color3.fromHex("#C5E1A5"),
		[enums.ColorShade["300"]] = Color3.fromHex("#AED581"),
		[enums.ColorShade["400"]] = Color3.fromHex("#9CCC65"),
		[enums.ColorShade["500"]] = Color3.fromHex("#8BC34A"),
		[enums.ColorShade["600"]] = Color3.fromHex("#7CB342"),
		[enums.ColorShade["700"]] = Color3.fromHex("#689F38"),
		[enums.ColorShade["800"]] = Color3.fromHex("#558B2F"),
		[enums.ColorShade["900"]] = Color3.fromHex("#33691E"),
	},
	[enums.ColorPallete["Lime"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#F9FBE7"),
		[enums.ColorShade["100"]] = Color3.fromHex("#F0F4C3"),
		[enums.ColorShade["200"]] = Color3.fromHex("#E6EE9C"),
		[enums.ColorShade["300"]] = Color3.fromHex("#DCE775"),
		[enums.ColorShade["400"]] = Color3.fromHex("#D4E157"),
		[enums.ColorShade["500"]] = Color3.fromHex("#CDDC39"),
		[enums.ColorShade["600"]] = Color3.fromHex("#C0CA33"),
		[enums.ColorShade["700"]] = Color3.fromHex("#AFB42B"),
		[enums.ColorShade["800"]] = Color3.fromHex("#9E9D24"),
		[enums.ColorShade["900"]] = Color3.fromHex("#827717"),
	},
	[enums.ColorPallete["Orange"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#FFF3E0"),
		[enums.ColorShade["100"]] = Color3.fromHex("#FFE0B2"),
		[enums.ColorShade["200"]] = Color3.fromHex("#FFCC80"),
		[enums.ColorShade["300"]] = Color3.fromHex("#FFB74D"),
		[enums.ColorShade["400"]] = Color3.fromHex("#FFA726"),
		[enums.ColorShade["500"]] = Color3.fromHex("#FF9800"),
		[enums.ColorShade["600"]] = Color3.fromHex("#FB8C00"),
		[enums.ColorShade["700"]] = Color3.fromHex("#F57C00"),
		[enums.ColorShade["800"]] = Color3.fromHex("#EF6C00"),
		[enums.ColorShade["900"]] = Color3.fromHex("#E65100"),
	},
	[enums.ColorPallete["Pink"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#FCE4EC"),
		[enums.ColorShade["100"]] = Color3.fromHex("#F8BBD0"),
		[enums.ColorShade["200"]] = Color3.fromHex("#F48FB1"),
		[enums.ColorShade["300"]] = Color3.fromHex("#F06292"),
		[enums.ColorShade["400"]] = Color3.fromHex("#EC407A"),
		[enums.ColorShade["500"]] = Color3.fromHex("#E91E63"),
		[enums.ColorShade["600"]] = Color3.fromHex("#D81B60"),
		[enums.ColorShade["700"]] = Color3.fromHex("#C2185B"),
		[enums.ColorShade["800"]] = Color3.fromHex("#AD1457"),
		[enums.ColorShade["900"]] = Color3.fromHex("#880E4F"),
	},
	[enums.ColorPallete["Purple"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#F3E5F5"),
		[enums.ColorShade["100"]] = Color3.fromHex("#E1BEE7"),
		[enums.ColorShade["200"]] = Color3.fromHex("#CE93D8"),
		[enums.ColorShade["300"]] = Color3.fromHex("#BA68C8"),
		[enums.ColorShade["400"]] = Color3.fromHex("#AB47BC"),
		[enums.ColorShade["500"]] = Color3.fromHex("#9C27B0"),
		[enums.ColorShade["600"]] = Color3.fromHex("#8E24AA"),
		[enums.ColorShade["700"]] = Color3.fromHex("#7B1FA2"),
		[enums.ColorShade["800"]] = Color3.fromHex("#6A1B9A"),
		[enums.ColorShade["900"]] = Color3.fromHex("#4A148C"),
	},
	[enums.ColorPallete["Red"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#FFEBEE"),
		[enums.ColorShade["100"]] = Color3.fromHex("#FFCDD2"),
		[enums.ColorShade["200"]] = Color3.fromHex("#EF9A9A"),
		[enums.ColorShade["300"]] = Color3.fromHex("#E57373"),
		[enums.ColorShade["500"]] = Color3.fromHex("#F44336"),
		[enums.ColorShade["600"]] = Color3.fromHex("#E53935"),
		[enums.ColorShade["700"]] = Color3.fromHex("#D32F2F"),
		[enums.ColorShade["800"]] = Color3.fromHex("#C62828"),
		[enums.ColorShade["900"]] = Color3.fromHex("#B71C1C"),
	},
	[enums.ColorPallete["Teal"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#E0F2F1"),
		[enums.ColorShade["100"]] = Color3.fromHex("#B2DFDB"),
		[enums.ColorShade["200"]] = Color3.fromHex("#80CBC4"),
		[enums.ColorShade["300"]] = Color3.fromHex("#4DB6AC"),
		[enums.ColorShade["400"]] = Color3.fromHex("#26A69A"),
		[enums.ColorShade["500"]] = Color3.fromHex("#009688"),
		[enums.ColorShade["600"]] = Color3.fromHex("#00897B"),
		[enums.ColorShade["700"]] = Color3.fromHex("#00796B"),
		[enums.ColorShade["800"]] = Color3.fromHex("#00695C"),
		[enums.ColorShade["900"]] = Color3.fromHex("#004D40"),
	},
	[enums.ColorPallete["Yellow"]] = {
		[enums.ColorShade["50"]] = Color3.fromHex("#FFFDE7"),
		[enums.ColorShade["100"]] = Color3.fromHex("#FFF9C4"),
		[enums.ColorShade["200"]] = Color3.fromHex("#FFF59D"),
		[enums.ColorShade["300"]] = Color3.fromHex("#FFF176"),
		[enums.ColorShade["400"]] = Color3.fromHex("#FFEE58"),
		[enums.ColorShade["500"]] = Color3.fromHex("#FFEB3B"),
		[enums.ColorShade["600"]] = Color3.fromHex("#FDD835"),
		[enums.ColorShade["700"]] = Color3.fromHex("#FBC02D"),
		[enums.ColorShade["800"]] = Color3.fromHex("#F9A825"),
		[enums.ColorShade["900"]] = Color3.fromHex("#F57F17"),
	}
}

local styleConfigInst = Instance.new("Configuration", game)
styleConfigInst.Name = "SyntheticTheme"
local maid = maidConstructor.new()
maid:GiveTask(styleConfigInst)

function getPalleteColor(color: string, shade: number, addVariants)
	color = enums.ColorPallete[color]
	shade = enums.ColorShade[shade]

	if addVariants then
		return pallete[color][shade], pallete[color][shade-2], pallete[color][shade+2]
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

local colors = fusion.State({--On refers to the color of overlaid text & iconography
	[enums.Theme.Primary] = fusion.Computed(function()
		local col = Primary:get()
		local shade = PrimaryShade:get()
		local base, _, _ = getPalleteColor(col, shade, true)
		return base
	end),
	[enums.Theme.PrimaryDark] = fusion.Computed(function()
		local col = Primary:get()
		local shade = PrimaryShade:get()
		local _, dark, _ = getPalleteColor(col, shade, true)
		return dark
	end),
	[enums.Theme.PrimaryLight] = fusion.Computed(function()
		local col = Primary:get()
		local shade = PrimaryShade:get()
		local _, _, light = getPalleteColor(col, shade, true)
		return light
	end),
	[enums.Theme.Secondary] = fusion.Computed(function()
		local col = Secondary:get()
		local shade = SecondaryShade:get()
		local base, _, _ = getPalleteColor(col, shade, true)
		return base
	end),
	[enums.Theme.SecondaryDark] = fusion.Computed(function()
		local col = Secondary:get()
		local shade = SecondaryShade:get()
		local _, dark, _ = getPalleteColor(col, shade, true)
		return dark
	end),
	[enums.Theme.SecondaryLight] = fusion.Computed(function()
		local col = Secondary:get()
		local shade = SecondaryShade:get()
		local _, _, light = getPalleteColor(col, shade, true)
		return light
	end),
	[enums.Theme.Surface] = fusion.Computed(function()
		local col = Surface:get()
		local shade = SurfaceShade:get()
		local base = getPalleteColor(col, shade, true)
		return base
	end),
	[enums.Theme.Background] = fusion.Computed(function()
		local col = Background:get()
		local shade = BackgroundShade:get()
		local base = getPalleteColor(col, shade, true)
		return base
	end),
	[enums.Theme.Error] = fusion.Computed(function()
		local col = Error:get()
		local shade = ErrorShade:get()
		local base = getPalleteColor(col, shade, true)
		return base
	end),
	[enums.Theme.Unknown] = fusion.State(Color3.new(0,0,0)),
})

local util
util = {
	getColorState = function(themeState)
		return fusion.Computed(function()
			local cols = colors:get()
			local themeEnum = enums.Theme[themeState:get()]
			return (cols[themeEnum] or cols[enums.Theme.Error]):get()
		end)
	end,
	getTextColorState = function(themeState)
		return fusion.Computed(function()
			local cols = colors:get()
			local themeEnum = enums.Theme[themeState:get()]
			local color = (cols[themeEnum] or cols[enums.Theme.Error]):get()
			local h,s,v = color:ToHSV()

			if v > 0.5 then
				return Color3.fromHSV(0, 0, 0.95)
			else
				return Color3.fromHSV(0, 0, 0.05)
			end
		end)
	end,
}

return util