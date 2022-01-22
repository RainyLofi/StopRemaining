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

for _, WeaponObj in pairs(Weapons:GetChildren()) do 
    if WeaponObj:IsA('ModuleScript') then
        local Weapon = require(WeaponObj)
        if Weapon and Weapon.Stats then
            Weapon.Stats.VerticleRecoil = math.rad(_G.Settings.Recoil)
            Weapon.Stats.HorizontalRecoil = math.rad(_G.Settings.Recoil)
            Weapon.Stats.RecoilShake = _G.Settings.Recoil
            Weapon.Stats.MaxPen = _G.Settings.Penetration

            if Weapon.Stats.WeaponType == 'Gun' and Weapon.Animations then
                for _, Animation in pairs(Weapon.Animations) do
                    for _, Part in pairs(Animation.Sequence) do
                        if Part.Time >= 0.3 then
                            Part.Time *= 0.4
                        elseif Part.Time >= 0.05 then
                            Part.Time = math.max(Part.Time * .8, 0.05)
                        end
                    end
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

local Headshotify = function(Zombie, Damage)
    warn('Headshotifying', Zombie.AI)
    Zombie.Special = 'H'

    local Attachment = Workspace.Terrain:FindFirstChild('Attachment')
    local Pos = Attachment.Position
    local Unit = (Attachment.Position - Pos).Unit

    local v15 = 1
    local v16 = 2.5
    local v17 = 1.2

    Zombie.Velocity = Unit.Unit * ((Damage - Damage * v15 * 0.5) * v16 * v17) -- there is some kind of check, it's very weird
end

local metatable = assert(getrawmetatable, "needs access to function 'getrawmetatable'")(game)
if setreadonly then
    setreadonly(metatable, false)
end

local enabled = {
	BindableEvent = false,
	BindableFunction = false,
	RemoteEvent = true,
	RemoteFunction = true
}

local methods = {
	BindableEvent = "Fire",
	BindableFunction = "Invoke",
	RemoteEvent = "FireServer",
	RemoteFunction = "InvokeServer"
}

local __namecall = __namecall or metatable.__namecall
local __index = __index or metatable.__index

local NameCallback = function(self, ...)
    if typeof(self) ~= "Instance" then
		return rconsoleerr(select(2, pcall(__index, self)))
	end

    warn('here')

    local Args = {...}
	local callerScript = rawget(getfenv(0), "script")
	callerScript = typeof(callerScript) == "Instance" and callerScript or nil

    if Args[1] == 'LL' then
        local WeaponModel, WeaponStats = Shared.Functions.GetWeaponModel()

        local Zombies = Args[2]
        for _, Zombie in pairs(Zombies) do
            if not Zombie.Special or Zombie.Special ~= 'H' then
                if Zombie.AI.Name == 'Burster' or Zombie.AI.Name == 'Bloater' then
                    Headshotify(Zombie, WeaponStats.Damage)
                elseif Zombie.AI.Name == 'Military' or Zombie.AI.Name == 'Riot' or Zombie.AI.Name == 'Hazmat' then
                    local HeadshotChance = math.random(1, 4)
                    if HeadshotChance == 1 then
                        Headshotify(Zombie, WeaponStats.Damage)
                    end
                else
                    local HeadshotChance = math.random(1, 8)
                    if HeadshotChance == 1 then
                        Headshotify(Zombie, WeaponStats.Damage)
                    end
                end
            end
        end

        return unpack({methods[self.ClassName](self, unpack(Args))})
    end

    return unpack({methods[self.ClassName](self, ...)})
end

NameCallback = newcclosure(NameCallback)
methods.BindableEvent = hookfunc(Instance.new("BindableEvent").Fire, NameCallback)
methods.BindableFunction = hookfunc(Instance.new("BindableFunction").Invoke, NameCallback)
methods.RemoteEvent = hookfunc(Instance.new("RemoteEvent").FireServer, NameCallback)
methods.RemoteFunction = hookfunc(Instance.new("RemoteFunction").InvokeServer, NameCallback)

local function IsAuthorized(self, index)
	return (index == "Fire" or index == "Invoke" or index == "FireServer" or index == "InvokeServer") and enabled[self.ClassName] and index ~= 'IsA'
end

function metatable:__namecall(...)
	local arguments = {...}
	local index = table.remove(arguments)
	if self and index and IsAuthorized(self, index) then
		return NameCallback(self, unpack(arguments))
	end
	return __namecall(self, ...)
end
metatable.__namecall = newcclosure(metatable.__namecall)

--------------------------------------------------------------------------------------------

while task.wait() do
    local UV = debug.getupvalues(ClientEnv.OnClientEvent)
    local Ammo = UV[4]

    for _, WeaponData in pairs(Ammo) do -- unlimited ammo
        if WeaponData.Name and Weapons:FindFirstChild(WeaponData.Name) and WeaponData.Pool then
            local GunData = require(Weapons:FindFirstChild(WeaponData.Name))
            if GunData and GunData.Stats and GunData.Stats.Pool then
                WeaponData.Pool = GunData.Stats.Pool
            end
        end
    end
end