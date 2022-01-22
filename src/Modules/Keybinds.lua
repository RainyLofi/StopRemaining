script.Name = 'Keybinds'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RhythmeticShots

    Keybinds
]]--
--------------------------------------------------------------------------------------------

local UIS = game:GetService('UserInputService')
local Workspace = game:GetService('Workspace')

local Players = game:GetService('Players')
local Player = Players.LocalPlayer

local SR = _G.SR

local Modules = SR.Modules
local Signal, Signals = Modules.Signal, SR.Signals
local Shared = Modules.Shared

local OS = SR.ObjectiveService

--------------------------------------------------------------------------------------------

local Keybinds = {
    [Enum.KeyCode.KeypadSix] = function()
        SR.AFKFarming = not SR.AFKFarming
        if not SR.AFKFarming then
            Shared.Functions.NoClip(false)
        end
    end,
}

UIS.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode then
        local Key = Input.KeyCode
        local Func = Keybinds[Key]
        local Textbox = UIS:GetFocusedTextBox()
        if Func and not Textbox then Func() end
    end
end)



return Keybinds