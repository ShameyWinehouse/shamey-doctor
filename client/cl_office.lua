


inMenu = false
OfficePromptGroup = nil
OfficePrompt = nil


Citizen.CreateThread(function()
	OfficePromptGroup = VORPutils.Prompts:SetupPromptGroup()
	OfficePrompt = OfficePromptGroup:RegisterPrompt("Open Office Menu", 0x760A9C6F, 1, 1, false, 'hold', {				timedeventhash = "SHORT_TIMED_EVENT_MP"})
end)

Citizen.CreateThread(function()
    while true do
        if Config.ShameyDebug then print("checking for grade commands") end

        -- Only register advanced commands if they have the job Grade
	    registerGradeCommands()

        Wait(1 * 60 * 1000) -- Wait 1 minute for the next check
    end
end)

function SetDuty(isOnDuty)
	if Config.ShameyDebug then print("SetDuty: "..dump(isOnDuty)) end
	onDuty = isOnDuty
	TriggerServerEvent("rainbow_doctor:SetDuty", isOnDuty)
	
	-- Alert the user
	local tipText = "You are now clocked in and will start to receive pay."
	if isOnDuty == false then
		tipText = "You are now clocked out."
	end
	TriggerEvent('vorp:Tip', tipText, 10000)
end

function OpenMenu()
	
	VORPMenu.CloseAll()
	inMenu = true

    local MenuElements = {
        { 
            label = "Clock In",
            value = "clock_in",
            desc = "Clock In"
        },
		{ 
            label = "Clock Out",
            value = "clock_out",
            desc = "Clock Out"
        }
    }

    VORPMenu.Open("default",GetCurrentResourceName(),"vorp_menu",
    {
        title = "Doctor's Office",
        subtext = "",
        align = "top-right", -- top-right , top-center , top-left
        elements = MenuElements, -- elements needed
    },
        function(data, menu)
            -- to go back to lastmenu if any
            if (data.current == "backup") then
              -- params last function need 
               return  _G[trigger.data]()
            end

              -- get any of the params you definded in the elements
            if data.current.value == "clock_in" then
              -- do code 
				SetDuty(true)
			elseif data.current.value == "clock_out" then
				SetDuty(false)
            end
			
			CloseMenu()

        end,function(data,menu)
			-- if theres no previous menu close menu on backspace press
            CloseMenu()
        end)
	
end

function CloseMenu()
	VORPMenu.CloseAll()
	inMenu = false
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end
    CloseMenu()
end)

-- Check if the player has the ability based on their job grade
function hasAbility(ability)
    for k,v in pairs(Config.Jobs) do
        for k2,v2 in pairs(v.jobGrade) do
			
			local hasJobAndGrade = RainbowCore.AbsolutelyHasJobAndGradeClient(v.job, v2.grade)

            if hasJobAndGrade then
                for k3,v3 in pairs(v2.abilities) do
                    if Config.ShameyDebug then print("v3", v3) end
                    if v3 == ability then
                        if Config.ShameyDebug then print("has ability: ", ability) end
                        return true
                    end
                end
            end
        end
    end
    if Config.ShameyDebug then print("doesn't have ability: ", ability) end
    return false
end

--------

RegisterNetEvent("rainbow_core:Jobs:Client:OnSwitchedJob")
AddEventHandler("rainbow_core:Jobs:Client:OnSwitchedJob", function()
    if onDuty then
        SetDuty(false)
    end
end)

------------------------------------
-- Toggle with same key as opening
CreateThread(function()
	while true do
		local sleep = 2000
		if inMenu then
			if Config.ShameyDebug then print("inMenu") end
			sleep = 4
			if IsControlJustPressed(0, 0x760A9C6F) then -- G key
				if Config.ShameyDebug then print("g pressed") end
				CloseMenu()
			end
		end
		Citizen.Wait(sleep)
	end
end)