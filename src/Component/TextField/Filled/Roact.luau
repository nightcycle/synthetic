--!strict
-- this script was generated by the build system, please do not make manual edits
local _Package = script.Parent.Parent.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local Roact = require(_Packages:WaitForChild("Roact"))

-- Modules
local Types = require(_Package:WaitForChild("Types"))
local Style = require(_Package:WaitForChild("Style"))

local Source = require(script.Parent:WaitForChild("ColdFusion"))

-- Types
type Maid = Maid.Maid
type Style = Style.Style
type FontData = Types.FontData
type OptionData = Types.OptionData
type ButtonData = Types.ButtonData
type ImageData = Types.ImageData
type CanBeState<V> = ColdFusion.CanBeState<V>
-- Constants
local DEFAULTS = require(script.Parent:WaitForChild("Defaults"))
-- Variables
-- References
-- Private Functions
-- Class
local Interface = {}

do
	local NewTextFieldFilled = Roact.Component:extend("NewTextFieldFilled")
	NewTextFieldFilled.defaultProps = {
		onSubmit = DEFAULTS.NEW.ON_SUBMIT,
		onInput = DEFAULTS.NEW.ON_INPUT,
		initialText = DEFAULTS.NEW.INITIAL_TEXT,
		isEnabled = DEFAULTS.NEW.IS_ENABLED,
		isError = DEFAULTS.NEW.IS_ERROR,
		label = DEFAULTS.NEW.LABEL,
		characterLimit = DEFAULTS.NEW.CHARACTER_LIMIT,
		supportingText = DEFAULTS.NEW.SUPPORTING_TEXT,
		icon = DEFAULTS.NEW.ICON,
		backgroundColor = DEFAULTS.NEW.BACKGROUND_COLOR,
		hightlightColor = DEFAULTS.NEW.HIGHTLIGHT_COLOR,
		errorColor = DEFAULTS.NEW.ERROR_COLOR,
		borderColor = DEFAULTS.NEW.BORDER_COLOR,
		textColor = DEFAULTS.NEW.TEXT_COLOR,
		labelColor = DEFAULTS.NEW.LABEL_COLOR,
		elevation = DEFAULTS.NEW.ELEVATION,
		schemeType = DEFAULTS.NEW.SCHEME_TYPE,
		bodyFontData = DEFAULTS.NEW.BODY_FONT_DATA,
		supportFontData = DEFAULTS.NEW.SUPPORT_FONT_DATA,
		scale = DEFAULTS.NEW.SCALE,
	}
	function NewTextFieldFilled:init(initialProps: { [string]: unknown })
		self._maid = Maid.new()
		local _fuse = ColdFusion.fuse(self._maid)
		local _Value = _fuse.Value
		self._internalStates = {
			onSubmit = _Value(self.defaultProps.onSubmit),
			onInput = _Value(self.defaultProps.onInput),
			initialText = _Value(self.defaultProps.initialText),
			isEnabled = _Value(self.defaultProps.isEnabled),
			isError = _Value(self.defaultProps.isError),
			label = _Value(self.defaultProps.label),
			characterLimit = _Value(self.defaultProps.characterLimit),
			supportingText = _Value(self.defaultProps.supportingText),
			icon = _Value(self.defaultProps.icon),
			backgroundColor = _Value(self.defaultProps.backgroundColor),
			hightlightColor = _Value(self.defaultProps.hightlightColor),
			errorColor = _Value(self.defaultProps.errorColor),
			borderColor = _Value(self.defaultProps.borderColor),
			textColor = _Value(self.defaultProps.textColor),
			labelColor = _Value(self.defaultProps.labelColor),
			elevation = _Value(self.defaultProps.elevation),
			schemeType = _Value(self.defaultProps.schemeType),
			bodyFontData = _Value(self.defaultProps.bodyFontData),
			supportFontData = _Value(self.defaultProps.supportFontData),
			scale = _Value(self.defaultProps.scale),
		}
		table.freeze(self._internalStates)
		for k, v in pairs(initialProps) do
			if self._internalStates[k] then
				self._internalStates[k]:Set(v)
			end
		end
		self._instance = Source.new(
			self._internalStates.onSubmit,
			self._internalStates.onInput,
			self._internalStates.initialText,
			self._internalStates.isEnabled,
			self._internalStates.isError,
			self._internalStates.label,
			self._internalStates.characterLimit,
			self._internalStates.supportingText,
			self._internalStates.icon,
			self._internalStates.backgroundColor,
			self._internalStates.hightlightColor,
			self._internalStates.errorColor,
			self._internalStates.borderColor,
			self._internalStates.textColor,
			self._internalStates.labelColor,
			self._internalStates.elevation,
			self._internalStates.schemeType,
			self._internalStates.bodyFontData,
			self._internalStates.supportFontData,
			self._internalStates.scale
		)
	end

	function NewTextFieldFilled:render()
		local props = {
			target = self._instance,
		}
		for k, v in pairs(self.props) do
			if self.props[k] ~= v then
				if self._internalStates[k] then
					if v == nil then
						v = self.defaultProps[k]
					end
					self._internalStates[k]:Set(v)
				else
					props[k] = v
				end
			end
		end
		return Roact.createElement(Roact.Portal, props)
	end
	function NewTextFieldFilled:didMount()
		for k, v in pairs(self) do
			if typeof(v) == "table" then
				if v["virtualNode"] then
					if self._instance.Parent ~= v["virtualNode"]["hostParent"] then
						self._instance.Parent = v["virtualNode"]["hostParent"]
					end
					break
				end
			end
		end
	end
	function NewTextFieldFilled:willUnmount()
		self._maid:Destroy()
		self._instance:Destroy()
	end
	Interface.New = NewTextFieldFilled
end

do
	local PrimaryTextFieldFilled = Roact.Component:extend("PrimaryTextFieldFilled")
	PrimaryTextFieldFilled.defaultProps = {
		style = DEFAULTS.PRIMARY.STYLE,
		onSubmit = DEFAULTS.PRIMARY.ON_SUBMIT,
		label = DEFAULTS.PRIMARY.LABEL,
		initialText = DEFAULTS.PRIMARY.INITIAL_TEXT,
		onInput = DEFAULTS.PRIMARY.ON_INPUT,
		supportingText = DEFAULTS.PRIMARY.SUPPORTING_TEXT,
		icon = DEFAULTS.PRIMARY.ICON,
		characterLimit = DEFAULTS.PRIMARY.CHARACTER_LIMIT,
		isError = DEFAULTS.PRIMARY.IS_ERROR,
		elevation = DEFAULTS.PRIMARY.ELEVATION,
		isEnabled = DEFAULTS.PRIMARY.IS_ENABLED,
	}
	function PrimaryTextFieldFilled:init(initialProps: { [string]: unknown })
		self._maid = Maid.new()
		local _fuse = ColdFusion.fuse(self._maid)
		local _Value = _fuse.Value
		self._internalStates = {
			style = _Value(self.defaultProps.style),
			onSubmit = _Value(self.defaultProps.onSubmit),
			label = _Value(self.defaultProps.label),
			initialText = _Value(self.defaultProps.initialText),
			onInput = _Value(self.defaultProps.onInput),
			supportingText = _Value(self.defaultProps.supportingText),
			icon = _Value(self.defaultProps.icon),
			characterLimit = _Value(self.defaultProps.characterLimit),
			isError = _Value(self.defaultProps.isError),
			elevation = _Value(self.defaultProps.elevation),
			isEnabled = _Value(self.defaultProps.isEnabled),
		}
		table.freeze(self._internalStates)
		for k, v in pairs(initialProps) do
			if self._internalStates[k] then
				self._internalStates[k]:Set(v)
			end
		end
		self._instance = Source.primary(
			self._internalStates.style,
			self._internalStates.onSubmit,
			self._internalStates.label,
			self._internalStates.initialText,
			self._internalStates.onInput,
			self._internalStates.supportingText,
			self._internalStates.icon,
			self._internalStates.characterLimit,
			self._internalStates.isError,
			self._internalStates.elevation,
			self._internalStates.isEnabled
		)
	end

	function PrimaryTextFieldFilled:render()
		local props = {
			target = self._instance,
		}
		for k, v in pairs(self.props) do
			if self.props[k] ~= v then
				if self._internalStates[k] then
					if v == nil then
						v = self.defaultProps[k]
					end
					self._internalStates[k]:Set(v)
				else
					props[k] = v
				end
			end
		end
		return Roact.createElement(Roact.Portal, props)
	end
	function PrimaryTextFieldFilled:didMount()
		for k, v in pairs(self) do
			if typeof(v) == "table" then
				if v["virtualNode"] then
					if self._instance.Parent ~= v["virtualNode"]["hostParent"] then
						self._instance.Parent = v["virtualNode"]["hostParent"]
					end
					break
				end
			end
		end
	end
	function PrimaryTextFieldFilled:willUnmount()
		self._maid:Destroy()
		self._instance:Destroy()
	end
	Interface.Primary = PrimaryTextFieldFilled
end

do
	local SecondaryTextFieldFilled = Roact.Component:extend("SecondaryTextFieldFilled")
	SecondaryTextFieldFilled.defaultProps = {
		style = DEFAULTS.SECONDARY.STYLE,
		onSubmit = DEFAULTS.SECONDARY.ON_SUBMIT,
		label = DEFAULTS.SECONDARY.LABEL,
		initialText = DEFAULTS.SECONDARY.INITIAL_TEXT,
		onInput = DEFAULTS.SECONDARY.ON_INPUT,
		supportingText = DEFAULTS.SECONDARY.SUPPORTING_TEXT,
		icon = DEFAULTS.SECONDARY.ICON,
		characterLimit = DEFAULTS.SECONDARY.CHARACTER_LIMIT,
		isError = DEFAULTS.SECONDARY.IS_ERROR,
		elevation = DEFAULTS.SECONDARY.ELEVATION,
		isEnabled = DEFAULTS.SECONDARY.IS_ENABLED,
	}
	function SecondaryTextFieldFilled:init(initialProps: { [string]: unknown })
		self._maid = Maid.new()
		local _fuse = ColdFusion.fuse(self._maid)
		local _Value = _fuse.Value
		self._internalStates = {
			style = _Value(self.defaultProps.style),
			onSubmit = _Value(self.defaultProps.onSubmit),
			label = _Value(self.defaultProps.label),
			initialText = _Value(self.defaultProps.initialText),
			onInput = _Value(self.defaultProps.onInput),
			supportingText = _Value(self.defaultProps.supportingText),
			icon = _Value(self.defaultProps.icon),
			characterLimit = _Value(self.defaultProps.characterLimit),
			isError = _Value(self.defaultProps.isError),
			elevation = _Value(self.defaultProps.elevation),
			isEnabled = _Value(self.defaultProps.isEnabled),
		}
		table.freeze(self._internalStates)
		for k, v in pairs(initialProps) do
			if self._internalStates[k] then
				self._internalStates[k]:Set(v)
			end
		end
		self._instance = Source.secondary(
			self._internalStates.style,
			self._internalStates.onSubmit,
			self._internalStates.label,
			self._internalStates.initialText,
			self._internalStates.onInput,
			self._internalStates.supportingText,
			self._internalStates.icon,
			self._internalStates.characterLimit,
			self._internalStates.isError,
			self._internalStates.elevation,
			self._internalStates.isEnabled
		)
	end

	function SecondaryTextFieldFilled:render()
		local props = {
			target = self._instance,
		}
		for k, v in pairs(self.props) do
			if self.props[k] ~= v then
				if self._internalStates[k] then
					if v == nil then
						v = self.defaultProps[k]
					end
					self._internalStates[k]:Set(v)
				else
					props[k] = v
				end
			end
		end
		return Roact.createElement(Roact.Portal, props)
	end
	function SecondaryTextFieldFilled:didMount()
		for k, v in pairs(self) do
			if typeof(v) == "table" then
				if v["virtualNode"] then
					if self._instance.Parent ~= v["virtualNode"]["hostParent"] then
						self._instance.Parent = v["virtualNode"]["hostParent"]
					end
					break
				end
			end
		end
	end
	function SecondaryTextFieldFilled:willUnmount()
		self._maid:Destroy()
		self._instance:Destroy()
	end
	Interface.Secondary = SecondaryTextFieldFilled
end

do
	local TertiaryTextFieldFilled = Roact.Component:extend("TertiaryTextFieldFilled")
	TertiaryTextFieldFilled.defaultProps = {
		style = DEFAULTS.TERTIARY.STYLE,
		onSubmit = DEFAULTS.TERTIARY.ON_SUBMIT,
		label = DEFAULTS.TERTIARY.LABEL,
		initialText = DEFAULTS.TERTIARY.INITIAL_TEXT,
		onInput = DEFAULTS.TERTIARY.ON_INPUT,
		supportingText = DEFAULTS.TERTIARY.SUPPORTING_TEXT,
		icon = DEFAULTS.TERTIARY.ICON,
		characterLimit = DEFAULTS.TERTIARY.CHARACTER_LIMIT,
		isError = DEFAULTS.TERTIARY.IS_ERROR,
		elevation = DEFAULTS.TERTIARY.ELEVATION,
		isEnabled = DEFAULTS.TERTIARY.IS_ENABLED,
	}
	function TertiaryTextFieldFilled:init(initialProps: { [string]: unknown })
		self._maid = Maid.new()
		local _fuse = ColdFusion.fuse(self._maid)
		local _Value = _fuse.Value
		self._internalStates = {
			style = _Value(self.defaultProps.style),
			onSubmit = _Value(self.defaultProps.onSubmit),
			label = _Value(self.defaultProps.label),
			initialText = _Value(self.defaultProps.initialText),
			onInput = _Value(self.defaultProps.onInput),
			supportingText = _Value(self.defaultProps.supportingText),
			icon = _Value(self.defaultProps.icon),
			characterLimit = _Value(self.defaultProps.characterLimit),
			isError = _Value(self.defaultProps.isError),
			elevation = _Value(self.defaultProps.elevation),
			isEnabled = _Value(self.defaultProps.isEnabled),
		}
		table.freeze(self._internalStates)
		for k, v in pairs(initialProps) do
			if self._internalStates[k] then
				self._internalStates[k]:Set(v)
			end
		end
		self._instance = Source.tertiary(
			self._internalStates.style,
			self._internalStates.onSubmit,
			self._internalStates.label,
			self._internalStates.initialText,
			self._internalStates.onInput,
			self._internalStates.supportingText,
			self._internalStates.icon,
			self._internalStates.characterLimit,
			self._internalStates.isError,
			self._internalStates.elevation,
			self._internalStates.isEnabled
		)
	end

	function TertiaryTextFieldFilled:render()
		local props = {
			target = self._instance,
		}
		for k, v in pairs(self.props) do
			if self.props[k] ~= v then
				if self._internalStates[k] then
					if v == nil then
						v = self.defaultProps[k]
					end
					self._internalStates[k]:Set(v)
				else
					props[k] = v
				end
			end
		end
		return Roact.createElement(Roact.Portal, props)
	end
	function TertiaryTextFieldFilled:didMount()
		for k, v in pairs(self) do
			if typeof(v) == "table" then
				if v["virtualNode"] then
					if self._instance.Parent ~= v["virtualNode"]["hostParent"] then
						self._instance.Parent = v["virtualNode"]["hostParent"]
					end
					break
				end
			end
		end
	end
	function TertiaryTextFieldFilled:willUnmount()
		self._maid:Destroy()
		self._instance:Destroy()
	end
	Interface.Tertiary = TertiaryTextFieldFilled
end

return Interface
