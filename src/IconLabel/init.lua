--!strict
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)

local RunService = game:GetService("RunService")

local Util = require(Package:WaitForChild("Util"))

local Types = require(Package:WaitForChild("Types"))

local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

local Maid = require(Packages:WaitForChild("Maid"))
type Maid = Maid.Maid

local Spritesheet = require(script:WaitForChild("Spritesheet"))

export type IconLabelParameters = Types.ImageLabelParameters & {
	IconTransparency: CanBeState<number>?,
	IconColor3: CanBeState<Color3>?,
	Icon: CanBeState<string>?,
}

export type IconLabel = ImageLabel

function Constructor(config: IconLabelParameters): IconLabel
	-- init workspace
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	-- unload config states
	local Name = _import(config.Name, script.Name)
	local IconTransparency = _import(config.IconTransparency, 0)
	local IconColor3 = _import(config.IconColor3, Color3.new(1, 1, 1))
	local Icon: State<string?> = _import(config.Icon, nil :: string?)

	-- init internal states
	local AbsoluteSize = _Value(Vector2.new(0, 0))
	local OutputState = _Value(nil :: IconLabel?)
	local DotsPerInch = _Value(36)
	local IconData = _Computed(function(key: string?, dpi): any
		if not key or key == "" then
			return nil
		end
		assert(key ~= nil)
		local iconResolutions = Spritesheet[string.lower(key)] or {}
		return iconResolutions[dpi]
	end, Icon, DotsPerInch)

	-- bind state changes
	maid:GiveTask(AbsoluteSize:Connect(function()
		local output = OutputState:Get()
		if not output or not output:IsDescendantOf(game) then
			return
		end
		assert(output ~= nil)
		local dpi = math.min(output.AbsoluteSize.X, output.AbsoluteSize.Y)
		local options = { 36, 48, 72, 96 }
		local closest = 36
		local closestDelta = nil

		for i, res in ipairs(options) do
			if dpi % res == 0 or res % dpi == 0 then
				closest = res
				break
			elseif not closestDelta or math.abs(res - dpi) < closestDelta then
				closest = res
				closestDelta = math.abs(res - dpi)
			end
		end

		DotsPerInch:Set(closest)
	end))

	-- assemble final parameters
	local parameters: any = {
		Name = Name,
		BackgroundTransparency = 1,
		Image = _Computed(function(iconData, key: string?)
			if not key or key == "" then
				return ""
			end
			if not iconData then
				return key or ""
			end
			return "rbxassetid://" .. iconData.Sheet
		end, IconData, Icon),
		ImageRectOffset = _Computed(function(iconData)
			if not iconData then
				return Vector2.new(0, 0)
			end
			return Vector2.new(iconData.X, iconData.Y)
		end, IconData),
		ImageRectSize = _Computed(function(dpi: number, iconData)
			if iconData then
				return Vector2.new(dpi, dpi)
			else
				return Vector2.new(0, 0)
			end
		end, DotsPerInch, IconData),
		ImageColor3 = IconColor3,
		ImageTransparency = IconTransparency,
	}

	config.IconTransparency = nil
	config.IconColor3 = nil
	config.Icon = nil

	for k, v in pairs(config) do
		if parameters[k] == nil then
			parameters[k] = v
		end
	end

	-- construct output instance
	local Output = _fuse.new("ImageLabel")(parameters) :: ImageLabel
	OutputState:Set(Output)

	maid:GiveTask(RunService.RenderStepped:Connect(function(deltaTime: number)
		AbsoluteSize:Set(Output.AbsoluteSize)
	end))

	Util.cleanUpPrep(maid, Output)

	return Output
end

return function(maid: Maid?)
	return function(params: IconLabelParameters): IconLabel
		local inst = Constructor(params)
		if maid then
			maid:GiveTask(inst)
		end
		return inst
	end
end
