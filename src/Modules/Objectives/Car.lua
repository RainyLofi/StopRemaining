script.Name = 'Silverado'

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

Objective.DisplayTextToItem = function(CarName, Text)
    if Text == 'TIRE REQUIRED' then
        return CarName .. ' Wheel'
    elseif string.find(Text, 'FUEL') then
        return 'Jerry Can'
    elseif string.find(Text, 'SPARK PLUGS') then
        return 'Spark Plug'
    end
end

Objective.GetTasks = function(CarName, Objectives)
    local Tasks = {}
    for _, Part in pairs(Objectives:GetChildren()) do
        if Part.Name == 'Part' and Part:IsA('BasePart') and Part:FindFirstChild('DisplayText') then
            local DT = Part:FindFirstChild('DisplayText')
            local Item = Objective.DisplayTextToItem(CarName, DT.Value)
            if Item then
                table.insert(Tasks, {
                    Part = Part,
                    Item = Item
                })
            end
        end
    end
    return Tasks
end

Objective.PickupItem = function(Object)
    local Tasks = Objective.GetTasks(Object.Name, Object.Parent)
    if #Tasks <= 0 then return end

    local Task = Tasks[1]

    local SelectedItem = nil
    for _, Item in pairs(Object.Parent:GetChildren()) do
        if Item.Name == Task.Item and Item.PrimaryPart then
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
    if not SR.CarryingItem then
        Objective.PickupItem(Object)
        Shared.Functions.NoClip(false)
        return
    end

    local SelectedItem = SR.CarryingItem
    local Tasks = Objective.GetTasks(Object.Name, Object.Parent)
    if #Tasks <= 0 then
        warn('No tasks?')
        return
    end

    local Task = nil
    for _, T in pairs(Tasks) do
        if T.Item == SelectedItem then
            Task = T
            break
        end
    end

    if Task then
        Shared.Functions.Teleport(Task.Part.CFrame * CFrame.new(0, 3.5, 0))
        task.wait(.2)
        Shared.Functions.PlaceItem(Task.Part.Position)
        task.wait(.2)
    else
        warn('No task found for', SelectedItem)
    end
end

return Objective