
local spawnedNpcs = {}
isDead = false
isInRangeOfNancy = false



-- Initial - Set up Nancy peds
Citizen.CreateThread(function()
    Citizen.Wait(0)
    for k,v in pairs(Config.NancyLocations) do
        SpawnNPC(k)
    end
end)

-- Performance -- Check for death
Citizen.CreateThread(function()
	Citizen.Wait(2000)
	while true do
		Citizen.Wait(2 * 1000)
		isDead = IsPedDeadOrDying(jo.me)
	end
end)


Citizen.CreateThread(function()
	Citizen.Wait(2000)
	while true do
		local sleep = 1000
        isInRangeOfNancy = false
		if isDead and jo.meCoords then
        -- if playerCoords then
			for k, v in pairs(Config.NancyLocations) do
                local nancyVector3 = vector3(v.coords.x, v.coords.y, v.coords.z)
				local distance = #(jo.meCoords - nancyVector3)
				if distance < Config.NancyDistance then
					sleep = 1
                    isInRangeOfNancy = true

                    local text = string.format(Config.NancyPromptLabel, Config.NancyPrice)
                    local textCoords = nancyVector3 + vector3(0, 0, 0)
                    DrawTextThisFrame(text, textCoords)

				end
			end
		end
		Citizen.Wait(sleep)
	end
end)


RegisterCommand("reviveme", function(source, args, rawCommand)
    local _source = source

    if Config.ShameyDebug then print("reviveme") end

    if isInRangeOfNancy then

        local x,y,z = table.unpack(jo.meCoords)
        -- Find ZoneName of type "Town" at current coords. Returns false if nothing of this type was found:
        local zoneTypeId = 1
        local currentTown = Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, zoneTypeId) -- CANT USE ON SERVER-SIDE
        if not currentTown then
            currentTown = "Unknown"
        end

        TriggerServerEvent("rainbow_doctor:CommandReviveMe", jo.meCoords, currentTown)
    end
end)


---------------- NPC ---------------------
function LoadModel(model)
    local model = GetHashKey(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(100)
    end
end

function SpawnNPC(id)

    if Config.ShameyDebug then print("SpawnNPC: ", id) end

    local v = Config.NancyLocations[id]
    LoadModel(Config.NancyModel)
    
    local npc = CreatePed(Config.NancyModel, v.coords.x, v.coords.y, (v.coords.z-1.0), v.coords.w, false, true, true, true)
    repeat Wait(1) until DoesEntityExist(npc)
    PlaceEntityOnGroundProperly(npc, true)
    Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    RainbowCore.UtilitySetPedUnattackable(npc)

    SetTimeout(3000, function()
        FreezeEntityPosition(npc, true)
    end)
    
    spawnedNpcs[id] = npc
    
end

--------

function DrawTextThisFrame(text, coords, scale)
    local onScreen, x, y = GetScreenCoordFromWorldCoord(table.unpack(coords))

    scale = scale or 0.30

    if onScreen then
	
		local font = 6 --0,1,5,6, 9, 11, 12, 15, 18, 19, 20, 22, 24, 25, 28, 29
		SetTextFontForCurrentCommand(font)

		SetTextColor(255, 255, 255, 255)
        SetTextCentre(true)
        SetTextScale(0.01, scale)
		
        -- SetTextDropshadow(1, 0, 0, 0, 255)

		str = CreateVarString(10, 'LITERAL_STRING', text)
		DisplayText(str, x, y);
		

        -- Background
        local height = 0.09 * scale
        local width = (0.001 * scale) + (string.len(text) * 0.0040)
        DrawRect(x, y + scale / 30, width + 0.010, height + 0.010, 0, 0, 0, 160)
    end
end

---------

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	for k,v in pairs(spawnedNpcs) do
        DeleteEntity(v)
        DeletePed(v)
        SetEntityAsNoLongerNeeded(v)
    end

    spawnedNpcs = nil

end)