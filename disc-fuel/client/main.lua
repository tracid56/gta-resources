ESX = nil
local isAtGarage = true

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

    ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
    DecorRegister(Config.FuelDecor, 1)
    for _, station in pairs(Config.GasStations) do
        Citizen.Wait(0)
        local blip = {
            id = station.name,
            name = station.name,
            coords = station.coords,
            sprite = 361,
            color = 59,
            scale = 0.8
        }
        TriggerEvent('disc-base:registerBlip', blip)
    end
end)

--Track Distance from nearest Garage
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    end
end)

--Display Things
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = GetPlayerPed(-1)
        if isAtGarage then
            local playerCoords = GetEntityCoords(playerPed)
            local vehicle, distance = ESX.Game.GetClosestVehicle(playerCoords)
            if vehicle ~= nil and distance < 2 then
                local model = GetEntityModel(vehicle)
                local bone = GetBone(model)
                local vehicleCoords = GetEntityCoords(vehicle)
                local min, max = GetModelDimensions(model)
                local markerCoords = vector3(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + max.z + 0.5)
                if bone then
                    local boneIndex = GetEntityBoneIndexByName(vehicle, bone)
                    local boneCoords = GetWorldPositionOfEntityBone(vehicle, boneIndex)
                    markerCoords = vector3(boneCoords.x, boneCoords.y, boneCoords.z + max.z + 0.5)
                end
                local marker = {
                    name = 'fuel_up_marker',
                    show3D = true,
                    coords = markerCoords,
                    colour = { r = 255, b = 55, g = 55 },
                    size = vector3(max.x + 1, max.y + 1, 1.0),
                    action = function()
                        print('Fuel')
                    end,
                    msg = 'Press [E] to fuel up',
                }
                TriggerEvent('disc-base:registerMarker', marker)
            else
                TriggerEvent('disc-base:deleteMarker', 'fuel_up_marker')
                Citizen.Wait(100)
            end
        else
            Citizen.Wait(100)
            TriggerEvent('disc-base:deleteMarker', 'fuel_up_marker')
        end
    end
end)

function GetBone(model)
    if IsThisModelABike(model) then
        return 'wheel_lr'
    end

    if IsThisModelACar(model) then
        return 'wheel_lr'
    end

    if IsThisModelABoat(model) then
        return nil
    end

end

function GetFuel(vehicle)
    return DecorGetFloat(vehicle, Config.FuelDecor)
end

function SetFuel(vehicle, fuel)
    if type(fuel) == 'number' and fuel >= 0 and fuel <= 100 then
        SetVehicleFuelLevel(vehicle, fuel + 0.0)
        DecorSetFloat(vehicle, Config.FuelDecor, GetVehicleFuelLevel(vehicle))
    end
end


function startRefuel(vehicle)

end