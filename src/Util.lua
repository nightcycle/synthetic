--!strict
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)

local Maid = require(Packages:WaitForChild("Maid"))
type Maid = Maid.Maid

local Signal = require(Packages:WaitForChild("Signal"))
type Signal = Signal.Signal

local Util = {}
Util.__index = Util

function Util.cleanUpPrep(Maid: Maid, inst: Instance)
	local compMaid = Maid.new()
	compMaid:GiveTask(inst)
	for i, desc in ipairs(inst:GetDescendants()) do
		compMaid:GiveTask(desc)
	end

	Maid:GiveTask(compMaid)

	Maid:GiveTask(inst.Destroying:Connect(function()
		compMaid:Destroy()
		Maid:Destroy()
	end))
end

function Util.bindFunction<F>(inst: Instance, Maid: Maid, name: string, func: F): BindableFunction & { OnInvoke: F }
	assert(typeof(func) == "function")
	local bindableFunction = Instance.new("BindableFunction")
	bindableFunction.Name = name
	bindableFunction.OnInvoke = func
	Maid:GiveTask(bindableFunction)
	bindableFunction.Parent = inst

	local bFunc: any = bindableFunction
	return bFunc
end

function Util.bindSignal(inst: Instance, Maid: Maid, name: string, Signal: Signal): BindableEvent
	local bindableEvent = Instance.new("BindableEvent")
	bindableEvent.Name = name

	-- Maid:GiveTask(bindableEvent.Event:Connect(function(...)
	-- 	Signal:Fire(...)
	-- end))
	Maid:GiveTask(Signal:Connect(function(...)
		bindableEvent:Fire(...)
	end))
	Maid:GiveTask(bindableEvent)
	bindableEvent.Parent = inst

	return bindableEvent
end

return Util
