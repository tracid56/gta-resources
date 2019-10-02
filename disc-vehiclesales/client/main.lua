ESX = nil

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

    for k, v in pairs(Config.Shops) do
        local marker = {
            name = v.name .. '_vehicleshop',
            type = 1,
            coords = v.coords,
            colour = { r = 55, b = 255, g = 55 },
            size = vector3(1.5, 1.5, 1.0),
            msg = 'Press ~INPUT_CONTEXT~ to open Shop',
            action = openShopMenu,
            shouldDraw = function()
                return ESX.PlayerData.job.name == 'cardealer' or not Config.PlayerManaged
            end
        }
        TriggerEvent('disc-base:registerMarker', marker)
    end

end)

function openShopMenu()
    local options = {
        { label = 'Buy Vehicle', action = showBuyVehicleMenu }
    }

    local menu = {
        title = 'Vehicle Shop',
        name = 'vehicle_shop_menu',
        options = options
    }

    TriggerEvent('disc-base:openMenu', menu)

end