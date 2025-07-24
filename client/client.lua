VORPMenu = {} -- local 
TriggerEvent("menuapi:getData",function(cb)
	VORPMenu = cb
end)
VORPutils = {}
TriggerEvent("getUtils", function(utils)
    VORPutils = utils
	print = VORPutils.Print:initialize(print)
end)
RainbowCore = exports["rainbow-core"]:initiate()

local blips = {}

onDuty = false
hasRegisteredGradeCommands = false


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


-----------------------------------------------------------------------------------------
---------------------------------Player Spawn
-----------------------------------------------------------------------------------------
RegisterNetEvent("vorp:SelectedCharacter")
AddEventHandler("vorp:SelectedCharacter", function()
    TriggerServerEvent("rainbow_doctor:GetJobs")
end)

-----------------------------------------------------------------------------------------
---------------------------------JOB HANDLER
-----------------------------------------------------------------------------------------
RegisterNetEvent("rainbow_doctor:DoctorCalled")
AddEventHandler("rainbow_doctor:DoctorCalled", function(downedServerId, downedCoords)

	downedServerId = tonumber(downedServerId)

	if Config.ShameyDebug then print("rainbow_doctor:DoctorCalled - downedServerId:", downedServerId) end
	
    if Config.ShameyDebug then print("rainbow_doctor:DoctorCalled - downedCoords:", downedCoords) end
	
	if hasAbility("map") then
		if downedServerId and downedServerId > 0 then
			AlertAboutDownedPlayer(downedCoords)
			LogCallOnDiscord(downedServerId, downedCoords)
		else
			print("ERROR: Downing occurred but cannot find downed character's server ID for notification.")
		end
	end
end)

function AlertAboutDownedPlayer(downedCoords)
	if Config.ShameyDebug then print("AlertAboutDownedPlayer()", downedCoords) end
	if downedCoords and downedCoords.x ~= 0.0 and downedCoords.y ~= 0.0 and downedCoords.z ~= 0.0 then
		AddDownedBlip(downedCoords)
	else
		print("ERROR: Not adding blip for downed person because coords is null or all are 0.0.")
	end
	TriggerEvent('vorp:NotifyLeft', "Downed Person", "A person was just downed and needs care. Check your map!", "toast_fme", "fme_dead_drop", 20*1000, nil)
	PlayDownedAlertSound()
	print("Sent client notification of downed person.")
end

function PlayDownedAlertSound()
	local frontend_soundset_ref = "HUD_Wanted_Sounds"
	local frontend_soundset_name = "Witness"

	if frontend_soundset_ref ~= 0 then
		Citizen.InvokeNative(0x0F2A2175734926D8,frontend_soundset_name, frontend_soundset_ref);   -- load sound frontend
	end

	Citizen.InvokeNative(0x67C540AA08E4A6F5,frontend_soundset_name, frontend_soundset_ref, true, 0);  -- play sound frontend
	if Config.ShameyDebug then print("sound frontend is playing") end
end

function AddDownedBlip(coords)
	if Config.ShameyDebug then print("AddDownedBlip: ", coords) end
	
	local x,y,z = table.unpack(coords)
	
	Citizen.CreateThread(function()
		-- Create the blip
		local blip = Citizen.InvokeNative(0x554D9D53F696D002, 1664425300, vector3(x, y, z))

		SetBlipSprite(blip, GetHashKey('blip_ambient_hunter'), true)
    	SetBlipScale(blip, 1.0)
		Citizen.InvokeNative(0x9CB1A1623062F402, blip, 'Downed Person')

		local radiusBlip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, x, y, z, 64.0)

		-- Remove the blip after x minutes
		Citizen.Wait(Config.DownedBlipDuration * 60 * 1000)
		RemoveBlip(radiusBlip)
		RemoveBlip(blip)

	end)
end

function LogCallOnDiscord(sourceServerId, downedCoords)
	TriggerServerEvent("rainbow_doctor:LogCallOnDiscord", sourceServerId, downedCoords)
end


-----------

function registerGradeCommands()
	if not hasRegisteredGradeCommands then
		if hasAbility("heal") then
			registerHealCommand()
			hasRegisteredGradeCommands = true
		end
		if hasAbility("revive") then
			registerReviveCommand()
			hasRegisteredGradeCommands = true
		end
	end
end

-- Register the "heal" command (assuming the player has the job and grade)
function registerHealCommand()
	RegisterCommand("heal", function(source, args, rawCommand)
		if Config.ShameyDebug then print("heal command") end
		local _source = source

		-- Make sure doctor isn't occupied
		local sourcePed = jo.me
		if canPedStartInteraction(sourcePed) then
			TriggerEvent("rainbow_doctor:heal")
		else
			TriggerEvent("vorp:TipRight", "You cannot heal while occupied.")
		end

	end)
end

-- Register the "revive" command (assuming the player has the job and grade)
function registerReviveCommand()
	RegisterCommand("revive", function(source, args, rawCommand)
		if Config.ShameyDebug then print("revive command") end

		-- Make sure doctor isn't occupied
		local sourcePed = jo.me
		if canPedStartInteraction(sourcePed) then
			TriggerEvent("rainbow_doctor:revive")
		else
			TriggerEvent("vorp:TipRight", "You cannot revive while occupied.")
		end

	end)
end

-- Handle the heal event
RegisterNetEvent("rainbow_doctor:heal")
AddEventHandler("rainbow_doctor:heal", function()
	if Config.ShameyDebug then print("rainbow_doctor:heal") end

	-- Short circuit if they don't have the ability
	if not hasAbility("heal") then
		return
	end
    
	local nearestInjuredPlayer = getNearestInjuredPlayer()

	if Config.ShameyDebug then print("nearestInjuredPlayer", nearestInjuredPlayer) end

	if nearestInjuredPlayer == nil then
		TriggerEvent("vorp:TipRight", "There is not a nearby injured person.")
		return
	end

	if #(jo.meCoords - GetEntityCoords(GetPlayerPed(nearestInjuredPlayer))) > 1.6 then
		TriggerEvent("vorp:TipRight", "The nearest injured person is too far away.")
		return
	end

	-- Trigger VORP's heal system
	TriggerServerEvent("rainbow_doctor:TriggerFrameworkHeal", GetPlayerServerId(nearestInjuredPlayer))
	
end)

-- Handle the revive event
RegisterNetEvent("rainbow_doctor:revive")
AddEventHandler("rainbow_doctor:revive", function()
	if Config.ShameyDebug then print("rainbow_doctor:revive") end

	-- Short circuit if they don't have the ability
	if not hasAbility("revive") then
		return
	end
    
	local nearestDeadPlayer = getNearestDeadPlayer()
	if Config.ShameyDebug then print("nearestDeadPlayer", nearestDeadPlayer) end

	if nearestDeadPlayer == nil then
		TriggerEvent("vorp:TipRight", "There is not a nearby downed person.")
		return
	end

	if #(jo.meCoords - GetEntityCoords(GetPlayerPed(nearestDeadPlayer))) > 1.6 then
		TriggerEvent("vorp:TipRight", "The nearest downed person is too far away.")
		return
	end

	-- Trigger VORP's resurrection system
	TriggerServerEvent("rainbow_doctor:TriggerFrameworkResurrection", GetPlayerServerId(nearestDeadPlayer))
	
end)

--------

Citizen.CreateThread(function()
	for k,v in pairs(Config.Locations) do
		if v.UseBlip == true then
			blips[k] = Citizen.InvokeNative(0x554d9d53f696d002, 1664425300, v.x, v.y, v.z)
			SetBlipSprite(blips[k], v.BlipSprite, 1)
			Citizen.InvokeNative(0x9CB1A1623062F402, blips[k], Config.BlipLabel)
		end
	end
end)


AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
		for k,v in pairs(Config.Locations) do
			if v.UseBlip == true and blips[k] then
				RemoveBlip(blips[k])
			end
		end
    end
end)



------ UTILS

function getNearestInjuredPlayer()
	local playerPed = jo.me
	local coords = jo.meCoords
	local closestPlayer
	local closestPlayerDistance = 9999999.9

	for _, player in pairs(GetActivePlayers()) do
		local targetPed = GetPlayerPed(player)

		if Config.ShameyDebug then print("getInnerCoreHealth", getInnerCoreHealth(targetPed)) end
		if targetPed ~= playerPed and getInnerCoreHealth(targetPed) < 80 then
			local targetPedCoords = GetEntityCoords(targetPed, true, true)
			local distance = #(targetPedCoords - coords)

			if distance < closestPlayerDistance then
				closestPlayer = player
			end
		end
	end

	if closestPlayer then
		return closestPlayer
	else
		return nil
	end
end

function getNearestDeadPlayer()
	local playerPed = jo.me
	local coords = jo.meCoords
	local closestPlayer
	local closestPlayerDistance = 9999999.9

	for _, player in pairs(GetActivePlayers()) do
		local targetPed = GetPlayerPed(player)

		-- if targetPed ~= playerPed and IsPlayerDead(player) then
		if targetPed ~= playerPed and IsPlayerDead(player) then
			local targetPedCoords = GetEntityCoords(targetPed, true, true)
			local distance = #(targetPedCoords - coords)

			if distance < closestPlayerDistance then
				closestPlayer = player
			end
		end
	end

	if closestPlayer then
		return closestPlayer
	else
		return nil
	end
end

function getInnerCoreHealth(ped)
	return GetAttributeCoreValue(ped, 0)
end

function canPedStartInteraction(ped)
	local isHogtied = (Citizen.InvokeNative(0x3AA24CCC0D451379, ped) ~= false) -- IsPedHogtied
	local isHandcuffed = Citizen.InvokeNative(0x74E559B3BC910685, ped) -- IsPedCuffed
	return not isHogtied and not isHandcuffed and not IsPedOnMount(ped) and not IsPedDeadOrDying(ped) and not IsPedInCombat(ped) and not IsPedInAnyVehicle(ped) and not IsPedSwimming(ped) and not IsPedClimbing(ped) and not IsPedFalling(ped)
end