RegisterServerEvent('tropic-carplay:playMusic')
AddEventHandler('tropic-carplay:playMusic', function(vehicleNetId, url, volume, radius)
    local owner = source
    TriggerClientEvent('tropic-carplay:startMusic', -1, vehicleNetId, url, volume, radius, owner)
end)

RegisterServerEvent('tropic-carplay:stopMusic')
AddEventHandler('tropic-carplay:stopMusic', function(vehicleNetId)
    TriggerClientEvent('tropic-carplay:stopMusic', -1)
end)
