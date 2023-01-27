local sprites = {}
for i, mod in ipairs(script:GetChildren()) do
	for k, v in pairs(require(mod)) do
		sprites[k] = v
	end
end
return sprites
