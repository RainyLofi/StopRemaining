script.Name = 'ClientOptimizer'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RainyLofi

    ClientOptimizer
]]--
--------------------------------------------------------------------------------------------

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local FortInfo = require(ReplicatedStorage.Modules:WaitForChild('FortificationsInfo'))
local Weapons = require(ReplicatedStorage.Modules:WaitForChild('Weapon Modules'))

local UIS = game:GetService('UserInputService')
local Workspace = game:GetService('Workspace')

local Players = game:GetService('Players')
local Player = Players.LocalPlayer

local SR = _G.SR

local Modules = SR.Modules
local Signal, Signals = Modules.Signal, SR.Signals
local Shared = Modules.Shared

local ClientEnv = SR.ClientEnv

--------------------------------------------------------------------------------------------

while task.wait() do
    local UV = debug.getupvalues(ClientEnv.OnClientEvent)
    local Forts, Ammo = UV[3]['List'], UV[4]

    for Name, Fortification in pairs(FortInfo) do -- unlimited fortifications
        local Found = false
        for _, Fort in pairs(Forts) do
            if Fort.Name == Name then
                Found = true
            end
        end
        if not Found then
            table.insert(Forts, {
                Name = Name,
                Count = Fortification.Count
            })
        end
    end

    for _, WeaponData in pairs(Ammo) do -- unlimited ammo
        if WeaponData.Name and Weapons:FindFirstChild(WeaponData.Name) and WeaponData.Pool then
            local GunData = require(Weapons:FindFirstChild(WeaponData.Name))
            if GunData and GunData.Stats and GunData.Stats.Pool then
                WeaponData.Pool = GunData.Stats.Pool
            end
        end
    end
end