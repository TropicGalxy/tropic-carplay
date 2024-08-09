local isMusicPlaying = false
local musicOwner = nil
local currentVehicle = nil

lib.registerContext({
    id = 'car_music_menu',
    title = 'Car Music Menu',
    options = {
        {
            title = 'Play Music',
            icon = 'play',
            onSelect = function()
                OpenMusicInput()
            end
        },
        {
            title = 'Stop Music',
            icon = 'stop',
            onSelect = function()
                StopMusic()
            end,
        }
    }
})

RegisterCommand(Config.CommandName, function()
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        lib.showContext('car_music_menu')
    else
        lib.notify({ type = 'error', description = 'You must be in a vehicle to use this command.' })
    end
end, false)

function OpenMusicInput()
    if isMusicPlaying and musicOwner ~= GetPlayerServerId(PlayerId()) then
        lib.notify({ type = 'error', description = 'Music is already playing. Only the owner can change it.' })
        return
    end

    local input = lib.inputDialog('Play Music', {
        {type = 'input', label = 'Song (YouTube Link)', required = true},
        {type = 'number', label = 'Volume (0-100)', default = 50, min = 0, max = 100},
        {type = 'number', label = 'Radius (Max 20)', default = 10, min = 1, max = 20}
    })

    if input then
        local url, volume, radius = input[1], input[2], input[3]
        PlayMusic(url, volume, radius)
    end
end

function PlayMusic(url, volume, radius)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local vehicleNetId = NetworkGetNetworkIdFromEntity(vehicle)

    currentVehicle = vehicle
    TriggerServerEvent('tropic-carplay:playMusic', vehicleNetId, url, volume, radius)
end

function StopMusic()
    if not isMusicPlaying then return end

    local vehicleNetId = NetworkGetNetworkIdFromEntity(currentVehicle)
    TriggerServerEvent('tropic-carplay:stopMusic', vehicleNetId)
end

RegisterNetEvent('tropic-carplay:startMusic', function(vehicleNetId, url, volume, radius, owner)
    local vehicle = NetToVeh(vehicleNetId)
    if DoesEntityExist(vehicle) then
        local vehicleCoords = GetEntityCoords(vehicle)
        exports.xsound:PlayUrlPos('car_music', url, volume / 100, vehicleCoords)
        exports.xsound:Distance('car_music', radius)

        CreateThread(function()
            while isMusicPlaying do
                local vehicleCoords = GetEntityCoords(vehicle)
                exports.xsound:Position('car_music', vehicleCoords)
                Wait(100)
            end
        end)

        isMusicPlaying = true
        musicOwner = owner
        currentVehicle = vehicle

        lib.notify({ type = 'inform', description = 'Music started.' })
    end
end)

RegisterNetEvent('tropic-carplay:stopMusic', function()
    exports.xsound:Destroy('car_music')
    isMusicPlaying = false
    musicOwner = nil
    currentVehicle = nil

    lib.notify({ type = 'inform', description = 'Music stopped.' })
end)
