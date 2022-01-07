local packages = script.Parent.Parent.Parent
local synthetic = require(script.Parent.Parent)
local util = require(script.Parent.Parent:WaitForChild("Util"))
local fusion = util.initFusion(require(packages:WaitForChild('fusion')))
local maidConstructor = require(packages:WaitForChild('maid'))
local typographyConstructor = require(packages:WaitForChild('typography'))
local viewport = require(packages:WaitForChild("viewport"))
local enums = require(script.Parent.Parent:WaitForChild("Enums"))
local effects = require(script.Parent.Parent:WaitForChild("Effects"))

local constructor = {}

function constructor.new(params)
	--[=[
		@class Display
		@tag Component
		@tag Atom
		A simple ViewportFrame
	]=]

	--public states
	local public = {}

	--[=[
		@prop CameraPosition Vector3 | FusionState | nil
		The camera position in the ViewportFrame
		@within Display
	]=]
	public.CameraPosition = util.import(params.CameraPosition) or fusion.State(Vector3.new(0,0,0))

	--[=[
		@prop CameraXVector Vector3 | FusionState | nil
		The XVector of the camera CFrame
		@within Display
	]=]
	public.CameraXVector = util.import(params.CameraXVector) or fusion.State(Vector3.new(1,0,0))

	--[=[
		@prop CameraYVector Vector3 | FusionState | nil
		The YVector of the camera CFrame
		@within Display
	]=]
	public.CameraYVector = util.import(params.CameraYVector) or fusion.State(Vector3.new(0,1,0))

	--[=[
		@prop CameraZVector Vector3 | FusionState | nil
		The ZVector of the camera CFrame
		@within Display
	]=]
	public.CameraZVector = util.import(params.CameraZVector) or fusion.State(Vector3.new(0,0,1))

	--[=[
		@prop CameraZVector Vector3 | FusionState | nil
		The light direction of the ViewportFrame
		@within Display
	]=]
	public.LightDirection = util.import(params.LightDirection) or fusion.State(Vector3.new(-1,-1,-1))

	--[=[
		@prop LightColor Color3 | FusionState | nil
		The color of the ViewportFrame light
		@within Display
	]=]
	public.LightColor = util.import(params.LightColor) or fusion.State(Color3.fromRGB(140,140,140))

	--[=[
		@prop Ambient Color3 | FusionState | nil
		The color of the ViewportFrame ambient
		@within Display
	]=]
	public.Ambient = util.import(params.Ambient) or fusion.State(Color3.fromRGB(255,255,255))

	--[=[
		@prop FOV number | FusionState | nil
		The vertical Field of View for the camera in degrees
		@within Display
	]=]
	public.FOV = util.import(params.FOV) or fusion.State(70)

	--[=[
		@prop SynthClassName string
		Read-Only attribute used to identify what type of component it is
		@within Display
		@readonly
	]=]
	public.SynthClassName = fusion.Computed(function()
		return script.Name
	end)

	--construct
	local maid = maidConstructor.new()
	local handler
	local camera = fusion.New "Camera" {
		CFrame = util.tween(fusion.Computed(function()
			local p = public.CameraPosition:get()
			local x = public.CameraXVector:get()
			local y = public.CameraYVector:get()
			local z = public.CameraZVector:get()
			return CFrame.fromMatrix(p,x,y,z)
		end), {Duration = 0.5}),
		FieldOfView = util.tween(public.FOV),
	}

	--[=[
		@function ClearScene:Fire
		Removes all added instances from current scene
		@within Display
	]=]
	--[=[
		@function HideScene:Fire
		Temporarily pauses and hides all instances, good to do for performance when an element is unused
		@within Display
	]=]
	--[=[
		@function ShowScene:Fire
		Unpauses and reveals all instances, undoes HideScene
		@within Display
	]=]
	local objects = {}
	local inst = util.set(fusion.New "ViewportFrame", public, params, {
		BackgroundTransparency = 1,
		LightDirection = util.tween(public.LightDirection),
		LightColor = util.tween(public.LightColor),
		Ambient = util.tween(public.Ambient),
		[fusion.Children] = {
			camera,
			fusion.New "BindableEvent" {
				Name = "ClearScene",
				[fusion.OnEvent "Event"] = function()
					for i, obj in ipairs(objects) do
						obj:Destroy()
					end
					objects = {}
				end,
			},
			fusion.New "BindableEvent" {
				Name = "HideScene",
				[fusion.OnEvent "Event"] = function()
					print(handler)
					handler:Hide()
				end,
			},
			fusion.New "BindableEvent" {
				Name = "ShowScene",
				[fusion.OnEvent "Event"] = function()
					handler:Show()
				end,
			},
		}
	}, maid)
	inst.CurrentCamera = camera


	-- maid:GiveTask(fusion.Observer(camCF):onChange(function()
	-- 	print("Update")
	-- 	camera.CFrame = getCF()
	-- end))

	local function bindFunction(name, func)
		local bf = Instance.new("BindableFunction", inst)
		bf.Name = name
		bf.OnInvoke = func
		maid:GiveTask(bf)
	end

	local function makeController(obj)
		return {
			Show = function(self) --show all objects
				obj:Show()
			end,
			Hide = function(self) --hides all objects
				obj:Hide()
			end,
			Resume = function(self) --resumes all objects
				obj:Resume()
			end,
			Pause = function(self) --pauses all objects
				obj:Pause()
			end,
			SetFPS = function(self, fps) --pauses all objects
				obj:SetFPS(fps)
			end,
			Destroy = function()
				obj:Destroy()
			end
		}
	end


	--[=[
		@function InsertHumanoid:Invoke
		Adds a humanoid character model to the ViewportFrame
		@param CharacterModel Instance -- the model of the humanoid containing character
		@param FPS number | nil -- the rate at which the ViewportFrame will attempt to update character animations
		@return ViewportFrameController
		@within Display
	]=]

	bindFunction("InsertHumanoid", function(character, fps)
		local obj = handler:RenderHumanoid(character, fps)
		table.insert(objects, obj)
		local controller = makeController(obj)
		-- maid:GiveTask(controller)
		return controller
	end)

	--[=[
		@function InsertBasePart:Invoke
		Adds a BasePart to the ViewportFrame
		@param Part Instance -- the BasePart instance
		@param FPS number | nil -- the rate at which the ViewportFrame will attempt to update the part's location
		@return ViewportFrameController
		@within Display
	]=]

	bindFunction("InsertBasePart", function(part, fps)
		local obj = handler:RenderObject(part, fps)
		table.insert(objects, obj)
		local controller = makeController(obj)
		return controller
	end)

	--[=[
		@function InsertModel:Invoke
		Adds a Model to the ViewportFrame
		@param Model Model -- the BasePart instance
		@param FPS number | nil -- the rate at which the ViewportFrame will attempt to update the model
		@return ViewportFrameController
		@within Display
	]=]
	bindFunction("InsertModel", function(modReference, FPS)
		if modReference.ClassName ~= "Model" then warn("Invalid model") return end
		local model = Instance.new("Model", inst)
		model.Name = modReference.Name
		local modelPartObjects = {}
		local modController = {
			Destroy = function()
				for i, v in ipairs(modelPartObjects) do
					v:Destroy()
				end
				modelPartObjects = {}
				model:Destroy()
			end,
			Show = function(self) --show all objects
				for i, v in ipairs(modelPartObjects) do
					v:Show()
				end
			end,
			Hide = function(self) --hides all objects
				for i, v in ipairs(modelPartObjects) do
					v:Hide()
				end
			end,
			Resume = function(self) --resumes all objects
				for i, v in ipairs(modelPartObjects) do
					v:Resume()
				end
			end,
			Pause = function(self) --pauses all objects
				for i, v in ipairs(modelPartObjects) do
					v:Pause()
				end
			end,
			SetFPS = function(self, fps) --pauses all objects
				for i, v in ipairs(modelPartObjects) do
					v:SetFPS(fps)
				end
			end,
		}

		for i, part in ipairs(modReference:GetDescendants()) do
			if part:IsA("BasePart") then
				table.insert(modelPartObjects, handler:RenderObject(part, FPS, model))
			end
		end
		table.insert(objects, modController)
		return modController
	end)

	handler = viewport.new(inst)
	maid:GiveTask(handler)

	return inst
end

return constructor