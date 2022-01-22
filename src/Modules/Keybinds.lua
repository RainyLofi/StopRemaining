script.Name = 'Keybinds'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RainyLofi

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
    [Enum.KeyCode.KeypadZero] = function()
        SR.AFKFarming = not SR.AFKFarming
        if not SR.AFKFarming then
            Shared.Functions.NoClip(false)
        end
    end,
    [Enum.KeyCode.Three] = function()
        local Character = Player.Character; if not Character or not Character.Parent then return false end
        local HRP = Character:FindFirstChild('HumanoidRootPart'); if not HRP then return false end

        Shared.Functions.PlaceFort('Barbed Wire', HRP.CFrame * CFrame.new(0, _G.Setings.FortPlaceOffset, 0))
    end,
    [Enum.KeyCode.Four] = function()
        local Character = Player.Character; if not Character or not Character.Parent then return false end
        local HRP = Character:FindFirstChild('HumanoidRootPart'); if not HRP then return false end

        Shared.Functions.PlaceFort('Clap Bomb', HRP.CFrame * CFrame.new(0, _G.Setings.FortPlaceOffset, 0))
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