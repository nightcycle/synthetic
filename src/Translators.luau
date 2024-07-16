--!strict
--!native
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Fusion = require(_Packages:WaitForChild("Fusion"))
local Maid = require(_Packages:WaitForChild("Maid"))
-- Modules
-- Types
type Maid = Maid.Maid

-- CFusion
export type CFuse = ColdFusion.Fuse
export type CFusionState<V> = ColdFusion.State<V>
export type CFusionValueState<V> = ColdFusion.ValueState<V>
export type CFusionCanBeState<V> = ColdFusion.CanBeState<V>

-- Fusion
export type FusionStateObject<V> = Fusion.StateObject<V>
export type FusionCanBeState<V> = Fusion.CanBeState<V>
export type FusionValue<V> = Fusion.Value<V>
export type FusionObserver = Fusion.Observer

export type Wrapper<BaseInstance, Definition, ClassName> = Definition & BaseInstance & {
	ClassName: ClassName & string,
	Instance: BaseInstance & Instance,
}

-- Private functions

-- Interface
local Translators = {}

Translators.Fusion = {}
Translators.Wrapper = {}
Translators.ColdFusion = {}
Translators.Roact = {}

function Translators.Fusion.toColdFusion<V>(
	maid: Maid,
	fuse: CFuse,
	value: FusionCanBeState<V>,
	default: V
): CFusionCanBeState<V>
	if typeof(value) == "table" then
		local valueTable: { [unknown]: unknown? } = value :: any
		-- print("state=", valueTable["State"],  valueTable)
		if
			valueTable["type"] == "State"
			and typeof(valueTable["kind"]) == "string"
			and typeof(valueTable["get"]) == "function"
		then
			local stateObject: FusionStateObject<V> = valueTable :: any
			local state = fuse.Value(stateObject:get(false))
			local observer = Fusion.Observer(stateObject)
			maid:GiveTask(observer:onChange(function()
				local val = stateObject:get(false)
				state:Set(if val == nil then default else val)
			end))

			return state
		end
	end
	if value == nil then
		return default
	else
		return value :: any
	end
end

function Translators.ColdFusion.toWrapper<BaseInstance, Definition, ClassName>(
	className: ClassName & string,
	inst: BaseInstance & Instance,
	states: {
		[unknown]: CFusionValueState<unknown?>,
	},
	defaults: {
		[unknown]: unknown?,
	}
): (Wrapper<
	Instance,
	{ [string]: any },
	string
>, () -> ())
	--  Private class
	local wrapper = {}
	wrapper.ClassName = className
	wrapper.Instance = inst

	local meta = {}

	local function cleanUp()
		table.clear(wrapper)
		-- setmetatable(wrapper, nil)
		table.clear(meta)
	end

	function meta:Destroy()
		inst:Destroy()
		cleanUp()
	end

	function meta:__index(k: unknown): unknown?
		if rawget(self, k) then
			return rawget(self, k)
		elseif states[k] then
			return states[k]:Get()
		else
			return (inst :: any)[k]
		end
	end

	function meta:__newindex(k: unknown, v: unknown?): ()
		if rawget(self, k) ~= nil then
			rawset(self, k, v)
		elseif states[k] then
			if v == nil then
				states[k]:Set(defaults[k])
			else
				states[k]:Set(v)
			end
		elseif v ~= nil then
			local anyInst: any = inst
			anyInst[k] = v
		end
	end

	setmetatable(wrapper :: any, meta)
	table.freeze(wrapper)
	return wrapper :: any, cleanUp
end

return Translators
