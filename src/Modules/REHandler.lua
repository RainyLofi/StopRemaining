script.Name = 'REHandler'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RhythmeticShots

    RE Handler
]]--
--------------------------------------------------------------------------------------------

local SR = _G.SR

local Modules = SR.Modules
local Signal, Signals = Modules.Signal, SR.Signals

local RE = SR.RE

--------------------------------------------------------------------------------------------

Signals.StageUpdated = Signal.new()

local ProcessRE = function(Purpose, Data)
    if Purpose == 'UpdateStage' then
        SR.Stage = Data.Stage; Signals.StageUpdated:Fire(Data)
    end
end

RE.OnClientEvent:Connect(function(Purpose, Data)
    if Purpose ~= 'Multi' then ProcessRE(Purpose, Data) return end
    for MultiPurpose, MultiData in pairs(Data) do ProcessRE(MultiPurpose, MultiData) end
end)