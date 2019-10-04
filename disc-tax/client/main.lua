RegisterNetEvent('disc-tax:notifyOfPay')
AddEventHandler('disc-tax:notifyOfPay', function(amount)
    exports['mythic_notify']:DoHudText('inform', 'You payed tax: $' .. amount)
end)