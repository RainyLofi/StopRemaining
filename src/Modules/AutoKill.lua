script.Name = 'AutoKill'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RhythmeticShots

    AutoKill
]]--
--------------------------------------------------------------------------------------------

local Players = game:GetService('Players')
local Player = Players.LocalPlayer

local Workspace = game:GetService('Workspace')

local SR = _G.SR

local Modules = SR.Modules
local Signal, Signals = Modules.Signal, SR.Signals
local Shared = Modules.Shared

local Entities = Workspace:WaitForChild('Entities')
local Zombies = Entities:WaitForChild('Infected')

local ShootZombie = Shared.Functions.ShootZombie

local OBJECTIVE_RANGE = 70 or _G.Settings.AutoKillObjectiveRange

--------------------------------------------------------------------------------------------

-- to avoid any weird checks on newly spawned zombies
local AvailableZombies = {}
local ZombieIsValid = function(Zombie, Search)
    if not Zombie.Parent or Zombie.Parent ~= Zombies then return end
    local HRP = Zombie:FindFirstChild('HumanoidRootPart'); if not HRP then return end
    local Hum = Zombie:FindFirstChild('Humanoid'); if not Hum then return end
    if Hum.Health <= 0 then return end

    if Search then return table.find(AvailableZombies, Zombie) ~= nil end

    return true
end
local AcceptZombie = function(Zombie)
    local HRP = Zombie:FindFirstChild('HumanoidRootPart'); if not HRP then return end
    local Hum = Zombie:FindFirstChild('Humanoid'); if not Hum then return end

    local Poof = function()
        if table.find(AvailableZombies, Zombie) then
            table.remove(AvailableZombies, table.find(AvailableZombies, Zombie))
        end
    end

    Zombie.AncestryChanged:Connect(Poof)
    Hum.Died:Connect(Poof)
end
Zombies.ChildAdded:Connect(function(Zombie)
    task.wait(5)
    if ZombieIsValid(Zombie) then AcceptZombie(Zombie) end
end)

local ZombiesInRange = function(Pos, Range)
    local Candidates = {}
    for _, Zombie in pairs(AvailableZombies) do
        local ZHRP = Zombie:FindFirstChild('HumanoidRootPart')
        if ZHRP and not Zombie:FindFirstChild('Debounce') then
            local Distance = (Pos - ZHRP.Position).Magnitude
            if Distance <= Range then
                table.insert(Candidates, Zombie)
            end
        end
    end
    return Candidates
end

local AFK = function() -- goes out of its way to find zombies
    local Character = Player.Character; if not Character then return end
    local HRP = Character:FindFirstChild('HumanoidRootPart'); if not HRP then return end

    local Zombs = Zombies:GetChildren()
    if #Zombs == 0 then return end

    local RandomZombie = Zombs[math.random(1, #Zombs)]
    if not RandomZombie then return end --? lol
    if not RandomZombie:FindFirstChild('HumanoidRootPart') then return end

    local ZHRP = RandomZombie:FindFirstChild('HumanoidRootPart')
    local ZCF = CFrame.new(ZHRP.Position) * CFrame.new(0, _G.Settings.SafeHeight, 0)

    Shared.Functions.NoClip(true)
    local Part = Shared.Functions.FloatingPart()
    Part.CFrame = ZCF * CFrame.new(0, -3.5, 0)
    Shared.Functions.Teleport(ZCF)

    SR.AFKKilling = true

    local Candidates = ZombiesInRange(ZCF.Position, OBJECTIVE_RANGE)
    for _, Candidate in pairs(Candidates) do
        local Debounce = Instance.new('Model', Candidate)
        Debounce.Name = 'Debounce'
        game:GetService('Debris'):AddItem(Candidate, 3)
        if ZombieIsValid(Candidate, true) then
            for _ = 1, 4 do ShootZombie(Candidate) end
        end
    end

    task.wait(1)
    SR.AFKKilling = false
end

local Objective = function() -- just kills any zombies that come near the player
    local Character = Player.Character; if not Character then return end
    local HRP = Character:FindFirstChild('HumanoidRootPart'); if not HRP then return end

    local Candidates = ZombiesInRange(HRP.Position, OBJECTIVE_RANGE)
    for _, Candidate in pairs(Candidates) do
        local Debounce = Instance.new('Model', Candidate)
        Debounce.Name = 'Debounce'
        game:GetService('Debris'):AddItem(Candidate, 3)

        if ZombieIsValid(Candidate, true) then
            for _ = 1, 4 do ShootZombie(Candidate) end
        end
    end
end

return {
    Objective = Objective,
    AFK = AFK
}