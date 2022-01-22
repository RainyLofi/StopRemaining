script.Name = 'ClientController'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RhythmeticShots

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
local PlayerScripts = Player:WaitForChild('PlayerScripts')

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local ServiceRemotes = ReplicatedStorage:WaitForChild('ServiceRemotes')

local SR = {
    AFKFarming = false,
    Stage = 'Unknown',

    Modules = {},

    CarryingItem = nil,
    Objectives = {},
    ObjectiveService = {
        UpdateCarryingItem = ServiceRemotes.ObjectiveService:WaitForChild('UpdateCarryingItem'),
        RemoveCarryingItem = ServiceRemotes.ObjectiveService:WaitForChild('RemoveCarryingItem'),
        AlreadyCarryingItem = ServiceRemotes.ObjectiveService:WaitForChild('AlreadyCarryingItem'),
        RegisterObjectiveMarkers = ServiceRemotes.ObjectiveService:WaitForChild('RegisterObjectiveMarkers'),
        ProgressedObjective = ServiceRemotes.ObjectiveService:WaitForChild('ProgressedObjective'),
        ObjectiveCompleted = ServiceRemotes.ObjectiveService:WaitForChild('ObjectiveCompleted'),
        HitDamageable = ServiceRemotes.ObjectiveService:WaitForChild('HitDamageable'),
    },

    InteractionService = {
        TryInteract = ServiceRemotes.InteractionService:WaitForChild('TryInteract'),
    },

    RE = ReplicatedStorage:WaitForChild('RE'),
    RF = ReplicatedStorage:WaitForChild('RF'),

    Client = PlayerScripts:WaitForChild('Client'),

    Signals = {},
} -- shared

SR.ClientEnv = getsenv(SR.Client)

_G.SR = SR

SR.Modules.Signal = _G.Import('Modules/Signal')
SR.Modules.Shared = _G.Import('Modules/Shared')

--------------------------------------------------------------------------------------------
_G.Import('Modules/Keybinds')
_G.Import('Modules/REHandler')

local OH = _G.Import('Modules/ObjectiveHandler')
game:GetService('RunService'):BindToRenderStep('OH', Enum.RenderPriority.Camera.Value, OH)

_G.Import('Modules/ClientOptimizer')