script.Name = 'Shared'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RainyLofi

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

Shared.Functions.PlaceFort = function(Fort, CF)
    RE:FireServer('PlaceFortification', {
        ['PlaceCF'] = CF,
        ['FortName'] = Fort
    })
end

Shared.Functions.ShootTank = function(Tank)
    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Tank.Position)
    OS.HitDamageable:FireServer(Tank)
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