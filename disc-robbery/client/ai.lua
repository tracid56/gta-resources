local trackedPeds = {}
local isRobbing = false

Citizen.CreateThread(function()
    SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
end)

Citizen.CreateThread(function()
    if not Config.AIRobbery.Allow then
        return
    end

    local playerPed = GetPlayerPed(-1)
    local player = PlayerId()
    while true do
        Citizen.Wait(0)
        if IsPlayerFreeAiming(player) then
            local found, entity = GetEntityPlayerIsFreeAimingAt(player)
            local entityCoords = GetEntityCoords(entity)
            local playerCoords = GetEntityCoords(playerPed)
            local distance = GetDistanceBetweenCoords(entityCoords, playerCoords)
            ClearTrackedPeds(entity)
            if found and IsEntityAPed(entity) and canRobPed(entity) and distance < 5 and not isRobbing then
                print('Robbing')
                ClearPedTasksImmediately(entity)
                Rob(entity)
                isRobbing = true
            end
        else
            ClearTrackedPeds()
            isRobbing = false
        end
    end
end)


function canRobPed(ped)
    return not IsPedAPlayer(ped)
end

function ClearTrackedPeds(ped)
    for k, v in pairs(trackedPeds) do
        if k ~= ped then
            ResetPed(k)
            trackedPeds[k] = nil
        end
    end
end

function ResetPed(ped)
    --ClearPedSecondaryTask(ped)
end

function Rob(entity)
    local playerPed = GetPlayerPed(-1)
    FreezeEntityPosition(entity, true)
    TaskHandsUp(entity, 100000, 0, 0, true)
    AddShockingEventAtPosition(99, GetEntityCoords(entity),0.5)
    Citizen.Wait(Config.AIRobbery.Duration)
    print('Done')
    isRobbing = false
end