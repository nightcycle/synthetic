--!strict
local _Package = script.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
-- Modules

-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
-- Types
type Maid = Maid.Maid
export type Transition = {
	__index: Transition,
	_Maid: Maid,
	_IsAlive: boolean,
	Destroy: (self: Transition) -> (),
	new: () -> Transition,
	init: (maid: Maid) -> nil
}

-- Class
local Transition = {} :: Transition
Transition.__index = Transition

function Transition:Destroy()
	if not self._IsAlive then return end
	self._IsAlive = false
	self._Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
end

function Transition.new()

	local self: Transition = setmetatable({}, Transition) :: any
	self._IsAlive = true
	self._Maid = Maid.new()

	return self
end

function Transition.init(maid: Maid)
	print(`booting {script.Name}`)
	return nil
end

return Transition