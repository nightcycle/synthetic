--!strict
local package = script.Parent
local packages = package.Parent

local Util = require(package.Util)

local Types = require(package.Types)
type ParameterValue<T> = Types.ParameterValue<T>

local ColdFusion = require(packages.coldfusion)
type Fuse = ColdFusion.Fuse
type State<T> = ColdFusion.State<T>
type ValueState<T> = ColdFusion.ValueState<T>

local Maid = require(packages.maid)
type Maid = Maid.Maid


local Spritesheet = require(script:WaitForChild("Spritesheet"))

export type IconLabelParameters = Types.ImageLabelParameters & {
	IconTransparency: ParameterValue<number>?,
	IconColor3: ParameterValue<Color3>?,
	Icon: ParameterValue<string>?,
}

export type IconLabel = ImageLabel

function Constructor(config: IconLabelParameters): IconLabel
	local _Maid = Maid.new()
	local _Fuse = ColdFusion.fuse(_Maid)
	local _Computed = _Fuse.Computed
	local _Value = _Fuse.Value
	local _import = _Fuse.import
	local _new = _Fuse.new

	local Name = _import(config.Name, script.Name)
	local IconTransparency = _import(config.IconTransparency, 0)
	local IconColor3 = _import(config.IconColor3, Color3.new(1,1,1))
	local Icon: State<nil> = _import(config.Icon, nil)
	

	local DotsPerInch = _Value(36)
	local IconData = _Computed(function(key: string?, dpi): any
		if not key or key == "" then return nil end
		assert(key ~= nil)
		local iconResolutions = Spritesheet[string.lower(key)] or {}
		return iconResolutions[dpi]
	end, Icon, DotsPerInch)

	local parameters: any = {
		Name = Name,
		BackgroundTransparency = 1,
		Image = _Computed(function(iconData, key)
			if not key or key == "" then return "" end
			if not iconData then return "" end
			return "rbxassetid://"..iconData.Sheet
		end, IconData, Icon),
		ImageRectOffset = _Computed(function(iconData)
			if not iconData then return Vector2.new(0,0) end
			return Vector2.new(iconData.X, iconData.Y)
		end, IconData),
		ImageRectSize = _Computed(function(dpi)
			return Vector2.new(dpi, dpi)
		end, DotsPerInch),
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

	local Output = _Fuse.new("ImageLabel")(parameters)
	local AbsoluteSize = _Fuse.Property(Output, "AbsoluteSize"):Else(Vector2.new(0,0))
	_Maid:GiveTask(AbsoluteSize:Connect(function()
		if not Output or not Output:IsDescendantOf(game) then return end
		local dpi = math.min(Output.AbsoluteSize.X, Output.AbsoluteSize.Y)
		local options = {36,48,72,96}
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

	Util.cleanUpPrep(_Maid, Output)

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