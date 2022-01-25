script.Name = 'Shared'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RhythmeticShots

    Shared
]]--
--------------------------------------------------------------------------------------------

local Players = game:GetService('Players')
local Player = Players.LocalPlayer

local Workspace = game:GetService('Workspace')
local Ignore = Workspace:WaitForChild('Ignore')
local Camera = Workspace.CurrentCamera

local RunService = game:GetService('RunService')

local SR = _G.SR

local Modules = SR.Modules
local Signal, Signals = Modules.Signal, SR.Signals

local RE = SR.RE
local RF = SR.RF
local IS = SR.InteractionService
local OS = SR.ObjectiveService

--------------------------------------------------------------------------------------------

local Shared = {
    Functions = {},
}

Shared.Functions.Teleport = function(CF)
    if not Player.Character or SR.Stage ~= 'Game' then return end
    local Character = Player.Character

    for _, Child in pairs(Character:GetChildren()) do
        if Child:IsA('BasePart') then
            local Connections = getconnections(Child.Changed)
            for _, Con in pairs(Connections) do
                Con:Disable()
            end
        end
    end

    if Character.PrimaryPart then
        Character:SetPrimaryPartCFrame(CF)
    end
end

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Weapons = ReplicatedStorage.Modules:WaitForChild('Weapon Modules')
Shared.Functions.GetWeaponModel = function()
    local Data = SR.Fire2[3]
    local Objs = Data['Objs']
    local WeaponModel, WeaponStats = nil, nil

    if Objs and Objs['WeaponModel'] then
        WeaponModel = Objs['WeaponModel']
        local Module = Weapons:FindFirstChild(WeaponModel.Name)
        if Module then WeaponStats = require(Module).Stats end
    end
    return WeaponModel, WeaponStats
end

Shared.Functions.FloatingPart = function()
    if Shared.FloatingPart and Shared.FloatingPart.Parent then
        return Shared.FloatingPart
    end

    local Part = Instance.new('Part', Ignore)
    Part.Size = Vector3.new(15, 1, 15)
    Part.Anchored = true
    Part.Transparency = 0.7
    Part.CanCollide = true
    Shared.FloatingPart = Part

    return Shared.FloatingPart
end

local ReplicatedStorage = game:GetService('ReplicatedStorage')
Shared.Functions.PlaceFort = function(Fort, CF)
    if typeof(CF) == 'Instance' then
        local Clone = ReplicatedStorage.Models.Fortifications[Fort]:Clone()
        CF = CF.CFrame * CFrame.new(0, _G.Settings.FortPlaceOffset + Clone.BoundingBox.Size.y / 2, 0)
    end

    RE:FireServer('PlaceFortification', {
        ['PlaceCF'] = CF,
        ['FortName'] = Fort
    })
end

Shared.Functions.ShootTank = function(Tank)
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Tank.Position)
    OS.HitDamageable:FireServer(Tank)
end

Shared.Functions.ShootZombie = function(Zombie)
    local Model, Stats = Shared.Functions.GetWeaponModel()
    local Character = Player.Character; if not Character then return false end
    local HRP = Character:FindFirstChild('HumanoidRootPart'); if not HRP then return false end
    local ZHRP = Zombie.PrimaryPart; if not ZHRP then return false end

    RE:FireServer(
        "GlobalReplicate",
        {
            ["Type"] = "Fire",
            ["RecoilScale"] = 1,
            ["RandomX"] = 0,
            ["Mag"] = Stats.Mag,
            ["PosCF"] = CFrame.new(177.8526, 31.8774776, -5.82643795, -0.966366649, -0.0201128013, 0.256380558, 6.06448557e-05, 0.996919155, 0.0784359053, -0.257168263, 0.0758133903, -0.963388205),
            ["Direction"] = Vector3.new(-0.25638055801392, -0.078435905277729, 0.96338820457458)
        }
    )

    RE:FireServer(
        "bb",
        {
            {
                ["AI"] = Zombie,
                ["Velocity"] = (HRP.Position - ZHRP.Position).Unit --Vector3.new(-8.4605493545532, -2.5883860588074, 31.791812896729)
            }
        }
    )
    return true
end

Shared.Functions.Pickup = function(Obj, Pos, CheckInteract)
    if Pos then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Pos) task.wait() end
    IS.TryInteract:FireServer()

    if CheckInteract then
        RF:InvokeServer(
            'CheckInteract',
            {
                ['Target'] = {
                    ['Mag'] = math.random(3.234, 4.567), -- magnitude/distance
                    ['Type'] = 'Item',
                    ['CanInteract'] = true,
                    ['Obj'] = Obj
                }
            }
        )
    end
end

Shared.Functions.PlaceItem = function(Pos)
    if Pos then Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Pos) task.wait() end
    IS.TryInteract:FireServer()
end

Shared.NoClip = false
Shared.Functions.NoClip = function(State) Shared.NoClip = State end

RunService.Stepped:Connect(function()
    local Character = Player.Character
    if not Character then return end

    local Humanoid = Character:FindFirstChild('Humanoid')
    if not Humanoid then return end

    if Shared.NoClip then
        for _, Part in pairs(Character:GetDescendants()) do
            if Part:IsA('BasePart') and Part.CanCollide then
                Part.CanCollide = false
            end
        end
    end
end)

return Shared