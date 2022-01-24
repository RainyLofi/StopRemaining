script.Name = 'ItemESP'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RhythmeticShots

    ItemESP
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

local Ignore = Workspace:WaitForChild('Ignore')
local Items = Ignore:WaitForChild('Items')

--------------------------------------------------------------------------------------------

local ESPItems = {
    'Body Armor',
    'Medkit',
    'Barbed Wire',
    'Energy Drink',
    'Bandages',
}

local CoreGui = game:GetService('CoreGui')

local ESPd = {}
local AddESP = function(Obj)
    if table.find(ESPd, Obj) then return end

    local Block = Obj.PrimaryPart
    local BG = Instance.new('BillboardGui', CoreGui)
    BG.AlwaysOnTop = true
    BG.Name = 'BG2'
    BG.Size = UDim2.new(0, 60, 0, 30)
    BG.StudsOffset = Vector3.new(0, 2, 0)
    BG.Adornee = Block

    local TL = Instance.new('TextLabel', BG)
    TL.Text = Obj.Name
    TL.BackgroundTransparency = 1
    TL.Size = UDim2.new(1, 0, 1, 0)
    TL.Font = 'Gotham'
    TL.TextScaled = true
    TL.TextColor3 = Color3.new(1, 1, 1)

    table.insert(ESPd, Obj)
    Obj.AncestryChanged:Connect(function()
        if table.find(ESPd, Obj) then
            table.remove(ESPd, table.find(ESPd, Obj))
        end
        if BG.Parent then BG:Destroy() end
    end)
end

Items.ChildAdded:Connect(function(Child)
    task.wait()
    if table.find(ESPItems, Child.Name) then AddESP(Child) end
end)