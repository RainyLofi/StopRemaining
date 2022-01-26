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

--------------------------------------------------------------------------------------------

local PlayerConnection = function(Plr, AlreadyPlaying)
    task.wait()

    if _G.Settings.NoNewPlayers and SR.AFKFarming and not AlreadyPlaying then
        Player:Kick('Unauthorised player joined, perhaps a mod. Automatically left the game quickly to be safe.')
    else
        local Rank = Plr:GetRankInGroup(2838077)
        if Rank > 1 then
            Player:Kick('Tester or moderator player is in server. Rank: ' .. Rank .. ' in peak studios. Username:' .. Plr.Name .. '.')
        end
    end
end

task.spawn(function()
    Players.PlayerAdded:Connect(function(Plr)
        PlayerConnection(Plr, false)
    end)

    for _, Plr in pairs(Players:GetPlayers()) do
        PlayerConnection(Plr, true)
    end
end)

--------------------------------------------------------------------------------------------

SR.ClientEnv = getsenv(SR.Client)
SR.Fire2 = debug.getupvalues(SR.ClientEnv.Fire2)

local PSM = PlayerScripts:WaitForChild('Modules')
local Other = PSM:WaitForChild('Other')
local Bullet = require(Other:WaitForChild('Bullet'))
local UpdateBullet = Bullet.Update
local Constants = debug.getconstants(UpdateBullet)
local DamageCode = Constants[#Constants]
if DamageCode and typeof(DamageCode) == 'string' then
    rconsoleprint('\nUsing damage code ' .. DamageCode)
    warn('Using damage code', DamageCode)
    SR.DamageCode = DamageCode
else
    rconsoleprint('\nFailed to get damage code! ' .. tostring(DamageCode))
    warn('Failed to get damage code!', tostring(DamageCode))
    return
end

_G.SR = SR

SR.Modules.Signal = _G.Import('Modules/Signal')
SR.Modules.Shared = _G.Import('Modules/Shared')
SR.Modules.AutoKill = _G.Import('Modules/AutoKill')

--------------------------------------------------------------------------------------------

_G.Import('Modules/Keybinds')
_G.Import('Modules/REHandler')
_G.Import('Modules/ItemESP')

local OH = _G.Import('Modules/ObjectiveHandler')
game:GetService('RunService'):BindToRenderStep('OH', Enum.RenderPriority.Camera.Value, OH)
game:GetService('RunService'):BindToRenderStep('AUTOKILL', Enum.RenderPriority.Camera.Value + 1, function()
    if SR.AFKFarming and SR.Stage == 'Game' then
        if #SR.Objectives > 0 then
            SR.Modules.AutoKill.Objective() -- kill zombies that come close
        else
            SR.Modules.AutoKill.AFK() -- go to zombies and kill them all
        end
    end
end)

_G.Import('Modules/ClientOptimizer')
