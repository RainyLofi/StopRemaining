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
Player:WaitForChild('PlayerGui')

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServiceRemotes = ReplicatedStorage:WaitForChild('ServiceRemotes')

local SR = {
    Stage = 'Unknown',

    Modules = {
        Signal = _G.Import('Modules/Signal'),
    },

    CarryingItem = nil,
    Objectives = {},
    ObjectiveService = {
        UpdateCarryingItem = ServiceRemotes.ObjectiveService:WaitForChild('UpdateCarryingItem'),
        RemoveCarryingItem = ServiceRemotes.ObjectiveService:WaitForChild('RemoveCarryingItem'),
        AlreadyCarryingItem = ServiceRemotes.ObjectiveService:WaitForChild('AlreadyCarryingItem'),
        RegisterObjectiveMarkers = ServiceRemotes.ObjectiveService:WaitForChild('RegisterObjectiveMarkers'),
        ProgressedObjective = ServiceRemotes.ObjectiveService:WaitForChild('ProgressedObjective'),
        ObjectiveCompleted = ServiceRemotes.ObjectiveService:WaitForChild('ObjectiveCompleted'),
    },

    RE = ReplicatedStorage:WaitForChild('RE'),
    RF = ReplicatedStorage:WaitForChild('RF'),

    Signals = {},
} -- shared
_G.SR = SR

--------------------------------------------------------------------------------------------

_G.Import('Modules/REHandler')
_G.Import('Modules/ObjectiveHandler')