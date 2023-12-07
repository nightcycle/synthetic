--!strict
-- https://github.com/material-foundation/material-color-utilities/blob/f5d03da60c268b43928f3a24d6bf499e2564d39a/typescript/hct/hct.ts
local Solver = require(script:WaitForChild("Solver"))
local Cam16 = require(script:WaitForChild("Cam16"))
local ColorUtils = require(script.Parent:WaitForChild("ColorUtils"))
local ViewingConditions = require(script.Parent:WaitForChild("ViewingConditions"))

type ViewingConditions = ViewingConditions.ViewingConditions

export type HCT = {
	__index: HCT,
	argb: number,
	_internalHue: number;
	_internalChroma: number;
	_internalTone: number;
	from: (hue: number, chroma: number, tone: number) -> HCT,
	fromInt: (argb: number) -> HCT,
	new: (argb: number) -> HCT,
	setHue: (self: HCT, newHue: number) -> (),
	setChroma: (self: HCT, newChroma: number) -> (),
	setTone: (self: HCT, newTone: number) -> (),
	getHue: (self: HCT) -> number,
	getChroma: (self: HCT) -> number,
	getTone: (self: HCT) -> number,
	toInt: (self: HCT) -> number,
	_setInternalState: (self: HCT, argb: number) -> (),
	inViewingConditions: (self: HCT, vc: ViewingConditions) -> (),
}

local HCT = {} :: HCT
HCT.__index = HCT

function HCT:toInt(): number
	return self.argb;
end

function HCT:getHue(): number
	return self.internalHue;
end

function HCT:setHue(newHue: number): ()
	self:_setInternalState(
		Solver.solveToInt(
			newHue,
			self._internalChroma,
			self._internalTone
		)
	)
end

function HCT:getChroma(): number
	return self._internalChroma;
end

function HCT:setChroma(newChroma: number): ()
	self:_setInternalState(
		Solver.solveToInt(
			self._internalHue,
			newChroma,
			self._internalTone
		)
	)
end

function HCT:getTone(): number
	return self._internalTone;
end

function HCT:setTone(newTone: number): ()
	self:_setInternalState(
		Solver.solveToInt(
			self._internalHue,
			self._internalChroma,
			newTone
		)
	)
end

function HCT:_setInternalState(argb: number)
	local cam = Cam16.fromInt(argb);
	self._internalHue = cam.hue;
	self._internalChroma = cam.chroma;
	self._internalTone = ColorUtils.lstarFromArgb(argb);
	self.argb = argb;
end

function HCT:inViewingConditions(vc: ViewingConditions): HCT
	local cam = Cam16.fromInt(self:toInt());
	local viewedInVc = cam.xyzInViewingConditions(vc);
	local recastInVc = Cam16.fromXyzInViewingConditions(
		viewedInVc[0],
		viewedInVc[1],
		viewedInVc[2],
		ViewingConditions.make()
	);
	local recastHct = HCT.from(
		recastInVc.hue,
		recastInVc.chroma,
		ColorUtils.lstarFromY(viewedInVc[1])
	);
	return recastHct;
end

function HCT.new(argb: number): HCT
	local cam = Cam16.fromInt(argb);
	local self: HCT = setmetatable({}, HCT) :: any
	self._internalHue = cam.hue;
	self._internalChroma = cam.chroma;
	self._internalTone = ColorUtils.lstarFromArgb(argb);
	self.argb = argb;
	return self
end

function HCT.from(hue: number, chroma: number, tone: number): HCT
	return HCT.new(Solver.solveToInt(hue, chroma, tone));
end

function HCT.fromInt(argb: number): HCT
	return HCT.new(argb);
end

return HCT