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
        Service = ServiceRemotes:WaitForChild('ObjectiveService'),
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
SR.Fire2 = debug.getupvalues(SR.ClientEnv.Fire2)

local PSM = PlayerScripts:WaitForChild('Modules')
local Other = PSM:WaitForChild('Other')
local Bullet = require(Other:WaitForChild('Bullet'))
local UpdateBullet = Bullet.Update
local Constants = debug.getconstants(UpdateBullet)
local DamageCode = Constants[#Constants]
if DamageCode and typeof(DamageCode) == 'string' then
    rconsoleprint('Using damage code' .. DamageCode)
    SR.DamageCode = DamageCode
else
    rconsoleprint('Failed to get damage code! ' .. tostring(DamageCode))
    warn('Failed to get damage code!', tostring(DamageCode))
    return
end

_G.SR = SR

SR.Modules.Signal = _G.Import('Modules/Signal')
SR.Modules.Shared = _G.Import('Modules/Shared')

--------------------------------------------------------------------------------------------
_G.Import('Modules/Keybinds')
_G.Import('Modules/REHandler')
_G.Import('Modules/ItemESP')

local OH = _G.Import('Modules/ObjectiveHandler')
game:GetService('RunService'):BindToRenderStep('OH', Enum.RenderPriority.Camera.Value, OH)

_G.Import('Modules/ClientOptimizer')
