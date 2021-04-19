local plateTable = {}
local allowedToUse = false
local directions = {
    North = 360, 0,
    East = 270,
    South = 180,
    West = 90
  }

Citizen.CreateThread(function()
    TriggerServerEvent("Prefech:checkPerms", GetPlayerServerId(PlayerId()))
end)

RegisterNetEvent("Prefech:getPerms")
AddEventHandler("Prefech:getPerms", function(_isAllowed)
    isAllowed = _isAllowed
end)

RegisterNetEvent('Prefech:sendPlates')
AddEventHandler('Prefech:sendPlates', function(_plateTable)
	plateTable = _plateTable
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        alertSend = false
        while insideCameraZone() do
            Citizen.Wait(500)
            if IsPedInAnyVehicle(GetPlayerPed(PlayerId()), true) then
                local vehicle = GetVehiclePedIsIn(GetPlayerPed(PlayerId()))
                if(GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1)) then
                    if has_value(plateTable, GetVehicleNumberPlateText(vehicle):upper():gsub("%s+","")) then
                        SetHornEnabled(vehicle, true)
                        local coords = GetEntityCoords(vehicle)
                        if(alertSend == false) then
                            TriggerServerEvent('Prefech:sendblip', coords.x, coords.y, coords.z)
                            TriggerServerEvent('Prefech:sendalert', coords.x, coords.y, coords.z, GetVehicleNumberPlateText(vehicle), GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)), GetEntityHeading(vehicle))
                            local var1 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
                            hash1 = GetStreetNameFromHashKey(var1);
                            heading = GetEntityHeading(vehicle);		
                            for k, v in pairs(directions) do
                                if (math.abs(heading - v) < 45) then
                                    heading = k;
                            
                                    if (heading == 1) then
                                        heading = 'North';
                                        break;
                                    end

                                    break;
                                end
                            end
                            local string = "**"..Config.Notification
                            local string = string:gsub("\n","\n")
                            local string = string:gsub("{{Plate}}",""..GetVehicleNumberPlateText(vehicle).."")
                            local string = string:gsub("{{Vehicle_Name}}",""..GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)).."")
                            local string = string:gsub("{{Street_Name}}",""..hash1.."")
                            local string = string:gsub("{{Heading}}",""..heading.."")
                            if Config.JD_logs then
                                exports.JD_logs:discord(string, 0, 0, Config.LogsColor, Config.LogsChannelCommands)
                            end
                            alertSend = true
                        end
                        Citizen.Wait(2000)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    if Config.CameraBlips then
        for i = 1, #Config.Zones do
            local Zone = Config.Zones[i]
            blip = AddBlipForCoord(Zone[1],Zone[2],Zone[3])
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Smart Camera")
            EndTextCommandSetBlipName(blip)
        end 
    end
end)

RegisterNetEvent("Prefech:trackerset")
AddEventHandler("Prefech:trackerset", function(x, y, z)
    if(isAllowed) then
        local blip = AddBlipForCoord(x, y, z)
        SetBlipFlashes(blip, true)
        SetBlipSprite(blip, 326)
        SetBlipColour(blip, 1)
        Citizen.Wait(Config.BlipTime * 1000)
        RemoveBlip(blip)
    end
end)

RegisterNetEvent("Prefech:alertsend")
AddEventHandler("Prefech:alertsend", function(x, y, z, plate, model, heading, postal)
    local veh = NetworkGetEntityFromNetworkId(veh)
    if(isAllowed) then
        local var1 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		hash1 = GetStreetNameFromHashKey(var1);
        		
        for k, v in pairs(directions) do
           if (math.abs(heading - v) < 45) then
                heading = k;
        
                if (heading == 1) then
                    heading = 'North';
                    break;
                end

                break;
            end
        end
        local string = Config.Notification
        local string = string:gsub("\n","~w~\n")
        local string = string:gsub("{{Plate}}","~y~"..plate.."~w~")
        local string = string:gsub("{{Vehicle_Name}}","~y~"..model.."~w~")
        local string = string:gsub("{{Street_Name}}","~y~"..hash1.."~w~")
        local string = string:gsub("{{Heading}}","~y~"..heading.."~w~")
        local string = string:gsub("{{Postal}}","~y~"..postal.."~w~")
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(string)
        EndTextCommandThefeedPostMessagetext("CHAR_CALL911", "CHAR_CALL911", 0, 0, "Prefech ALPR System", "Vehcile: ~y~"..model.."~w~, Plate: ~y~"..plate.." ~w~")
        EndTextCommandDisplayText(0.5, 0.5)
        PlaySound(-1, "Menu_Accept", "Phone_SoundSet_Default", 0, 0, 1)
    end
end)

function insideCameraZone()
    local oddNodes = false
    for i = 1, #Config.Zones do
        local Zone = Config.Zones[i]
        local j = #Zone
        for i = 1, #Zone do
            local x, y, z = GetEntityCoords(GetPlayerPed(PlayerId()))
            if GetDistanceBetweenCoords(Zone[1],Zone[2],Zone[3], x, y, z, true) <= Zone[4] then
                return true
            end
            j = i;
        end
    end
end

function has_value (tab, val)
    for i, v in ipairs (tab) do
        if (v == val) then
            return true
        end
    end
    return false
end
