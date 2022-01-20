script.Name = 'ClientController'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RainyLofi

    Client Controller
]]--
--------------------------------------------------------------------------------------------

-- Wait for game to load.
local Players = game:GetService('Players')
repeat task.wait() until Players and Players.LocalPlayer and game.PlaceId

--------------------------------------------------------------------------------------------

-- Setup shared variables
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild('PlayerGui')

local StopRemaining = {
    Modules = {
        Signal = _G.Import('Modules/Signal'),

    }

} -- shared
_G.SR = StopRemaining

