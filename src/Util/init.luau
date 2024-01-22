--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))

-- Types
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type CanBeState<V> = ColdFusion.CanBeState<V>
type Style = Style.Style
type ImageData = Types.ImageData
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Util = {}

Util.Container = require(script:WaitForChild("Container"))
Util.List = require(script:WaitForChild("List"))
Util.Padding = require(script:WaitForChild("Padding"))
Util.TextLabel = require(script:WaitForChild("TextLabel"))
Util.ImageLabel = require(script:WaitForChild("ImageLabel"))

return Util
