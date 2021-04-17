local plateTable = {}

RegisterCommand("addplate", function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, Config.AdminPerm) or Config.NoPerms == true then	
		local plate = table.concat(args, " "):upper():gsub("%s+","")
		if has_value(plateTable, plate) then
			TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1This plate is already being tracked!"} })	
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "Plate: ^1^*"..plate.."^r^0 added to the tracker."} })	
			table.insert(plateTable, plate)
			if Config.JD_logs then
				exports.JD_logs:discord(GetPlayerName(source).." added "..plate.." to the tracking list.", source, 0, Config.LogsColor, Config.LogsChannelCommands)
			end
		end		
		TriggerClientEvent("Prefech:sendPlates", -1, plateTable)
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1Insuficient Premissions!"} })
	end
end)

RegisterCommand("delplate", function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, Config.AdminPerm) or Config.NoPerms == true then	
		local plate = table.concat(args, " "):upper():gsub("%s+","")
		if has_value(plateTable, plate) then
			TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "Plate: ^1^*"..plate.."^r^0 removed from the tracker."} })	
			removebyKey(plateTable, plate)
			if Config.JD_logs then
				exports.JD_logs:discord(GetPlayerName(source).." removed "..plate.." from the tracking list.", source, 0, Config.LogsColor, Config.LogsChannelCommands)
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1This plate is not being tracked!"} })	
		end
		
		TriggerClientEvent("Prefech:sendPlates", -1, plateTable)
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1Insuficient Premissions!"} })
	end
end)

RegisterCommand("plates", function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, Config.AdminPerm) or Config.NoPerms == true then
		s = ""
		for k, v in pairs(plateTable) do
			s = s ..v.. ", "
		end
		TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "Currently tracked License Plates are: ^1"..s..""} })	
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1Insuficient Premissions!"} })
	end
end)

function getPlayerLocation(src)

	local raw = LoadResourceFile(GetCurrentResourceName(), 'postals.json')
	local postals = json.decode(raw)
	local nearest = nil
	local vehCoords = GetEntityCoords(NetworkGetEntityFromNetworkId(src))
	local x, y = table.unpack(vehCoords)
	local ndm = -1
	local ni = -1
	for i, p in ipairs(postals) do
		local dm = (x - p.x) ^ 2 + (y - p.y) ^ 2
		if ndm == -1 or dm < ndm then
			ni = i
			ndm = dm
		end
	end
	if ni ~= -1 then
		local nd = math.sqrt(ndm)
		nearest = {i = ni, d = nd}
	end
	_nearest = postals[nearest.i].code
	return _nearest
end

RegisterServerEvent('Prefech:sendblip')
AddEventHandler('Prefech:sendblip', function(veh)
	TriggerClientEvent('Prefech:trackerset',-1 , veh)
end)

RegisterServerEvent('Prefech:sendalert')
AddEventHandler('Prefech:sendalert', function(veh)
	TriggerClientEvent('Prefech:alertsend',-1 , veh, getPlayerLocation(veh))
	
end)

RegisterServerEvent("Prefech:checkPerms")
AddEventHandler("Prefech:checkPerms", function(source)
    if IsPlayerAceAllowed(source, Config.AdminPerm) or Config.NoPerms == true then
        TriggerClientEvent("Prefech:getPerms", source, true)
    else
        TriggerClientEvent("Prefech:getPerms", source, false)
    end
end)

function has_value (tab, val)
    for i, v in ipairs (tab) do
        if (v == val) then
            return true
        end
    end
    return false
end

function removebyKey(tab, val)
    for i, v in ipairs (tab) do 
        if (v == val) then
          tab[i] = nil
        end
    end
end

-- version check
Citizen.CreateThread(
	function()
		local vRaw = LoadResourceFile(GetCurrentResourceName(), 'version.json')
		if vRaw and Config.versionCheck then
			local v = json.decode(vRaw)
			PerformHttpRequest(
				'https://raw.githubusercontent.com/Prefech/Prefech_ALPR/master/version.json',
				function(code, res, headers)
					if code == 200 then
						local rv = json.decode(res)
						if rv.version ~= v.version then
							print(
								([[^1
-------------------------------------------------------
Prefech_ALPR
UPDATE: %s AVAILABLE
CHANGELOG: %s
-------------------------------------------------------
^0]]):format(
									rv.version,
									rv.changelog
								)
							)
						end
					else
						print('^1Prefech_ALPR unable to check version^0')
					end
				end,
				'GET'
			)
		end
	end
)