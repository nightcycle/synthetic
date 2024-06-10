--!strict
--!native
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Fusion = require(_Packages:WaitForChild("Fusion"))
-- Modules
-- Types
type CFusionState<V> = ColdFusion.State<V>
type CFusionValueState<V> = ColdFusion.ValueState<V>
type CFusionCanBeState<V> = ColdFusion.CanBeState<V>
type FusionStateObject<V> = Fusion.StateObject<V>
type FusionValue<V> = Fusion.Value<V>

-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Translators = {}

return Translators
