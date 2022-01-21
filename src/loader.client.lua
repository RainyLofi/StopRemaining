--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RainyLofi
]]--
--------------------------------------------------------------------------------------------

_G.Settings = {
	SafeHeight = 12.4,
}

--------------------------------------------------------------------------------------------

_G.Import = function(Source: string, JSON: boolean)
	local RunService, HttpService = game:GetService('RunService'), game:GetService('HttpService')
	local Repo = 'https://raw.githubusercontent.com/RainyLofi/StopRemaining/main/src/'
	if JSON then
		return RunService:IsStudio() and HttpService:JSONDecode(script:WaitForChild(Source)) or HttpService:JSONDecode(game:HttpGet(Repo .. Source .. '.json', true))
	elseif RunService:IsStudio() then
		return require(script:WaitForChild(Source))
	else
		local Success, Result = pcall(function()
			return game:HttpGet(Repo .. Source .. '.lua', true)
		end)
		if Success then
			return loadstring(Result, Source)()
		else
			warn('Failed to get source', Repo .. Source .. '.lua')
		end
	end
end

_G.Import('init.client')