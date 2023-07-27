--!strict
-- Services
-- Packages
local TestEZ = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("TestEZ"))
-- Types
-- Constants
-- Variables
-- References
local Client = game:GetService("ReplicatedStorage"):WaitForChild("Client") :: Folder
local Shared = game:GetService("ReplicatedStorage"):WaitForChild("Shared") :: Folder
local Server = game:GetService("ServerScriptService"):WaitForChild("Server") :: Folder

type TestData = {
	children: {[number]: TestData},
	errors: {[number]: string},
	planNode: TestData?,
	plan: TestData,
	phrase: string?,
	status: "Failure" | "Success" | nil,
}

local result = "test-run result:"

function parseResults(data: TestData, path: string)
	if data.planNode and data.status then
		if data.planNode.phrase then
			path ..= "/"..data.planNode.phrase
			if #data.children == 0 then
				if path then
					local pathKeys = path:split("/")
					local finalKeys = {}
					for i, key in ipairs(pathKeys) do
						if finalKeys[#finalKeys] ~= key and key ~= "" then
							table.insert(finalKeys, key)
						end
					end
					local finalPath = table.concat(finalKeys, "/")
					local basePath = "\n["..data.status:lower().."]:["..finalPath.."]"
					if #data.errors > 0 then
						for i, errorMessage in ipairs(data.errors) do
							local finalLine = errorMessage:split("\n")[1]
							local content = (finalLine:split(":")[3]):sub(2)
							content = content:gsub("\"", "'")
							result ..= basePath..":[\""..content.."\"]"
						end
					else
						result ..= basePath
					end
				end
			end
		end
	end
	for i, child in ipairs(data.children) do
		parseResults(child, path)
	end
end

-- Class
function test()
	local function testDomain(domain: Folder)
		local domainPath = domain:GetFullName()
		for i, inst in ipairs(domain:GetDescendants()) do
			if inst:IsA("ModuleScript") and inst.Name:find(".spec") then
				TestEZ.run(inst, function(data: TestData)
					local modPath = inst:GetFullName()
					local filteredPath = modPath:gsub(domainPath, "")
					local path = filteredPath:gsub(inst.Name, ""):gsub("%.", "/"):gsub("//", "/")
					-- print(inst.Name, ":", filteredPath, ": ", path)
					parseResults(data, domain.Name:lower()..path)
				end)
			end
		end
	end
	testDomain(Client)
	testDomain(Shared)
	testDomain(Server)
	
	error(result)
	-- return result
end

return test()