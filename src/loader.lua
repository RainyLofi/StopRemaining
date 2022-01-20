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

}

--------------------------------------------------------------------------------------------

_G.Import = function(Source: string, JSON: boolean)
	local RunService, HttpService = game:GetService('RunService'), game:GetService('HttpService')
	local Repo = 'https://raw.githubusercontent.com/RainyLofi/StopRemaining/main/new/'
	if JSON then
		return RunService:IsStudio() and HttpService:JSONDecode(script:WaitForChild(Source)) or HttpService:JSONDecode(game:HttpGet(Repo .. Source .. '.json', true))
	elseif RunService:IsStudio() then
		return require(script:WaitForChild(Source))
	else
		return loadstring(game:HttpGet(Repo .. Source .. '.lua', true), Source)()
	end
end

_G.Import('init.client')