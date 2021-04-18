local plateTable = {}

RegisterCommand("addplate", function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, Config.addPlatePerms) or IsPlayerAceAllowed(source, Config.AdminPerm) or Config.NoPerms == true then	
		local newPlate = table.concat(args, ""):upper():gsub("%s+","")
		local loadFile = LoadResourceFile(GetCurrentResourceName(), "plates.json")
		local loadedFile = json.decode(loadFile)
		if args[1] then
			if has_value(loadedFile.Plates, newPlate) then
				TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1This plate is already being tracked!"} })	
			else
				table.insert(loadedFile.Plates, newPlate)
				TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "Plate: ^1^*"..newPlate.."^r^0 added to the tracker."} })	
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1You need to specify a plate to track!"} })	
		end
		SaveResourceFile(GetCurrentResourceName(), "plates.json", json.encode(loadedFile), -1)
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1Insuficient Premissions"} })
	end
end)

RegisterCommand("delplate", function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, Config.delPlatePerms) or IsPlayerAceAllowed(source, Config.AdminPerm) or Config.NoPerms == true then	
		local newPlate = table.concat(args, ""):upper():gsub("%s+","")
		local loadFile = LoadResourceFile(GetCurrentResourceName(), "plates.json")
		local loadedFile = json.decode(loadFile)
		if args[1] then
			if has_value(loadedFile.Plates, newPlate) then
				removebyKey(loadedFile.Plates, newPlate)
				TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "Plate: ^1^*"..newPlate.."^r^0 removed from the tracker."} })	
			else
				TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1This plate is not being tracked!"} })	
			end
		else
			TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1You need to specify a plate to remove from the tracker!"} })	
		end
		SaveResourceFile(GetCurrentResourceName(), "plates.json", json.encode(loadedFile), -1)
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1Insuficient Premissions"} })
	end
end)

RegisterCommand("clearplates", function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, Config.clearPlatePerms) or IsPlayerAceAllowed(source, Config.AdminPerm) or Config.NoPerms == true then	
		local loadFile = LoadResourceFile(GetCurrentResourceName(), "plates.json")
		local loadedFile = {Plates = {}}		
		SaveResourceFile(GetCurrentResourceName(), "plates.json", json.encode(loadedFile), -1)
		TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "Removed all plates from the tracker!"} })	
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1Insuficient Premissions"} })
	end
end)


RegisterCommand("plates", function(source, args, rawCommand)
	if IsPlayerAceAllowed(source, Config.SeePlatesPerm) or IsPlayerAceAllowed(source, Config.AdminPerm) or Config.NoPerms == true then	
		local loadFile = LoadResourceFile(GetCurrentResourceName(), "plates.json")
		local loadedFile = json.decode(loadFile)
		local s = ""
		for i, v in pairs(loadedFile.Plates) do
			s = s ..v.. ", "
		end
		TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "Currently tracked License Plates are: ^*^1"..s..""} })
	else
		TriggerClientEvent('chat:addMessage', source, { args = {"^5["..Config.ChatPrefix.."]", "^1Insuficient Premissions"} })
	end
end)

function getPlayerLocation(x, y)
	local raw = LoadResourceFile(GetCurrentResourceName(), 'postals.json')
	local postals = json.decode(raw)
	local nearest = nil
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

Citizen.CreateThread(function()
    while true do
        local loadFile = LoadResourceFile(GetCurrentResourceName(), "plates.json")
	    local loadedFile = json.decode(loadFile)
        plateTable = loadedFile.Plates
		TriggerClientEvent('Prefech:sendPlates',-1 , plateTable)
        Citizen.Wait(Config.SyncDelay)
    end
end)


RegisterServerEvent('Prefech:sendblip')
AddEventHandler('Prefech:sendblip', function(x, y, z)
	TriggerClientEvent('Prefech:trackerset',-1 , x, y, z)
end)

RegisterServerEvent('Prefech:sendalert')
AddEventHandler('Prefech:sendalert', function(x, y, z, plate, model, heading)
	TriggerClientEvent('Prefech:alertsend',-1 , x, y, z, plate, model, heading, getPlayerLocation(x, y))
	
end)

RegisterServerEvent("Prefech:checkPerms")
AddEventHandler("Prefech:checkPerms", function(source)
    if IsPlayerAceAllowed(source, Config.NotificationPerm) or IsPlayerAceAllowed(source, Config.AdminPerm) or Config.NoPerms == true then
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
								([[^1-------------------------------------------------------
^1Prefech_ALPR
^1UPDATE: %s AVAILABLE
^1CHANGELOG: %s
^1-------------------------------------------------------^0]]):format(
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