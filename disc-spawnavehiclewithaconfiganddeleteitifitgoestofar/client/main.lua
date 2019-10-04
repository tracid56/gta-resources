ESX = nil

local vehicle
local spawn

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

Citizen.CreateThread(function()
    for k, v in pairs(Config.Spawners) do
        local marker = {
            name = v.name .. '_spawn',
            coords = v.coords,
            show3D = true,
            size = vector3(1.0, 1.0, 1.0),
            msg = 'Press [E] to spawn a vehicle',
            action = function()
                ShowVehicleMenu(v)
            end,
            shouldDraw = function()
                return vehicle == nil
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)

        local marker = {
            name = v.name .. '_store',
            coords = v.coords,
            show3D = true,
            size = vector3(2.0, 2.0, 1.0),
            msg = 'Press [E] to return the vehicle',
            action = function()
                ReturnVehicle()
            end,
            shouldDraw = function()
                return not not vehicle
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end
end)

function ShowVehicleMenu(config)
    local options = {}

    for k, v in pairs(config.vehicles) do
        table.insert(options, {
            label = v.name,
            action = function()
                SpawnVehicle(v.model, config.coords, config.heading)
                ESX.UI.Menu.CloseAll()
            end
        })
    end

    local menu = {
        name = 'spawn_vehicle',
        title = config.name,
        options = options
    }

    TriggerEvent('disc-base:openMenu', menu)

end

function SpawnVehicle(model, coords, heading)
    if ESX.Game.IsSpawnPointClear(coords, 3.0) then
        ESX.Game.SpawnVehicle(model, coords, heading, function(cbVeh)
            vehicle = cbVeh
            spawn = coords
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), vehicle, -1)
        end)
    else
        exports['mythic_notify']:DoHudText('error', 'No space to spawn!')
    end
end

function ReturnVehicle()
    ESX.Game.DeleteVehicle(vehicle)
    vehicle = nil
    spawn = nil
end

Citizen.CreateThread(function()
    while true do
        if vehicle and not DoesEntityExist(vehicle) then
            ReturnVehicle()
        end

        if vehicle and spawn then
            local vehicleCoords = GetEntityCoords(vehicle)
            if GetDistanceBetweenCoords(vehicleCoords, spawn) > Config.DriveDistance then
                ReturnVehicle()
            end
            Citizen.Wait(100)
        else
            Citizen.Wait(500)
        end
    end
end)

