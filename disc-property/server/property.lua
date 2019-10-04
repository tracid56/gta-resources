RegisterServerEvent('disc-property:sellProperty')
AddEventHandler('disc-property:sellProperty', function(property)
    MySQL.Async.execute('UPDATE disc_property SET sold = 0 WHERE name = @name', {
        ['@name'] = property.name
    })
    MySQL.Async.execute('DELETE FROM disc_property_owners WHERE name = @name', {
        ['@name'] = property.name
    })
    local player = ESX.GetPlayerFromId(source)
    player.addMoney(property.price * Config.ResellPercentage)
end)

ESX.RegisterServerCallback('disc-property:buyProperty', function(source, cb, property)
    local player = ESX.GetPlayerFromId(source)
    if player.getMoney() >= property.price * Config.BuyPercentage then
        MySQL.Async.execute('UPDATE disc_property SET sold = 1 WHERE name = @name', {
            ['@name'] = property.name
        })
        MySQL.Async.execute('INSERT INTO disc_property_owners (name, identifier, active, owner) VALUES (@name, @identifier, 1, 1)', {
            ['@name'] = property.name,
            ['@identifier'] = player.identifier
        })
        player.removeMoney(property.price * Config.BuyPercentage)
        cb(true)
    else
        cb(false)
    end
end)

RegisterServerEvent('disc-property:GiveKeys')
AddEventHandler('disc-property:GiveKeys', function(property, identifier)
    MySQL.Async.execute('INSERT INTO disc_property_owners (name, identifier, active, owner) VALUES (@name, @identifier, 1, 0)', {
        ['@name'] = property.name,
        ['@identifier'] = identifier
    })
end)

RegisterServerEvent('disc-property:TakeKeys')
AddEventHandler('disc-property:TakeKeys', function(property, identifier)
    MySQL.Async.execute('DELETE FROM disc_property_owners WHERE name = @name and identifier = @identifier', {
        ['@name'] = property.name,
        ['@identifier'] = identifier
    })
end)

ESX.RegisterServerCallback('disc-property:searchUsers', function(source, cb, value)
    MySQL.Async.fetchAll(
            [[SELECT *
                FROM users u
                JOIN disc_property_owners o on u.identifier = o.identifier
                WHERE (LOWER(u.firstname) = LOWER(@value) OR LOWER(u.lastname) = LOWER(@value)) and o.owner = 0]], {
                ['@value'] = value
            },
            function(results)
                cb(results)
            end)
end)

ESX.RegisterServerCallback('disc-property:getKeyUsers', function(source, cb, property)
    MySQL.Async.fetchAll(
            [[SELECT * FROM disc_property_owners o
            JOIN users u on u.identifier = o.identifier
            WHERE o.name = @name and o.owner = 0]], {
                ['@name'] = property.name
            },
            function(results)
                cb(results)
            end)
end)