script.Name = 'Bus'

--[[

       _____ __              ____                       _       _
      / ___// /_____  ____  / __ \___  ____ ___  ____ _(_)___  (_)___  ____ _
      \__ \/ __/ __ \/ __ \/ /_/ / _ \/ __ `__ \/ __ `/ / __ \/ / __ \/ __ `/
     ___/ / /_/ /_/ / /_/ / _, _/  __/ / / / / / /_/ / / / / / / / / / /_/ /
    /____/\__/\____/ .___/_/ |_|\___/_/ /_/ /_/\__,_/_/_/ /_/_/_/ /_/\__, /
                  /_/                                               /____/

    -- Stop Remaining
    -- By: RhythmeticShots

    ObjectiveHandler
]]--
--------------------------------------------------------------------------------------------

local SR = _G.SR

local Modules = SR.Modules
local Signal, Signals = Modules.Signal, SR.Signals
local Shared = Modules.Shared

--------------------------------------------------------------------------------------------

local Objective = {}
Objective.BusMaterials = {
    'Can Package',
    'Generator',
    'Propane Tank',
    'Tool Box',
    'Water Jug'
}

Objective.PickupItem = function(Object)
    local SelectedItem = nil
    for _, Item in pairs(Object.Parent:GetChildren()) do
        if table.find(Objective.BusMaterials, Item.Name) then
            SelectedItem = Item
            break
        end
    end

    if SelectedItem then
        Shared.Functions.Teleport(SelectedItem.PrimaryPart.CFrame * CFrame.new(0, 3.5, 0))
        task.wait(.2)
        Shared.Functions.Pickup(SelectedItem, SelectedItem.PrimaryPart.Position, false)
        task.wait(.2)
    end
end

Objective.Run = function(Data)
    local Name, Object, Point = Data.Name, Data.Object, Data.Point
    if Object.Parent == nil or Point.Parent == nil then return end

    Shared.Functions.NoClip(true)

    local InteractPart = Object.Parent:FindFirstChild('Part'); if not InteractPart then return false end
    local SelectedItem = SR.CarryingItem

    if not SelectedItem then Objective.PickupItem() return end

    Shared.Functions.Teleport(InteractPart.CFrame * CFrame.new(0, 3.5, 0))
    task.wait(.2)
    Shared.Functions.PlaceItem(InteractPart.Position)
    task.wait(.2)
end

return Objective