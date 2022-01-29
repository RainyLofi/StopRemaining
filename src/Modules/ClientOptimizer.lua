script.Name = 'ClientOptimizer'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RhythmeticShots

    ClientOptimizer
]]--
--------------------------------------------------------------------------------------------

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local FortInfo = require(ReplicatedStorage.Modules:WaitForChild('FortificationsInfo'))
local Weapons = ReplicatedStorage.Modules:WaitForChild('Weapon Modules')

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

local GetTime = function(Animation)
    local Time = 0
    for _, Part in pairs(Animation.Sequence) do
        if Part.Time then Time += Part.Time end
    end
    return Time
end

for _, WeaponObj in pairs(Weapons:GetChildren()) do
    if WeaponObj:IsA('ModuleScript') then
        local Weapon = require(WeaponObj)
        if Weapon and Weapon.Stats then
            Weapon.Stats.VerticleRecoil = math.rad(_G.Settings.Recoil)
            Weapon.Stats.HorizontalRecoil = math.rad(_G.Settings.Recoil)
            Weapon.Stats.RecoilShake = _G.Settings.Recoil

            if Weapon.Stats.WeaponType == 'Gun' and Weapon.Animations then
                for Name, Animation in pairs(Weapon.Animations) do

                    if Name == 'Reload' then -- reload is 90% (10% faster)
                        for _, Part in pairs(Animation.Sequence) do
                            Part.Time = Part.Time * 0.9
                        end
                    else
                        for _, Part in pairs(Animation.Sequence) do
                            if Part.Time >= 0.3 then
                                Part.Time *= 0.4
                            elseif Part.Time >= 0.05 then
                                Part.Time = math.max(Part.Time * .8, 0.05)
                            end
                        end
                    end

                    --[[if GetTime(Animation) >= 1.4 then
                        for _, Part in pairs(Animation.Sequence) do
                            if Part.Time >= 0.3 then
                                Part.Time *= 0.8
                            elseif Part.Time >= 0.05 then
                                Part.Time = math.max(Part.Time * .5, 0.05)
                            end
                        end
                    end]]--

                end
                --[[if Weapon.Animations and Weapon.Animations.Reload then
                    local Reload = Weapon.Animations.Reload
                    for _, Part in pairs(Reload.Sequence) do
                        if Part.Time >= 0.3 then
                            Part.Time *= 0.4
                        elseif Part.Time >= 0.05 then
                            Part.Time = math.max(Part.Time * .8, 0.05)
                        end
                    end
                end]]--
            end

            --[[if Weapon.Stats.Type == 'Flamethrower' then
                Weapon.Stats.Range = 250
            end]]--
        end
    end
end

--------------------------------------------------------------------------------------------

local OldNameCall
OldNameCall = hookmetamethod(game, "__namecall", function(self, ...) -- auto headshot
    if checkcaller() then return OldNameCall(self, ...) end

    local Args = {...}
    local Method = getnamecallmethod()

    if Method == 'FireServer' then
        if Args[1] == SR.DamageCode then
            local Zombies = Args[2]
            for _, Zombie in pairs(Zombies) do
                if not Zombie.Special or Zombie.Special ~= 'H' then
                    Shared.Functions.HeadshotChance(Zombie)
                end
            end
        end
    end

    return OldNameCall(self, unpack(Args))
end)

--------------------------------------------------------------------------------------------

task.spawn(function() -- unlimited ammo
    while task.wait() do
        local UV = debug.getupvalues(ClientEnv.OnClientEvent)
        local Ammo = UV[4]

        for _, WeaponData in pairs(Ammo) do
            if WeaponData.Name and Weapons:FindFirstChild(WeaponData.Name) and WeaponData.Pool then
                local GunData = require(Weapons:FindFirstChild(WeaponData.Name))
                if GunData and GunData.Stats and GunData.Stats.Pool then
                    WeaponData.Pool = GunData.Stats.Pool
                end
            end
        end
    end
end)