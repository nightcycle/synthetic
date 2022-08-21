--!strict
local package = script.Parent
local packages = package.Parent

local Maid = require(packages.maid)
type Maid = Maid.Maid

local Signal = require(packages.signal)
type Signal = Signal.Signal

local Util = {}
Util.__index = Util

function Util.cleanUpPrep(maid: Maid, inst: Instance)
	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
		for i, inst in ipairs(inst:GetDescendants()) do
			pcall(function()
				inst:Destroy()
			end)
		end
		pcall(function()
			inst:Destroy()
		end)
	end))
end

function Util.bindFunction<F>(inst: Instance, maid: Maid, name: string, func: F): BindableFunction & {OnInvoke: F}
	assert(typeof(func) == "function")
	local bindableFunction = Instance.new("BindableFunction")
	bindableFunction.Name = name
	bindableFunction.OnInvoke = func
	maid:GiveTask(bindableFunction)
	bindableFunction.Parent = inst

	local bFunc: any = bindableFunction
	return bFunc
end

function Util.bindSignal(inst: Instance, maid: Maid, name: string, signal: Signal): BindableEvent
	local bindableEvent = Instance.new("BindableEvent")
	bindableEvent.Name = name

	maid:GiveTask(bindableEvent.Event:Connect(function(...)
		signal:Fire(...)
	end))
	maid:GiveTask(signal:Connect(function(...)
		bindableEvent:Fire(...)
	end))
	maid:GiveTask(bindableEvent)
	bindableEvent.Parent = inst

	return bindableEvent
end

return Util