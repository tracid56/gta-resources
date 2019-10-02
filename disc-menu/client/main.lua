local menus = {}

RegisterNetEvent('disc-menu:open')
AddEventHandler('disc-menu:open', function(data)
    local menu = {
        open = function()
            SendNUIMessage({
                action = 'openMenu',
                data = data
            })
        end,
        close = {
            SendNUIMessage({
                action = 'closeMenu',
                data = data
            })
        }
    }
end)
