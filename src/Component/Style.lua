local synthetic = script.Parent.Parent

local packages = synthetic.Parent
local fusion = require(packages:WaitForChild('fusion'))
local maidConstructor = require(packages:WaitForChild('maid'))
local attributerConstructor = require(packages:WaitForChild('attributer'))

local camera = game.Workspace.CurrentCamera
local viewportSizeY = fusion.State(camera.ViewportSize.Y)

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

local constructor = {}

local styleConfigInst = Instance.new("Configuration", game)
styleConfigInst.Name = "SyntheticStyleConfiguration"

local validFonts = {
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
local validTextSizes = {
	Headline = {
		Maximum = 120,
		Minimum = 60,
	},
	Subtitle = {
		Maximum = 48,
		Minimum = 24,
	},
	Button = {
		Maximum = 36,
		Minimum = 18,
	},
	Body = {
		Maximum = 24,
		Minimum = 12,
	},
	Caption = {
		Maximum = 20,
		Minimum = 10,
	},
}

function getTextSize(tKey)
	local textConfig = validTextSizes[tKey]

	local vertResolution = math.clamp(game.Workspace.CurrentCamera.ViewportSize.Y, minVertResolution, maxVertResolution)
	local alpha = vertResolution/(maxVertResolution-minVertResolution)

	local min = textConfig.Minimum
	local max = textConfig.Maximum

	return math.round(alpha*(max-min) + min)
end

local config = {
	-- https://material.io/design/color/the-color-system.html

	--the color displayed most frequently
	Primary_Color = "Blue",
	Primary_Shade = 500,

	--provides more ways to accent and distinguish your product
	Secondary_Color = "Orange",
	Secondary_Shade = 200,

	--affect surfaces of Components, such as cards, sheets, and menus
	Surface_Color = "Grey",
	Surface_Shade = 50,

	-- appears behind scrollable content
	Background_Color = "Grey",
	Background_Shade = 50,

	-- indicates errors in Components, such as invalid text in a text field
	Error_Color = "Red",
	Error_Shade = 800,

	-- font to be used
	Font = "Gotham",
}
local colors

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

colors = {--On refers to the color of overlaid text & iconography
	Primary = fusion.State(getPalleteColor("Purple", 700)),
	PrimaryDark = fusion.State(getPalleteColor("Purple", 900)),
	PrimaryLight = fusion.State(getPalleteColor("Purple", 500)),
	Secondary = fusion.State(getPalleteColor("Cyan", 400)),
	SecondaryDark = fusion.State(getPalleteColor("Cyan", 600)),
	SecondaryLight = fusion.State(getPalleteColor("Cyan", 200)),
	Surface = fusion.State(getPalleteColor("Grey", 50)),
	Background = fusion.State(getPalleteColor("Grey", 50)),
	Error = fusion.State(getPalleteColor("Red", 700)),
}

local styleConfigAttributer = attributerConstructor.new(styleConfigInst, config, nil, false, nil, true)
local onStyleChanged = styleConfigAttributer.OnChanged
local currentSystemFont = fusion.State(config.Font)
onStyleChanged:Connect(function(k, val)
	if k == "Font" then
		currentSystemFont:set(val)
	end
end)


function getKeyFromColor(color:Color3)
	for synthCol, shades in pairs(pallete) do
		-- warn(synthCol)
		for shade, col in pairs(shades) do
			if col:ToHex() == color:ToHex() then
				return synthCol, shade
			end
		end
	end
end

function solve()
	local prim, primDark, primLight = getPalleteColor(config.Primary_Color, config.Primary_Shade, false)
	colors.Primary:set(prim)
	colors.PrimaryDark:set(primDark)
	colors.PrimaryLight:set(primLight)

	local sec, secDark, secLight = getPalleteColor(config.Secondary_Color, config.Secondary_Shade, true)
	colors.Secondary:set(sec)
	colors.SecondaryDark:set(secDark)
	colors.SecondaryLight:set(secLight)

	colors.Surface:set(getPalleteColor(config.Surface_Color, config.Surface_Shade, false))
	colors.Background:set(getPalleteColor(config.Background_Color, config.Background_Shade, false))
	colors.Error:set(getPalleteColor(config.Error_Color, config.Error_Shade, false))
end
solve()
function getColor(colorCategory:string)
	solve()
	local key = tostring(colorCategory)
	local color = colors[key]
	if not color then warn("No color found at "..key) return colors.Error:get() end
	return colors[key]:get()
end

local ed = Enum.EasingDirection
local es = Enum.EasingStyle
function newTweenInfo(params)  --default is a nice smooth transition
	params = params or {}
	local duration = params.Duration or 0.4
	local easingStyle = params.EasingStyle or es.Quint
	local easingDirection = params.EasingDirection or ed.InOut
	local repeatCount = params.RepeatCount or 0
	local reverses = params.Reverses or false
	local delayTime = params.DelayTime or 0
	return TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
end

function update(parent: Instance, backgroundColor, onColor, font, fontSize)
	if not parent or not parent:IsA("GuiObject") then return end
	if not parent:GetAttribute("StartStyleConfig") then
		parent:SetAttribute("SSC_BackgroundColor3", parent.BackgroundColor3)
	end
	parent.BackgroundColor3 = backgroundColor:get()
	if parent:IsA("ImageButton") or parent:IsA("ImageLabel") then

		if not parent:GetAttribute("StartStyleConfig") then
			parent:SetAttribute("SSC_ImageColor3", parent.ImageColor3)
		end
		parent.ImageColor3 = onColor:get()

	elseif parent:IsA("TextButton") or parent:IsA("TextLabel") or parent:IsA("TextBox") then
		if not parent:GetAttribute("StartStyleConfig") then
			parent:SetAttribute("SSC_TextColor3", parent.TextColor3)
			parent:SetAttribute("SSC_Font", tostring(parent.Font))
			parent:SetAttribute("SSC_TextSize", parent.TextSize)
		end
		parent.TextColor3 = onColor:get()
		parent.Font = font:get()
		parent.TextSize = fontSize:get()
	end
	parent:SetAttribute("StartStyleConfig", true)
end

function resetParent(parent: Instance, maid)
	local isViable = parent:GetAttribute("StartStyleConfig")
	if not isViable then return end
	parent:SetAttribute("StartStyleConfig", false)
	if not parent or not parent:IsA("GuiObject") then return end
	parent.BackgroundColor3 = parent:GetAttribute("SSC_BackgroundColor3")
	parent:SetAttribute("SSC_BackgroundColor3", nil)
	if parent:IsA("ImageButton") or parent:IsA("ImageLabel") then

		parent.ImageColor3 = parent:GetAttribute("SSC_ImageColor3")
		parent:SetAttribute("SSC_ImageColor3", nil)

	elseif parent:IsA("TextButton") or parent:IsA("TextLabel") or parent:IsA("TextBox") then
		if not parent:GetAttribute("StartStyleConfig") then
			parent:SetAttribute("SSC_TextColor3", parent.TextColor3)
			parent:SetAttribute("SSC_Font", tostring(parent.Font))
			parent:SetAttribute("SSC_FontSize", parent.FontSize)
		end

		parent.TextColor3 = parent:GetAttribute("SSC_TextColor3")
		parent:SetAttribute("SSC_TextColor3", nil)

		parent.Font = parent:GetAttribute("SSC_Font")
		parent:SetAttribute("SSC_Font", nil)

		parent.TextSize = parent:GetAttribute("SSC_TextSize")
		parent:SetAttribute("SSC_TextSize", nil)
	end
	parent:SetAttribute("StartStyleConfig", nil)
	maid:DoCleaning()
end

function tweenCompat(state, maid, tweenInfo, func)
	local stateTween = fusion.Tween(state, tweenInfo) --newTweenInfo())
	local stateTweenCompat = fusion.Compat(stateTween)
	maid:GiveTask(stateTweenCompat:onChange(func))
	return stateTween
end

function constructor.new()
	local maid = maidConstructor.new()
	local parentMaid = maidConstructor.new()
	maid:GiveTask(parentMaid)

	local currentParent

	--set control states
	local category = fusion.State("Primary")
	local textClass = fusion.State("Body")

	--create inst
	local inst = fusion.New "Configuration" {
		Name = "Style",
		Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	}

	--bind to attributes
	local attributer = attributerConstructor.new(inst, {})
	maid:GiveTask(attributer)
	local function bindAttributeToState(key, state)
		attributer:Connect(key, state:get())
		maid:GiveTask(attributer.OnChanged:Connect(function(k, val)
			if k == key then
				state:set(val)
			end
		end))
	end
	bindAttributeToState("Category", category)
	bindAttributeToState("TextClass", textClass)

	--solve background color
	local goalBackgroundColor = fusion.Computed(function()
		return getColor(category:get())
	end)

	---solve goal on color
	local goalOnColor = fusion.Computed(function()
		local _, shade = getKeyFromColor(goalBackgroundColor:get())
		return getPalleteColor("Grey", if shade > 300 then 50 else 900)
	end)

	--solve font size
	local goalFont = fusion.Computed(function()
		local curSysFont = currentSystemFont:get()
		local coreFont = validFonts[tostring(curSysFont)]
		local tClass = textClass:get()
		if not tClass or not coreFont[tClass] then
			warn("TextClass "..tostring(tClass).." is not valid")
			tClass = "Body"
		end
		local finalFont = coreFont[tClass]
		return finalFont
	end)
	local goalFontSize = fusion.Computed(function()
		local tClass = textClass:get()
		if not tClass then
			warn("TextClass "..tostring(tClass).." is not valid")
			tClass = "Body"
		end
		return getTextSize(tClass)
	end)

	--connect goals to parent
	local currentBackgroundColor = goalBackgroundColor
	local currentOnColor = goalOnColor
	local currentFontSize = goalFontSize
	local function fireUpdate()
		update(currentParent, currentBackgroundColor, currentOnColor, goalFont, currentFontSize)
	end
	currentBackgroundColor = tweenCompat(goalBackgroundColor, maid, newTweenInfo(), fireUpdate)
	currentOnColor = tweenCompat(goalOnColor, maid, newTweenInfo(), fireUpdate)
	currentFontSize = tweenCompat(goalFontSize, maid, newTweenInfo(), fireUpdate)

	maid:GiveTask(inst)

	maid:GiveTask(inst.AncestryChanged:Connect(function()
		if inst:IsDescendantOf(game.Players.LocalPlayer:WaitForChild("PlayerGui")) == false then
			maid:Destroy()
		elseif inst.Parent ~= nil or currentParent ~= nil then
			currentParent = inst.Parent
			parentMaid:GiveTask(currentParent:GetPropertyChangedSignal("AbsoluteSize"):Connect(fireUpdate))
			fireUpdate()
		else
			resetParent(currentParent, parentMaid)
			currentParent = nil
		end
	end))

	maid:GiveTask(viewportSizeChangeSignal:Connect(fireUpdate))

	return inst
end

return constructor