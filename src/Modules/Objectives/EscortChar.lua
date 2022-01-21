script.Name = 'Escort'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RainyLofi

    ObjectiveHandler
]]--
--------------------------------------------------------------------------------------------

local SR = _G.SR

local Modules = SR.Modules
local Signal, Signals = Modules.Signal, SR.Signals
local Shared = Modules.Shared

--------------------------------------------------------------------------------------------

local Objective = {}
Objective.Run = function(Data)
    local Name, Object, Point = Data.Name, Data.Object, Data.Point
    if Object.Parent == nil or Point.Parent == nil then return end

    Shared.Functions.NoClip(true)
    local Part = Shared.Functions.FloatingPart()
    local Target = Object.PrimaryPart

    local CF = CFrame.new(Target.Position) * CFrame.new(0, _G.Settings.SafeHeight, 0)
    Part.CFrame = CF * CFrame.new(0, -3.5, 0)
    Shared.Functions.Teleport(CF)
end

return Objective