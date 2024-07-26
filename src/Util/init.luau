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

Util.Container = {
	ColdFusion = require(script:WaitForChild("Container"):WaitForChild("ColdFusion")),
}
Util.List = {
	ColdFusion = require(script:WaitForChild("List"):WaitForChild("ColdFusion")),
}
Util.Padding = {
	ColdFusion = require(script:WaitForChild("Padding"):WaitForChild("ColdFusion")),
}
Util.TextLabel = {
	ColdFusion = require(script:WaitForChild("TextLabel"):WaitForChild("ColdFusion")),
}
Util.ImageLabel = {
	ColdFusion = require(script:WaitForChild("ImageLabel"):WaitForChild("ColdFusion")),
}
Util.PopUp = {
	ColdFusion = require(script:WaitForChild("PopUp"):WaitForChild("ColdFusion")),
}
Util.ScrollingContainer = {
	ColdFusion = require(script:WaitForChild("ScrollingContainer"):WaitForChild("ColdFusion")),
}

return Util
