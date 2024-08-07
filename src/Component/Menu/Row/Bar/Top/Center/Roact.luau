--!strict
-- this script was generated by the build system, please do not make manual edits
local _Package = script.Parent.Parent.Parent.Parent.Parent.Parent.Parent
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
	local NewMenuRowBarTopCenter = Roact.Component:extend("NewMenuRowBarTopCenter")
	NewMenuRowBarTopCenter.defaultProps = {
		title = DEFAULTS.NEW.TITLE,
		buttons = DEFAULTS.NEW.BUTTONS,
		navigation = DEFAULTS.NEW.NAVIGATION,
		backgroundColor = DEFAULTS.NEW.BACKGROUND_COLOR,
		textColor = DEFAULTS.NEW.TEXT_COLOR,
		elevation = DEFAULTS.NEW.ELEVATION,
		schemeType = DEFAULTS.NEW.SCHEME_TYPE,
		titleFontData = DEFAULTS.NEW.TITLE_FONT_DATA,
		subHeadingFontData = DEFAULTS.NEW.SUB_HEADING_FONT_DATA,
		buttonFontData = DEFAULTS.NEW.BUTTON_FONT_DATA,
		scale = DEFAULTS.NEW.SCALE,
	}
	function NewMenuRowBarTopCenter:init(initialProps: { [string]: unknown })
		self._maid = Maid.new()
		local _fuse = ColdFusion.fuse(self._maid)
		local _Value = _fuse.Value
		self._internalStates = {
			title = _Value(self.defaultProps.title),
			buttons = _Value(self.defaultProps.buttons),
			navigation = _Value(self.defaultProps.navigation),
			backgroundColor = _Value(self.defaultProps.backgroundColor),
			textColor = _Value(self.defaultProps.textColor),
			elevation = _Value(self.defaultProps.elevation),
			schemeType = _Value(self.defaultProps.schemeType),
			titleFontData = _Value(self.defaultProps.titleFontData),
			subHeadingFontData = _Value(self.defaultProps.subHeadingFontData),
			buttonFontData = _Value(self.defaultProps.buttonFontData),
			scale = _Value(self.defaultProps.scale),
		}
		table.freeze(self._internalStates)
		for k, v in pairs(initialProps) do
			if self._internalStates[k] then
				self._internalStates[k]:Set(v)
			end
		end
		self._instance = Source.new(
			self._internalStates.title,
			self._internalStates.buttons,
			self._internalStates.navigation,
			self._internalStates.backgroundColor,
			self._internalStates.textColor,
			self._internalStates.elevation,
			self._internalStates.schemeType,
			self._internalStates.titleFontData,
			self._internalStates.subHeadingFontData,
			self._internalStates.buttonFontData,
			self._internalStates.scale
		)
	end

	function NewMenuRowBarTopCenter:render()
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
	function NewMenuRowBarTopCenter:didMount()
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
	function NewMenuRowBarTopCenter:willUnmount()
		self._maid:Destroy()
		self._instance:Destroy()
	end
	Interface.New = NewMenuRowBarTopCenter
end

do
	local PrimaryMenuRowBarTopCenter = Roact.Component:extend("PrimaryMenuRowBarTopCenter")
	PrimaryMenuRowBarTopCenter.defaultProps = {
		style = DEFAULTS.PRIMARY.STYLE,
		title = DEFAULTS.PRIMARY.TITLE,
		buttons = DEFAULTS.PRIMARY.BUTTONS,
		navigation = DEFAULTS.PRIMARY.NAVIGATION,
		elevation = DEFAULTS.PRIMARY.ELEVATION,
	}
	function PrimaryMenuRowBarTopCenter:init(initialProps: { [string]: unknown })
		self._maid = Maid.new()
		local _fuse = ColdFusion.fuse(self._maid)
		local _Value = _fuse.Value
		self._internalStates = {
			style = _Value(self.defaultProps.style),
			title = _Value(self.defaultProps.title),
			buttons = _Value(self.defaultProps.buttons),
			navigation = _Value(self.defaultProps.navigation),
			elevation = _Value(self.defaultProps.elevation),
		}
		table.freeze(self._internalStates)
		for k, v in pairs(initialProps) do
			if self._internalStates[k] then
				self._internalStates[k]:Set(v)
			end
		end
		self._instance = Source.primary(
			self._internalStates.style,
			self._internalStates.title,
			self._internalStates.buttons,
			self._internalStates.navigation,
			self._internalStates.elevation
		)
	end

	function PrimaryMenuRowBarTopCenter:render()
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
	function PrimaryMenuRowBarTopCenter:didMount()
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
	function PrimaryMenuRowBarTopCenter:willUnmount()
		self._maid:Destroy()
		self._instance:Destroy()
	end
	Interface.Primary = PrimaryMenuRowBarTopCenter
end

do
	local SecondaryMenuRowBarTopCenter = Roact.Component:extend("SecondaryMenuRowBarTopCenter")
	SecondaryMenuRowBarTopCenter.defaultProps = {
		style = DEFAULTS.SECONDARY.STYLE,
		title = DEFAULTS.SECONDARY.TITLE,
		buttons = DEFAULTS.SECONDARY.BUTTONS,
		navigation = DEFAULTS.SECONDARY.NAVIGATION,
		elevation = DEFAULTS.SECONDARY.ELEVATION,
	}
	function SecondaryMenuRowBarTopCenter:init(initialProps: { [string]: unknown })
		self._maid = Maid.new()
		local _fuse = ColdFusion.fuse(self._maid)
		local _Value = _fuse.Value
		self._internalStates = {
			style = _Value(self.defaultProps.style),
			title = _Value(self.defaultProps.title),
			buttons = _Value(self.defaultProps.buttons),
			navigation = _Value(self.defaultProps.navigation),
			elevation = _Value(self.defaultProps.elevation),
		}
		table.freeze(self._internalStates)
		for k, v in pairs(initialProps) do
			if self._internalStates[k] then
				self._internalStates[k]:Set(v)
			end
		end
		self._instance = Source.secondary(
			self._internalStates.style,
			self._internalStates.title,
			self._internalStates.buttons,
			self._internalStates.navigation,
			self._internalStates.elevation
		)
	end

	function SecondaryMenuRowBarTopCenter:render()
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
	function SecondaryMenuRowBarTopCenter:didMount()
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
	function SecondaryMenuRowBarTopCenter:willUnmount()
		self._maid:Destroy()
		self._instance:Destroy()
	end
	Interface.Secondary = SecondaryMenuRowBarTopCenter
end

do
	local TertiaryMenuRowBarTopCenter = Roact.Component:extend("TertiaryMenuRowBarTopCenter")
	TertiaryMenuRowBarTopCenter.defaultProps = {
		style = DEFAULTS.TERTIARY.STYLE,
		title = DEFAULTS.TERTIARY.TITLE,
		buttons = DEFAULTS.TERTIARY.BUTTONS,
		navigation = DEFAULTS.TERTIARY.NAVIGATION,
		elevation = DEFAULTS.TERTIARY.ELEVATION,
	}
	function TertiaryMenuRowBarTopCenter:init(initialProps: { [string]: unknown })
		self._maid = Maid.new()
		local _fuse = ColdFusion.fuse(self._maid)
		local _Value = _fuse.Value
		self._internalStates = {
			style = _Value(self.defaultProps.style),
			title = _Value(self.defaultProps.title),
			buttons = _Value(self.defaultProps.buttons),
			navigation = _Value(self.defaultProps.navigation),
			elevation = _Value(self.defaultProps.elevation),
		}
		table.freeze(self._internalStates)
		for k, v in pairs(initialProps) do
			if self._internalStates[k] then
				self._internalStates[k]:Set(v)
			end
		end
		self._instance = Source.tertiary(
			self._internalStates.style,
			self._internalStates.title,
			self._internalStates.buttons,
			self._internalStates.navigation,
			self._internalStates.elevation
		)
	end

	function TertiaryMenuRowBarTopCenter:render()
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
	function TertiaryMenuRowBarTopCenter:didMount()
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
	function TertiaryMenuRowBarTopCenter:willUnmount()
		self._maid:Destroy()
		self._instance:Destroy()
	end
	Interface.Tertiary = TertiaryMenuRowBarTopCenter
end

return Interface
