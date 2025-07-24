VorpCore = {}
TriggerEvent("getCore",function(core)
    VorpCore = core
end)
VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
	print = VORPutils.Print:initialize(print)
end)


onDuty = false


-- For ALL players, not just doctors
-- RegisterCommand("calldoctor", function(source, args, rawCommand)
-- 	TriggerEvent("rainbow_doctor:calldoctor")
-- end)

RegisterNetEvent("rainbow_doctor:calldoctor")
AddEventHandler("rainbow_doctor:calldoctor", function()
	local downedServerId = source
	if Config.ShameyDebug then print("rainbow_doctor:calldoctor", downedServerId) end

	-- We cannot get the coords from clientside if they're too far, so grab them now while we have access
	local downedPed = GetPlayerPed(downedServerId)
	local downedCoords = GetEntityCoords(downedPed)

	-- Alert ALL players in case they're a doctor
	TriggerClientEvent("rainbow_doctor:DoctorCalled", -1, downedServerId, downedCoords)
	-- Let the player know the doctors were called
	-- TriggerClientEvent("vorp:Tip", _source, "Doctors have been alerted with your current location.", 10 * 1000)
end)

RegisterNetEvent("rainbow_doctor:LogCallOnDiscord")
AddEventHandler("rainbow_doctor:LogCallOnDiscord", function(downedServerId, downedCoords)
	local _source = source
	if Config.ShameyDebug then print("rainbow_doctor:LogCallOnDiscord", _source, downedServerId, downedCoords) end
	
	local doctorCharacter = VorpCore.getUser(_source).getUsedCharacter
    local doctorCharIdentifier = doctorCharacter.charIdentifier
    local doctorFullName = string.format("%s %s", doctorCharacter.firstname, doctorCharacter.lastname)
	
	local downedCharacter = VorpCore.getUser(downedServerId).getUsedCharacter
    local downedCharIdentifier = downedCharacter.charIdentifier
    local downedFullName = string.format("%s %s", downedCharacter.firstname, downedCharacter.lastname)
	
	local x,y,z = table.unpack(downedCoords)
	
	VorpCore.AddWebhook("A doctor was alerted about a downed person.", Config.Webhook, string.format(
        "**Doctor:** %s (CharId %s)\n**Downed Person:** %s (CharId %s)\n**Downed Coords:** %.4f, %.4f, %.4f", 
        doctorFullName, doctorCharIdentifier, downedFullName, downedCharIdentifier, x, y, z))
end)

RegisterNetEvent("rainbow_doctor:LogHealOnDiscord")
AddEventHandler("rainbow_doctor:LogHealOnDiscord", function(_source, downedServerId)
	if Config.ShameyDebug then print("rainbow_doctor:LogHealOnDiscord", _source, downedServerId) end
	
	local doctorCharacter = VorpCore.getUser(_source).getUsedCharacter
    local doctorCharIdentifier = doctorCharacter.charIdentifier
    local doctorFullName = string.format("%s %s", doctorCharacter.firstname, doctorCharacter.lastname)
	
	local downedCharacter = VorpCore.getUser(downedServerId).getUsedCharacter
    local downedCharIdentifier = downedCharacter.charIdentifier
    local downedFullName = string.format("%s %s", downedCharacter.firstname, downedCharacter.lastname)
	
	VorpCore.AddWebhook("A doctor healed a person.", Config.Webhook, string.format(
        "**Doctor:** %s (CharId %s)\n**Injured Person:** %s (CharId %s)", 
        doctorFullName, doctorCharIdentifier, downedFullName, downedCharIdentifier))
end)

RegisterNetEvent("rainbow_doctor:LogResurrectOnDiscord")
AddEventHandler("rainbow_doctor:LogResurrectOnDiscord", function(_source, downedServerId)
	if Config.ShameyDebug then print("rainbow_doctor:LogResurrectOnDiscord", _source, downedServerId) end
	
	local doctorCharacter = VorpCore.getUser(_source).getUsedCharacter
    local doctorCharIdentifier = doctorCharacter.charIdentifier
    local doctorFullName = string.format("%s %s", doctorCharacter.firstname, doctorCharacter.lastname)
	
	local downedCharacter = VorpCore.getUser(downedServerId).getUsedCharacter
    local downedCharIdentifier = downedCharacter.charIdentifier
    local downedFullName = string.format("%s %s", downedCharacter.firstname, downedCharacter.lastname)
	
	VorpCore.AddWebhook("A doctor resurrected a person.", Config.Webhook, string.format(
        "**Doctor:** %s (CharId %s)\n**Downed Person:** %s (CharId %s)", 
        doctorFullName, doctorCharIdentifier, downedFullName, downedCharIdentifier))
end)


-- Trigger VORP's heal command
RegisterNetEvent("rainbow_doctor:TriggerFrameworkHeal")
AddEventHandler("rainbow_doctor:TriggerFrameworkHeal", function(injuredPlayer)
    local _source = source
	if Config.ShameyDebug then print("rainbow_doctor:TriggerFrameworkHeal", injuredPlayer) end

    TriggerClientEvent('vorp:heal', injuredPlayer)

	-- Let the doc know it worked
	TriggerClientEvent("vorp:Tip", _source, "The person has been made healthy.", 10 * 1000)
	
	TriggerEvent("rainbow_doctor:LogHealOnDiscord", _source, injuredPlayer)
end)


-- Trigger VORP's resurrection command
RegisterNetEvent("rainbow_doctor:TriggerFrameworkResurrection")
AddEventHandler("rainbow_doctor:TriggerFrameworkResurrection", function(deadPlayer)
    local _source = source
	if Config.ShameyDebug then print("rainbow_doctor:TriggerFrameworkResurrection", deadPlayer) end

    TriggerClientEvent('vorp:resurrectPlayer', deadPlayer)

	-- Let the doc know it worked
	TriggerClientEvent("vorp:Tip", _source, "The person has been revived.", 10 * 1000)
	
	TriggerEvent("rainbow_doctor:LogResurrectOnDiscord", _source, deadPlayer)
end)

-- Called by VorpCore
RegisterServerEvent("rainbow_doctor:GetNearestDoctorDistance")
AddEventHandler("rainbow_doctor:GetNearestDoctorDistance", function(playerIds)
	local _source = source
    
	local playerPed = GetPlayerPed(_source)
	local playerCoords = GetEntityCoords(playerPed)
	if Config.ShameyDebug then print("Player Coords", playerCoords) end

	local allDoctorsList = exports["rainbow-core"]:findAllPlayersWithJobInJobArray(getJobList())
    local nearestDoctor
	local nearestDoctorDistance = 99999.9

    for i,v in pairs(allDoctorsList) do 
        if v ~= _source then 
            if VorpCore.getUser(v) then 
				-- if Config.ShameyDebug then print("player with doctor job: ", player) end

				-- Get the doctor's coords
				local doctorCoords = GetEntityCoords(GetPlayerPed(v))
				local doctorDistance = #(playerCoords - doctorCoords)
				if Config.ShameyDebug then print("Doctor Distance", doctorDistance) end

				if doctorDistance < nearestDoctorDistance then
					nearestDoctor = v
					nearestDoctorDistance = doctorDistance
				end	
            end
        end
    end

	if nearestDoctor then
    	TriggerClientEvent("rainbow_doctor:RespawnUpdateNearestDoctor", _source, nearestDoctorDistance)
	else
		TriggerClientEvent("rainbow_doctor:RespawnUpdateNearestDoctor", _source, -1)
	end
end)

function getFullPlayerList()
	if Config.ShameyDebug then print("GetPlayers: ", GetPlayers()) end
	return GetPlayers()
end