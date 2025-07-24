

local jobList
local hasJobInJobList = false


Citizen.CreateThread(function()
	Citizen.Wait(1000)
	jobList = getJobList()
end)

Citizen.CreateThread(function()
	Citizen.Wait(2000)
	while true do
		Citizen.Wait(2 * 1000)
		hasJobInJobList = RainbowCore.AbsolutelyHasJobInJoblistClient(jobList)
	end
end)


Citizen.CreateThread(function()
	Citizen.Wait(2000)
	while true do
		local sleep = 1000
		if not inMenu and hasJobInJobList then
			for k, v in pairs(Config.Locations) do
				local coords = vector3(v.x, v.y, v.z)
				local distance = #(jo.meCoords - coords)
				if distance < 2.0 then
					sleep = 1
					OfficePromptGroup:ShowGroup(v.label)
					if OfficePrompt:HasCompleted() then
						if Config.ShameyDebug then print("Office prompt completed") end
						OpenMenu()
					end
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.Timer * 60 * 1000)
		if onDuty then
			TriggerServerEvent("rainbow_doctor:GetPaycheck")
		end
	end
end)

