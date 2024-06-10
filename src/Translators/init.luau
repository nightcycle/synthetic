--!strict
--!native
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Roact = require(_Packages:WaitForChild("Roact"))
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

type Properties = {
	[string]: unknown?,
}
export type RoactProperties<V> = Properties & V

export type RoactElement<V> = {
	props: RoactProperties<V>,
	render: (self: RoactElement<V>) -> (),
	init: (self: RoactElement<V>) -> (),
	setState: (self: RoactElement<V>, props: RoactProperties<V> | () -> RoactProperties<V>?) -> (),
}
export type RoactHandle<V> = {}
export type Roact = {
	-- creates a backend only class that can be modified
	createElement: <States>(
		className: string,
		props: RoactProperties<States>,
		children: { [string]: unknown }
	) -> RoactElement<States>,
	-- binds an element to a Roblox instance
	mount: <States, InstanceType>(
		element: RoactElement<Properties>,
		inst: InstanceType
	) -> RoactHandle<States>,
}
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Translators = {}

Translators.Fusion = {}

function Translators.Fusion.toColdFusion<V>(fuse: CFuse, value: FusionCanBeState<V>): CFusionCanBeState<V>
	if typeof(value) == "table" then
		local valueTable: { [unknown]: unknown? } = value :: any
		if
			valueTable["State"] == "State"
			and typeof(valueTable["kind"]) == "string"
			and typeof(valueTable["get"]) == "function"
		then
			local stateObject: FusionStateObject<V> = valueTable :: any
			local state = fuse.Value(stateObject:get(false))
			local observer = Fusion.Observer(stateObject)
			observer:onChange(function()
				state:Set(stateObject:get(false))
			end)

			return state
		else
			return value :: any
		end
	else
		return value :: any
	end
end

Translators.ColdFusion = {}

function Translators.ColdFusion.ToRoact()
	local app = Roact.Component:extend("Greeting")
end

return Translators
