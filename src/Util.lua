local packages = script.Parent.Parent
local attributerConstructor = require(packages:WaitForChild("attributer"))
local util
local f
local signalConstructor = require(packages:WaitForChild("signal"))
local typographyConstructor = require(packages:WaitForChild("typography"))
local maidConstructor = require(packages:WaitForChild("maid"))
local ed = Enum.EasingDirection
local es = Enum.EasingStyle

function mergeConfig(baseConfig, changes, whiteList, blackList)
	if not whiteList then whiteList = changes end
	for k, v in pairs(changes) do
		if k == f.c then
			baseConfig[k] = baseConfig[k] or {}
			for i, val in ipairs(v) do
				table.insert(baseConfig[k], val)
			end
		else
			if whiteList[k] ~= nil and blackList[k] == nil then
				baseConfig[k] = changes[k] or baseConfig[k]
			end
		end
	end
	return baseConfig
end

function setPublicState(key, state, inst, maid)
	local readOnly = state.set == nil
	if readOnly then key = "_"..key end
	if type(state:get()) == "table" and state.get then
		for k, v in pairs(state:get()) do
			local vState = f.v(v)
			if not readOnly then
				local vCompute = f.get(function()
					return state:get()[k]
				end)
				local function updateParentState()
					local newTabl = state:get()
					newTabl[k] = vState:get()
					state:set(newTabl)
				end
				maid:GiveTask(f.step(vState):onChange(updateParentState))
				maid:GiveTask(f.step(vCompute):onChange(updateParentState))
			end
			setPublicState(key.."_"..k, vState, inst, maid)
		end
		return
	end
	--bind to attributes
	maid._attributer = maid._attributer or attributerConstructor.new(inst, {}, {})

	local isEnum = typeof(state:get()) == "EnumItem"
	local enumType
	local val = state:get()
	if isEnum then
		enumType = tostring(state:get().EnumType)
		val = val.Name
	end

	maid._attributer:Connect(key, val)
	local compat = f.step(state)

	local function setAttribute(v)
		if isEnum then
			v = v or state:get().Name
			if inst:GetAttribute(key) ~= state:get() then
				inst:SetAttribute(key, v)
			end
		else
			v = v or state:get()
			if inst:GetAttribute(key) ~= state:get() then
				inst:SetAttribute(key, state:get())
			end
		end
	end

	maid:GiveTask(compat:onChange(setAttribute))
	maid:GiveTask(maid._attributer.OnChanged:Connect(function(k, val)
		if k == key and val ~= state:get() then
			if not readOnly then
				if isEnum then
					local enum = Enum[enumType][val]
					state:set(enum)
				else
					state:set(val)
				end
			else
				setAttribute()
			end
		end
	end))
end

util = {
	setPublicState = setPublicState,

	newTypography = function(font, minTextSize, maxTextSize)
		return typographyConstructor.new(font, minTextSize, maxTextSize)
	end,

	import = function(stateOrVal)
		if (type(stateOrVal) == "table" and stateOrVal.get) or stateOrVal == nil then
			return stateOrVal
		else
			return f.v(stateOrVal)
		end
	end,

	getInteractionColor = function(_Clicked, _Hovered, _Color)
		--colors
		local RecolorWeight = 0.8
		local _MainHighlightColor = f.get(function()
			local h,s,v = _Color:get():ToHSV()
			return Color3.fromHSV(h,s*RecolorWeight,1 - (1-v)*RecolorWeight)
		end)
		local _MainShadowColor = f.get(function()
			local h,s,v = _Color:get():ToHSV()
			return Color3.fromHSV(h,s,v*RecolorWeight)
		end)
		local _DynamicMainColor = f.get(function()
			if _Clicked:get() then
				return _MainShadowColor:get()
			elseif _Hovered:get() then
				return _MainHighlightColor:get()
			else
				return _Color:get()
			end
		end)
		return _DynamicMainColor
	end,

	initFusion = function(fusionLibrary)
		fusionLibrary.new = fusionLibrary.New

		fusionLibrary.c = fusionLibrary.Children

		fusionLibrary.e = fusionLibrary.OnEvent

		fusionLibrary.dt = fusionLibrary.OnChange

		fusionLibrary.v = fusionLibrary.State
		fusionLibrary.Value = fusionLibrary.v

		fusionLibrary.get = fusionLibrary.Computed

		fusionLibrary.gets = fusionLibrary.ComputedPairs

		fusionLibrary.step = fusionLibrary.Compat
		fusionLibrary.Observer = fusionLibrary.step

		fusionLibrary.t = fusionLibrary.Tween

		fusionLibrary.s = fusionLibrary.Spring
		return fusionLibrary
	end,

	getTypographyStates = function(typographyState)
		local _Padding = f.get(function()
			return typographyState:get().Padding
		end)
		local _TextSize = f.get(function()
			return typographyState:get().TextSize
		end)
		local _Font = f.get(function()

		end)
		return _Padding, _TextSize, _Font
	end,

	cornerRadius = UDim.new(0, 5),

	set = function(constructor, publicStates, params, config, maid)
		-- print("1")
		if not maid then
			maid = maidConstructor.new()
		end
		params.SynthClassName = nil
		params.Name = params.Name or publicStates.SynthClassName:get()
		mergeConfig(config, params, nil, publicStates)
		-- print(config)
		-- print("2")
		local inst = constructor(config)
		maid:GiveTask(inst)
		-- print("3")
		for k, v in pairs(publicStates) do
			setPublicState(k, v, inst, maid)
		end
		-- print("4")
		local wasEverDescendeded = inst:IsDescendantOf(game.Players.LocalPlayer)
		maid.deathSignal = inst.AncestryChanged:Connect(function()
			if wasEverDescendeded == false then
				wasEverDescendeded = inst:IsDescendantOf(game.Players.LocalPlayer)
				if wasEverDescendeded == false then
					return
				end
			end
			wasEverDescendeded = true
			if not inst:IsDescendantOf(game.Players.LocalPlayer) then
				for i, desc in ipairs(inst:GetDescendants()) do
					desc:Destroy()
				end
				maid:Destroy()
			end
		end)
		-- print("5")
		return inst
	end,

	tween = function(state, params)
		params = params or {}
		local duration = params.Duration or 0.35
		local easingStyle = params.EasingStyle or es.Quint
		local easingDirection = params.EasingDirection or ed.InOut
		local repeatCount = params.RepeatCount or 1
		local reverses = params.Reverses or false
		local delayTime = params.DelayTime or 0
		return f.t(state, TweenInfo.new(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime))
	end,

	mergeConfig = mergeConfig
}

f = util.initFusion(require(packages:WaitForChild('fusion')))
return util