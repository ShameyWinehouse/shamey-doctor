
local cigaretteEntity
local showSmokingPromptGroup = false

----------------------------------------------------------------
----------------------------------------------------------------
-- CIGARETTES
----------------------------------------------------------------
----------------------------------------------------------------

RegisterNetEvent("rainbow_doctor:StopSmoking")
AddEventHandler("rainbow_doctor:StopSmoking", function()
    if Config.ShameyDebug then print("showSmokingPromptGroup = false") end
    showSmokingPromptGroup = false
end)

function UseCigarette(itemName, itemLabel)

    if Config.ShameyDebug then print("UseCigarette()", itemName) end

    if isSmoking then
        TriggerEvent("vorp:TipRight", "You are already smoking.")
        return
    end

    TriggerServerEvent("rainbow_doctor:UsedItem", itemName)

    local cigaretteType = Config.UseItems[itemName].CigaretteType

    HandleSmokingABasenimAndEffects(itemName, itemLabel, cigaretteType)
end

function HandleSmokingABasenimAndEffects(itemName, itemLabel, cigaretteType)
    if Config.ShameyDebug then print("HandleSmokingABasenimAndEffects()", itemName, cigaretteType) end

    -- Unarm the player so the weapon doesn't interfere
	Citizen.InvokeNative(0xFCCC886EDE3C63EC, jo.me, 2, true) -- HidePedWeapons

    TriggerEvent("vorp:Tip", string.format("Used %s.", itemLabel), 3000)

	if cigaretteType == "cigarette" then
		HandleCigarette(itemName)
	elseif cigaretteType == "cigar" then
		HandleCigar(itemName)
	end
end

function HandleCigarette(itemName)

    if Config.ShameyDebug then print("HandleCigarette()") end

    isSmoking = true

    local configItem = Config.UseItems[itemName]

    local StanceA <const> = "A"
    local StanceB <const> = "B"
    local StanceC <const> = "C"
    local StanceD <const> = "D"

    local Anims = Config.Smoking.Anims

    -- Setup prompts
    local SmokingPromptGroup = VORPutils.Prompts:SetupPromptGroup()
    local PromptStop = SmokingPromptGroup:RegisterPrompt("Finish Smoking", Config.Smoking.Keys.Stop, 1, 1, true, "click", nil)
    local PromptInhale = SmokingPromptGroup:RegisterPrompt("Inhale", Config.Smoking.Keys.Inhale, 1, 1, true, "customhold", {holdtime = 500})
    local PromptChangeStance = SmokingPromptGroup:RegisterPrompt("Change Stance", Config.Smoking.Keys.ChangeStance, 1, 1, true, "click", nil)

    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)

    local ped = jo.me

    -- Adjust stamina & stress
    if configItem["Stamina"] then
        TriggerEvent("rainbow_metabolism:AdjustStamina", configItem["Stamina"])
    end
    if configItem["Stress"] then
        TriggerEvent("rainbow_metabolism:AdjustStress", configItem["Stress"])
    end
    
    local isMasculine = IsPedMale(ped)

    -- Create the object
    local x,y,z = table.unpack(GetEntityCoords(ped, true))
	cigaretteEntity = CreateObject(GetHashKey("P_CIGARETTE01X"), x, y, z + 0.2, true, true, true)
    local righthand = GetEntityBoneIndexByName(ped, "SKEL_R_Finger13")
    local mouth = GetEntityBoneIndexByName(ped, "skel_head")
    
    -- "Start smoking" anims
    if isMasculine then
        AttachEntityToEntity(cigaretteEntity, ped, mouth, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        Anim(ped, "amb_rest@world_human_smoking@male_c@stand_enter", "enter_back_rf", 9400, 0)
        Wait(1000)
        AttachEntityToEntity(cigaretteEntity, ped, righthand, 0.03, -0.01, 0.0, 0.0, 90.0, 0.0, true, true, false, true, 1, true)
        Wait(1000)
        AttachEntityToEntity(cigaretteEntity, ped, mouth, -0.017, 0.1, -0.01, 0.0, 90.0, -90.0, true, true, false, true, 1, true)
        Wait(3000)
        AttachEntityToEntity(cigaretteEntity, ped, righthand, 0.017, -0.01, -0.01, 0.0, 120.0, 10.0, true, true, false, true, 1, true)
        Wait(1000)
        Anim(ped, Config.Smoking.Anims.Masculine.SmokingCBase, "base", -1,30)
        RemoveAnimDict("amb_rest@world_human_smoking@male_c@stand_enter")
        Wait(1000)
    else
        -- Female
        AttachEntityToEntity(cigaretteEntity, ped, mouth, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
        Anim(ped, Anims.Feminine.SmokingCBase, "base", -1, 30)
        Wait(1000)
        AttachEntityToEntity(cigaretteEntity, ped, righthand, 0.01, 0.0, 0.01, 0.0, -160.0, -130.0, true, true, false, true, 1, true)
        Wait(2500)
    end


    -- Effects
    if configItem.Effect then
        PlayFxWithStrength(configItem.Effect.Name, configItem.Effect.Duration, configItem.Effect.Strength, configItem.Effect.ShouldFadeIn or false)
    end


    local currentStance = StanceC

    showSmokingPromptGroup = true

    local requestChangeStance = false
    local requestInhale = false
    local requestStop = false

    Citizen.CreateThread(function()
        while showSmokingPromptGroup do

            Wait(0)

            SmokingPromptGroup:ShowGroup("Smoking")

            if PromptStop:HasCompleted() then
                requestStop = true
            end
            if PromptInhale:HasCompleted() then
                requestInhale = true
            end
            if PromptChangeStance:HasCompleted() then
                requestChangeStance = true
            end

            if requestChangeStance or requestInhale then
                PromptInhale:TogglePrompt(false)
                PromptChangeStance:TogglePrompt(false)
            else
                PromptInhale:TogglePrompt(true)
                PromptChangeStance:TogglePrompt(true)
            end
        end
    end)

    
    while showSmokingPromptGroup do

        Wait(0)

        if isMasculine then
            while  IsEntityPlayingAnim(ped, Anims.Masculine.SmokingCBase, "base", 3)
                or IsEntityPlayingAnim(ped, Anims.Masculine.SmokingBBase, "base", 3)
                or IsEntityPlayingAnim(ped, Anims.Masculine.SmokingDBase, "base", 3)
                or IsEntityPlayingAnim(ped, Anims.Masculine.SmokingABase, "base", 3) do

                Wait(5)
                if requestStop then
                    if Config.ShameyDebug then print("PromptStop") end
                    requestStop = false
                    showSmokingPromptGroup = false
                    break
                end

                -- Check for "change stance"
                if requestChangeStance then
                    requestChangeStance = false
                    if Config.ShameyDebug then print("PromptChangeStance") end
                    if currentStance == StanceC then
                        Anim(ped, Anims.Masculine.SmokingBBase, "base", -1, 30)
                        Wait(1000)
                        while not IsEntityPlayingAnim(ped, Anims.Masculine.SmokingBBase, "base", 3) do
                            Wait(100)
                        end    
                        currentStance = StanceB
                    elseif currentStance == StanceB then
                        Anim(ped, Anims.Masculine.SmokingDBase, "base", -1, 30)
                        Wait(1000)
                        while not IsEntityPlayingAnim(ped, Anims.Masculine.SmokingDBase, "base", 3) do
                            Wait(100)
                        end
                        currentStance = StanceD
                    elseif currentStance == StanceD then
                        Anim(ped, Anims.Masculine.TransitionD, "d_trans_a", -1, 30)
                        Wait(4000)
                        Anim(ped, Anims.Masculine.SmokingABase, "base", -1, 30, 0)
                        while not IsEntityPlayingAnim(ped, Anims.Masculine.SmokingABase, "base", 3) do
                            Wait(100)
                        end
                        currentStance = StanceA
                    else --currentStance == StanceA
                        Anim(ped, Anims.Masculine.TransitionA, "a_trans_c", -1, 30)
                        Wait(4233)
                        Anim(ped, Anims.Masculine.SmokingCBase, "base", -1, 30, 0)
                        while not IsEntityPlayingAnim(ped, Anims.Masculine.SmokingCBase, "base", 3) do
                            Wait(100)
                        end
                        currentStance = StanceC
                    end
                end
            
                -- Check for inhale
                if currentStance == StanceC then
                    if requestInhale then
                        requestInhale = false
                        if Config.ShameyDebug then print("PromptInhale") end
                        Anim(ped, Anims.Masculine.SmokingCIdleA, "idle_b", -1, 30, 0)
                        Wait(21166)
                        Anim(ped, Anims.Masculine.SmokingCBase, "base", -1, 30, 0)
                        Wait(100)
                    -- else
                    --     Anim(ped, Anims.Masculine.SmokingCIdleA, "idle_a", -1, 30, 0)
                    --     Wait(8500)
                    --     Anim(ped, Anims.Masculine.SmokingCBase, "base", -1, 30, 0)
                    --     Wait(100)
                    end
                elseif currentStance == StanceB then
                    if requestInhale then
                        requestInhale = false
                        if Config.ShameyDebug then print("PromptInhale") end
                        Anim(ped, Anims.Masculine.SmokingBIdleC, "idle_g", -1, 30, 0)
                        Wait(13433)
                        Anim(ped, Anims.Masculine.SmokingBBase, "base", -1, 30, 0)
                        Wait(100)
                    -- else
                    --     Anim(ped, Anims.Masculine.SmokingBIdleA, "idle_a", -1, 30, 0)
                    --     Wait(3199)
                    --     Anim(ped, Anims.Masculine.SmokingBBase, "base", -1, 30, 0)
                    --     Wait(100)
                    end
                elseif currentStance == StanceD then
                    if requestInhale then
                        requestInhale = false
                        if Config.ShameyDebug then print("PromptInhale") end
                        Anim(ped, Anims.Masculine.SmokingDIdleA, "idle_b", -1, 30, 0)
                        Wait(7366)
                        Anim(ped, Anims.Masculine.SmokingDBase, "base", -1, 30, 0)
                        Wait(100)
                    -- else
                    --     Anim(ped, Anims.Masculine.SmokingDIdleC, "idle_g", -1, 30, 0)
                    --     Wait(7866)
                    --     Anim(ped, Anims.Masculine.SmokingDBase, "base", -1, 30, 0)
                    --     Wait(100)
                    end
                else --currentStance==StanceA
                    if requestInhale then
                        requestInhale = false
                        if Config.ShameyDebug then print("PromptInhale") end
                        Anim(ped, Anims.Masculine.SmokingAIdleA, "idle_b", -1, 30, 0)
                        Wait(12533)
                        Anim(ped, Anims.Masculine.SmokingABase, "base", -1, 30, 0)
                        Wait(100)
                    -- else
                    --     Anim(ped, Anims.Masculine.SmokingAIdleA, "idle_a", -1, 30, 0)
                    --     Wait(8200)
                    --     Anim(ped, Anims.Masculine.SmokingABase, "base", -1, 30, 0)
                    --     Wait(100)
                    end
                end
            end

        else

            -- Is feminine-bodied
            while  IsEntityPlayingAnim(ped, Anims.Feminine.SmokingCBase, "base", 3) 
                or IsEntityPlayingAnim(ped, Anims.Feminine.SmokingBBase, "base", 3)
                or IsEntityPlayingAnim(ped, Anims.Feminine.SmokingABase, "base", 3) do

                Wait(5)
                if requestStop then
                    if Config.ShameyDebug then print("PromptStop") end
                    requestStop = false
                    showSmokingPromptGroup = false
                    break
                end

                -- Check for "change stance"
                if requestChangeStance then
                    requestChangeStance = false
                    if Config.ShameyDebug then print("PromptChangeStance") end
                    if currentStance == StanceC then
                        Anim(ped, Anims.Feminine.SmokingBBase, "base", -1, 30)
                        Wait(1000)
                        while not IsEntityPlayingAnim(ped, Anims.Feminine.SmokingBBase, "base", 3) do
                            Wait(100)
                        end    
                        currentStance = StanceB
                    elseif currentStance == StanceB then
                        Anim(ped, Anims.Feminine.TranisitionB, "b_trans_a", -1, 30)
                        Wait(5733)
                        Anim(ped, Anims.Feminine.SmokingABase, "base", -1, 30, 0)
                        while not IsEntityPlayingAnim(ped,Anims.Feminine.SmokingABase, "base", 3) do
                            Wait(100)
                        end
                        currentStance = StanceA
                    else --currentStance == StanceA
                        Anim(ped, Anims.Feminine.SmokingCBase, "base", -1, 30)
                        Wait(1000)
                        while not IsEntityPlayingAnim(ped, Anims.Feminine.SmokingCBase, "base", 3) do
                            Wait(100)
                        end
                        currentStance = StanceC
                    end
                end
            
                -- Check for inhale
                if currentStance == StanceC then
                    if requestInhale then
                        requestInhale = false
                        if Config.ShameyDebug then print("PromptInhale") end
                        Anim(ped, Anims.Feminine.SmokingCIdleA, "idle_a", -1, 30, 0)
                        Wait(9566)
                        Anim(ped, Anims.Feminine.SmokingCBase, "base", -1, 30, 0)
                        Wait(100)
                    -- else
                    --     Anim(ped, Anims.Feminine.SmokingCIdleB, "idle_f", -1, 30, 0)
                    --     Wait(8133)
                    --     Anim(ped, Anims.Feminine.SmokingCBase, "base", -1, 30, 0)
                    --     Wait(100)
                    end
                elseif currentStance == StanceB then
                    if requestInhale then
                        requestInhale = false
                        if Config.ShameyDebug then print("PromptInhale") end
                        Anim(ped, Anims.Feminine.SmokingBIdleB, "idle_f", -1, 30, 0)
                        Wait(8033)
                        Anim(ped, Anims.Feminine.SmokingBBase, "base", -1, 30, 0)
                        Wait(100)
                    -- else
                    --     Anim(ped, Anims.Feminine.SmokingBIdleA, "idle_b", -1, 30, 0)
                    --     Wait(4266)
                    --     Anim(ped, Anims.Feminine.SmokingBBase, "base", -1, 30, 0)
                    --     Wait(100)
                    end
                else --currentStance==StanceA
                    if requestInhale then
                        requestInhale = false
                        if Config.ShameyDebug then print("PromptInhale") end
                        Anim(ped, Anims.Feminine.SmokingAIdleB, "idle_d", -1, 30, 0)
                        Wait(14566)
                        Anim(ped, Anims.Feminine.SmokingABase, "base", -1, 30, 0)
                        Wait(100)
                    -- else
                    --     Anim(ped, Anims.Feminine.SmokingAIdleA, "idle_b", -1, 30, 0)
                    --     Wait(6100)
                    --     Anim(ped, Anims.Feminine.SmokingABase, "base", -1, 30, 0)
                    --     Wait(100)
                    end
                end
            end
        end
    end

    StopSmokingCigarette(isMasculine, ped)
end

function StopSmokingCigarette(isMasculine, ped)

    if Config.ShameyDebug then print("StopSmokingCigarette()", isMasculine, ped) end

    showSmokingPromptGroup = false

    local configItem = Config.UseItems[itemName]

    local Anims = Config.Smoking.Anims

    ClearPedSecondaryTask(ped)
    if isMasculine then
        Anim(ped, "amb_rest@world_human_smoking@male_a@stand_exit", "exit_back", -1, 1)
        Wait(2800)
    else
        Anim(ped, Anims.Feminine.TranisitionB, "b_trans_fire_stand_a", -1, 1)
        Wait(3800)
    end
    DetachEntity(cigaretteEntity, true, true)
    SetEntityVelocity(cigaretteEntity, 0.0, 0.0, -1.0)
    Wait(1500)
    RemoveSmokingABasenimDicts()
    ClearPedSecondaryTask(ped)
    ClearPedTasks(ped)

    isSmoking = false
end

function HandleCigar(itemName)

    isSmoking = true

    local configItem = Config.UseItems[itemName]

    if Config.ShameyDebug then print("HandleCigar()") end

    -- Setup prompt
    local SmokingPromptGroup = VORPutils.Prompts:SetupPromptGroup()
    local PromptStop = SmokingPromptGroup:RegisterPrompt("Finish Smoking", Config.Smoking.Keys.Stop, 1, 1, true, "click", nil)

    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)

    local ped = jo.me

    -- Adjust stamina & stress
    if configItem["Stamina"] then
        TriggerEvent("rainbow_metabolism:AdjustStamina", configItem["Stamina"])
    end
    if configItem["Stress"] then
        TriggerEvent("rainbow_metabolism:AdjustStress", configItem["Stress"])
    end

    local prop_name = "P_CIGAR01X"
    local isMasculine = IsPedMale(ped)
    local dict = "amb_rest@world_human_smoke_cigar@male_a@idle_b"
    local anim = "idle_d"
    local x,y,z = table.unpack(GetEntityCoords(ped, true))
    local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_Finger12")
    local smoking = false

    if not IsEntityPlayingAnim(ped, dict, anim, 3) then
    
        local waiting = 0
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                --print('RedM Fucked up this animation')
                break
            end
        end
    
        Wait(100)
        AttachEntityToEntity(prop, ped, boneIndex, 0.01, -0.00500, 0.01550, 0.024, 300.0, -40.0, true, true, false, true, 1, true)
        TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
        Wait(1000)
        
        showSmokingPromptGroup = true
        while showSmokingPromptGroup do

            Wait(0)

            SmokingPromptGroup:ShowGroup("Smoking")

            if IsEntityPlayingAnim(ped, dict, anim, 3) then

                DisableControlAction(0, `INPUT_ATTACK`, true) -- MOUSE LEFT CLICK
                DisableControlAction(0, `INPUT_AIM`, true) -- MOUSE RIGHT CLICK
                DisableControlAction(0, `INPUT_SPECIAL_ABILITY`, true) -- MOUSE SCROLL CLICK
                DisableControlAction(0, `INPUT_MELEE_ATTACK`, true) -- F
                DisableControlAction(0, `INPUT_SPRINT`, true) -- LEFT SHIFT
                DisableControlAction(0, `INPUT_JUMP`, true) -- SPACE

                if PromptStop:HasCompleted() then
                    showSmokingPromptGroup = false
                    StopSmokingCigar(ped, prop, dict)
                    break
                end

            else
                TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 31, 0, true, 0, false, 0, false)
            end

        end

        StopSmokingCigar(ped, prop, dict)
    end
end

function StopSmokingCigar(ped, prop, dict)
    showSmokingPromptGroup = false
    ClearPedSecondaryTask(ped)
    DeleteObject(prop)
    RemoveAnimDict(dict)
    isSmoking = false
end

function RemoveSmokingABasenimDicts()
    local Anims = Config.Smoking.Anims
    RemoveAnimDict(Anims.Masculine.SmokingABase)
    RemoveAnimDict(Anims.Masculine.SmokingAIdleA)
    RemoveAnimDict(Anims.Masculine.SmokingBBase)
    RemoveAnimDict(Anims.Masculine.SmokingBIdleA)
    RemoveAnimDict("amb_rest@world_human_smoking@nervous_stressed@male_b@idle_g")
    RemoveAnimDict(Anims.Masculine.SmokingCBase)
    RemoveAnimDict(Anims.Masculine.SmokingCIdleA)
    RemoveAnimDict(Anims.Masculine.SmokingDBase)
    RemoveAnimDict(Anims.Masculine.SmokingDIdleA)
    RemoveAnimDict(Anims.Masculine.SmokingDIdleC)
    RemoveAnimDict(Anims.Masculine.TransitionA)
    RemoveAnimDict("amb_rest@world_human_smoking@male_c@trans")
    RemoveAnimDict(Anims.Masculine.TransitionD)
    RemoveAnimDict(Anims.Feminine.SmokingABase)
    RemoveAnimDict(Anims.Feminine.SmokingAIdleA)
    RemoveAnimDict(Anims.Feminine.SmokingAIdleB)
    RemoveAnimDict(Anims.Feminine.SmokingBBase)
    RemoveAnimDict(Anims.Feminine.SmokingBIdleA)
    RemoveAnimDict(Anims.Feminine.SmokingBIdleB)
    RemoveAnimDict(Anims.Feminine.SmokingCBase)
    RemoveAnimDict(Anims.Feminine.SmokingCIdleA)
    RemoveAnimDict(Anims.Feminine.SmokingCIdleB)
    RemoveAnimDict(Anims.Feminine.TranisitionB)
end

function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
    Citizen.CreateThread(function()
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
        timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout>0) do
            timeout = timeout-1
            if timeout == 0 then 
                --print("Animation Failed to Load")
            end
            Citizen.Wait(300)
        end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag --[[1 for repeat--]], 1, false, false, false, 0, true)
    end)
end
