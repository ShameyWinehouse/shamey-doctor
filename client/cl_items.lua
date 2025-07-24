local currentEffect = nil

local cooldownBandagesEndTime = 0
local cooldownMedicinesEndTime = 0
local cooldownsOtherEndTimes = {}

local isUsingHealingBalm = false
local healingBalmInterval = 0

isSmoking = false


-------- EVENTS

RegisterNetEvent("rainbow_doctor:UseBandage")
AddEventHandler("rainbow_doctor:UseBandage", function(item)
    if Config.ShameyDebug then print("rainbow_doctor:UseBandage", item) end
    UseBandage(item.item, item.label)
    TriggerServerEvent("vorpmetabolism:ItemUsed", GetPlayerServerId(PlayerId()), item.item)
end)

RegisterNetEvent("rainbow_doctor:UseMedicine")
AddEventHandler("rainbow_doctor:UseMedicine", function(item)
    if Config.ShameyDebug then print("rainbow_doctor:UseMedicine", item) end
    UseMedicine(item.item, item.label)
    TriggerServerEvent("vorpmetabolism:ItemUsed", GetPlayerServerId(PlayerId()), item.item)
end)

RegisterNetEvent("rainbow_doctor:UseOther")
AddEventHandler("rainbow_doctor:UseOther", function(item)
    if Config.ShameyDebug then print("rainbow_doctor:UseOther", item) end
    UseOther(item.item, item.label)
    TriggerServerEvent("vorpmetabolism:ItemUsed", GetPlayerServerId(PlayerId()), item.item)
end)

RegisterNetEvent("rainbow_doctor:UseCigarette")
AddEventHandler("rainbow_doctor:UseCigarette", function(item)
    if Config.ShameyDebug then print("rainbow_doctor:UseCigarette", item) end
    UseCigarette(item.item, item.label, item.CigaretteType)
    TriggerServerEvent("vorpmetabolism:ItemUsed", GetPlayerServerId(PlayerId()), item.item)
end)

RegisterNetEvent("rainbow_doctor:UseBalmHealing")
AddEventHandler("rainbow_doctor:UseBalmHealing", function(item)
	if Config.ShameyDebug then print("UseBalmHealing", item) end

	-- Check if they've already used a balm
	if isUsingHealingBalm then
		TriggerEvent("vorp:Tip", "You already have a healing balm applied.", 10000)
		return
	end

    TriggerServerEvent("rainbow_doctor:UsedItem", item.item)

	isUsingHealingBalm = true

	Citizen.CreateThread(function()

		TriggerEvent("vorp:Tip", Config.HealingBalm.UseNotification, 4000)
		PlayAnim(Config.BalmAnimation.PutOnAnimDict, Config.BalmAnimation.PutOnAnimName)
		
		Citizen.Wait(6 * 1000)

		while isUsingHealingBalm do
			if Config.ShameyDebug then print("isUsingHealingBalm") end
			healingBalmInterval = healingBalmInterval + 1

			if healingBalmInterval >= Config.HealingBalm.IntervalMax then
				CleanupHealingBalm()
			end

            local innerCoreHealthAmount = Config.HealingBalm.InnerHealthMax / Config.HealingBalm.IntervalMax
            local outerCoreHealthAmount = Config.HealingBalm.OuterHealthMax / Config.HealingBalm.IntervalMax
            TriggerEvent("rainbow_metabolism:AdjustHealth", innerCoreHealthAmount, outerCoreHealthAmount)

			TriggerEvent("vorp:Tip", Config.HealingBalm.EffectNotification, 4000)

			Citizen.Wait(60 * 1000)
		end
	end)

    TriggerServerEvent("vorpmetabolism:ItemUsed", GetPlayerServerId(PlayerId()), item.item)

end)


-------- FUNCTIONS


----------------------------------------------------------------
----------------------------------------------------------------
-- BANDAGES
----------------------------------------------------------------
----------------------------------------------------------------

function UseBandage(itemName, label)

    if Config.ShameyDebug then print("UseBandage", itemName, label) end

    local cooldownBandagesTime = Config.CooldownsInSeconds.Bandages * 1000
	
	if cooldownBandagesEndTime == 0 then

        TriggerServerEvent("rainbow_doctor:UsedItem", itemName)
	
        cooldownBandagesEndTime = GetGameTimer() + cooldownBandagesTime
		startCooldownBandages()

        local configItem = Config.UseItems[itemName]

        if configItem.Audio and configItem.Audio.RDRCoreFillUpSound then
            PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
        end
		
        -- Health/Stamina/Stress
		if configItem["InnerCoreHealth"] and configItem["OuterCoreHealth"] then
		    TriggerEvent("rainbow_metabolism:AdjustHealth", configItem["InnerCoreHealth"], configItem["OuterCoreHealth"])
        end
        if configItem["Stamina"] then
            TriggerEvent("rainbow_metabolism:AdjustStamina", configItem["Stamina"])
        end
        if configItem["Stress"] then
            TriggerEvent("rainbow_metabolism:AdjustStress", configItem["Stress"])
        end

        -- Animation
        PlayAnimBandage()
		
		TriggerEvent("vorp:Tip", string.format("Used %s.", label), 3000)
	
	else
		Wait(500)
        local secondsLeft = (cooldownBandagesEndTime - GetGameTimer() ) / 1000
        TriggerEvent("vorp:TipBottom", string.format("You must wait %.2f seconds before applying another bandage.", secondsLeft), 6000)
    end
end


function startCooldownBandages()
    if Config.ShameyDebug then print("startCooldownBandages") end
    Citizen.CreateThread(function()
        while GetGameTimer() < cooldownBandagesEndTime do
            Wait(500)
        end
        cooldownBandagesEndTime = 0
    end)
end

----------------------------------------------------------------
----------------------------------------------------------------
-- MEDICINES
----------------------------------------------------------------
----------------------------------------------------------------

function UseMedicine(itemName, label)

    if Config.ShameyDebug then print("UseMedicine", itemName, label) end

    local cooldownMedicinesTime = Config.CooldownsInSeconds.Medicines * 1000
	
	if cooldownMedicinesEndTime == 0 then

        TriggerServerEvent("rainbow_doctor:UsedItem", itemName)
	
        cooldownMedicinesEndTime = GetGameTimer() + cooldownMedicinesTime
		startCooldownMedicines()

        local configItem = Config.UseItems[itemName]

        if configItem.Audio and configItem.Audio.RDRCoreFillUpSound then
            PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
        end
		
        TriggerEvent("rainbow_metabolism:PlayAnimDrink", configItem.PropName)
        -- Wait for the animation to finish
        Wait(5000)

        -- Thirst/Hunger
        if configItem["Thirst"] then
		    TriggerEvent("rainbow_metabolism:AdjustThirst", configItem["Thirst"])
        end
        if configItem["Hunger"] then
		    TriggerEvent("rainbow_metabolism:AdjustHunger", configItem["Hunger"])
        end

        -- Health/Stamina/Stress
        if configItem["InnerCoreHealth"] and configItem["OuterCoreHealth"] then
		    TriggerEvent("rainbow_metabolism:AdjustHealth", configItem["InnerCoreHealth"], configItem["OuterCoreHealth"])
        end
        if configItem["Stamina"] then
            TriggerEvent("rainbow_metabolism:AdjustStamina", configItem["Stamina"])
        end
        if configItem["Stress"] then
            TriggerEvent("rainbow_metabolism:AdjustStress", configItem["Stress"])
        end

        -- Golds
        if configItem["Golds"] then
            TriggerEvent("rainbow_metabolism:AdjustGolds", configItem.Golds.OuterCoreHealthGold, configItem.Golds.InnerCoreHealthGold, configItem.Golds.OuterCoreStaminaGold, configItem.Golds.InnerCoreStaminaGold)
        end

        -- Effects
        if configItem.Effect then
            PlayFx(configItem.Effect.Name, configItem.Effect.Duration)
        end
		
		TriggerEvent("vorp:Tip", string.format("Used %s.", label), 3000)
	
	else
		Wait(500)
        local secondsLeft = (cooldownMedicinesEndTime - GetGameTimer() ) / 1000
        TriggerEvent("vorp:TipBottom", string.format("You must wait %.2f seconds before using another medicine or potion.", secondsLeft), 6000)
    end
end

function startCooldownMedicines()
    if Config.ShameyDebug then print("startCooldownMedicines") end
    Citizen.CreateThread(function()
        while GetGameTimer() < cooldownMedicinesEndTime do
            Wait(500)
        end
        cooldownMedicinesEndTime = 0
    end)
end






----------------------------------------------------------------
----------------------------------------------------------------
-- OTHER
----------------------------------------------------------------
----------------------------------------------------------------

function UseOther(itemName, label)

    if Config.ShameyDebug then print("UseOther", itemName, label) end

    local configItem = Config.UseItems[itemName]

    local cooldownOtherItemTime = configItem.CooldownInSeconds * 1000
	
	if cooldownsOtherEndTimes[itemName] == nil or cooldownsOtherEndTimes[itemName] == 0 then

        TriggerServerEvent("rainbow_doctor:UsedItem", itemName)
	
        cooldownsOtherEndTimes[itemName] = GetGameTimer() + cooldownOtherItemTime
		startCooldownOther(itemName)
		
        if configItem.Audio and configItem.Audio.RDRCoreFillUpSound then
            PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)
        end

        -- Props & Animation
        if configItem.PropName and configItem.PropAnimType then
            if configItem.PropAnimType == "drink" then
                TriggerEvent("rainbow_metabolism:PlayAnimDrink", configItem.PropName)
                -- Wait for the animation to finish
                Wait(5000)
            elseif configItem.PropAnimType == "eat" then
                TriggerEvent("rainbow_metabolism:PlayAnimEat", configItem.PropName)
                -- Wait for the animation to finish
                Wait(5000)
            end
        elseif configItem.SpecialAnimation then
            PlayAnim(configItem.SpecialAnimation.AnimDict, configItem.SpecialAnimation.AnimName)
        end

        -- Thirst/Hunger
        if configItem["Thirst"] then
		    TriggerEvent("rainbow_metabolism:AdjustThirst", configItem["Thirst"])
        end
        if configItem["Hunger"] then
		    TriggerEvent("rainbow_metabolism:AdjustHunger", configItem["Hunger"])
        end

        -- Health/Stamina/Stress
        if configItem["InnerCoreHealth"] and configItem["OuterCoreHealth"] then
		    TriggerEvent("rainbow_metabolism:AdjustHealth", configItem["InnerCoreHealth"], configItem["OuterCoreHealth"])
        end
        if configItem["Stamina"] then
            TriggerEvent("rainbow_metabolism:AdjustStamina", configItem["Stamina"])
        end
        if configItem["Stress"] then
            TriggerEvent("rainbow_metabolism:AdjustStress", configItem["Stress"])
        end

        -- Golds
        if configItem["Golds"] then
            TriggerEvent("rainbow_metabolism:AdjustGolds", configItem.Golds.OuterCoreHealthGold, configItem.Golds.InnerCoreHealthGold, configItem.Golds.OuterCoreStaminaGold, configItem.Golds.InnerCoreStaminaGold)
        end

        -- Effects
        if configItem.Effect then
            PlayFxWithStrength(configItem.Effect.Name, configItem.Effect.Duration, configItem.Effect.Strength)
        end

        -- Special Audio
        if configItem.Audio then
            if configItem.Audio.RainbowCoreFileName then
                TriggerEvent("rainbow_core:PlayAudioFile", configItem.Audio.RainbowCoreFileName)
            end
        end

        -- Special for one-year anniversary item
        if itemName == "RainbowElixir" then
            FlameThemHoovesHenny(itemName)
        end
		
		TriggerEvent("vorp:Tip", string.format("Consumed %s.", label), 3000)
    else
		Wait(500)
        local secondsLeft = (cooldownsOtherEndTimes[itemName] - GetGameTimer() ) / 1000
        if secondsLeft <= 60 then
            TriggerEvent("vorp:TipBottom", string.format("You must wait %.2f seconds before using another item of this kind.", secondsLeft), 6000)
        else
            TriggerEvent("vorp:TipBottom", string.format("You must wait %.2f minutes before using another item of this kind.", (secondsLeft / 60)), 6000)
        end
    end

end

function startCooldownOther(itemName)
    if Config.ShameyDebug then print("startCooldownOther") end
    Citizen.CreateThread(function()
        while GetGameTimer() < cooldownsOtherEndTimes[itemName] do
            Wait(500)
        end
        cooldownsOtherEndTimes[itemName] = 0
    end)
end

function FlameThemHoovesHenny(itemName)
    -- print("FlameThemHoovesHenny")
    local playerPedId = jo.me
    Citizen.CreateThread(function()
        while ((cooldownsOtherEndTimes[itemName] - GetGameTimer() ) / 1000) > 1 do
            local sleep = 2000

            if IsPedOnMount(playerPedId) then
                local mount = GetMount(playerPedId)
                local rider = GetRiderOfMount(mount)
                -- Make sure the player is driver
                if rider and rider ~= 0 and rider == playerPedId then
                    -- See it it's a horse
                    if IsThisModelAHorse(GetEntityModel(mount)) then
                        if GetPedConfigFlag(mount, 207, true) == false then
                            SetPedConfigFlag(mount, 207, true)
                        end
                    end
                end
            end

            Wait(sleep)
        end
    end)
    -- print("ended loop")
end


----------------------------------------------------------------
----------------------------------------------------------------
-- EFFECTS
----------------------------------------------------------------
----------------------------------------------------------------

function PlayFx(effectName, effectDuration)
    if Config.ShameyDebug then print("PlayFx") end
    PlayFxWithStrength(effectName, effectDuration, 0.25)
end

function PlayFxWithStrength(effectName, effectDuration, effectStrength, shouldFadeIn)
    if Config.ShameyDebug then print("PlayFxWithStrength") end

    -- If there's already an effect in use
    if currentEffect then
        AnimpostfxStop(currentEffect)
    end

    currentEffect = effectName

    Citizen.CreateThread(function()

        if shouldFadeIn then
            DoScreenFadeOut(500)
            Citizen.Wait(500)
        end
        
        AnimpostfxPlay(currentEffect)
        Citizen.InvokeNative(0xCAB4DD2D5B2B7246, currentEffect, effectStrength) -- AnimpostfxSetStrength

        if shouldFadeIn then
            DoScreenFadeIn(500)
        end

        Citizen.Wait(effectDuration)

        DoScreenFadeOut(500)
        Citizen.Wait(500)

        AnimpostfxStop(currentEffect)
        currentEffect = nil

        DoScreenFadeIn(500)

    end)
end


----------------------------------------------------------------
----------------------------------------------------------------
-- HEALTH
----------------------------------------------------------------
----------------------------------------------------------------

function AdjustHealth(index)
    if Config.ShameyDebug then print("AdjustHealth", index) end

    
end


----------------------------------------------------------------
----------------------------------------------------------------
-- ANIMATIONS
----------------------------------------------------------------
----------------------------------------------------------------

function PlayAnim(animDict, animName)
	if Config.ShameyDebug then print("PlayAnim") end

	-- Unarm the player so the weapon doesn't interfere
	Citizen.InvokeNative(0xFCCC886EDE3C63EC, jo.me, 2, true) -- HidePedWeapons

	-- Play the animation
	RequestAnimDict(animDict)
	while (not HasAnimDictLoaded(animDict)) do
		Citizen.Wait(100)
	end
	TaskPlayAnim(jo.me, animDict, animName, 1.0, 1.0, 3000, 1, 1.0, false, false, false)
	Citizen.Wait(3000)
	ClearPedTasks(jo.me)
    if Config.ShameyDebug then print("PlayAnim - done") end
end

function PlayAnimBandage()
	local playerPed = jo.me
	TaskStartScenarioInPlace(playerPed, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), 10000, true, false, false, false)
	TriggerEvent("vorp:Tip", "Bandaging...", label, 6000)
end

---------

function CleanupHealingBalm()
	if Config.ShameyDebug then print("CleanupHealingBalm") end
	isUsingHealingBalm = false
	healingBalmInterval = 0
end

---------

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	CleanupHealingBalm()

	cooldownBandagesEndTime = 0
    cooldownMedicinesEndTime = 0
    cooldownsOtherEndTimes = {}

	ClearPedTasks(jo.me)

    if currentEffect then
        AnimpostfxStop(currentEffect)
        currentEffect = nil
    end

    isSmoking = false

end)
